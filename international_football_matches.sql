CREATE DATABASE international_football_matches
		DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_general_ci;
USE international_football_matches;

CREATE TABLE results (
    id INT PRIMARY KEY AUTO_INCREMENT,
    match_date DATE,
    home_team VARCHAR(100),
    away_team VARCHAR(100),
    home_score INT,
    away_score INT,
    tournament VARCHAR(100),
    city VARCHAR(100),
    country VARCHAR(100),
    neutral_venue BOOL
);

CREATE TABLE goalscorers (
   id int PRIMARY KEY AUTO_INCREMENT,
   match_date date,
   home_team varchar(100),
   away_team varchar(100),
   player_name varchar(100),
   score_minute time,
   own_goal bool,
   penalty bool
);

CREATE TABLE shootouts (
    id int primary key AUTO_INCREMENT,
    match_date date,
    home_team varchar(100),
    away_team varchar(100),
    winner varchar(100)
);

# Loading csv data into tables
LOAD DATA
    LOCAL INFILE 'C:\\Users\\Cairo\\Documents\\BI Projects\\International Football Matches\\results.csv'
    INTO TABLE results
    FIELDS TERMINATED BY ';'
    LINES TERMINATED BY '\n'
    IGNORE 1 LINES
    (match_date, home_team, away_team, home_score, away_score, tournament, city, country, neutral_venue);

LOAD DATA
  LOCAL INFILE 'C:\\Users\\Cairo\\Documents\\BI Projects\\International Football Matches\\goalscorers.csv'
  INTO TABLE goalscorers
  FIELDS TERMINATED BY ';'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES
  (match_date, home_team, away_team, player_name, score_minute, own_goal, penalty);
  
LOAD DATA
  LOCAL INFILE 'C:\\Users\\Cairo\\Documents\\BI Projects\\International Football Matches\\shootouts.csv'
  INTO TABLE shootouts
  FIELDS TERMINATED BY ';'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES
  (match_date, home_team, away_team, winner);

# How many matches were played
SELECT COUNT(*) FROM results;

# All results from all matches
SELECT 
    (SELECT 
            COUNT(*)
        FROM
            results
        WHERE
            (home_score > away_score)) AS home_team_wins,
    (SELECT 
            COUNT(*)
        FROM
            results
        WHERE
            (away_score > home_score)) AS away_team_wins,
    (SELECT 
            COUNT(*)
        FROM
            results
        WHERE
            (home_score = away_score)) AS draws;
        
        
###################################################### Em construção ######################################################
# TODO: Percentual de jogos ganhos em casa e fora de casa, antes e depois de 1980
SET @home_team_wins_before1980 = (SELECT COUNT(*) FROM results WHERE (home_score > away_score) AND match_date < '1980-01-01'); # setando variável

SELECT 
    @home_team_wins_before1980 / COUNT(results.home_team) AS home_team_wins_percent
FROM
    results
WHERE match_date < '1980-01-01';

# TODO: Seleção que mais venceu jogos (total, em casa, fora de casa, como percentual dos jogos)