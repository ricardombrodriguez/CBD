package com.videoshare.app;

import java.security.Timestamp;
import java.util.Date;
import java.util.Set;
import java.util.UUID;
import com.datastax.driver.core.Cluster;
import com.datastax.driver.core.LocalDate;
import com.datastax.driver.core.Row;
import com.datastax.driver.core.Session;
import com.datastax.driver.core.ResultSet;

public class App {

	public static void main(String[] args) {
		
		Cluster cluster = Cluster.builder().addContactPoint("localhost").build();
		Session session = cluster.connect("videoshare");

		System.out.println("INSERTS USERS");
		session.execute("insert into users (username, name, email, created_at) values ('ricardinho9', 'Ricardo Albertino', 'ricardoal@gmail.com', dateof(now()));");
		session.execute("insert into users (username, name, email, created_at) values ('aswwww3', 'António Rodrigues', 'antrodri@gmail.com', dateof(now()));");
        session.execute("insert into users (username, name, email, created_at) values ('tbag', 'Theodore Bagwell', 'tbag@gmail.com', dateof(now()));");

		System.out.println("INSERTS VIDEOS");
		session.execute("insert into videos (uid, author , name, description, video_duration, tags, created_at) values (uuid(), 'tbag', 'Escaping from prison', 'eheheh escaping #epic', 46m32s, {'prison'}, dateof(now()));");
        session.execute("insert into videos (uid, author , name, description, video_duration, tags, created_at) values (uuid(), 'ricardinho9', 'Epic fursal skills', 'Ricardinho futsal', 8m1s, {'futsal'}, dateof(now()));");

        System.out.println("INSERTS COMMENTS");
        session.execute("insert into comments_users (uid, video, author, comment, created_at) values (uuid(), e9e20c0d-49ab-4c62-9fa2-94c717f81a3b,'aswwww3', 'Ahahah muito bom!', dateof(now()));");
        session.execute("insert into comments_users (uid, video, author, comment, created_at) values (uuid(), 1cbf0aeb-7a4f-47c9-9250-42a38896b98a,'ematthiesen6', 'Like from Bangladesh', dateof(now()));");


        System.out.println("EDIT USERS");
        session.execute("UPDATE users SET name='António Manuel Rodrigues',email='antoniorodrigues@ua.pt' WHERE username='aswwww3';");
        session.execute("UPDATE users SET name='Ricardo Braga' WHERE username='ricardinho9';");

        System.out.println("EDIT VIDEOS");
        session.execute("UPDATE videos SET description='Like and subscribe' WHERE author='etunnicliffei' AND created_at='2021-12-11 15:27:26.009000+0000';");
        session.execute("UPDATE videos SET name='Music video' WHERE author='acollumbellf' AND created_at='2021-12-11 15:27:25.973000+0000';");

        System.out.println("SEARCH USERS");
        System.out.println("===============");
        String username = null, name = null, email = null;
        ResultSet results = session.execute("select * from users;");
		for (Row row : results){
			username = row.getString("username");
			name = row.getString("name");
			email = row.getString("email");
            System.out.println("Username: " + username);
            System.out.print(" | Name: " + name);
            System.out.print(" | Email: " + email);
            System.out.println("===============");
		}

        System.out.println();
        System.out.println("SEARCH COMMENTS FROM USER NAMED 'swillcock2'");
        System.out.println("===============");
        UUID video = null; 
        String author = null, comment = null;
        Date created_at = null;
        results = session.execute("select * from comments_users where author='swillcock2';");
		for (Row row : results){
			author = row.getString("author");
			video = row.getUUID("video");
			comment = row.getString("comment");
            created_at = row.getTimestamp("created_at");
            System.out.println("Author: " + username);
            System.out.print(" | Video (UUID): " + video);
            System.out.print(" | Comment: " + comment);
            System.out.print(" | Created at: " + created_at);
            System.out.println("===============");
		}

        System.out.println();
        System.out.println("LAST 3 COMMENTS FOR A VIDEO");
        System.out.println("===============");
        video = null; 
        author = null;
        comment = null;
        created_at = null;
        results = session.execute("SELECT * FROM comments_videos WHERE video = 1cbf0aeb-7a4f-47c9-9250-42a38896b98a LIMIT 3;");
		for (Row row : results){
			author = row.getString("author");
			video = row.getUUID("video");
			comment = row.getString("comment");
            created_at = row.getTimestamp("created_at");
            System.out.println("Author: " + username);
            System.out.print(" | Video (UUID): " + video);
            System.out.print(" | Comment: " + comment);
            System.out.print(" | Created at: " + created_at);
            System.out.println("===============");
		}


        System.out.println();
        System.out.println("ALL FOLLOWERS FOR A VIDEO");
        System.out.println("===============");
        results = session.execute("select users as Followers from video_followers WHERE video = 94e9894e-59e7-4c80-9ba3-975c053d4cd8;");
        for (Row row : results){
            Set<String> users = row.getSet("followers", String.class);
            System.out.println("Users:");
            for (String user : users){
                System.out.println(user);
            }
        }

        System.out.println();
        System.out.println("5 EVENTS FROM A SPECIFIC VIDEO DONE BY A USER");
        System.out.println("===============");
        String user = null, action = null;
        Integer videotime = null;
        user = null; 
        video = null;
        action = null;
        created_at = null;
        results = session.execute("SELECT * FROM video_events WHERE user = 'kgreenrdea' AND video = c02f54b5-0be7-43e9-a6f9-1eae1aa02e26;");
		for (Row r : results){
			user = r.getString("user");
			video = r.getUUID("video");
            action = r.getString("action");
			videotime = r.getInt("video_time");
            created_at = r.getTimestamp("created_at");
            System.out.println("User: " + user);
            System.out.print(" | Video (UUID): " + video);
            System.out.print(" | Action: " + action);
            System.out.print(" | Video time: " + videotime);
            System.out.print(" | Created at: " + created_at);
            System.out.println("===============");
		}

        System.out.println();
        System.out.println("AVERAGE RATING FOR A VIDEO");
        System.out.println("===============");
        results = session.execute("SELECT COUNT(video) AS Votes, AVG(rating) AS Average_Rating FROM video_rating WHERE video = 813024e1-3535-4240-ab66-383b42a00ebb;");
        for (Row r : results){
            long votes = r.getLong("Votes");
            int average_rating = r.getInt("Average_Rating");
            System.out.println("Votes: " + votes);
            System.out.print(" | Average Rating: " + average_rating);
            System.out.println("===============");
        }

        session.close();
		cluster.close();

	}

}
