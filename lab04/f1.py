from neo4j import GraphDatabase

races_file = "file:///AllRace.csv"
constructor_file = "file:///ConstructorStandings.csv"
driver_file = "file:///DriverStandings.csv"

class Formula1:

    def __init__(self, uri, user, password):
        self.driver = GraphDatabase.driver(uri, auth=(user, password))

    def close(self):
        self.driver.close()

    def insert_data(self):
        self.insert_nodes()
        self.insert_relationships()

    def insert_nodes(self):
        with self.driver.session() as session:
            session.run(
                "LOAD CSV WITH HEADERS FROM 'file:///AllRace.csv' AS Row MERGE (race:Race {name: Row.Race, date: Row.Date}) ")
            session.run(
                "LOAD CSV WITH HEADERS FROM 'file:///ConstructorStandings.csv' AS Row MERGE (team:Team {name: Row.Team}) ")
            session.run(
                "LOAD CSV WITH HEADERS FROM 'file:///DriversStandings.csv' AS Row MERGE (driver:Driver {name: Row.Driver, nationality: Row.Nationality}) ")
            session.run(
                "LOAD CSV WITH HEADERS FROM 'file:///DriversStandings.csv' AS Row MERGE (championship:Championship {year: Row.Year}) ")

    def insert_relationships(self):
        with self.driver.session() as session:
            for position in range(1,36):
                session.run(
                    "LOAD CSV WITH HEADERS FROM 'file:///AllRace.csv' AS Row MATCH(driver:Driver {name: Row.`" + str(position) + "`}),(race:Race {name: Row.Race, date: Row.Date}) MERGE (driver)-[:RACED_IN{position:" + str(position) + "}]->(race) ")
            session.run(
                "LOAD CSV WITH HEADERS FROM 'file:///ConstructorStandings.csv' AS Row MATCH(team:Team {name: Row.Team}),(championship:Championship {year: Row.Year}) MERGE (team)-[:FOUGHT_FOR{position: Row.Pos, points: Row.PTS}]->(championship) ")
            session.run(
                "LOAD CSV WITH HEADERS FROM 'file:///DriversStandings.csv' AS Row MATCH(driver:Driver {name: Row.Driver, nationality: Row.Nationality}),(championship:Championship {year: Row.Year}) MERGE (driver)-[r:FOUGHT_FOR{position: Row.Pos, points: Row.PTS}]->(championship) SET r.team = Row.Car ")
            session.run(
                "LOAD CSV WITH HEADERS FROM 'file:///DriversStandings.csv' AS Row MATCH(driver:Driver {name: Row.Driver, nationality: Row.Nationality}),(team:Team {name: Row.Car}) MERGE (driver)-[:DRIVED_FOR{position: Row.Pos, points: Row.PTS, year: Row.Year}]->(team) ")

    def run_query(self, query):
        with self.driver.session() as session:
            return list(session.run(query))

    def run_queries(self, query_title, query_cypher):

        counter = 1

        with open("CBD_L44c_output.txt", "w") as writer:
            for current_query in query_cypher:
                writer.write("Query n" +  str(counter) + ": " + query_title[counter-1]+"\n")
                writer.write(current_query +"\n\n")

                counter += 1

                result = self.run_query(current_query)

                i = result[0]
                s = ""
                for j in range(len(i.items())):
                    string = "| " + str(i.items()[j][0])
                    s += "{: <50}".format(string)
                writer.write("   " + str(s) + "\n")

                for i in result:
                    s = ""
                    for j in range(len(i.items())):
                        string = "| " + str(i.items()[j][1])
                        s += "{: <50}".format(string)
                    writer.write("   " + str(s) + "\n")
                writer.write("\n\n\n")


query_cypher = ["MATCH (driver:Driver)-[r:RACED_IN]->(race:Race {date: '30-Aug-20'}) RETURN race.name, r.position, driver.name ORDER BY r.position ASC",
                "MATCH (driver:Driver)-[r:RACED_IN]->(n:Race) WHERE r.position = 1 WITH driver, count(driver) AS num_wins ORDER BY num_wins DESC MATCH (driver)-[r]->(race:Race) WITH driver,num_wins,count(race) AS num_races, round(num_wins * 100 / count(race),2) AS win_ratio RETURN driver.name, driver.nationality,num_races,num_wins,win_ratio LIMIT 20",
                "MATCH (driver:Driver)-[r:DRIVED_FOR]->(team:Team {name: 'Ferrari'}) WITH driver, team, sum(toInteger(r.points)) AS points, count(r.year) AS years_spent, collect(r.year) AS list_years WHERE all(year in list_years WHERE toInteger(year) <= 1990) RETURN driver.name, driver.nationality, team.name, years_spent, list_years, points ORDER BY points DESC",
                "MATCH (driver:Driver)-[r:FOUGHT_FOR]->(championship:Championship) WITH driver.nationality AS country, count(driver) AS num_drivers, sum(toInteger(r.points)) AS total_points RETURN country, num_drivers, total_points, (total_points/num_drivers) AS points_per_driver ORDER BY total_points DESC LIMIT 10",
                "MATCH (driver:Driver)-[r]->(race:Race) WHERE race.name STARTS WITH 'Portugal' WITH driver, sum(toInteger(r.position)) AS sum_positions, collect(toInteger(r.position)) AS positions, collect(race.date) AS dates, avg(toInteger(r.position)) AS avg_position WHERE all(position IN positions WHERE toInteger(position) < 6) AND size(positions) > 1 RETURN driver.name, driver.nationality, avg_position, positions, dates ORDER BY avg_position ASC LIMIT 3",
                "MATCH (team:Team)-[r1:FOUGHT_FOR]->(championship:Championship {year: '2014'})<-[r2:FOUGHT_FOR]-(driver:Driver) WHERE team.name = r2.team WITH team, toInteger(r1.points) AS team_points, toInteger(r1.position) AS team_position, collect(driver.name) AS drivers_names, collect(toInteger(r2.points)) AS drivers_points, collect(toInteger(r2.position)) AS drivers_positions RETURN team.name, team_position, team_points, drivers_names, drivers_points, drivers_positions  ORDER BY team_position ASC",
                "MATCH (team:Team)-[:FOUGHT_FOR]->(championship:Championship)<-[:FOUGHT_FOR]-(driver:Driver) WITH team, count(DISTINCT championship) AS num_years, count(DISTINCT driver) AS num_drivers RETURN team.name,num_years,num_drivers ORDER BY num_years DESC LIMIT 10",
                "MATCH (driver:Driver {name: 'Sergio Perez PER'})-[r:RACED_IN]->(race:Race) WITH driver,toInteger(r.position) AS position, race RETURN driver.name,driver.nationality,position,race.name,race.date ORDER BY position ASC LIMIT 1",
                "MATCH (driver:Driver)-[r:FOUGHT_FOR]->(championship:Championship) WITH driver,championship,toInteger(r.points) AS points RETURN driver.name,driver.nationality,points,championship.year ORDER BY points DESC LIMIT 1",
                "MATCH (driver:Driver {name: 'Michael Schumacher MSC'})-[r:FOUGHT_FOR]->(championship:Championship) WITH driver,championship,toInteger(r.points) AS points, toInteger(r.position) AS position, r.team AS team RETURN driver.name,driver.nationality,championship.year as year,position,points,team ORDER BY toInteger(championship.year) ASC"]

query_titles = ["Get all drivers that raced in 30-Aug-20 and order them by the position. Show the name of the Gran Prix too.",
            "Count the number of races each driver has participated, the number of races he won and his win-ratio (%). Present only 20 of them by number of wins in descending order.",
            "List all the drivers that raced for 'Ferrari' before 1990 (old scoring system), their nationality, the number of years they spent in the team, the list of years they spent in the team and all the points they earned for the team. Order them by points scored in descending order.",
            "Get the top 10 countries with the most points scored by their national drivers since 2010, alongside with the number of drivers and the average points scored by a driver.",
            "Get the 3 drivers with the best position average (the less the better) in 'Portugal', who raced more than one time there and whose position was always 5th place or higher, alongside with the list of positions obtained and the date of the races.",
            "Get all the teams/constructors who fought for the 2014 championship, showing the team position, the total points obtained by the team, the drivers of the team in that year, its points and its positions. Order them by team position, from best to worse.",
            "Get the top 10 teams who are in Formula 1 for the longest time, showing the number of pilots they had and the number of years they fought for championships.",
            "Get the best result 'Sergio Perez' ever got in a F1 race, showing the position he got and the name and date of the race.",
            "Get the driver who scored the most points in a F1 championship.",
            "Get the standings obtained by 'Michael Schumacher' throughout each year of his career, his points and the car he raced."]


if __name__ == "__main__":
    f1 = Formula1("bolt://localhost:7687", "neo4j", "admin")
    f1.insert_data()
    f1.run_queries(query_titles,query_cypher)
    f1.close()
