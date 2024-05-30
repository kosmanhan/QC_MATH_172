--please note, the database is named "imdb". The code will not run otherwise.
--1.1 verify that the data type of the three specified columns is varchar
select table_name, column_name, data_type 
from imdb.information_schema.columns
where  table_schema = 'public' and table_name = 'title_basics';

--1.2 create each view below: 
create view imdb.public.etl_title_basic_v
as
select 
 tb.tconst
,tb.titletype
,tb.primarytitle
,tb.originaltitle
,cast(tb.isadult as boolean) as isadult
,cast(tb.startyear as integer) as startyear
,cast(tb.endyear as integer) as endyear
,cast(tb.runtimeminutes as integer) as runtimeminutes
,regexp_split_to_array(tb.genres,',')::varchar[] as genres       
from imdb.public.title_basics tb;

create view imdb.public.etl_name_basic_v as select
nb.nconst,
nb.primaryname,
cast(nb.birthyear as integer)as birthyear,
cast(nb.deathyear as integer)as deathyear,
regexp_split_to_array(nb.primaryprofession,',')::varchar[]as primaryprofession ,
regexp_split_to_array(nb.knownfortitles,',')::varchar[]as knownfortitles
from imdb.public.name_basics nb;

create view imdb.public.etl_title_akas_v as select
ta.titleid,
cast(ta.ordering as integer) as ordering,
ta.title,
ta.region,
ta.language,
ta.types,
regexp_split_to_array(ta.attributes,',')::varchar[]as attributes,
cast(ta.isoriginaltitle as boolean) as isoriginaltitle
from imdb.public.title_akas ta;

create view imdb.public.etl_title_crew_v as select
tc.tconst,
regexp_split_to_array(tc.directors,',')::varchar[]as directors,
regexp_split_to_array(tc.writers,',')::varchar[]as writers
from imdb.public.title_crew tc;

create view imdb.public.etl_title_episode_v as select
te.tconst,
te.parenttconst,
cast(te.seasonnumber as integer)as seasonnumber,
cast(te.episodenumber as integer)as episodenumber
from imdb.public.title_episode te;

create view imdb.public.etl_title_principals_v as select
tp.tconst,
cast(tp.ordering as integer)as ordering,
tp.nconst,
tp.category,
tp.job,
tp.characters
from imdb.public.title_principals tp;

create view imdb.public.etl_title_ratings_v as select
tr.tconst,
cast(tr.averagerating as decimal(3,1)) as averagerating,
cast(tr.numvotes as integer) as numvotes
from imdb.public.title_ratings tr;

--1.3 create physical tables
create table imdb.public.xf_name_basic
as
select * from imdb.public.etl_name_basic_v;

create table imdb.public.xf_title_ratings
as
select * from imdb.public.etl_title_ratings_v;

create table imdb.public.xf_title_basic
as
select * from imdb.public.etl_title_basic_v;

create table imdb.public.xf_title_crew
as
select * from imdb.public.etl_title_crew_v;

create table imdb.public.xf_title_episode
as
select * from imdb.public.etl_title_episode_v;

create table imdb.public.xf_title_principals
as
select * from imdb.public.etl_title_principals_v;

create table imdb.public.xf_title_akas
as
select * from imdb.public.etl_title_akas_v;

--1.4 this adds the appropriate primary (composite) key to each table
alter table imdb.public.xf_title_basic add primary key (tconst);
alter table imdb.public.xf_name_basic add primary key (nconst);
alter table imdb.public.xf_title_crew add primary key (tconst);
alter table imdb.public.xf_title_ratings add primary key (tconst);
alter table imdb.public.xf_title_principals add primary key (tconst, ordering);
alter table imdb.public.xf_title_episode add primary key (tconst, parenttconst);
alter table imdb.public.xf_title_akas add primary key (titleid,ordering);

--2.1 movies with runtimes between 42 and 77 minutes
select titletype as titletype, count (*) as movies_with_run_time_bw_42_and_77 
from imdb.public.xf_title_basic
where runtimeminutes >=42 and runtimeminutes <=72 and titletype='movie' group by titletype;

--2.2 average runtime of movies for adults
select avg(runtimeminutes)as average_runtime_adults from imdb.public.xf_title_basic where genres[1] = 'Adult' or genres[2] = 'Adult';

--2.4 average runtime of movies whose first genre is Action
select cast(avg(runtimeminutes) as integer)as average_runtime_action from imdb.public.xf_title_basic where genres[1] = 'Action';

--movies with a runtime of 47 minutes
select count(*) as forty_seven_long from imdb.public.xf_title_basic where cast(runtimeminutes as integer) = 47;

--2.5 relative frequency of each distinct genre array
select genres,
sum(count (*)) over (partition by genres)/ (select count(*) from imdb.public.xf_title_basic)as relative_frequency
from imdb.public.xf_title_basic group by genres order by relative_frequency desc;


