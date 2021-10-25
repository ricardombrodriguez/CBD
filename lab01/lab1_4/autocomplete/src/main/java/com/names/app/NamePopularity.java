package com.names.app;

import redis.clients.jedis.Jedis;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class NamePopularity {

    private Jedis jedis;

    public NamePopularity() {
        this.jedis = new Jedis("localhost");
    }

    public List<String> getNames() {
        return jedis.lrange("NAME_POPULARITY", 0, -1);
    }

    public static void main( String[] args )
    {

        NamePopularity np = new NamePopularity();

        try {
            Scanner sc = new Scanner(new File("./nomes-pt-2021.csv"));
            while (sc.hasNextLine()) {
               String line = sc.nextLine();
               String[] name = line.split(";");
               np.jedis.rpush("NAME_POPULARITY",name[0].toLowerCase());
            }
            sc.close();

            System.out.print("Search for ('Enter' for quit): ");
            sc = new Scanner(System.in);
            String input = sc.next().toLowerCase();

            ArrayList<String> autocomplete = new ArrayList<>();

            for (String n : np.getNames())  {
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
