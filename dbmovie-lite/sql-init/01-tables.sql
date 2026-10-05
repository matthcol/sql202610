PRAGMA foreign_keys = ON;

create table person (
	id integer constraint pk_person primary key autoincrement,
	name text not null,
	birthdate date
);

create table movie (
	id integer constraint pk_movie primary key autoincrement,
	title text not null,
	year smallint not null,
	duration smallint,
	synopsis text,
	poster_uri text,
	color text,
	pg text,
	director_id integer,
	constraint uniq_movie unique(title, year),
	constraint chk_movie_year check(year >= 1850),
	constraint FK_MOVIE_DIRECTOR foreign key (director_id)
		references person(id)
);

create table play(
	movie_id integer not null,
	actor_id integer not null,
	role text,
	constraint pk_play primary key(movie_id, actor_id),
	constraint FK_PLAY_MOVIE foreign key (movie_id)
		references movie(id),
	constraint FK_PLAY_ACTOR foreign key (actor_id)
		references person(id)
);

create table have_genre(
	movie_id integer not null,
	genre text not null,
	constraint FK_HAVE_GENRE foreign key (movie_id)
		references movie(id)
);
