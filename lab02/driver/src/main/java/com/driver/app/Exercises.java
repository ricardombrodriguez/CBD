package com.driver.app;

import java.util.Arrays;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.mongodb.MongoClient;
import com.mongodb.client.AggregateIterable;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Accumulators;
import com.mongodb.client.model.Projections;
import com.mongodb.client.model.Sorts;
import static com.mongodb.client.model.Filters.*;
import static com.mongodb.client.model.Aggregates.group;

import org.bson.Document;

// alínea c)

public class Exercises {

    public static void main(String[] args) {

        MongoClient mongoClient = new MongoClient();
        MongoDatabase database = mongoClient.getDatabase("cbd");
        MongoCollection<Document> collection = database.getCollection("restaurants");

        //prevenir logs do mongo na consola
        Logger mongoLogger = Logger.getLogger( "org.mongodb.driver" );
        mongoLogger.setLevel(Level.SEVERE); 


        System.out.println("5. Apresente os primeiros 15 restaurantes localizados no Bronx, ordenados por ordem crescente de nome.");

        try {
            FindIterable<Document> query = collection.find(eq("localidade", "Bronx")).sort(Sorts.ascending("nome")).limit(15);
            for (Document document : query) {
                System.out.println(document.toJson());
            }
        } catch (Exception e){
            e.printStackTrace();
        }

        System.out.println();
        System.out.println();
        System.out.println();

        System.out.println("13. Liste o nome, a localidade, o score e gastronomia dos restaurantes que alcançaram sempre pontuações inferiores ou igual a 3.");

        try {
            FindIterable<Document> query = collection.find(not(gt("grades.score", 3))).projection(Projections.fields(Projections.include("nome"), Projections.include("localidade"), Projections.include("grades.score"), Projections.include("gastronomia")));
            for (Document document : query) {
                System.out.println(document.toJson());
            }
        } catch (Exception e){
            e.printStackTrace();
        }

        System.out.println();
        System.out.println();
        System.out.println();

        System.out.println("16. Liste o restaurant_id, o nome, o endereço (address) e as coordenadas geográficas (coord) dos restaurantes onde o 2º elemento da matriz de coordenadas tem um valor superior a 42 e inferior ou igual a 52.");

        try {
            FindIterable<Document> query = collection.find(and(gt("address.coord.1",42),lte("address.coord.1",52))).projection(Projections.fields(Projections.include("restaurant_id"), Projections.include("nome"), Projections.include("address")));
            for (Document document : query) {
                System.out.println(document.toJson());
            }
        } catch (Exception e){
            e.printStackTrace();
        }

        System.out.println();
        System.out.println();
        System.out.println();

        System.out.println("19. Conte o total de restaurante existentes em cada localidade.");

        try {
            AggregateIterable<Document> query = collection.aggregate(Arrays.asList(group("$localidade", Accumulators.sum("count", 1))));
            for (Document document : query) {
                System.out.println(document.toJson());
            }
        } catch (Exception e){
            e.printStackTrace();
        }

        System.out.println();
        System.out.println();
        System.out.println();


        System.out.println("26. Apresenta os 10 primeiros restaurantes, por nome e gastronomia, começados por \"Pe\" e ordenados por ordem crescente de gastronomia.");

        try {
            String pattern = "Pe.*";
            FindIterable<Document> query = collection.find(regex("nome", pattern)).projection(Projections.fields(Projections.include("nome"), Projections.include("gastronomia"))).sort(Sorts.ascending("gastronomia")).limit(10);
            for (Document document : query) {
                System.out.println(document.toJson());
            }
        } catch (Exception e){
            e.printStackTrace();
        }

        mongoClient.close();

    }
    
}
