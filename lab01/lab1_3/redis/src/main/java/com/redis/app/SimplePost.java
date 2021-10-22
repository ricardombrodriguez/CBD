package com.redis.app;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import redis.clients.jedis.Jedis;

public class SimplePost {

    private Jedis jedis;
    public static String USERS = "users"; // Key set for users' name
    public static String USERS_LIST = "users_list"; 
    public static String USERS_HASHMAP = "users_hashmap"; 
    
    public SimplePost() {
        this.jedis = new Jedis("localhost");
    }

    // using lists:

    public void saveUserList(String username) {
        jedis.rpush(USERS_LIST, username);
    }

    public List<String> getUserList() {
        return jedis.mget(USERS_LIST);
    }
    
    // using hashmaps

    public void saveUserHashmap(String username, Map<String, String> hash) {
        jedis.hmset(username, hash);
    }

    public Map<String, String> getUserHashmap(String user) {
        return jedis.hgetAll(user);
    }

    // using sets:

    public void saveUser(String username) {
        jedis.sadd(USERS, username);
    }
    
    public Set<String> getUser() {
        return jedis.smembers(USERS);
    }
    
    public Set<String> getAllKeys() {
        return jedis.keys("*");
    }

    public static void main(String[] args) {

        SimplePost board = new SimplePost();
        
        // for set
        String[] users = { "Ana", "Pedro", "Maria", "Luis" };

        System.out.println("Set:");
        for (String user: users)
            board.saveUser(user);
        board.getAllKeys().stream().forEach(System.out::println);
        board.getUser().stream().forEach(System.out::println);

        System.out.println("List:");
        // for list
        for (String user: users)
            board.saveUserList(user);
        board.getAllKeys().stream().forEach(System.out::println);
        board.getUserList().stream().forEach(System.out::println);

        // for hashmap
        System.out.println("Hashmap:");
        HashMap<String,String> names_city = new HashMap<>();
        names_city.put("Ana","Coimbra");
        names_city.put("Pedro","Porto");
        names_city.put("Maria","São João da pesqueira");
        names_city.put("Luís","Régua");
        names_city.put("Ricardo","Estarreja");

        board.saveUserHashmap("names_city", names_city);
        board.getAllKeys().stream().forEach(System.out::println);
        for (Map.Entry<String, String> entry : board.getUserHashmap("names_city").entrySet()) {
            System.out.println(entry.getKey() + "/" + entry.getValue());
        }

    }
}