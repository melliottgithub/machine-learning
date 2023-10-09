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
	imdb_score NUMERIC(2, 1) 
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














