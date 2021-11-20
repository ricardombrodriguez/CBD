package com.driver.app;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.mongodb.MongoClient;
import com.mongodb.client.AggregateIterable;
import com.mongodb.client.DistinctIterable;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Accumulators;
import com.mongodb.client.model.Projections;
import com.mongodb.client.model.Sorts;
import static com.mongodb.client.model.Filters.*;
import static com.mongodb.client.model.Aggregates.group;

import org.bson.Document;

public class Metodos {

    static MongoCollection<Document> collection;
    
    public static void main(String[] args) {

        MongoClient mongoClient = new MongoClient();
        MongoDatabase database = mongoClient.getDatabase("cbd");
        collection = database.getCollection("restaurants");

        //prevenir logs do mongo na consola
        Logger mongoLogger = Logger.getLogger( "org.mongodb.driver" );
        mongoLogger.setLevel(Level.SEVERE); 

        System.out.println("Numero de localidades distintas: " + countLocalidades());

        System.out.println();

        System.out.println("Numero de restaurantes por localidade:");
        for (Map.Entry<String, Integer> entry : countRestByLocalidade().entrySet() ) {
            System.out.println(" -> " + entry.getKey() + " - " + entry.getValue());
        }

        System.out.println();

        System.out.println("Nome de restaurantes contendo 'Park' no nome:");
        for (String nome : getRestWithNameCloserTo("Park")) {
            System.out.println(" -> " + nome);
        }

        mongoClient.close();
    }

    public static int countLocalidades() {

        int localidades = 0;
        try {
            DistinctIterable<String> query = collection.distinct("localidade",String.class);
            for (String localidade : query) {
                localidades++;
            }
        } catch (Exception e){
            e.printStackTrace();
        }
        return localidades;

    }

    public static Map<String,Integer> countRestByLocalidade() {
        Map<String,Integer> restLocalidade = new HashMap<String,Integer>();
        try {
            AggregateIterable<Document> query = collection.aggregate(Arrays.asList(group("$localidade", Accumulators.sum("count", 1))));
            for (Document document : query) {
                restLocalidade.put(document.get("_id").toString(),(int)document.get("count"));
            }
        } catch (Exception e){
            e.printStackTrace();
        }
        return restLocalidade;
    }

    public static List<String> getRestWithNameCloserTo(String name) {
        List<String> similarNames = new ArrayList<String>();
        try {
            String pattern = ".*" + name + ".*";
            FindIterable<Document> query = collection.find(regex("nome", pattern));
            for (Document document : query) {
                similarNames.add(document.get("nome").toString());
            }
        } catch (Exception e){
            e.printStackTrace();
        }
        return similarNames;
    }

}
