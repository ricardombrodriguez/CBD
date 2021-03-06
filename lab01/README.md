# Aula prática 01

Recomendado Linux para a cadeira.
Software utilizado -> *Redis* (REmote DIctionary Service)

# What is Redis?

Redis is an open-source NoSQL key-value datastore where instead of storing just one type of value, such as a string, more complex types of values can be stored. Redis, short for REmote DIctionary Server, was created and is actively maintained and developed by Salvatore Sanfilippo.

By thinking how data can represented and managed as basic computing data structures like a lists, hashes, and sets, Redis allows you to grasp both positive and negative characteristics of your data and it's structures in a more fundamental, mathematical fashion then going through intermediate structuring process.

# Redis data structure

![redis](http://intro2libsys.info/introduction-to-redis/static/img/redis-data-structure-server.svg)

**IT ALL BEGINS WITH THE KEY**

Redis keys are binary safe - any binary stream can be used as a key - although the most common (and recommended) stream to use is a string key, like "Person", other file formats and binary streams like images, mp3, or other file formats, can be used.

The flexibility of Redis allows for a wide diversity in how keys are structured and stored. Performance and maintainability of the Redis instance can be either positively or negatively impacted by the choices made in designing and constructing the Redis keys using in your database.

A good general practice when designing your Redis keys is to construct at least a rough outline of what information you are trying to store in Redis, which Redis data structure to use, and finally how your data structures relates to other information stored at different keys in your Redis database.

## Data-types

### String

In Redis, a string is not merely alphanumeric characters as strings are normally understood to be in higher-level programming languages, but are serialized characters in C. 

**Integers are stored in Redis as a string.**

Command examples:

```
127.0.0.1:6379> SET Book:1 "Infinite Jest"
OK
127.0.0.1:6379> GET Book:1
"Infinite Jest"
127.0.0.1:6379> SET Book:1:ReadAction 1
OK
127.0.0.1:6379> GET Book:1:ReadAction
"1"

127.0.0.1:6379> INCR Book:1:ReadAction
(integer) 2
127.0.0.1:6379> GET Book:1:ReadAction
"2"
127.0.0.1:6379> INCRBY Book:1:ReadAction 20
(integer) 22
127.0.0.1:6379> GET Book:1:ReadAction
"22"
127.0.0.1:6379> DECR Book:1:ReadAction
(integer) 21
127.0.0.1:6379> GET Book:1:ReadAction
"21"
127.0.0.1:6379> DECRBY Book:1:ReadAction 5
(integer) 16
127.0.0.1:6379> GET Book:1:ReadAction
"16"

127.0.0.1:6379> MSET Person:2 "Kurt Vonnegut" Person:3 "Jane Austen" Person:4 "Mark Twain"
OK
127.0.0.1:6379> MGET Person:2 Person:3 Person:4
1) "Kurt Vonnegut"
2) "Jane Austen"
3) "Mark Twain"
```

Setting a string value with a characters and an integer using the SET and GET commands.

The INCR command will increase an string "integer" value by 1, the INCRBY command is similar but increase the value by a integer. The DECR and DECRBY commands decrease an string "integer" value by 1 or more.

You can set multiple key-string values using MSET command. The MGET command retrieves multiple values from one or more keys.

If key already exists and is a string, this command appends the value at the end of the string. If key does not exist it is created and set as an empty string, so APPEND will be similar to SET in this special case.

```
redis> EXISTS mykey
(integer) 0
redis> APPEND mykey "Hello"
(integer) 5
redis> APPEND mykey " World"
(integer) 11
redis> GET mykey
"Hello World"
```

Accessing individual elements in the time series is not hard:

- STRLEN can be used in order to obtain the number of samples.
- GETRANGE allows for random access of elements. If our time series have associated time information we can easily implement a binary search to get range combining GETRANGE with the Lua scripting engine available in Redis 2.6.
- SETRANGE can be used to overwrite an existing time series.

Critical Commands for String:

- SET key string optional nx|xx
- GET key
- INCR key
- INCRBY key integer
- DECR key
- DECRBY key integer
- APPEND key string
- MSET key1 string key2 string
- MGET key1 key2 key3


### List

Lists in Redis are ordered collections of Redis strings that allows for duplicates values. Because Redis lists are implemented as linked-lists, adding an item to the front of the list with LPUSH or to the end of the list with RPUSH are relatively inexpensive operations that are performed in constant time of O(1).

The LPUSH command adds one or more elements to the front of a list, the RPUSH command adds one or more elements to the end of a list.

```
127.0.0.1:6379> LPUSH Book:1:comment "This was a fun read"
(integer) 1
127.0.0.1:6379> LRANGE Book:1:comment 0 -1
1) "This was a fun read"
127.0.0.1:6379> LPUSH Book:1:comment "Way too long!"
(integer) 2
127.0.0.1:6379> LRANGE Book:1:comment 0 -1
1) "Way too long!"
2) "This was a fun read"
127.0.0.1:6379> RPUSH Book:1:comment "Tennis anyone?"
(integer) 3
127.0.0.1:6379> LRANGE Book:1:comment 0 -1
1) "Way too long!"
2) "This was a fun read"
3) "Tennis anyone?"
```
   
The LPOP command remove the first element from the list and returns it the calling client while the RPOP command removes and returns the last element of the list.

```
127.0.0.1:6379> LPOP Book:1:comment
"Way too long!"
127.0.0.1:6379> LRANGE Book:1:comment 0 -1
1) "This was a fun read"
2) "Tennis anyone?"
127.0.0.1:6379> RPOP Book:1:comment
"Tennis anyone?"
127.0.0.1:6379> LRANGE Book:1:comment 0 -1
1) "This was a fun read" 
```
   
The LTRIM command replaces a list with a range from an existing list.

```
127.0.0.1:6379> RPUSH Organization:1:members Person:1 Person:2 Person:3 Person:4
(integer) 4
127.0.0.1:6379> LRANGE Organization:1:members 0 -1
1) "Person:1"
2) "Person:2"
3) "Person:3"
4) "Person:4"
127.0.0.1:6379> LTRIM Organization:1:members 0 2
OK
127.0.0.1:6379> LRANGE Organization:1:members 0 -1
1) "Person:1"
2) "Person:2"
3) "Person:3"
```
   
To add in implementing simple queues in Redis using the List data-type, the BLPOP and BRPOP commands are similar to LPOP and RPOP commands only they will block sending a return back to client if the list is empty. These blocking commands return two values, the key of the list and an element.

```
127.0.0.1:6379> BRPOP Organization:1:members 5
1) "Organization:1:members"
2) "Person:3"
127.0.0.1:6379> LRANGE Organization:1:members 0 -1
1) "Person:1"
2) "Person:2"   

```

### Hash

To set the value of a single field, use the HSET, to retrieve a single field for a Hash key, use the HGET command.

```
127.0.0.1:6379> HSET Book:3 name "Cats Cradle"
(integer) 1
127.0.0.1:6379> HGET Book:3 name
"Cats Cradle"

```

You can set multiple field-values using the HMSET command and retrieve multiple field-values with the HMGET command. To retrieve all of the values of a Redis Hash, use the HGETALL command.


```
127.0.0.1:6379> HMSET Book:4 name "Slaughterhouse-Five" author "Kurt Vonnegut" copyrightYear 1969 ISBN 29960763
OK
127.0.0.1:6379> HMGET Book:4 author ISBN
1) "Kurt Vonnegut"
2) "29960763"
127.0.0.1:6379> HGETALL Book:4
1) "name"
2) "Slaughterhouse-Five"
3) "author"
4) "Kurt Vonnegut"
5) "copyrightYear"
6) "1969"
7) "ISBN"
8) "29960763"
   
```
   
The HEXISTS determine if a field exists in a Redis Hash. The HLEN returns the number fields in a Redis Hash.

```
127.0.0.1:6379> HEXISTS Book:4 copyrightYear
(integer) 1
127.0.0.1:6379> HEXISTS Book:4 barcode
(integer) 0
127.0.0.1:6379> HLEN Book:4
(integer) 4  
```

The HKEYS returns all of the field names for a Redis Hash and the HVALS returns all of the values in the Hash.


```
127.0.0.1:6379> HKEYS Book:4
1) "name"
2) "author"
3) "copyrightYear"
4) "ISBN"
127.0.0.1:6379> HVALS Book:4
1) "Slaughterhouse-Five"
2) "Kurt Vonnegut"
3) "1969"
4) "29960763"
   
```

HDEL deletes a field from a hash and the HINCRBY increases the integer value of a hash field by a given number.


```
127.0.0.1:6379> HDEL Book:4 copyrightYear
(integer) 1
127.0.0.1:6379> HGETALL Book:4
1) "name"
2) "Slaughterhouse-Five"
3) "author"
4) "Kurt Vonnegut"
5) "ISBN"
6) "29960763"
127.0.0.1:6379> HSET Book:4 copyrightYear 1968
(integer) 1
127.0.0.1:6379> HGET Book:4 copyrightYear
"1968"
127.0.0.1:6379> HINCRBY Book:4 copyrightYear 1
(integer) 1969
127.0.0.1:6379> HGET Book:4 copyrightYear
"1969"

```

### Set

A set is a collection of string values where uniqueness of each member is guaranteed but does not offer ordering of members. Redis sets also implement union, intersection, and difference set semantics along with the ability to store the results of those set operations as a new Redis.

The SADD command adds one or members to a set, to display all of the members of a set use the SMEMBERS command.

```
127.0.0.1:6379> SET Organization:5 "Beatles"
127.0.0.1:6379> SADD Organization:5:member Paul John George Ringo
(integer) 4
127.0.0.1:6379> SMEMBERS Organization:5:member
1) "Ringo"
2) "John"
3) "Paul"
4) "George"
```


The SISMEMBER command determines if a value is a member of a set, the SCARD command returns the number of members in a set.

```
127.0.0.1:6379> SISMEMBER Organization:5:member "John"
(integer) 1
127.0.0.1:6379> SISMEMBER Organization:5:member "Ralph"
(integer) 0
127.0.0.1:6379> SCARD Organization:5:member
(integer) 4
```
  
Set operations, union and intersection, are available with the SUNION and SINTER commands respectively. The SDIFF command subtracts multiple sets.

```
127.0.0.1:6379> SET Organization:6 "Wings"
OK
127.0.0.1:6379> SET Organization:7 "Traveling Wilburys"
OK
127.0.0.1:6379> SADD Organization:6:member Paul Linda Denny
(integer) 3
127.0.0.1:6379> SADD Organization:7:member Bob George Jeff Roy Tom
(integer) 5
127.0.0.1:6379> SUNION Organization:5:member Organization:6:member
1) "Ringo"
2) "John"
3) "Paul"
4) "George"
5) "Denny"
6) "Linda"
127.0.0.1:6379> SUNION Organization:6:member Organization:7:member
1) "Paul"
2) "George"
3) "Roy"
4) "Bob"
5) "Denny"
6) "Tom"
7) "Linda"
8) "Jeff"
127.0.0.1:6379> SUNION Organization:5:member Organization:6:member Organization:8
 1) "Roy"
 2) "George"
 3) "Bob"
 4) "Denny"
 5) "Linda"
 6) "Ringo"
 7) "Paul"
 8) "John"
 9) "Tom"
10) "Jeff"
127.0.0.1:6379> SINTER Organization:5:member Organization:6:member
1) "Paul"
127.0.0.1:6379> SINTER Organization:5:member Organization:7:member
1) "George"
127.0.0.1:6379> SINTER Organization:6:member Organization:7:member
(empty list or set)
127.0.0.1:6379> SDIFF Organization:5:member Organization:6:member
1) "John"
2) "Ringo"
3) "George"
127.0.0.1:6379> SDIFF Organization:6:member Organization:5:member
1) "Linda"
2) "Denny"
```

