-- Toutes les lignes (et colonnes) d'une table
SELECT * FROM movie;

-- Nombre de lignes
SELECT COUNT(*) FROM movie;  -- ~1K 
SELECT COUNT(*) FROM person; -- ~50K

-- Filtrer les lignes
SELECT * 
FROM movie
WHERE id = 6366
;

SELECT * 
FROM movie
WHERE id = 0
;

SELECT * 
FROM movie
WHERE year = 1984
;

SELECT * 
FROM movie
WHERE 
	year = 1984
	AND duration >= 110
;

SELECT * 
FROM movie
WHERE 
	year = 1984
	OR duration >= 110
;

SELECT * 
FROM movie
WHERE 
	(year = 1984 OR year = 1954)
	AND duration >= 110
;

SELECT *
FROM movie
WHERE year > 1789 -- filtre généreux
;

SELECT *
FROM movie
WHERE year > 2222 -- filtre tout
;

-- opérateurs de comparaison
--    égalité    :  =   
--    différence :  <>  !=
--    ordre      :  >  >=  <  <=
SELECT *
FROM movie
WHERE
	year = 1919
	AND duration != 50
;

SELECT *
FROM movie
WHERE
	year = 1919
	AND duration <> 50
;

SELECT *
FROM movie
WHERE year BETWEEN 1980 and 1989
ORDER BY year  -- ordre croissant implicite
;

SELECT *
FROM movie
WHERE year BETWEEN 1980 and 1989
ORDER BY year ASC -- ordre croissant implicite
;

SELECT *
FROM movie
WHERE year BETWEEN 1980 and 1989
ORDER BY year DESC
;


SELECT *
FROM movie
WHERE year BETWEEN 1980 and 1989
ORDER BY year, title   -- tri 2 critères
;

SELECT *
FROM movie
WHERE year BETWEEN 1980 and 1989
ORDER BY year DESC, duration DESC, title
;

-- selection discrète
SELECT *
FROM movie
WHERE year IN (1996, 1972, 1975, 1976)
ORDER BY year, title
;

SELECT *
FROM movie
WHERE 
	year BETWEEN 1990 and 1999
	AND year NOT IN (1992, 1995)
ORDER BY year
;


SELECT *
FROM movie
WHERE title = 'Frenzy'
;

SELECT *
FROM movie
WHERE title = 'frenzy'   
	-- Postgres/Oracle : CS (Case Sensitive)  => 0 résultats
	-- SQL Server : CI (Case Insensitive) => 1
;

SELECT *
FROM movie
WHERE LOWER(title) = 'frenzy' 
;

-- NULL
SELECT *
FROM movie
WHERE duration IS NULL  -- pas de durée
;

SELECT *
FROM movie
WHERE 
	duration IS NOT NULL
	AND	year = 1983
ORDER BY title
;


-- Projection : choix de colonnes
SELECT title, year, duration  -- 3
FROM movie   -- 1
WHERE   -- 2
	duration IS NOT NULL
	AND	year = 1983
ORDER BY title  -- 4
;

-- filtrage texte
--   - texte complet : = (+lower)
--   - texte incomplet : LIKE + Regexp

-- Avec LIKE : % vaut 0 à n caractères quelconque

-- qui commencent par
SELECT title, year
FROM movie
WHERE title LIKE 'Star%' 
;

-- qui contient
SELECT title, year
FROM movie
WHERE title LIKE '%Star%'
;

-- qui finit par
SELECT title, year
FROM movie
WHERE title LIKE '%Night'
;

-- Note : LIKE de PostgreSQL CS et celui de SQLite CI

SELECT title, year
FROM movie
WHERE title ILIKE '%night'  -- pour PostgreSQL uniquement
;


SELECT title, year
FROM movie
WHERE 
	title LIKE '%Star%'
	AND title NOT LIKE '%War%'
;

SELECT title, year
FROM movie
WHERE 
	title LIKE '%Love%'
	AND title NOT LIKE '%War%'
;

SELECT title, year
FROM movie
WHERE 
	title LIKE '%Love%'
	AND title LIKE '%War%'
;


SELECT title, year
FROM movie
WHERE 
	title ILIKE 'w_r%'
;

-- Regular Expression = Regexp = Pattern
SELECT title, year
FROM movie
WHERE 
	title ~* 'w[ao]r|love'
;

SELECT title, year
FROM movie
WHERE 
	title ~* '(of.*){5}'
;

-- idem avec la fonction standard
SELECT title, year
FROM movie
WHERE 
	REGEXP_LIKE(title, '(of.*){5}', 'i')
;


-- pour SQLIte:
SELECT title, year
FROM movie
WHERE 
	title REGEXP '(of.*){5}'
;


SELECT
	title,
	year,
	duration,
	duration / 60 as duration_h
FROM movie
WHERE year BETWEEN 2000 AND 2009
;

SELECT
	title,
	year,
	duration,
	duration / 60.0 as duration_h
FROM movie
WHERE year BETWEEN 2000 AND 2009
;

SELECT
	title,
	year,
	duration,
	duration::decimal / 60.0 as duration_h
FROM movie
WHERE year BETWEEN 2000 AND 2009
;

SELECT
	title,
	year,
	duration,
	CAST(duration as decimal) / 60.0 as duration_h
FROM movie
WHERE year BETWEEN 2000 AND 2009
;

-- SQLite: type decimal => real
SELECT
	title,
	year,
	duration,
	CAST(duration as real) / 60.0 as duration_h
FROM movie
WHERE year BETWEEN 2000 AND 2009
;




SELECT
	title,
	year,
	duration,
	duration / 60.0 as duration_h
FROM movie
WHERE 
	year BETWEEN 2000 AND 2009
	AND duration / 60.0 >= 2.0  -- nom de colonne 'duration_h' n'est pas disponible
ORDER BY duration_h
;

SELECT
	title,
	year,
	duration
FROM movie
WHERE 
	year BETWEEN 2000 AND 2009
	AND duration / 60.0 >= 2.0  -- nom de colonne 'duration_h' n'est pas disponible
ORDER BY duration / 60.0 DESC
;

-- Exercice:
-- Q1 : titre en majuscule et année des films des années 1950s
-- Q2 : titre (10 premiers caractères) en majuscule, longueur du titre et année des films des années 2010s


SELECT 
	UPPER(title) as title_u,
	year
FROM movie
WHERE year between 1950 and 1959
ORDER BY year, title_u
;

SELECT 
	UPPER(title) as "title upper case",
	year
FROM movie
WHERE year between 1950 and 1959
ORDER BY year, "title upper case"
;

-- LEFT : Postgresql at MSSQL
SELECT
	UPPER(LEFT(title, 10)) as title_u10,
	LENGTH(title) as title_length, 
	year
FROM movie
WHERE year BETWEEN 2010 AND 2019
ORDER BY title_length DESC
;

-- SUBSTR : "all"
SELECT
	UPPER(SUBSTR(title, 1, 10)) as title_u10,
	LENGTH(title) as title_length, 
	year
FROM movie
WHERE year BETWEEN 2010 AND 2019
ORDER BY title_length DESC
;

-- [LR]TRIM
INSERT INTO movie (title, year, duration) VALUES ('The Odyssey', 2026, 172);
SELECT * FROM movie WHERE year = 2026; -- id = 8079249
DELETE FROM movie WHERE id = 8079249;
INSERT INTO movie (title, year, duration) VALUES (' The Odyssey   ', 2026, 172);
SELECT * FROM movie WHERE year = 2026;
SELECT * FROM movie WHERE year >= 2020;

-- operateur de concaténation: || (presque tous) ou + MSSQL
SELECT 
	title,
	'#' || title || '#' as title_check, 
	TRIM(title) as title_clean,
	'#' || TRIM(title) || '#' as title_clean_check,
	year
FROM movie 
WHERE year >= 2020
ORDER BY year DESC
;

SELECT 
	title,
	CONCAT('#', title, '#') as title_check, 
	TRIM(title) as title_clean,
	CONCAT('#', TRIM(title), '#') as title_clean_check,
	year
FROM movie 
WHERE year >= 2020
ORDER BY year DESC
;

SELECT title || ' (' || year || ')' as title_year
FROM movie
WHERE year = 2011
ORDER BY title_year
;

SELECT
	name,
	birthdate,
	EXTRACT(YEAR FROM birthdate) as birth_year
FROM person
WHERE EXTRACT(YEAR FROM birthdate) = 1930
;

SELECT
	name,
	birthdate,
	DATE_PART('year', birthdate) as birth_year
FROM person
WHERE DATE_PART('year', birthdate) = 1930
;


-- MariaDB ou MSSQL : YEAR(), MONTH(), DAY()
SELECT
	name,
	birthdate,
	YEAR(birthdate) as birth_year
FROM person
WHERE YEAR(birthdate) = 1930
;





































