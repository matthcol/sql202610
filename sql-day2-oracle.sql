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


select *
from play
where actor_id in (
    142,
    138
)
;

-- Pour trouver Leonardo DiCaprio
select * 
from person
where lower(name) like 'leonardo %'
; 

select *
from play
where movie_id = 1205489
;

-- Les films dans lesquels ont joué Clint Eastwood ou Leonard DiCaprio
select 
    pe.name, 
    m.year, 
    m.title, 
    pl.role
from 
    person pe, 
    movie m, 
    play pl
where 
    pe.id = pl.actor_id
    and pl.movie_id = m.id
    and pe.name IN ('Clint Eastwood', 'Leonardo DiCaprio')
order by pe.name, m.year;

select 
    pe.name, 
    m.year, 
    m.title, 
    pl.role
from 
    person pe
    join play pl  on pe.id = pl.actor_id
    join movie m on  pl.movie_id = m.id
where 
    pe.name IN ('Clint Eastwood', 'Leonardo DiCaprio')
order by pe.name, m.year desc;



-- Les acteurs du film Gran Torino
select
    m.title,
    pe.name,
    pl.role
from 
    person pe
    join play pl  on pe.id = pl.actor_id
    join movie m on  pl.movie_id = m.id
where
    m.title = 'Gran Torino'
;

-- Les acteurs ayant joué James Bond (et les films)
select
    pe.name,
    m.year,
    m.title,
    pl.role
from 
    person pe
    join play pl  on pe.id = pl.actor_id
    join movie m on  pl.movie_id = m.id
where
    lower(pl.role) like 'james bond%'
order by m.year
;

select
    pe.name,
    m.year,
    m.title,
    pl.role
from 
    person pe
    join play pl  on pe.id = pl.actor_id
    join movie m on  pl.movie_id = m.id
where
    lower(pl.role) like '%po%'
    and lower(title) like 'star%'
order by m.year
;

select
    pe.name,
    m.year,
    m.title,
    pl.role
from 
    person pe
    join play pl  on pe.id = pl.actor_id
    join movie m on  pl.movie_id = m.id
where
    pl.role = 'C-3PO'
order by m.year
;

select * from person where name like '%B%art';


-- Statistiques : axe vertical, fonction d'agrégation (réduction)
-- * COUNT
-- * SUM
-- * AVG
-- * MIN / MAX
-- etc.

select
    -- title,  -- INTERDIT
    count(*) as nb_movie,  -- compte les lignes
    count(title) as nb_title, -- compte sur 1 colonne non nullable => idem count(*)
    count(duration) as nb_duration, -- compte sur 1 colonne nullable  : inferieur ou egal au count(*)
    sum(duration) as total_duration_mn,
    floor(sum(duration) / 60) as total_duration_h_f,
    ceil(sum(duration) / 60) as total_duration_h_c,
    round(sum(duration) / 60, 2) as total_duration_h_r2,
    avg(duration) as avg_duration,
    min(year) as first_year,
    max(year) as last_year,
    count(distinct year) as nb_distinct_year, 
    max(year) - min(year) as year_gap
from movie
;

-- compter les films avec James Bond
select
    count(movie_id) as nb_movie_id,  -- compte les doublons (doublures de Sean Connery)
    count(distinct movie_id) as nb_movie_007
from play
where lower(role) like 'james bond%'
; 

-- nb de films PAR année
-- i.e. nb de films POUR CHAQUE année
select 
    year,
    count(*) as nb_movie
from movie
group by year
order by year;


select 
    year,
    count(*) as nb_movie,
    count(title) as nb_title, 
    count(duration) as nb_duration, 
    sum(duration) as total_duration_mn,
    floor(sum(duration) / 60) as total_duration_h_f,
    ceil(sum(duration) / 60) as total_duration_h_c,
    round(sum(duration) / 60, 2) as total_duration_h_r2,
    floor(avg(duration)) as avg_duration
from movie
group by year
order by year;


-- statistiques : count, min year, max year par acteur de James Bond
insert into movie (title, year, duration) values ('No Time to Die', 2021, 163);
select * from movie where title = 'No Time to Die';  -- 8079309
select * from person where name = 'Daniel Craig'; -- 185819
insert into play (movie_id, actor_id, role) values (8079309, 185819, 'James Bond');

-- * 1ère étape : sans le nom de l'acteur (table play uniquement)
select
    actor_id,
    count(movie_id)
from play
where lower(role) like 'james bond%'
group by actor_id
;

-- * 2e : ajouter le nom de chaque acteur
select
    pl.actor_id,
    pe.NAME,
    count(pl.movie_id) as nb_movie_007
from 
    play pl
    join person pe on pl.ACTOR_ID = pe.id
where lower(pl.role) like 'james bond%'
group by pl.actor_id, pe.name
order by nb_movie_007 desc;

select
    pe.id,
    pe.NAME,
    count(pl.movie_id) as nb_movie_007
from 
    play pl
    join person pe on pl.ACTOR_ID = pe.id
where lower(pl.role) like 'james bond%'
group by pe.id, pe.name
order by nb_movie_007 desc;


select
    pe.id,
    pe.NAME,
    count(pl.movie_id) as nb_movie_007,
    listagg(m.title, ', ') within group (order by m.year) as movies
from 
    play pl
    join person pe on pl.ACTOR_ID = pe.id
    join movie m on pl.movie_id = m.id
where lower(pl.role) like 'james bond%'
group by pe.id, pe.name
-- order by pe.id;  -- pour avoir le même ordre que la requete intermédiaire ci dessous
order by nb_movie_007 desc;

select *
from 
    play pl
    join person pe on pl.ACTOR_ID = pe.id
    join movie m on pl.movie_id = m.id
where lower(pl.role) like 'james bond%'
order by pe.id, pe.name
;


select
    pe.id,
    pe.NAME,
    count(pl.movie_id) as nb_movie_007,
    min(m.year) as first_year,
    max(m.year) as last_year,
    sum(m.duration) as total_duration,
    listagg(m.title, ', ') within group (order by m.year) as movies,
    listagg(distinct pl.role, ', ') as role_007
from 
    play pl
    join person pe on pl.ACTOR_ID = pe.id
    join movie m on pl.movie_id = m.id
where lower(pl.role) like '%james bond%'
group by pe.id, pe.name
order by nb_movie_007 desc;

















-- TODO : CASE / IF