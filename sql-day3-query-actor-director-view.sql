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