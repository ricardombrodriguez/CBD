package com.driver.app;

import java.util.Arrays;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import static com.mongodb.client.model.Filters.*;

import org.bson.Document;
import org.bson.conversions.Bson;

// alínea a)

public class App 
{
    public static void main( String[] args )
    {
        MongoClient mongoClient = new MongoClient();
        MongoDatabase database = mongoClient.getDatabase("cbd");
        MongoCollection<Document> collection = database.getCollection("restaurants");

        //prevenir logs do mongo na consola
        Logger mongoLogger = Logger.getLogger( "org.mongodb.driver" );
        mongoLogger.setLevel(Level.SEVERE); 

        // Desenvolva um programa que permita inserir, editar e pesquisar registos sobre a BD.

        System.out.println("INSERT DOCUMENT: ");

        Document main = new Document("address", new Document("building", "232")
                                                .append("coord", Arrays.asList(-73.856077,"40.848447"))
                                                .append("rua", "Avenida L. Peixinho")
                                                .append("zipcode", "3800"))
        .append("localidade", "Aveiro")
        .append("gastronomia", "American")
        .append("nome", "Ramona")
        .append("restaurant_id", "123456")
        .append("grades", new Document()
                            .append("date","23012001")
                            .append("grade","A")
                            .append("score","100"));

        collection.insertOne(main);
        
        //UPDATE
        
        System.out.println("UPDATE DOCUMENT ZIPCODE: ");

        collection.updateOne(eq("nome", "Ramona"),Updates.set("address.zipcode","3810"));

        // find localidade Aveiro
        
        System.out.println("FIND DOCUMENT BY 'LOCALIDADE': ");
        
        String parameter = "localidade";
        String value = "Aveiro";

        Bson filter = Filters.and(Filters.eq(parameter, value));

        find(collection,filter);

        mongoClient.close();

    }


    private static void find(MongoCollection<Document> collection, Bson filter) {

        for (Document document : collection.find(filter)) {
            System.out.println(document.toJson());
        }

    }

    public static void showMenu() {

        System.out.println("==== MENU ==== ");
        System.out.println("1. Insert data");
        System.out.println("2. Update data");
        System.out.println("3. Find data");
        System.out.println("9. Exit");
        System.out.println("============== ");

    }

}
