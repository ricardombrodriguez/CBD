DROP KEYSPACE videoshare;

CREATE KEYSPACE videoshare WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };

USE videoshare;

CREATE TABLE users (
   username VARCHAR,
   name VARCHAR,
   email VARCHAR,
   created_at timestamp,
   PRIMARY KEY (username)
   );

 CREATE TABLE videos (
   uid uuid,
   author VARCHAR,
   name VARCHAR,
   description VARCHAR,
   video_duration duration,
   tags set<text>,
   created_at timestamp,
   PRIMARY KEY (author,created_at)
  );
   
 CREATE TABLE comments_users (
   uid uuid,
   video uuid,
   author VARCHAR,
   comment VARCHAR,
   created_at timestamp,
   PRIMARY KEY (author,created_at)
   ) WITH CLUSTERING ORDER BY (created_at DESC);
  
 CREATE TABLE comments_videos (
   uid uuid,
   video uuid,
   author VARCHAR,
   comment VARCHAR,
   created_at timestamp,
   PRIMARY KEY (video,created_at)
   ) WITH CLUSTERING ORDER BY (created_at DESC);  
 
CREATE TABLE video_followers (
   video uuid PRIMARY KEY,
   users set<VARCHAR>
   );
   
 CREATE TABLE video_events (
   uid uuid PRIMARY KEY,
   user VARCHAR,
   video uuid,
   action VARCHAR,
   created_at timestamp,
   video_time timestamp
   );

 CREATE TABLE video_rating (
   uid uuid,
   rating int,
   video uuid,
   PRIMARY KEY ((video),uid)
   );
  
  
-- INSERTS
insert into users (username, name, email, created_at) values ('cmenchenton0', 'Cyril Menchenton', 'cmenchenton0@jugem.jp', dateof(now()));
insert into users (username, name, email, created_at) values ('pkettles1', 'Patti Kettles', 'pkettles1@msn.com', dateof(now()));
insert into users (username, name, email, created_at) values ('swillcock2', 'Shalna Willcock', 'swillcock2@tamu.edu', dateof(now()));
insert into users (username, name, email, created_at) values ('whofton3', 'Wyatan Hofton', 'whofton3@linkedin.com', dateof(now()));
insert into users (username, name, email, created_at) values ('mizkoveski4', 'Meris Izkoveski', 'mizkoveski4@newsvine.com', dateof(now()));
insert into users (username, name, email, created_at) values ('ewhitloe5', 'Esma Whitloe', 'ewhitloe5@guardian.co.uk', dateof(now()));
insert into users (username, name, email, created_at) values ('ematthiesen6', 'Editha Matthiesen', 'ematthiesen6@over-blog.com', dateof(now()));
insert into users (username, name, email, created_at) values ('kmartschik7', 'Kinsley Martschik', 'kmartschik7@studiopress.com', dateof(now()));
insert into users (username, name, email, created_at) values ('rtunnicliff8', 'Rachel Tunnicliff', 'rtunnicliff8@oakley.com', dateof(now()));
insert into users (username, name, email, created_at) values ('tbramsen9', 'Troy Bramsen', 'tbramsen9@cmu.edu', dateof(now()));
insert into users (username, name, email, created_at) values ('kgreenrdea', 'Kristin Greenrde', 'kgreenrdea@creativecommons.or', dateof(now()));
insert into users (username, name, email, created_at) values ('dlatteyb', 'Dehlia Lattey', 'dlatteyb@discuz.net', dateof(now()));
insert into users (username, name, email, created_at) values ('kbirtwhistlec', 'Kattie Birtwhistle', 'kbirtwhistlec@alexa.com', dateof(now()));
insert into users (username, name, email, created_at) values ('adowdelld', 'Arabela Dowdell', 'adowdelld@opensource.org', dateof(now()));
insert into users (username, name, email, created_at) values ('abridgemane', 'Alyss Bridgeman', 'abridgemane@seattletimes.com', dateof(now()));
insert into users (username, name, email, created_at) values ('acollumbellf', 'Arnaldo Collumbell', 'acollumbellf@yelp.com', dateof(now()));
insert into users (username, name, email, created_at) values ('gbonelleg', 'Grethel Bonelle', 'gbonelleg@marriott.com', dateof(now()));
insert into users (username, name, email, created_at) values ('treitenbachh', 'Tonnie Reitenbach', 'treitenbachh@amazon.co.jp', dateof(now()));
insert into users (username, name, email, created_at) values ('etunnicliffei', 'Ernst Tunnicliffe', 'etunnicliffei@guardian.co.uk', dateof(now()));
insert into users (username, name, email, created_at) values ('gmacgiollaj', 'Golda MacGiolla Pheadair', 'gmacgiollaj@miitbeian.gov.cn', dateof(now()));

insert into videos (uid, author , name, description, video_duration, tags, created_at) values (uuid(), 'rtunnicliff8', 'Raven, cape', '714qXK3m50z75o03JCw78G7k1414vr', 12m1s, {'cats'}, dateof(now()));
insert into videos (uid, author , name, description, video_duration, tags, created_at) values (uuid(), 'cmenchenton0', 'Topi', 'iSH55WUw74UvZ18cq9236uP66f1x60', 1h12m04s, {'educational','cbd'}, dateof(now()));
insert into videos (uid, author , name, description, video_duration, tags, created_at) values (uuid(), 'gbonelleg', 'Long-crested hawk eagle', 'Dt7cVG6AD9V2L3u7g716H8E4z9D0D6', 13m04s, {'dogs'}, dateof(now()));
insert into videos (uid, author , name, description, video_duration, tags, created_at) values (uuid(), 'acollumbellf', 'Insect, stick', 'O93NJ5Z4g0va28jY4yya4y075H5687', 0h02m34s, {'cats'}, dateof(now()));
insert into videos (uid, author , name, description, video_duration, tags, created_at) values (uuid(), 'ematthiesen6', 'Turkey, common', 'x94LAG3bP2649613oz5B19UO146p3x', 1h53m02s, {'educational'}, dateof(now()));
insert into videos (uid, author , name, description, video_duration, tags, created_at) values (uuid(), 'whofton3', 'Bear, american black', 'oO66Al08Rz3Gh2633yRf9NSAGD1362', 53m12s, {'educational','sio'}, dateof(now()));
insert into videos (uid, author , name, description, video_duration, tags, created_at) values (uuid(), 'gmacgiollaj', 'Brush-tailed rat kangaroo', '2oka79Qk335kt22086vo1Fa206I49J', 12m04s, {'educational'}, dateof(now()));
insert into videos (uid, author , name, description, video_duration, tags, created_at) values (uuid(), 'mizkoveski4', 'Boa, columbian rainbow', '3MBf9337s44tO7rF7g4o6lVylMj98h', 12m04s, {'sports'}, dateof(now()));
insert into videos (uid, author , name, description, video_duration, tags, created_at) values (uuid(), 'adowdelld', 'Southern boubou', 'E7uh020f91y40Hk6o588rlVo9R6109', 43s, {'cats'}, dateof(now()));
insert into videos (uid, author , name, description, video_duration, tags, created_at) values (uuid(), 'etunnicliffei', 'Bat, madagascar fruit', 'h0oZnK0or11Bd38N94ZF0110SEf3yG', 12m13s, {'games'}, dateof(now()));
insert into videos (uid, author , name, description, video_duration, tags, created_at) values (uuid(), 'etunnicliffei', 'Porto goals', 'Golos do porto', 14m13s, {'soccer'}, dateof(now()));

insert into comments_users (uid, video, author, comment, created_at) values (uuid(), e9e20c0d-49ab-4c62-9fa2-94c717f81a3b,'abridgemane', 'Ahahah muito bom!', dateof(now()));
insert into comments_users (uid, video, author, comment, created_at) values (uuid(), c01cdc84-9737-4af4-b10d-28b65a101772,'kgreenrdea', 'Cassandra!!!', dateof(now()));
insert into comments_users (uid, video, author, comment, created_at) values (uuid(), c01cdc84-9737-4af4-b10d-28b65a101772,'gmacgiollaj', 'Portooo!', dateof(now()));
insert into comments_users (uid, video, author, comment, created_at) values (uuid(), 1cbf0aeb-7a4f-47c9-9250-42a38896b98a,'adowdelld', 'Like!', dateof(now()));
insert into comments_users (uid, video, author, comment, created_at) values (uuid(), 813024e1-3535-4240-ab66-383b42a00ebb,'swillcock2', 'Gostei da receita', dateof(now()));
insert into comments_users (uid, video, author, comment, created_at) values (uuid(), 1cbf0aeb-7a4f-47c9-9250-42a38896b98a,'swillcock2', 'niceeee', dateof(now()));
 
insert into comments_videos (uid, video, author, comment, created_at) values (uuid(), e9e20c0d-49ab-4c62-9fa2-94c717f81a3b,'abridgemane', 'Ahahah muito bom!', dateof(now()));
insert into comments_videos (uid, video, author, comment, created_at) values (uuid(), c01cdc84-9737-4af4-b10d-28b65a101772,'kgreenrdea', 'Cassandra!!!', dateof(now()));
insert into comments_videos (uid, video, author, comment, created_at) values (uuid(), c01cdc84-9737-4af4-b10d-28b65a101772,'gmacgiollaj', 'Portooo!', dateof(now()));
insert into comments_videos (uid, video, author, comment, created_at) values (uuid(), 1cbf0aeb-7a4f-47c9-9250-42a38896b98a,'adowdelld', 'Like!', dateof(now()));
insert into comments_videos (uid, video, author, comment, created_at) values (uuid(), 813024e1-3535-4240-ab66-383b42a00ebb,'swillcock2', 'Gostei da receita', dateof(now()));
insert into comments_videos (uid, video, author, comment, created_at) values (uuid(), 1cbf0aeb-7a4f-47c9-9250-42a38896b98a,'swillcock2', 'niceeee', dateof(now()));

insert into video_followers (video, users) values (e9e20c0d-49ab-4c62-9fa2-94c717f81a3b, {'pkettles1','abridgemane'});
insert into video_followers (video, users) values (c01cdc84-9737-4af4-b10d-28b65a101772, {'kgreenrdea','gmacgiollaj','gbonelleg'});
insert into video_followers (video, users) values (813024e1-3535-4240-ab66-383b42a00ebb, {'swillcock2'});

insert into video_events (uid, user, video, action, created_at, video_time) values (uuid(), 'swillcock2',813024e1-3535-4240-ab66-383b42a00ebb,'Pause',dateof(now()), 123000);
insert into video_events (uid, user, video, action, created_at, video_time) values (uuid(), 'swillcock2',c01cdc84-9737-4af4-b10d-28b65a101772,'Play',dateof(now()), 320000);
insert into video_events (uid, user, video, action, created_at, video_time) values (uuid(), 'adowdelld',e9e20c0d-49ab-4c62-9fa2-94c717f81a3b,'Skip 10 seconds',dateof(now()), 500000);

insert into video_rating (uid, rating, video) values (uuid(), 4, 813024e1-3535-4240-ab66-383b42a00ebb);
insert into video_rating (uid, rating, video) values (uuid(), 2, 813024e1-3535-4240-ab66-383b42a00ebb);
insert into video_rating (uid, rating, video) values (uuid(), 5, 813024e1-3535-4240-ab66-383b42a00ebb);
insert into video_rating (uid, rating, video) values (uuid(), 5, 813024e1-3535-4240-ab66-383b42a00ebb);
insert into video_rating (uid, rating, video) values (uuid(), 5, c01cdc84-9737-4af4-b10d-28b65a101772);
insert into video_rating (uid, rating, video) values (uuid(), 3, c01cdc84-9737-4af4-b10d-28b65a101772);


-- QUERIES

SELECT * FROM videos WHERE author = 'etunnicliffei';
SELECT * FROM videos WHERE author = 'cmenchenton0';

SELECT * FROM comments_users WHERE author = 'adowdelld';
SELECT * FROM comments_users WHERE author = 'swillcock2';

SELECT * FROM comments_videos WHERE video = 1cbf0aeb-7a4f-47c9-9250-42a38896b98a;
SELECT * FROM comments_videos WHERE video = c01cdc84-9737-4af4-b10d-28b65a101772;

SELECT COUNT(video) AS "Votes", AVG(rating) AS "Average Rating" FROM video_rating WHERE video = 813024e1-3535-4240-ab66-383b42a00ebb;
SELECT COUNT(video) AS "Votes", AVG(rating) AS "Average Rating" FROM video_rating WHERE video = c01cdc84-9737-4af4-b10d-28b65a101772;
