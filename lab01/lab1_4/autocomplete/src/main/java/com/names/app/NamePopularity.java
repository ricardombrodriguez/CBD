package com.names.app;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Scanner;

public class NamePopularity {
    
    public static void main( String[] args )
    {
    
        ArrayList<String> names = new ArrayList<>();

        try {
            Scanner sc = new Scanner(new File("./nomes-pt-2021.csv"));
            while (sc.hasNextLine()) {
               String line = sc.nextLine();
               String[] name = line.split(";");
               names.add(name[0].toLowerCase());
            }
            sc.close();

            System.out.print("Search for ('Enter' for quit): ");
            sc = new Scanner(System.in);
            String input = sc.next().toLowerCase();

            ArrayList<String> autocomplete = new ArrayList<>();

            for (String n : names)  {
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
