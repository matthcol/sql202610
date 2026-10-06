SELECT COUNT(*) FROM movie;

SELECT COUNT(*) FROM person;

SELECT
    id,   -- PK (Primary Key) de la table movie
    title, 
    year, 
    director_id  -- FK (Foreign Key) référence la PK id dans la table person
FROM movie
WHERE year = 2010
;

SELECT 
    id,  -- PK de la table person
    name,
    birthdate
FROM PERSON
WHERE id = 142
;

select * from MOVIE where YEAR = 2026; 
INSERT INTO movie (title, year, duration) VALUES (' The Odyssey   ', 2026, 172);
select * from MOVIE where YEAR = 2026;  -- id 'the Odyssey' = 8079269
select * from person where lower(name) like 'ch% nolan';  -- id: 634240

update MOVIE 
set 
    DIRECTOR_ID = 634240,
    title = trim(title)
where id = 8079269
;

select 
    MOVIE.*,
    '#'  || title || '#' as title_check
from MOVIE 
where YEAR = 2026; 


select * 
from person
where id in (
    687964,
    881279,
    631,
    230,
    729,
    634240,
    1053,
    989998,
    965,
    585011,
    217,
    142,
    891114
)
;


select
    id,
    title,
    year,
    director_id
from movie
where director_id = 142
order by year desc
;


SELECT
    movie.id, 
    movie.title, 
    movie.year, 
    movie.director_id 
FROM movie
WHERE movie.year = 2010
;

SELECT
    m.id, 
    m.title, 
    m.year, 
    m.director_id 
FROM movie m
WHERE m.year = 2010
;


-- produit cartésien entre 2 tables
SELECT
    m.id, 
    m.title, 
    m.year, 
    m.director_id,
    p.id as person_id,
    p.name
FROM 
    movie m,
    person p
WHERE m.year = 2010
;

-- jointure interne : JOIN = INNER JOIN
SELECT
    m.id, 
    m.title, 
    m.year, 
    m.director_id,
    p.id as person_id,
    p.name
FROM 
    movie m
    JOIN person p ON m.DIRECTOR_ID = p.id
WHERE m.year = 2010
;

-- les films de Clint Eastwood en tant que réalisateur
select
    p.id as person_id,
    p.name,
    m.id as movie_id,
    m.title,
    m.year,
    m.director_id 
from 
    person p
    join movie m on p.id = m.DIRECTOR_ID
where
    p.name = 'Clint Eastwood'
order by m.year desc, m.title
;


select
    p.id as person_id,
    p.name,
    m.id as movie_id,
    m.title,
    m.year,
    m.director_id 
from 
    person p,
    movie m
where
    p.id = m.director_id             -- condition de jointure
    AND p.name = 'Clint Eastwood'    -- filtre table person
order by m.year desc, m.title
;


-- Rappel pour The Odyssey
INSERT INTO movie 
    (title, year, duration, director_id) 
    VALUES 
    ('The Odyssey', 2026, 145, 634240)
;

INSERT INTO movie 
    (title, year, duration) 
    VALUES 
    ('Spider-Man: Brand New Day', 2026, 145)
;
COMMIT; -- Oracle est en mode transaction par défaut / Postgresql non


select 
    title,
    year,
    duration,
    director_id
from movie
where year = 2026
;


-- jointure interne ne garde que les lignes en correspondance
-- => plus de Spiderman (2026)
select
    m.title,
    m.year,
    m.director_id,
    p.id,
    p.name
from 
    movie m
    join person p on m.director_id = p.id
where m.year = 2026
;

-- jointure externe
-- * à gauche : on garde toutes les lignes de la table de gauche
-- * à droite : on garde toutes les lignes de la table de gauche
-- * complète (rare)
select
    m.title,
    m.year,
    m.director_id,
    p.id as person_id,
    p.name
from 
    movie m
    left join person p on m.director_id = p.id
where m.year = 2026
;

-- NB: 
--    LEFT JOIN = LEFT OUTER JOIN
--    RIGHT JOIN = RIGHT OUTER JOIN
--    FULL JOIN = FULL OUTER JOIN


