-- statistiques par réalisateur:
--    * nb de films
--    * année du 1er film
--    * année du dernier
--    * durée totale

select
	pe.id,
	pe.name,
	count(m.id) as nb_movie,
	MIN (m.year) as first_movie,
	MAX (m.year) as last_movie,
	CEIL(SUM(m.duration) / 60) as total_duration_h
FROM 	
	movie m 
	join person pe on m.director_id = pe.id
GROUP BY pe.id, pe.name
ORDER BY nb_movie DESC
;



-- statistiques par acteur:
--    * nb de films
--    * année du 1er film
--    * année du dernier
--    * durée totale
select
	pe.id,
	pe.name,
	count(m.id) as nb_movie,
	MIN (m.year) as first_movie,
	MAX (m.year) as last_movie,
	CEIL(SUM(m.duration) / 60) as total_duration_h
FROM 	
	movie m 
	join play pl on m.id = pl.movie_id
	join person pe on pl.actor_id = pe.id
-- where pe.name ='Harrison Ford'
GROUP BY pe.id, pe.name
ORDER BY nb_movie DESC
;







-- Bonus :
--   * seuil à 10 films minimum [query réalisateur + query acteur]

select
	pe.id,
	pe.name,
	count(m.id) as nb_movie,
	MIN (m.year) as first_movie,
	MAX (m.year) as last_movie,
	CEIL(SUM(m.duration) / 60) as total_duration_h
FROM 	
	movie m 
	join person pe on m.director_id = pe.id
GROUP BY pe.id, pe.name
HAVING count(m.id) >= 10
ORDER BY nb_movie DESC
;

select
	pe.id,
	pe.name,
	count(m.id) as nb_movie,
	MIN (m.year) as first_movie,
	MAX (m.year) as last_movie,
	CEIL(SUM(m.duration) / 60) as total_duration_h
FROM 	
	movie m 
	join play pl on m.id = pl.movie_id
	join person pe on pl.actor_id = pe.id
GROUP BY pe.id, pe.name
HAVING count(m.id) >= 10
ORDER BY nb_movie DESC
;


-- WHERE vs HAVING
SELECT
    -- 5 - projections
	pe.id,
	pe.name,
	count(m.id) as nb_movie,
	MIN (m.year) as first_movie,
	MAX (m.year) as last_movie,
	CEIL(SUM(m.duration) / 60) as total_duration_h
FROM 
    -- 1 - Source = tables
	movie m 
	join play pl on m.id = pl.movie_id
	join person pe on pl.actor_id = pe.id
WHERE m.year between 1950 and 1999  -- 2 - filtre source(s)
GROUP BY pe.id, pe.name   -- 3  - groupage
HAVING count(m.id) >= 10  -- 4  - filtre groupe (stat)
ORDER BY nb_movie DESC -- 6 - tri
;

-- tri(proj(filter_gpe(group(filter(join(join(movie,play), person), ...), ...), ...)


-- indexes :
-- * implicite : clé primaires + contrainte unique
-- * explicite : à créer en fonction des requetes, des volumes de données et des temps de réponses
select * from person where id = 142;
select * from person where name = 'Clint Eastwood';

create index idx_movie_director on movie(director_id);

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

-- TODO: indexation des person.name et des movie.title

-- Réalisateur ayant réalisé le plus de film [et/ou acteur]

-- CTE : Common Table Expression (DEMO)
with director_stats as (
    select
        pe.id,
        pe.name,
        count(m.id) as nb_movie,
        MIN (m.year) as first_movie,
        MAX (m.year) as last_movie,
        CEIL(SUM(m.duration) / 60) as total_duration_h
    FROM 	
        movie m 
        join person pe on m.director_id = pe.id
    GROUP BY pe.id, pe.name
) 
select 
    ds.name,
    ds.nb_movie,
    ds.total_duration_h
from director_stats ds
where ds.nb_movie >= 30
order by ds.nb_movie desc
;

-- query du max
with director_stats as (
    select
        pe.id,
        pe.name,
        count(m.id) as nb_movie,
        MIN (m.year) as first_movie,
        MAX (m.year) as last_movie,
        CEIL(SUM(m.duration) / 60) as total_duration_h
    FROM 	
        movie m 
        join person pe on m.director_id = pe.id
    GROUP BY pe.id, pe.name
) 
select 
    max(ds.nb_movie) as max_nb_movie
from director_stats ds
;

-- filtrer par le max : qui fait le plus
with director_stats as (
    select
        pe.id,
        pe.name,
        count(m.id) as nb_movie,
        MIN (m.year) as first_movie,
        MAX (m.year) as last_movie,
        CEIL(SUM(m.duration) / 60) as total_duration_h
    FROM 	
        movie m 
        join person pe on m.director_id = pe.id
    GROUP BY pe.id, pe.name
)
select *
from director_stats ds
where ds.nb_movie = (
    select 
        max(ds.nb_movie) as max_nb_movie
    from director_stats ds
)
;

-- vue logique : seul la requete est stockée
create view v_director_stats as (
    select
        pe.id,
        pe.name,
        count(m.id) as nb_movie,
        MIN (m.year) as first_movie,
        MAX (m.year) as last_movie,
        CEIL(SUM(m.duration) / 60) as total_duration_h
    FROM 	
        movie m 
        join person pe on m.director_id = pe.id
    GROUP BY pe.id, pe.name
);

select *
from v_director_stats ds
where ds.nb_movie = (
    select 
        max(ds.nb_movie) as max_nb_movie
    from v_director_stats ds
)
;


-- Sur la selection de personne : 
--   * Clint Eastwood
--   * Steve McQueen
--   * Harrison Ford
--   * Quentin Tarantino
--   * Leonardo DiCaprio
--   * Zoe Saldana
--   * Anne Hathaway
--   * Alfred Hitchcock
--   * Christopher Nolan

with selection_person as (
    select *
    from person
    where name in (
        'Clint Eastwood',
        'Steve McQueen',
        'Harrison Ford',
        'Quentin Tarantino',
        'Leonardo DiCaprio',
        'Zoe Saldana',
        'Anne Hathaway',
        'Alfred Hitchcock',
        'Christopher Nolan'
    )
)
select
	pe.id,
	pe.name,
	count(m.id) as nb_movie,
	MIN (m.year) as first_movie,
	MAX (m.year) as last_movie
FROM 	
	movie m 
	join selection_person pe on m.director_id = pe.id
GROUP BY pe.id, pe.name
;

-- Note : la jointure interne fait disparaitre toutes les personnes non realisatrices

with selection_person as (
    select *
    from person
    where name in (
        'Clint Eastwood',
        'Steve McQueen',
        'Harrison Ford',
        'Quentin Tarantino',
        'Leonardo DiCaprio',
        'Zoe Saldana',
        'Anne Hathaway',
        'Alfred Hitchcock',
        'Christopher Nolan'
    )
)
select
	pe.id,
	pe.name,
	count(m.id) as nb_movie,
	MIN(m.year) as first_movie,
	MAX(m.year) as last_movie
FROM 	
    selection_person pe
    left join movie m on m.director_id = pe.id
GROUP BY pe.id, pe.name
;


-- on ajoute les stats acteur
with selection_person as (
    select *
    from person
    where name in (
        'Clint Eastwood',
        'Steve McQueen',
        'Harrison Ford',
        'Quentin Tarantino',
        'Leonardo DiCaprio',
        'Zoe Saldana',
        'Anne Hathaway',
        'Alfred Hitchcock',
        'Christopher Nolan'
    )
), stat_director as (
    select
        pe.id,
        pe.name,
        count(m.id) as nb_movie,
        MIN(m.year) as first_movie,
        MAX(m.year) as last_movie
    FROM 	
        selection_person pe
        left join movie m on m.director_id = pe.id
    GROUP BY pe.id, pe.name
)
select 
    pe.id,
    pe.name,
    count(m.id) as nb_movie,
    MIN(m.year) as first_movie,
    MAX(m.year) as last_movie
from
    selection_person pe
    left join play pl on pe.id = pl.actor_id
    left join movie m on pl.movie_id = m.id
group by pe.id, pe.name
;


with selection_person as (
    select *
    from person
    where name in (
        'Clint Eastwood',
        'Steve McQueen',
        'Harrison Ford',
        'Quentin Tarantino',
        'Leonardo DiCaprio',
        'Zoe Saldana',
        'Anne Hathaway',
        'Alfred Hitchcock',
        'Christopher Nolan'
    )
), stat_director as (
    select
        pe.id,
        pe.name,
        count(m.id) as nb_movie,
        MIN(m.year) as first_year,
        MAX(m.year) as last_year
    FROM 	
        selection_person pe
        left join movie m on m.director_id = pe.id
    GROUP BY pe.id, pe.name
), stat_actor as (
    select 
        pe.id,
        pe.name,
        count(m.id) as nb_movie,
        MIN(m.year) as first_year,
        MAX(m.year) as last_year
    from
        selection_person pe
        left join play pl on pe.id = pl.actor_id
        left join movie m on pl.movie_id = m.id
    group by pe.id, pe.name
) 
select
    sd.id,
    sd.name,
    -- renommage stats director
    sd.nb_movie as nb_movie_direct,
    sd.first_year as first_year_direct,
    sd.last_year as last_year_direct,
    -- renommage stats actor
    sa.nb_movie as nb_movie_act,
    sa.first_year as first_year_act,
    sa.last_year as last_year_act
from
    stat_director sd
    join stat_actor sa on sd.id = sa.id
order by sd.name
;


-- avec des vues
create view v_actor_stats as (
    select
        pe.id,
        pe.name,
        count(m.id) as nb_movie,
        MIN (m.year) as first_movie,
        MAX (m.year) as last_movie,
        CEIL(SUM(m.duration) / 60) as total_duration_h
    FROM 	
        movie m 
        join play pl on m.id = pl.movie_id
        join person pe on pl.actor_id = pe.id
    GROUP BY pe.id, pe.name
);

select * from V_DIRECTOR_STATS order by nb_movie desc;
select * from V_ACTOR_STATS order by nb_movie desc;

 with selection_person as (
    select *
    from person
    where name in (
        'Clint Eastwood',
        'Steve McQueen',
        'Harrison Ford',
        'Quentin Tarantino',
        'Leonardo DiCaprio',
        'Zoe Saldana',
        'Anne Hathaway',
        'Alfred Hitchcock',
        'Christopher Nolan'
    )
)
select 
    pe.id as person_id,
    pe.name,
    coalesce(dst.nb_movie, 0) as nb_movie_director,
    coalesce(ast.nb_movie, 0) as nb_movie_actor
from
    selection_person pe
    left join V_DIRECTOR_STATS dst on pe.id = dst.id
    left join V_ACTOR_STATS ast on pe.id = ast.id
;

-- projection : colonne à valeur conditionnelle
-- * COALESCE : cf exemple précédente
-- * CASE
-- * NULLIF

select
    m.title,
    m.year,
    m.duration,
    case 
        when m.DURATION < 60 then 'COURT_METRAGE'
        when m.duration < 120 then 'MOYEN_METRAGE'
        when m.duration >= 120 then 'LONG_METRAGE'
        else 'NC'
    end as classification
from movie m
where 
    m.duration is null
    or m.year in (1920, 1954, 1984, 2026)
order by m.duration
;


select
    m.title,
    m.year,
    m.duration,
    case floor(m.year / 10)
        when 197 then '70s'
        when 198 then '80s'
        when 199 then '90s'
    end as decade
from movie m
where m.year between 1970 and 1999
order by m.year, m.title
;

select distinct pg from movie;
select distinct year from movie;


select
    m.title,
    m.year,
    nullif(m.year, 1975) as year_masked
from movie m
where m.year between 1970 and 1979
order by m.year
;

-- sous-requete
select *
from person pe
where pe.id in (
    select distinct pl.ACTOR_ID
    from play pl
    where lower(pl.role) like '%james bond%'
)
;

-- meme chose que :
select *
from person pe
where pe.id in (
    125,799689,1355486,184092,493872,549,1096,185819,112
);

-- Q1. les personnes qui sont acteur
select *
from person pe
where pe.id in (
    select actor_id
    from play
);
-- Q2. les personnes qui sont réalisateur
select *
from person pe
where pe.id in (
    select director_id
    from movie
);
-- Q3. les personnes qui sont acteur et réalisateur
select *
from person pe
where 
    pe.id in (
        select actor_id
        from play
    )
    and pe.id in (
        select director_id
        from movie
    )
;

-- idem avec operateur ensembliste
select *
from person pe
where 
    pe.id in (
        select actor_id
        from play
        INTERSECT
        select director_id
        from movie
        where director_id is not null
    )
;
-- Q4. les personnes qui sont que acteur (pas realisateur)
select *
from person pe
where 
    pe.id in (
        select actor_id
        from play
    )
    and 
    pe.id not in (
        select director_id  -- peut etre absent
        from movie
        where director_id is not null
    )
    and pe.name like 'Cli%'
order by pe.name
;

select *
from person pe
where 
    pe.id in (
        select actor_id
        from play
        MINUS
        select director_id
        from movie
        where director_id is not null
    )
;
-- Q5. les personnes qui sont que réalisateur (pas acteur)
select *
from person pe
where 
    pe.id not in (
        select actor_id   -- toujours present
        from play
    )
    and pe.id in (
        select director_id
        from movie
    )
order by pe.name
;

select *
from person pe
where 
    pe.id in (
        select director_id
        from movie
        where director_id is not null
        MINUS
        select actor_id
        from play
    )
;

-- Q6. les personnes qui sont ni acteur ni realisateur
select *
from person pe
where 
    pe.id not in (
        select actor_id
        from play
    )
    and 
    pe.id not in (
        select director_id  -- peut etre absent
        from movie
        where director_id is not null
    )
and pe.name like 'J%'
order by pe.name
;

select *
from person pe
where 
    pe.id not in (
        select director_id
        from movie
        where director_id is not null
        UNION
        select actor_id
        from play
    )
    and pe.name like 'J%'
order by pe.name
;

-- enquete sur
-- 136 Johnny Depp
-- 945 Jane Birkin
-- 675 Jeanne Tripplehorn

select * from play where actor_id in (136, 945, 675);

delete from person where id = 136;  -- ok car non referencé
-- delete from person where id = 142;  -- ko car referencé dans movie et play
-- delete from person where id = 634240; -- ko car referencé dans movie 


select 
    'movie' as table_name,
    count(*) as nb_rows
from movie
UNION
select 
    'person' as table_name,
    count(*) as nb_rows
from person
UNION
select 
    'play' as table_name,
    count(*) as nb_rows
from play
UNION
select 
    'have_genre' as table_name,
    count(*) as nb_rows
from have_genre
;

-- Note: UNION ALL si doublons que l'on souhaite garder


-- acteurs ayant collaboré avec les realisateurs Clint Eastwood, Steven Spielberg (ds quel film)


select 
    actor.name as actor_name,
    m.year,
    m.title,
    director.name as director_name
from
    person actor
    join play pl on actor.id = pl.actor_id
    join movie m on pl.movie_id = m.id
    join person director on m.director_id = director.id
where
    director.name in (
        'Clint Eastwood',
        'Steven Spielberg'
    )
order by actor.name, director.name, m.year
;


-- division = TOUS

-- réalisateurs :  Clint Eastwood, Steven Spielberg, Quentin Tarantino, Martin Scorsese
-- Qui a joué pour TOUS ces réalisateurs

-- solution 1 = on compte
-- step 1 : on relie les tables
with director_selection as (
    select *
    from person
    where name in (
        'Clint Eastwood',
        'Steven Spielberg',
        'Quentin Tarantino', 
        'Martin Scorsese'
    )
)
select
    actor.name,
    m.title,
    d.name
from 
    person actor 
    join play pl on actor.id = pl.actor_id
    join movie m on pl.movie_id = m.id
    join director_selection d on m.director_id = d.id
;
-- on compte
with director_selection as (
    select *
    from person
    where name in (
        'Clint Eastwood',
        'Steven Spielberg',
        'Quentin Tarantino', 
        'Martin Scorsese'
    )
)
select
    actor.id,
    actor.name,
    count(distinct d.id) as nb_director,
    listagg(distinct d.name, ', ') as directors
from 
    person actor 
    join play pl on actor.id = pl.actor_id
    join movie m on pl.movie_id = m.id
    join director_selection d on m.director_id = d.id
group by actor.id, actor.name
order by nb_director desc
;
-- step 3 : garder que ceux qui ont 4 = nb de real
with director_selection as (
    select *
    from person
    where name in (
        'Clint Eastwood',
        'Steven Spielberg',
        'Quentin Tarantino',
        'Martin Scorsese',
        'Danny Boyle'
    )
)
select
    actor.id,
    actor.name,
    count(distinct d.id) as nb_director,
    listagg(distinct d.name, ', ') as directors
from 
    person actor 
    join play pl on actor.id = pl.actor_id
    join movie m on pl.movie_id = m.id
    join director_selection d on m.director_id = d.id
group by actor.id, actor.name
having count(distinct d.id) = (
    select count(*) from director_selection
)
order by nb_director desc
;




-- solution 2 = double negative (not exists)
with director_selection as (
    select *
    from person
    where name in (
        'Clint Eastwood',
        'Steven Spielberg',
        'Quentin Tarantino',
        'Martin Scorsese',
        'Danny Boyle'
    )
)
select *
from person person_actor
where not exists (
    select * from director_selection person_director
    where not exists (
        select *
        from 
            play pl
            join movie m on pl.movie_id = m.id
        where
            person_actor.id = pl.actor_id
            and person_director.id = m.director_id
    )
);













