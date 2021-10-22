package com.names.app;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Scanner;

public class Autocomplete 
{
    public static void main( String[] args )
    {
    
        ArrayList<String> names = new ArrayList<>();

        try {
            Scanner sc = new Scanner(new File("./names.txt"));
            while (sc.hasNextLine()) {
               String name = sc.nextLine();
               names.add(name);
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
