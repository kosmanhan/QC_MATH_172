-- 1.2 this creates the database 
create database imdb;

--1.3 the following creates the seven schemas
--title_akas
create table imdb.public.title_akas (
titleId	varchar,
ordering varchar,
title varchar,
region varchar,
language varchar,
types varchar,
attributes varchar,
isOriginalTitle varchar
);

--title_basics
create table imdb.public.title_basics (
tconst varchar,
titleType varchar,
primaryTitle varchar,
originalTitle varchar,
isAdult varchar,
startYear varchar,
endYear varchar,
runtimeMinutes varchar,
genres varchar
);

--title_crew
create table imdb.public.title_crew (
tconst varchar,
directors varchar,
writers varchar
);

--title_episode
create table imdb.public.title_episode (
tconst varchar,
parentTconst varchar,
seasonNumber varchar,
episodeNumber varchar
);

--title_principals
create table imdb.public.title_principals (
tconst varchar,
ordering varchar,
nconst varchar,
category varchar,
job varchar,
characters varchar
);

--title_ratings
create table imdb.public.title_ratings (
tconst varchar,
averageRating varchar,
numVotes varchar
);

--name_basics
create table imdb.public.name_basics (
nconst varchar,
primaryName varchar,
birthYear varchar,
deathYear varchar,
primaryProfession varchar,
knownForTitles varchar
);

--1.3 Kyla's code was a little different
create table imdb.public.title_akas (
titleId	varchar,
ordering varchar,
title varchar,
region varchar,
language varchar,
types varchar,
attributes varchar,
isOriginalTitle varchar
);

create table imdb.public.title_basics (
tconst varchar,
titleType varchar,
primaryTitle varchar,
originalTitle varchar,
isAdult varchar,
startYear varchar,
endYear varchar,
runtimeMinutes varchar,
genres varchar
);

create table imdb.public.title_crew  (
tconst varchar,
directors varchar,
writers varchar
);

create table imdb.public.title_episode (
tconst varchar,
parentTconst varchar,
seasonNumber varchar,
episodeNumber varchar
);

create table imdb.public.title_principals (
tconst varchar,
ordering varchar,
nconst varchar,
category varchar,
job varchar,
characters varchar
);

create table imdb.public.title_ratings (
tconst varchar,
averageRating varchar,
numVotes varchar
);

--1.4 this imports the .tsv's into the appropriate schema
copy imdb.public.title_akas from 'D:\\imdb\title.akas.tsv\data.tsv' delimiter E'\t';
copy imdb.public.title_ratings from 'D:\\imdb\title.ratings.tsv\data.tsv' delimiter E'\t';
copy imdb.public.name_basics from 'D:\\imdb\name.basics.tsv\data.tsv' delimiter E'\t';
copy imdb.public.title_basics from 'D:\\imdb\title.basics.tsv\data.tsv' delimiter E'\t';
copy imdb.public.title_crew from 'D:\\imdb\title.crew.tsv\data.tsv' delimiter E'\t';
copy imdb.public.title_episode from 'D:\\imdb\title.episode.tsv\data.tsv' delimiter E'\t';
copy imdb.public.title_principals from 'D:\\imdb\title.principals.tsv\data.tsv' delimiter E'\t';

copy imdb.public.title_akas from '/Users/kylabrowne/Desktop/MATH172/title.akas.tsv' 
copy imdb.public.title_basics from '/Users/kylabrowne/Desktop/MATH172/title.basics.tsv'
copy imdb.public.title_crew from '/Users/kylabrowne/Desktop/MATH172/title.crew.tsv'
copy imdb.public.title_episode from '/Users/kylabrowne/Desktop/MATH172/title.episode.tsv'
copy imdb.public.title_principals from '/Users/kylabrowne/Desktop/MATH172/title.principals.tsv'
copy imdb.public.title_ratings from '/Users/kylabrowne/Desktop/MATH172/title.ratings.tsv'
  
--1.5 this removes the first row from each table
delete from imdb.public.name_basics where nconst = 'nconst';
delete from imdb.public.title_akas where titleId = 'titleId';
delete from imdb.public.title_basics where tconst = 'tconst';
delete from imdb.public.title_crew where tconst = 'tconst';
delete from imdb.public.title_episode where tconst = 'tconst';
delete from imdb.public.title_principals where tconst = 'tconst';
delete from imdb.public.title_ratings where tconst = 'tconst';

--1.6 this exports the tables into .csv's
COPY title_ratings TO 'D:\\imdb\title_ratings.csv' DELIMITER ',' CSV HEADER;
COPY name_basics TO 'D:\\imdb\name_basics.csv' DELIMITER ',' CSV HEADER;
COPY title_basics TO 'D:\\imdb\title_basics.csv' DELIMITER ',' CSV HEADER;
COPY title_crew TO 'D:\\imdb\title_crew.csv' DELIMITER ',' CSV HEADER;
COPY title_episode TO 'D:\\imdb\title_episode.csv' DELIMITER ',' CSV HEADER;
COPY title_principals TO 'D:\\imdb\title_principals.csv' DELIMITER ',' CSV HEADER;
COPY title_akas TO 'D:\\imdb\title_akas.csv' DELIMITER ',' CSV HEADER;

--2.1 the following calculates the cardinalities of each column in each table
--title_ratings
select 
count(distinct  "tconst") as tconst,
count(distinct  "numvotes") as numvotes,
count(distinct  "averagerating") as averagerating
from imdb.public.title_ratings;

--name_basics
select 
count(distinct  "nconst") as nconst,
count(distinct  "primaryname") as primaryname,
count(distinct  "birthyear") as birthyear,
count(distinct  "deathyear") as deathyear,
count(distinct  "primaryprofession") as primaryprofession,
count(distinct  "knownfortitles") as knownfortitles
from imdb.public.name_basics;

--title_basics
select 
count(distinct  "tconst") as tconst,
count(distinct  "titletype") as titleType,
count(distinct  "primarytitle") as primaryTitle,
count(distinct  "originaltitle") as originalTitle,
count(distinct  "isadult") as isAdult,
count(distinct  "startyear") as startYear,
count(distinct  "endyear") as endYear,
count(distinct  "runtimeminutes") as runtimeMinutes,
count(distinct  "genres") as genres
from imdb.public.title_basics;

--title_akas
select 
count(distinct  "titleid") as titleId,
count(distinct  "ordering") as ordering,
count(distinct  "title") as title,
count(distinct  "region") as region,
count(distinct  "language") as language,
count(distinct  "types") as types,
count(distinct  "attributes") as attributes,
count(distinct  "isoriginaltitle") as isOriginalTitle
from imdb.public.title_akas;

--title_principals
select 
count(distinct  "tconst") as tconst,
count(distinct  "ordering") as ordering,
count(distinct  "nconst") as nconst,
count(distinct  "category") as category,
count(distinct  "job") as job,
count(distinct  "characters") as characters
from imdb.public.title_principals;

--title_crew
select 
count(distinct  "tconst") as tconst,
count(distinct  "directors") as directors,
count(distinct  "writers") as writers
from imdb.public.title_crew;

--title_episode
select 
count(distinct  "tconst") as tconst,
count(distinct  "parenttconst") as parentTconst,
count(distinct  "seasonnumber") as seasonNumber,
count(distinct  "episodenumber") as episodeNumber
from imdb.public.title_episode;

--2.3 this adds the appropriate primary (composite) key to each table
alter table imdb.public.title_basics add primary key (tconst);
alter table imdb.public.name_basics add primary key (nconst);
alter table imdb.public.title_crew add primary key (tconst);
alter table imdb.public.title_ratings add primary key (tconst);
alter table imdb.public.title_principals add primary key (tconst, ordering);
alter table imdb.public.title_episode add primary key (tconst, parenttconst);
alter table imdb.public.title_akas add primary key (titleid,ordering);

--3.1
select count (*) as tconst_not_in_basics
from(
select 
tconst from imdb.public.title_ratings
except
select tconst from imdb.public.title_basics
) as sub_query;


--3.2
select count (*) as tconst_not_in_ratings
from(
select 
tconst from imdb.public.title_basics
except
select tconst from imdb.public.title_ratings
) as sub_query;

--3.3
select count (*) as tconst_in_both_ratings_basics
from(
select 
tconst from imdb.public.title_basics
intersect
select tconst from imdb.public.title_ratings
) as sub_query;

--3.5 this adds a foreign key constraint to title_ratings
alter table imdb.public.title_ratings add constraint tconst foreign key (tconst) references imdb.public.title_basics (tconst);

