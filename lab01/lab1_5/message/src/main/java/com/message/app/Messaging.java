package com.message.app;

import redis.clients.jedis.Jedis;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;
import java.util.Set;

public class Messaging 
{

    private Jedis jedis;
    public static String ASSOCIATION_SUFFIX = "_association";

    public Messaging() {
        this.jedis = new Jedis("localhost");
    }

    public Set<String> getUsers() {
        return jedis.keys("*");
    }

    public List<String> getAssociatedUsers(String username) {
        return jedis.lrange(username + ASSOCIATION_SUFFIX, 0, -1);
    }

    public void addUser(String username) {
        if (getUsers().contains(username)) {
            System.out.println("'" + username + "' already exists.");
        } else {
            jedis.rpush(username, "");
        }
    }

    // 'username1' should start getting message notifications from 'username2'
    public void addAssociation(String username1, String username2) {
        if (getAssociatedUsers(username2).contains(username1)) {
            System.out.println("'" + username1 + "' is already associated.");
        } else {
            jedis.rpush(username2 + ASSOCIATION_SUFFIX, username1);
        }
    }

    public void storeMsg(String username, List<String> message) {
        if (!getUsers().contains(username)) {
            System.out.println("'" + username + "' doesn't exist.");
        } else {
            String msg = "";
            for (String str : message) {
                msg += str + " ";
            }
            for (String associated_user : getAssociatedUsers(username)) {
                System.out.println("['" + username + "' to '" + associated_user + "'] " + msg);
            }
            jedis.rpush(username, msg);
        }
    }

    public void getAllUserMessages(String username) {
        List<String> allMessages = jedis.lrange(username, 0, -1);
        System.out.println(" == '" + username + "' messages == ");
        for (String message : allMessages) {
            if (!message.equals(""))
                System.out.println(message);
        }
        System.out.println();
    }
    

    public static void showMenu() {
        System.out.println("=============================== MENU ===================================");
        System.out.println("/add [username] -> Add new username to the database");
        System.out.println("/associate [user1] [user2] -> 'user1' starts receiving 'user2' messages");
        System.out.println("/send [user] [message] -> 'user' sends a text message");
        System.out.println("/readall [username] -> Presents a list of the 'username' message history");
        System.out.println("/exit -> Close the program");
        System.out.println("========================================================================");
        System.out.println();
    }

    public static void main( String[] args )
    {
        Messaging msg = new Messaging();

        Scanner sc = new Scanner(System.in);

        System.out.println("Welcome to the message application!");
        showMenu();
        boolean alive = true;
        while (alive) {
            String[] line = sc.nextLine().split(" ");
            String command = line[0];
            switch(command) {
                case "/add":
                    msg.addUser(line[1]);
                    break;
                case "/associate":
                    msg.addAssociation(line[1], line[2]);
                    break;
                case "/send":
                    msg.storeMsg(line[1], Arrays.asList(line).subList(2, line.length));
                    break;
                case "/readall":
                    msg.getAllUserMessages(line[1]);
                    break;
                case "/exit":
                    alive = false;
                    System.out.println("Thanks for using the application!");
                    break;
                default:
                    System.out.println("Error! Non-existing command.");
            }
        }

        sc.close();
        
    }
}
