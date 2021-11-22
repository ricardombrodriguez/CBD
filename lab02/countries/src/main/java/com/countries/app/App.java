package com.countries.app;

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

import org.bson.Document;

import static com.mongodb.client.model.Filters.*;
import static com.mongodb.client.model.Aggregates.group;

public class App 
{
    public static void main( String[] args )
    {
        MongoClient mongoClient = new MongoClient();
        MongoDatabase database = mongoClient.getDatabase("cbd");
        MongoCollection<Document> collection = database.getCollection("countries");

        //prevenir logs do mongo na consola
        Logger mongoLogger = Logger.getLogger( "org.mongodb.driver" );
        mongoLogger.setLevel(Level.SEVERE); 

        System.out.println();

        System.out.println("Listar o nome de todos os países no mundo que usam o Euro (EUR) como moeda:");

        try {
            FindIterable<Document> query = collection.find(eq("currency", "EUR")).projection(Projections.fields(Projections.exclude("_id"),Projections.include("name.common"), Projections.include("latlng"), Projections.include("region"), Projections.include("subregion")));
            for (Document document : query) {
                System.out.println(document.toJson());
            }
        } catch (Exception e){
            e.printStackTrace();
        }

        System.out.println();
        System.out.println();
        System.out.println();


        System.out.println("Listar o nome, capital, área e coordenadas dos 10 maiores países do mundo sem litoral, de ordem decrescente:");

        try {
            FindIterable<Document> query = collection.find(eq("landlocked", true)).projection(Projections.fields(Projections.exclude("_id"),Projections.include("name.common"), Projections.include("capital"), Projections.include("area"), Projections.include("coordinates"))).sort(Sorts.descending("area")).limit(10);
            for (Document document : query) {
                System.out.println(document.toJson());
            }
        } catch (Exception e){
            e.printStackTrace();
        }

        System.out.println();
        System.out.println();
        System.out.println();

        System.out.println("Listar o nome, capital, área, região, subregião, moeda e coordenadas dos países do mundo que fazem fronteira com o Brasil (BRA), por ordem ordem crescente de moeda");

        try {
            FindIterable<Document> query = collection.find(in("borders","BRA")).projection(Projections.fields(Projections.exclude("_id"),Projections.include("name.common"), Projections.include("capital"), Projections.include("area"), Projections.include("region"), Projections.include("subregion"), Projections.include("currency"), Projections.include("latlng"))).sort(Sorts.ascending("currency"));
            for (Document document : query) {
                System.out.println(document.toJson());
            }
        } catch (Exception e){
            e.printStackTrace();
        }

        System.out.println();
        System.out.println();
        System.out.println();



        System.out.println("Listar o nome, capital, área, coordenadas e fronteiras dos países do mundo que falam Português e com uma área superior a 5000, por ordem decrescente de área:");

        try {
            FindIterable<Document> query = collection.find(and(eq("languages.por", "Portuguese"),gt("area",5000))).projection(Projections.fields(Projections.exclude("_id"),Projections.include("name.common"), Projections.include("capital"), Projections.include("area"), Projections.include("latlng"), Projections.include("borders"))).sort(Sorts.descending("area"));
            for (Document document : query) {
                System.out.println(document.toJson());
            }
        } catch (Exception e){
            e.printStackTrace();
        }

        System.out.println();
        System.out.println();
        System.out.println();

        System.out.println("Listar o nome, capital, área, coordenadas, moeda e os idiomas dos países do mundo cuja capital começa por 'A', por ordem crescente de capital:");

        try {
            String pattern = "A.*";
            FindIterable<Document> query = collection.find(regex("capital",pattern)).projection(Projections.fields(Projections.exclude("_id"),Projections.include("name.common"), Projections.include("capital"), Projections.include("area"), Projections.include("latlng"), Projections.include("currency"), Projections.include("languages"))).sort(Sorts.ascending("capital"));
            for (Document document : query) {
                System.out.println(document.toJson());
            }
        } catch (Exception e){
            e.printStackTrace();
        }

        System.out.println();
        System.out.println();
        System.out.println();


        System.out.println("Listar o nome, capital, coordenadas, moeda e a tradução do nome em japonês dos países do mundo cuja latitude seja menor que '20' e cuja longitude seja superior, ou igual, a '0' e que usem o 'USD' (dólar) como moeda.");

        try {
            FindIterable<Document> query = collection.find(and(eq("currency","USD"),lt("latlng.0",20),gte("latlng.1",0))).projection(Projections.fields(Projections.exclude("_id"),Projections.include("name.common"), Projections.include("capital"), Projections.include("area"), Projections.include("latlng"), Projections.include("currency"), Projections.include("translations.jpn"))).sort(Sorts.ascending("capital"));
            for (Document document : query) {
                System.out.println(document.toJson());
            }
        } catch (Exception e){
            e.printStackTrace();
        }

        System.out.println();
        System.out.println();
        System.out.println();









        // aggregates:








        // este usa o aggregate
        // https://stackoverflow.com/questions/21387969/mongodb-count-the-number-of-items-in-an-array
        System.out.println("Listar o nome, área, países fronteiriços, região e subregião dos 10 países no mundo com maior número de países fronteiriços, por ordem decrescente:");

        try {
            FindIterable<Document> query = collection.find(eq("currency", "EUR")).projection(Projections.fields(Projections.exclude("_id"),Projections.include("name.common"), Projections.include("area"), Projections.include("borders"), Projections.include("region"), Projections.include("subregion"))).sort(Sorts.descending("borders")).limit(10);
            for (Document document : query) {
                System.out.println(document.toJson());
            }
        } catch (Exception e){
            e.printStackTrace();
        }

        System.out.println();
        System.out.println();
        System.out.println();




        mongoClient.close();

    }
}
