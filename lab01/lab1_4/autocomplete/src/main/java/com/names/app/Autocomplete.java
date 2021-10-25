package com.names.app;

import redis.clients.jedis.Jedis;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class Autocomplete 
{

    private Jedis jedis;

    public Autocomplete() {
        this.jedis = new Jedis("localhost");
    }

    public List<String> getNames() {
        return jedis.lrange("NAMES", 0, -1);
    }

    public static void main( String[] args )
    {

        Autocomplete au = new Autocomplete();

        try {
            Scanner sc = new Scanner(new File("./names.txt"));
            while (sc.hasNextLine()) {
               String name = sc.nextLine();
               au.jedis.rpush("NAMES",name);
            }
            sc.close();

            System.out.print("Search for ('Enter' for quit): ");
            sc = new Scanner(System.in);
            String input = sc.next().toLowerCase();

            ArrayList<String> autocomplete = new ArrayList<>();

            for (String n : au.getNames())  {
                if (n.startsWith(input)) {
                    autocomplete.add(n);
                }
            }

            for (String result : autocomplete) {
                System.out.println(result);
            }
            System.out.println();
   
        } catch(FileNotFoundException e){
            e.printStackTrace();
        }

    }
}
