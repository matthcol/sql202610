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

















--   * nombre d'acteurs ayant collaboré avec [query réalisateur]






