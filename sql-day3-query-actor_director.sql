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


