package com.driver.app;

import java.util.ArrayList;
import java.util.Scanner;
import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import org.bson.Document;
import org.bson.conversions.Bson;

/**
 * Hello world!
 *
 */

public class App 
{
    public static void main( String[] args )
    {
        MongoClient mongoClient = new MongoClient();
        MongoDatabase database = mongoClient.getDatabase("cbd");
        MongoCollection<Document> collection = database.getCollection("restaurants");

        // Desenvolva um programa que permita inserir, editar e pesquisar registos sobre a BD.
        
        Scanner sc = new Scanner(System.in);

        String option = "0";
        do {

            showMenu();
            System.out.println("Option: ");
            option = sc.nextLine();

            switch ( option ) {

                    case "1":
                        
                    //estático
                    /*
                    {"address": {"building": "232", "coord": [-73.123421, 40.726193], "rua": "Avenida L. Peixinho", "zipcode": "3800"}, 
                    "localidade": "Aveiro", "gastronomia": "American", 
                    "grades": [{"date": {"$date": 1419897600000}, "grade": "A", "score": 12}, {"date": {"$date": 1404172800000}, "grade": "B", "score": 23}, {"date": {"$date": 1367280000000}, "grade": "A", "score": 12}, {"date": {"$date": 1336435200000}, "grade": "A", "score": 12}], "nome": "Ramona", "restaurant_id": "30112344"}
                    */

                    System.out.println("INSERT DOCUMENT: ");

                    Document address = new Document("building", "232")
                    .append("coord", new String[] {"-73.123421", "40.726193"})
                    .append("rua", "Avenida L. Peixinho")
                    .append("zipcode", "3800");

                    ArrayList<Document> grades = new ArrayList<Document>();
                    Document doc = new Document();
                    String command = "Y";
                    do {
                        System.out.println("Date: ");
                        String date = sc.nextLine();
                        System.out.println("Grade: ");
                        String grade = sc.nextLine();
                        System.out.println("Score: ");
                        String score = sc.nextLine();
                        doc.append("date",date)
                        .append("grade",grade)
                        .append("score",score);
                        grades.add(doc);
                        System.out.println("Want to add a new command? (Y)es to continue. Otherwise, type any other command.");
                        command = sc.nextLine();
                        if (!command.equals("Y"))
                            break;
                    }
                    while (true);
                    
                    Document main = new Document("address", address)
                    .append("localidade", "Aveiro")
                    .append("gastronomia", "American")
                    .append("nome", "Ramona")
                    .append("restaurant_id", "30112344")
                    .append("grades", grades);

                    collection.insertOne(main);
                    
                    break;

                case "2":
                    
                    System.out.println("UPDATE DOCUMENT: ");

                    Document addr = new Document("building", "10")
                    .append("coord", new String[] {"-73.234234", "40.121212"})
                    .append("rua", "Rua Não Sei Das Quantas")
                    .append("zipcode", "3810");

                    Document mainn = new Document("address", addr)
                    .append("localidade", "Aveiro")
                    .append("gastronomia", "American")
                    .append("nome", "Ramona");

                    ArrayList<Document> gr = new ArrayList<Document>();
                    Document document = new Document();
                    String comm = "Y";
                    do {
                        System.out.println("Date: ");
                        String date = sc.nextLine();
                        System.out.println("Grade: ");
                        String grade = sc.nextLine();
                        System.out.println("Score: ");
                        String score = sc.nextLine();
                        document.append("date",date)
                        .append("grade",grade)
                        .append("score",score);
                        gr.add(document);
                        System.out.println("Want to add a new document? (Y)es to continue. Otherwise, type any other comm.");
                        comm = sc.nextLine();
                        if (!comm.equals("Y"))
                            break;
                    }
                    while (true);
                    
                    mainn.append("grades", gr);

                    collection.updateOne(eqID("restaurant_id", "30112344", collection), mainn);
                    
                    break;

                case "3":
                    
                    System.out.println("FIND DOCUMENT BY 'LOCALIDADE': ");
                    
                    System.out.println("Parâmetro a ser alterado: ");
                    String parameter = sc.nextLine();

                    System.out.println("Parameter value: ");
                    String value = sc.nextLine();

                    Bson filter = Filters.and(Filters.eq(parameter, value));
                    find(collection,filter);

                    break;

                default:
                    System.out.println("error");
            }

        } while ( option != "9" );

        System.out.println("exit");
        sc.close();
        mongoClient.close();

    }

    private static void find(MongoCollection<Document> collection, Bson filter) {

        for (Document document : collection.find(filter)) {
            System.out.println(document.toJson());
        }

    }

    private static Bson eqID(String string, String restaurant_id, MongoCollection<Document> collection) {

        Bson filter = Filters.eq(string, restaurant_id); // where doc is the CustomDocument
        Document firstDocument = collection.find(filter).first();
    
        return firstDocument;
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
