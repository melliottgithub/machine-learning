CREATE TABLE movie (
	movie_title VARCHAR(80) NOT NULL,
	color VARCHAR(20),
	genres VARCHAR(80) NOT NULL,
	language VARCHAR(20),
	country	VARCHAR(20),
	title_year SMALLINT
);

CREATE TABLE rating (
	movie_id CHAR(4) NOT NULL,
	movie_title VARCHAR(80) NOT NULL,
	imdb_score NUMERIC(2, 1) -- not nullD
);

-- select * from rating
-- CREATE TABLE movie_sparse (
-- 	movie_title VARCHAR(80) NOT NULL,
-- 	title_year SMALLINT
-- );

CREATE TABLE movie_cast (
	movie_title VARCHAR(80) NOT NULL,
	director VARCHAR(50),
	actor VARCHAR(50)
);

CREATE TABLE engagement (
	movie_id CHAR(4) NOT NULL,
	votes BIGINT NOT NULL,
	reviews SMALLINT -- NOT NULL
);


CREATE TABLE revenue (
	movie_title varchar(80) NOT NULL,
	budget BIGINT,
	gross_revenue BIGINT
);

-------------------------------------------------------------------------------------------------
--------------------------------------------- DEMO 2 ---------------------------------------------
--------------------------------------------------------------------------------------------------
-- commands:
-- SELECT (*, my_column_name, DISTINCT)
-- FROM
-- LIMIT
-- ORDER BY (ASC (usually default), DESC)
-- WHERE (AND, OR, IS NOT, NULL, LIKE)




SELECT * FROM movie LIMIT 5;
SELECT * FROM movie_sparse LIMIT 5;
SELECT * FROM rating LIMIT 5;
SELECT * FROM engagement LIMIT 5;
SELECT * FROM revenue LIMIT 5;


-- movie_cast
-- watch out for headers!!
SELECT * FROM movie_cast LIMIT 3;
SELECT COUNT(*) FROM movie_cast;
SELECT COUNT(*) FROM movie_cast WHERE director IS NULL;
DELETE FROM movie_cast WHERE movie_title='movie_title';





SELECT COUNT(country) FROM movie;
-- distinct?
-- number of distinct?


-- ORDER BY
SELECT movie_title, genres, title_year
	FROM movie
	WHERE title_year IS NOT NULL
	ORDER BY title_year DESC
	LIMIT 30;


-- WHERE
-- Note case sensitivity
-- regex
SELECT movie_title, genres, title_year FROM movie WHERE genres = 'Drama';
SELECT movie_title, genres, title_year FROM movie WHERE genres IN ('Drama', 'Drama|Thriller');
SELECT movie_title, genres, title_year FROM movie WHERE genres = 'drama';
SELECT movie_title, genres, title_year FROM movie WHERE genres = 'Drama' OR genres LIKE '%Action%';

-- Combined
-- Update the below query so every row has a title_year
SELECT movie_title, genres, title_year
	FROM movie
	WHERE genres LIKE '%Action%'
	ORDER BY title_year DESC
	LIMIT 5;






SELECT movie_title, genres, title_year
	FROM movie
	WHERE genres LIKE '%Action%' AND title_year IS NOT NULL
	ORDER BY title_year DESC, genres DESC
	LIMIT 3;


--------------------------------------------------------------------------------------------------
--------------------------------------------- DEMO 3 ---------------------------------------------
------------------------------------------ AGGREGATION -------------------------------------------
--------------------------------------------------------------------------------------------------


-- COUNT
SELECT COUNT(DISTINCT(genres)) FROM movie;
SELECT COUNT(*) FROM movie;

-- MIN / MAX
SELECT MIN(title_year) FROM movie;
SELECT MIN(title_year), MAX(title_year) FROM movie;

-- AVG
-- What is the average production year for each genre?
SELECT genres, AVG(title_year)
	FROM movie
	GROUP BY genres
	ORDER BY avg; -- weird 'avg' at end

SELECT genres, AVG(title_year) AS avg_title_year
	FROM movie
	GROUP BY genres
	ORDER BY avg_title_year;


-- HAVING
-- point out HAVING vs WHERE
-- List all directors with at least 3 movie productions
SELECT * FROM movie_cast LIMIT 10;
SELECT COUNT(*) FROM movie_cast; -- 485
SELECT COUNT(DISTINCT(director)) FROM movie_cast; -- 366


SELECT director AS num_movies
	FROM movie_cast









-- Answer:
SELECT director, COUNT(movie_title) AS num_movies
	FROM movie_cast
-- 	WHERE director IS NOT NULL AND actor LIKE 'j%' -- optional
	GROUP BY director
	HAVING COUNT(movie_title) > 3
	ORDER BY num_movies DESC;

--------------------------------------------------------------------------------------------------
-------------------------------------------- DEMO 3.5 --------------------------------------------
---------------------------------------- other functions -----------------------------------------
--------------------------------------------------------------------------------------------------

SELECT CURRENT_DATE

-- PERCENTILE_CONT / PERCENTILE_DISC WITHIN
SELECT * FROM revenue LIMIT 5;
SELECT PERCENTILE_CONT(0.25)
 WITHIN GROUP(ORDER BY gross_revenue) 
 FROM revenue;
 
SELECT
	PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY gross_revenue) AS asc_25,
	PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY gross_revenue DESC) AS desc_75
	FROM revenue;

SELECT
	PERCENTILE_CONT(0) WITHIN GROUP(ORDER BY gross_revenue) AS cont_0,
	PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY gross_revenue) AS cont_25,
	PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY gross_revenue) AS cont_50,
	PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY gross_revenue) AS cont_75,
	PERCENTILE_CONT(1) WITHIN GROUP(ORDER BY gross_revenue) AS cont_100
	FROM revenue;

SELECT MIN(gross_revenue) FROM revenue;


-- dates
SELECT CURRENT_DATE - 3;




-- BETWEEN
SELECT movie_title, genres, title_year
	FROM movie
	WHERE title_year >= 1990 AND title_year <= 1995
	ORDER BY title_year;
	
SELECT movie_title, genres, title_year
	FROM movie
	WHERE title_year BETWEEN 1990 AND 1995
	ORDER BY title_year;





-- SUBSTRING
SELECT Substring('great SQL class', 7, 3); -- SQL







-- CASE WHEN
-- Add a 'coarse rating' column for each movie, with 'low' <5, <=5 'mid' <8,  >=8 'high'
-- (advanced: display which quartile each movie rating belongs to)
SELECT * FROM rating LIMIT 10;






-- Trick question: what will go wrong here?
SELECT movie_title, imdb_score,
	CASE
		WHEN imdb_score < 5 THEN 'low'
		WHEN imdb_score > 8 THEN 'high'
		ELSE 'mid'
	END coarse_imdb_score
	FROM rating
	ORDER BY imdb_score DESC;





-- Answer: NULL imdb values also become 'mid'

-- aggregating with CASE WHEN
SELECT COUNT(movie_title),
	CASE
		WHEN imdb_score < 5 THEN 'low'
		WHEN imdb_score < 8 THEN 'mid'
		WHEN imdb_score >= 8 THEN 'high'
		ELSE 'unknown'
	END coarse_imdb_score
	FROM rating
	GROUP BY coarse_imdb_score;



--------------------------------------------------------------------------------------------------
-------------------------------------------- DEMO 4a ---------------------------------------------
--------------------------------------------- SETS -----------------------------------------------
--------------------------------------------------------------------------------------------------

-- We have two movie tables ('movie' with rich info and 'movie_sparse')
-- How many unique movies do we know of?
-- How many duplicates do we know of?

SELECT COUNT(movie_title) FROM movie -- 383
SELECT COUNT(movie_title) FROM movie_sparse -- 109
SELECT 383 + 109     -- 492

SELECT movie_title, title_year
	FROM movie
-- UNION
-- UNION ALL
-- INTERSECT
-- EXCEPT
SELECT movie_title, title_year
	FROM movie_sparse

-- Your colleague has a copy of 'movie_sparse' and wants to update all the missing rich columns
-- Which rows should be updated without creating already existing data?








--answer
SELECT movie_title, title_year
	FROM movie_sparse
EXCEPT
SELECT movie_title, title_year
	FROM movie

--------------------------------------------------------------------------------------------------
-------------------------------------------- DEMO 4b ---------------------------------------------
--------------------------------------------- JOINS ----------------------------------------------
--------------------------------------------------------------------------------------------------

-- Retrieve movie ids where we do NOT have the director's names
-- 'movie_id' is in table rating
-- 'director' is in table movie_cast
-- both tables have 'movie_title'

SELECT COUNT(*) FROM movie_cast
	WHERE director IS NULL

SELECT r.movie_id, mc.director FROM rating r
-- 	FULL JOIN movie_cast mc
-- 	INNER JOIN movie_cast mc
-- 	LEFT JOIN movie_cast mc
-- 	RIGHT JOIN movie_cast mc
		ON r.movie_title = mc.movie_title
		
		


-- Answer (also notice the double order!)
SELECT r.movie_id, mc.director FROM rating r
	INNER JOIN movie_cast mc
		ON r.movie_title = mc.movie_title
		AND mc.director IS NULL
	ORDER BY r.movie_id, mc.director;
		


-- For each movie in 'movie' list the director (including movies with unknown directors)
-- 'movie_title' is in table movie
-- 'director' is in table movie_cast, which also has 'movie_title'

SELECT m.movie_title, mc.director FROM movie m






-- answer
SELECT m.movie_title, mc.director FROM movie m
	LEFT JOIN movie_cast mc
		ON m.movie_title = mc.movie_title



-- For each director list the 'color' of the movie titles they've directed,
--            including directors without movies, using RIGHT JOIN:
-- 'color' is in table movie
-- 'director' is in table movie_cast

SELECT mc.director, m.color FROM movie m







-- answer
SELECT COUNT(m.color) as num_movies, mc.director, m.color FROM movie m
	RIGHT JOIN movie_cast mc
		ON m.movie_title = mc.movie_title
	GROUP BY m.color, mc.director



-- Update the above to instead show the sum of movies per color per director




-- answer
SELECT mc.director, m.color, COUNT(m.color) FROM movie m
	RIGHT JOIN movie_cast mc
		ON m.movie_title = mc.movie_title
	GROUP BY mc.director, m.color


-- Advanced: double join with aggregation: get the number of reviews per director
--    movie_cast table: movie_title -> director
--    rating table: movie_id -> movie_title
--    engagement table: reviews -> movie_id


SELECT e.reviews, mc.director FROM engagement e





SELECT SUM(e.reviews) as num_reviews, mc.director FROM engagement e
	INNER JOIN rating r
		ON e.movie_id = r.movie_id
			AND e.reviews IS NOT NULL
	INNER JOIN movie_cast mc
		ON r.movie_title = mc.movie_title
	GROUP BY mc.director



-- Whats the difference between these two queries:
SELECT m.movie_title, r.imdb_score, r.movie_id
	FROM movie m
    LEFT JOIN rating r
		ON m.movie_title = r.movie_title
		AND r.movie_id = 'c001' 

SELECT m.movie_title, r.imdb_score, r.movie_id
	FROM movie m
    LEFT JOIN rating r
		ON m.movie_title = r.movie_title
	WHERE  r.movie_id = 'c001'


--------------------------------------------------------------------------------------------------
-------------------------------------------- DEMO 5 ----------------------------------------------
----------------------------------- combining multiple queries -----------------------------------
--------------------------------------------------------------------------------------------------

-- Nested queries
SELECT
	(
	SELECT COUNT(movie_title) FROM movie
	) AS rich_movie_count,
	(
	SELECT COUNT(movie_title) FROM movie_sparse
	) AS sparse_movie_count,
	(
	SELECT COUNT(movie_title) FROM movie
	) +
	(
	SELECT COUNT(movie_title) FROM movie_sparse
	) AS summed_movie_count


-- Give the movie_id's for all movies with language 'Japanese' with a subquery
SELECT movie_title FROM movie where language = 'Japanese'







-- Answer:
SELECT movie_id FROM rating
	WHERE movie_title IN
		(SELECT movie_title FROM movie where language = 'Japanese');






-- WITH
-- Repeat the previous, this time with a WITH statement (note, you may need 3 x SELECT)





-- answer
WITH ja_moves AS (
		SELECT movie_title FROM movie where language = 'Japanese'
	)
	SELECT movie_id FROM rating WHERE movie_title IN (SELECT * FROM ja_moves);




-- VIEW
-- Repeat the previous, this time with a CREATE VIEW statement and two separate queries




-- answer
CREATE VIEW ja_movies AS (SELECT movie_title FROM movie where language = 'Japanese');

SELECT movie_id FROM rating WHERE movie_title IN (SELECT * FROM ja_movies);

-- Note how to remove the view again:
DROP VIEW ja_movies;



--------------------------------------------------------------------------------------------------
-------------------------------------------- DEMO 6 ----------------------------------------------
---------------------------------------- window functions ----------------------------------------
--------------------------------------------------------------------------------------------------

-- Extend this query with a window function to list, per director per movie,
--       which count of movie production this is for said director, according to title_year
--       That is: director1, movie_a, 1992, FIRST. 
-- 				  director1, movie_b, 1993, SECOND.
-- 				  director2, movie_c, 1984, FIRST.
SELECT mc.director, m.title_year
     FROM movie_cast mc
	 INNER JOIN movie m
	 	ON mc.movie_title = m.movie_title




-- answer
SELECT mc.director, m.title_year, ROW_NUMBER() OVER (PARTITION BY mc.director ORDER BY m.title_year)
	FROM movie_cast mc
	INNER JOIN movie m
		ON mc.movie_title = m.movie_title
	
	
-- Example of using multiple window operations together, each requiring an OVER
-- Note that we do not necessarily need 'PARTITION', and can combine with and without
SELECT mc.director, m.title_year,
		
		ROW_NUMBER() OVER (PARTITION BY mc.director ORDER BY m.title_year) AS row_number,
		
		ROW_NUMBER() OVER (ORDER BY m.title_year) AS row_number,
		RANK() OVER (ORDER BY m.title_year) AS rank,
		DENSE_RANK() OVER (ORDER BY m.title_year) AS dense_rank
	
	FROM movie_cast mc
	INNER JOIN movie m
		ON mc.movie_title = m.movie_title
	


-- Extend the below to list the top 5 ranking movies per color/black&white
-- table 'movies' has 'color'
-- table 'rating' has 'imdb_score'
-- hint: Slowly build up your answer, and use a double query

SELECT m.color, r.imdb_score
	FROM rating r
	INNER JOIN movie m
		ON m.movie_title = r.movie_title





-- answer
SELECT color, imdb_score, row_nb FROM ( 
		SELECT m.color, r.imdb_score,
			ROW_NUMBER() OVER (PARTITION BY m.color ORDER BY r.imdb_score DESC) AS row_nb
		FROM rating r
		INNER JOIN movie m
			ON m.movie_title = r.movie_title
		WHERE r.imdb_score IS NOT NULL AND m.color IS NOT NULL
	)
	WHERE row_nb < 6



-- Show for each director, movie_title, title_year row, also the title_year of that directors previous movie
SELECT mc.director, m.movie_title, m.title_year
     FROM movie_cast mc
	 INNER JOIN movie m
	 	ON mc.movie_title = m.movie_title
		
		
		
		
-- answer
SELECT mc.director, m.movie_title, m.title_year,
		LAG(m.title_year, 1) OVER (PARTITION BY mc.director ORDER BY m.title_year) AS previous_year
	FROM movie_cast mc
	INNER JOIN movie m
	 	ON mc.movie_title = m.movie_title


-- Extend the above to also show the number of years passed since the previous movie




		
		
		
-- answer
SELECT mc.director, m.movie_title, m.title_year,
		LAG(m.title_year, 1) OVER (PARTITION BY mc.director ORDER BY m.title_year) AS previous_year,
		m.title_year - LAG(m.title_year, 1) OVER (PARTITION BY mc.director ORDER BY m.title_year) AS passed_years
	FROM movie_cast mc
	INNER JOIN movie m
	 	ON mc.movie_title = m.movie_title
		
		
		
-- Continuing the above trend, what is the average number of years between each movie, per director?
-- Hint: combine multiple queries!





-- answer
SELECT AVG(avg_passed_years) AS average_passed_years FROM (
	SELECT
		m.title_year - LAG(m.title_year, 1) OVER (PARTITION BY mc.director ORDER BY m.title_year) AS passed_years
	FROM movie_cast mc
	INNER JOIN movie m
	 	ON mc.movie_title = m.movie_title
	)
	WHERE avg_passed_years IS NOT NULL
	












