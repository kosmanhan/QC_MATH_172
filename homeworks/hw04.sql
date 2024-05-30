/*1.*/

/*Please note that the taxicab 2018 data table needs to be named nyctaxicab2018 for the code in this .sql to work*/

/* We create a table named distincttaxi2018 with two columns*/

create table qcmath172.public.distincttaxi2018 (
"column_name" varchar,
"distinct_records" bigint
);

/*We insert the distinct records for each of the seventeen columns from our data*/

insert into qcmath172.public.distincttaxi2018 
(column_name, distinct_records) values
('VendorID', (select count(distinct  "VendorID") from qcmath172.public.nyctaxicab2018)),
('tpep_pickup_datetime', (select count(distinct  "tpep_pickup_datetime") from qcmath172.public.nyctaxicab2018)),
('tpep_dropoff_datetime', (select count(distinct  "tpep_dropoff_datetime") from qcmath172.public.nyctaxicab2018)),
('passenger_count', (select count(distinct  "passenger_count") from qcmath172.public.nyctaxicab2018)),
('trip_distance', (select count(distinct  "trip_distance") from qcmath172.public.nyctaxicab2018)),
('RatecodeID', (select count(distinct  "RatecodeID") from qcmath172.public.nyctaxicab2018)),
('store_and_fwd_flag', (select count(distinct  "store_and_fwd_flag") from qcmath172.public.nyctaxicab2018)),
('PULocationID', (select count(distinct  "PULocationID") from qcmath172.public.nyctaxicab2018)),
('DOLocationID', (select count(distinct  "DOLocationID") from qcmath172.public.nyctaxicab2018)),
('payment_type', (select count(distinct  "payment_type") from qcmath172.public.nyctaxicab2018)),
('fare_amount', (select count(distinct  "fare_amount") from qcmath172.public.nyctaxicab2018)),
('extra', (select count(distinct  "extra") from qcmath172.public.nyctaxicab2018)),
('mta_tax', (select count(distinct  "mta_tax") from qcmath172.public.nyctaxicab2018)),
('tip_amount', (select count(distinct  "tip_amount") from qcmath172.public.nyctaxicab2018)),
('tolls_amount', (select count(distinct  "tolls_amount") from qcmath172.public.nyctaxicab2018)),
('improvement_surcharge', (select count(distinct  "improvement_surcharge") from qcmath172.public.nyctaxicab2018)),
('total_amount', (select count(distinct  "total_amount") from qcmath172.public.nyctaxicab2018))
;

/*2.*/

select count(*) as distinct_observation_count 
from (select distinct 
"VendorID", 
"tpep_pickup_datetime", 
"tpep_dropoff_datetime",
"passenger_count",
"trip_distance",
"RatecodeID",
"store_and_fwd_flag",
"PULocationID",
"DOLocationID",
"payment_type",
"fare_amount",
"extra",
"mta_tax",
"tip_amount",
"tolls_amount",
"improvement_surcharge",
"total_amount"
from qcmath172.public.nyctaxicab2018) 
as sub_query;

/*3.*/

select count(*) as passenger_count_is_5 
from(select * from nyctaxicab2018 where passenger_count = '5')
as sub_query;

select count(*) as passenger_count_is_greater_than_3 
from(select distinct * from nyctaxicab2018 where passenger_count > '3')
as sub_query;

select count(*) as april_pickup 
from(select * from nyctaxicab2018 
where tpep_pickup_datetime > '2018-04-01 00:00:00' 
and tpep_pickup_datetime < '2018-05-01 00:00:00')
as sub_query;

select count(*) as june_ge_five_bucks 
from(select * from nyctaxicab2018 
where tpep_pickup_datetime < '2018-07-01 00:00:00' 
and tpep_dropoff_datetime > '2018-06-01 00:00:00'
and tip_amount >= '5'
)
as sub_query;

select count(*) as may_bw_two_and_five_bucks_with_more_than_three_passengers 
from(select * from nyctaxicab2018 
where tpep_pickup_datetime < '2018-06-01 00:00:00' 
and tpep_dropoff_datetime > '2018-05-01 00:00:00'
and tip_amount <= '5'
and tip_amount >= '2'
and passenger_count > '3'
)
as sub_query;

select sum(tip_amount) from qcmath172.public.nyctaxicab2018;

/*4.*/

select count(*) as vendor_id_is_two from qcmath172.public.nyctaxicab2018 where "VendorID" = '2';

delete from qcmath172.public.nyctaxicab2018 where "VendorID" = '2';
	
select count(*) as vendor_id_is_two from qcmath172.public.nyctaxicab2018 where "VendorID" = '2';

/*5.*/

vacuum full;

/*6.*/

truncate nyctaxicab2018;

/*The data will be re-imported. Please note that I have saved the data on a flash drive, and named the .csv 'Yellow_Taxi.csv' 
On my computer, there is only one disk, 'C:', which is why the flash drive appears as 'D:'*/

copy qcmath172.public.nyctaxicab2018 from 'D:\\Yellow_Taxi.csv' DELIMITER ',' csv header;
