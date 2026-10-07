select * from person where name like '%B%art';

select 
    year,
    count(*) as nb_movie
from movie
group by year
order by year;

insert into movie (title, year, duration) values ('No Time to Die', 2021, 163)
returning id, title; -- 8079252

insert into play (movie_id, actor_id, role) values (8079252, 185819, 'James Bond');


select
    pl.actor,
    pe.NAME,
    count(pl.movie_id) as nb_movie_007
from 
    play pl
    join person pe on pl.ACTOR_ID = pe.id
where pl.role ilike 'James bond%'
group by pl.actor_id
order by nb_movie_007 desc;

select
    pe.id,
    pe.NAME,
    count(pl.movie_id) as nb_movie_007,
    min(m.year) as first_year,
    max(m.year) as last_year,
    sum(m.duration) as total_duration,
    string_agg(m.title, ', ' order by m.year) as movies,
    string_agg(distinct pl.role, ', ') as role_007
from 
    play pl
    join person pe on pl.ACTOR_ID = pe.id
    join movie m on pl.movie_id = m.id
where lower(pl.role) like '%james bond%'
group by pe.id
order by nb_movie_007 desc;

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

select * from person where id = 142;  -- sgbd utilise l'index sur la clé primaire

create index idx_movie_director on movie(director_id);

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

select * from play where actor_id in (136, 945, 675);






