DROP DATABASE IF EXISTS CINEMA_CHAIN;
CREATE DATABASE CINEMA_CHAIN;
USE CINEMA_CHAIN; #Default Database

SET FOREIGN_KEY_CHECKS=0; #Disable ALL foreign key constraint checks

CREATE TABLE CINEMA (
	address VARCHAR(250) NOT NULL,
    cinema_name VARCHAR (180) NOT NULL,
    cinema_ID INT NOT NULL AUTO_INCREMENT,
    primary key (cinema_ID)
);

CREATE TABLE THEATER (
	seating_capacity INT NOT NULL,
    cinema_ID INT NOT NULL,
    theater_number CHAR(3) NOT NULL,
    primary key (theater_number),
    foreign key (cinema_ID) REFERENCES CINEMA(cinema_ID)
);

CREATE TABLE MOVIE (
	director_name VARCHAR(180) NOT NULL,
    movie_name VARCHAR(250) NOT NULL,
    time_slot TIME NOT NULL,
    release_year YEAR NOT NULL,
    movie_rating INT NOT NULL,
    theater_num CHAR(3) NOT NULL,
    primary key (movie_name, time_slot),
    #unique(movie_name, release_year),
    foreign key (theater_num) REFERENCES THEATER(theater_number)
);

CREATE TABLE PEOPLE (
	bdate DATE NOT NULL,
    age_group CHAR(5) NOT NULL,
    awards_member VARCHAR(6) NOT NULL,
    email VARCHAR(255) NOT NULL,
    primary key (email)
);

CREATE TABLE TICKET (
	ticket_price DECIMAL(10,2) UNSIGNED NOT NULL,
    movie_name VARCHAR(250) NOT NULL,
    time_slot TIME NOT NULL,
	email VARCHAR(255) NOT NULL,
    ticket_price_index INT NOT NULL AUTO_INCREMENT,
    primary key (ticket_price_index),
    foreign key (movie_name, time_slot) REFERENCES MOVIE(movie_name, time_slot),
    foreign key (email) REFERENCES PEOPLE(email)
);

CREATE TABLE WATCHED (
	mov_name VARCHAR(250) NOT NULL,
    time_slot TIME NOT NULL,
    email VARCHAR(255) NOT NULL,
    num_watched INT NOT NULL,
    primary key(mov_name, time_slot, email),
    foreign key (mov_name, time_slot) REFERENCES MOVIE(movie_name, time_slot),
    foreign key (email) REFERENCES PEOPLE(email)
);

# -- In order to enable the foreign keys, we need to insert values for each table -- #

# insert values into CINEMA table
INSERT INTO CINEMA 
	VALUES
('4400 Towne Center Dr, Louisville, KY 40241', 'Cinemark Tinseltown', 101),
('12450 Sycamore Station Pl, Louisville, KY 40299', 'Xscape Theatres', 102),
('2745 S Hurstbourne Pkwy, Louisville, KY 40220', 'AMC Stonybrook 20', 103),
('2800 Gottbrath Pkwy, Jeffersonville, IN 47130', 'Xscape Jeffersonville 12', 104),
('1250 Bardstown Rd, Louisville, KY 40204', 'Baxter Avenue Theatres', 105);

-- Set next auto-increment to 106
ALTER TABLE CINEMA AUTO_INCREMENT = 106;

# insert values into THEATER table
INSERT INTO THEATER
	VALUES
(250, 101, 'A01'),
(300, 102, 'A02'),
(150, 103, 'A03'),
(450, 104, 'A04'),
(600, 105, 'A05'),
(600, 105, 'A06');

# insert values into MOVIE table
INSERT INTO MOVIE
	VALUES
('Steven Spielberg', 'Jaws', '22:00:00', 1975, 5, 'A01'),
('Christopher Nolan', 'Inception', '13:00:00', 2010, 4, 'A02'),
('Steven Spielberg', 'Jurassic Park', '14:30:00', 1993, 5, 'A03'),
('Colin Trevorrow', 'Jurassic World Dominion', '19:30:00', 2022, 2, 'A04'),
('Adam Wingard', 'Godzilla x Kong: The New Empire', '12:00:00', 2024, 3, 'A05'),
('Adam Wingard', 'Godzilla x Kong: The New Empire', '10:00:00', 2024, 3, 'A06'),
('Greta Gerwig', 'Barbie', '23:00:00', 2023, 4, 'A06');

# insert values into PEOPLE table
INSERT INTO PEOPLE
	VALUES
('1998-04-12', 'adult', 'Golden', 'alex@gmail.com'),
('2011-11-03', 'child', 'None',  'bella@gmail.com'),
('1987-07-29', 'adult', 'Silver', 'carla@yahoo.com'),
('1975-02-15', 'adult', 'Golden', 'derek@hotmail.com'),
('2005-09-08', 'adult', 'None', 'emma@gmail.com'),
('1999-10-05', 'adult', 'None', 'mary@gmail.com'),
('2010-12-10', 'child', 'None',  'sarah710@gmail.com');

# insert values into TICKET table
INSERT INTO TICKET
    VALUES
(15.00, 'Jaws', '22:00:00', 'alex@gmail.com', 1),             -- Alex, $15 per ticket
(12.00, 'Jurassic World Dominion', '19:30:00', 'derek@hotmail.com', 2), -- Derek, $12 per ticket
(10.00, 'Jurassic Park', '14:30:00', 'carla@yahoo.com', 3),   -- Carla, $10 per ticket
(9.00, 'Inception', '13:00:00', 'bella@gmail.com', 4),        -- Bella, $9 per ticket
(8.00, 'Godzilla x Kong: The New Empire', '12:00:00', 'emma@gmail.com', 5), -- Emma, $8 per ticket
(7.00, 'Godzilla x Kong: The New Empire', '10:00:00', 'mary@gmail.com', 6),
(16.00, 'Barbie', '23:00:00', 'sarah710@gmail.com', 7); -- Sarah, $16 per ticket

-- Set next auto-increment for tickets
ALTER TABLE TICKET AUTO_INCREMENT = 8;

# insert values into WATCHED table
INSERT INTO WATCHED
    VALUES
('Jaws', '22:00:00', 'alex@gmail.com', 2),            -- Alex bought 2 tickets
('Jurassic World Dominion', '19:30:00', 'derek@hotmail.com', 3), -- Derek bought 3 tickets
('Jurassic Park', '14:30:00', 'carla@yahoo.com', 1),  -- Carla bought 1 ticket
('Inception', '13:00:00', 'bella@gmail.com', 1),      -- Bella bought 1 ticket
('Godzilla x Kong: The New Empire', '12:00:00', 'emma@gmail.com', 2), -- Emma bought 2 tickets
('Godzilla x Kong: The New Empire', '10:00:00', 'mary@gmail.com', 1),
('Barbie', '23:00:00', 'sarah710@gmail.com', 2); -- Sarah bought 2 tickets

SET FOREIGN_KEY_CHECKS = 1; #We will now enable all the foreign key checks

# -- Stored Procedure Queries -- #
# Get total number of tickets sold for a specific movie for various show times (Stored Procedure with an Output Argument)
DELIMITER //

CREATE PROCEDURE total_tickets_sold(
    IN in_movie_name VARCHAR(250),
    OUT total_sold INT
)
BEGIN
    SELECT SUM(num_watched) INTO total_sold
    FROM WATCHED
    WHERE mov_name = in_movie_name;
END;
//

DELIMITER ;

-- How many tickets were sold for the movie Jaws?
CALL total_tickets_sold('Jaws', @sold);
SELECT @sold;

-- How many tickets were sold for the movie Jurassic World Dominion?
CALL total_tickets_sold('Jurassic World Dominion', @sold);
SELECT @sold;

-- How many tickets were sold for the movie Godzilla x Kong: The New Empire?
CALL total_tickets_sold('Godzilla x Kong: The New Empire', @sold);
SELECT @sold;

# Get the movie name with its release year and show time by a specific director (Stored Procedure with an Input Argument)
DELIMITER //

CREATE PROCEDURE movies_by_director(
	IN in_director VARCHAR (180)
)
BEGIN
	SELECT movie_name, release_year, time_slot
    FROM MOVIE
    WHERE director_name = in_director;
END;
//

DELIMITER ;

-- What movies with their associated release year and show time were directed by Steven Spielberg?
CALL movies_by_director('Steven Spielberg');

# For all ticket buyers, get their emails, age group, the movie name they watched, the show time, and the ticket price 
# (Stored Procedure Involving a JOIN and Input)
DELIMITER //

CREATE PROCEDURE ticket_buyer_info ( 
	IN in_email VARCHAR(225)
)
BEGIN
	SELECT PEOPLE.email, age_group, movie_name, time_slot, ticket_price
	FROM PEOPLE JOIN TICKET ON PEOPLE.email = TICKET.email
    WHERE PEOPLE.email = in_email;
END;
//

DELIMITER ;

-- what is the information for emma@gmail.com?
CALL ticket_buyer_info('emma@gmail.com');

# Get the number of movies scheduled per theater (Stored Procedure with an Input Argument)
DELIMITER //

CREATE PROCEDURE movies_per_theater(
    IN in_theater_num CHAR(3)
)
BEGIN
    SELECT theater_num, COUNT(*) AS number_of_movies
    FROM MOVIE
    WHERE theater_num = in_theater_num
    GROUP BY theater_num;
END;
//

DELIMITER ;

-- what is the number of movies scheduled for theater A06
CALL movies_per_theater('A06')

# Get the total number of tickets sold for each movie with its associated show times (Stored Procedure)
DELIMITER //

CREATE PROCEDURE movies_and_tickets_sold(
	IN in_movie_name VARCHAR(250),
    IN in_time_slot TIME
)
BEGIN
    SELECT MOVIE.movie_name, MOVIE.time_slot, SUM(WATCHED.num_watched) AS tickets_sold
    FROM MOVIE JOIN WATCHED ON MOVIE.movie_name = WATCHED.mov_name AND MOVIE.time_slot = WATCHED.time_slot
    WHERE MOVIE.movie_name = in_movie_name AND MOVIE.time_slot = in_time_slot
    GROUP BY MOVIE.movie_name, MOVIE.time_slot;
END;
//

DELIMITER ;

-- what is the total number of tickets sold for Godzilla x Kong: New Empire at the 12:00 pm showing?
CALL movies_and_tickets_sold('Godzilla x Kong: The New Empire', '12:00:00');

# Get the total revenue generated by a movie (Stored Prodecure)
DELIMITER //

CREATE PROCEDURE revenue_generated_per_movie(
	IN in_movie_name VARCHAR(250)
)
BEGIN
	SELECT TICKET.movie_name, TICKET.time_slot, num_watched, num_watched*ticket_price AS revenue_generated
	FROM TICKET JOIN WATCHED ON TICKET.movie_name = WATCHED.mov_name AND TICKET.time_slot = WATCHED.time_slot
    WHERE TICKET.movie_name = in_movie_name;
END;
//

DELIMITER ;

-- what is the total revenue generated from showing Jaws at the cinemas?
CALL revenue_generated_per_movie('Jaws');

# checking if new entries were added through the GUI system
SELECT * FROM CINEMA;
SELECT * FROM THEATER;
SELECT * FROM MOVIE;
SELECT * FROM PEOPLE;
SELECT * FROM TICKET;
SELECT * FROM WATCHED;