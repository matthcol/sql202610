SELECT 
	CURRENT_DATE,
	CURRENT_TIMESTAMP,  -- with tz
	CURRENT_TIMESTAMP::timestamp,  -- without tz
	CURRENT_TIME,       -- with tz
	CURRENT_TIME::time  -- without tz
-- FROM dual -- pour Oracle
;

SELECT 1;


-- Exercice: les personnes nées il y a 50 ans

-- Draft
SELECT *
FROM person
LIMIT 10
;

SELECT 
	name,
	birthdate,
	EXTRACT(YEAR FROM birthdate) as birth_year,
	EXTRACT(YEAR FROM CURRENT_DATE) as current_year
FROM person
LIMIT 10
;

-- solution
SELECT *
FROM person
WHERE EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birthdate) = 50
;

SELECT 
	*,
	AGE(birthdate) as age,
	-- calculs sur des dates : grain = 1 jour
	current_date - birthdate as age_days,
	current_date + 1 as tomorrow,
	current_date - 1 as yesterday,
	-- calculs sur des timestamps : interval
	current_timestamp::timestamp - birthdate::timestamp as age_interval
FROM person
WHERE EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birthdate) = 50
ORDER BY birthdate DESC
;

-- les personnes nés le 1976-10-24
SELECT *
FROM person
WHERE birthdate = '1976-10-24'  -- PostgreSQL : OK car format ISO
;


-- settings PostgreSQL
set datestyle = 'dmy';
show datestyle;

SELECT *
FROM person
WHERE birthdate = '24/10/1976'
;


-- query SQLite
-- https://www.sqlite.org/lang_datefunc.html
select 
	  name, 
	  birthdate,
	  strftime('%Y', birthdate) as birth_year,
      strftime('%Y', birthdate) as current_year
 From person
 limit 10;


SELECT
	name,
	birthdate,
	to_char(birthdate, 'DD/MM/YYYY') as birthdate_fr  -- strftime('%d/%m/%Y', birthdate)
FROM person
WHERE EXTRACT(YEAR FROM birthdate) = 1930  -- strftime('%Y', birthdate) = '1930'
;


-- SQLite
SELECT
	name,
	birthdate,
	strftime('%d/%m/%Y', birthdate) as birthdate_fr  
FROM person
WHERE strftime('%Y', birthdate) = '1930'
;





