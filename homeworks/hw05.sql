-- 2. 
-- i) This gives us the number of trips per hour per day of year per VendorID
select
extract (doy from tpep_dropoff_datetime) as drop_off_doy,
extract (hour from tpep_dropoff_datetime) as drop_off_hour_of_day,
"VendorID",
Count (*) as number_of_trips
from qcmath172.public.nyctaxicab2018
group by "VendorID", drop_off_doy, drop_off_hour_of_day
order by "VendorID", drop_off_doy, drop_off_hour_of_day;

-- ii) daily(based on drop_off_date) mean, median, extrema trips by vendorID
select 
drop_off_doy as drop_off_date,
"VendorID" as vendor_id,
min(number_of_trips) as min_cnt_trip,
percentile_disc(0.5) within group (order by number_of_trips) as median_cnt_trip,
avg(number_of_trips) as mean_cnt_trip,
max(number_of_trips) as max_cnt_trip
from (
select
extract (doy from tpep_dropoff_datetime) as drop_off_doy,
extract (hour from tpep_dropoff_datetime) as drop_off_hour_of_day,
"VendorID",
Count (*) as number_of_trips
from qcmath172.public.nyctaxicab2018
group by drop_off_doy, drop_off_hour_of_day, "VendorID"
) as number_of_trips
group by drop_off_doy,"VendorID"
order by drop_off_doy,"VendorID";

-- iii) This gives us min, mean, median, max trip distance by vendor b/w 5am & 6am.
select 
"VendorID" as vendor_id,
min(trip_distance) as min_trip_distance,
percentile_disc(0.5) within group (order by trip_distance) as median_trip_distance,
avg(cast (trip_distance as numeric)) as mean_trip_distance,
max(trip_distance) as max_trip_distance
from qcmath172.public.nyctaxicab2018
where 
extract (hour from tpep_dropoff_datetime) = 5 and 
extract (minute from tpep_dropoff_datetime) <60
group by "VendorID"
order by "VendorID";

-- iv) a) This gives us amount of unique trips, in ascending order
select extract (doy from tpep_dropoff_datetime) as drop_off_doy,
Count (*) as amount_of_unique_trips
from(select distinct * from nyctaxicab2018)
as sub_query
group by drop_off_doy
order by amount_of_unique_trips;
-- min day 4th

-- iv) b) ) This gives us amount of unique trips, in descending order
select extract (doy from tpep_dropoff_datetime) as drop_off_doy,
Count (*) as amount_of_unique_trips
from(select distinct * from nyctaxicab2018)
as sub_query
group by drop_off_doy
order by amount_of_unique_trips desc;
-- max day 75th

-- 3.
-- i) This gives us the average tip amount for unique trips
select (sum(tip_amount)/sum(total_amount)) as average_tip_percentage 
from(select distinct * from nyctaxicab2018)
as sub_query;
-- result -> 0.114348353

-- ii)This gives us the average tip amount for unique trips per hour
select extract (hour from tpep_dropoff_datetime) as drop_off_hour_of_day,
(100*sum(tip_amount)/sum(total_amount)) as average_tip_percentage
from(select distinct * from nyctaxicab2018)
as sub_query
group by drop_off_hour_of_day
order by drop_off_hour_of_day;

-- 4. 
-- i) This gives the average tip percentage per mileage bands
select 
CASE 
	WHEN cast(trip_distance as float) >= 0 and cast(trip_distance as float) < 1 then '0-1 mile'
	WHEN cast(trip_distance as float)>= 1 and cast(trip_distance as float)< 2 then '1-2 miles'
    WHEN cast(trip_distance as float)>= 2 and cast(trip_distance as float)< 3 then '2-3 miles'
    WHEN cast(trip_distance as float)>= 3 and cast(trip_distance as float)< 4 then '3-4 miles'
    WHEN cast(trip_distance as float)>= 4 then '>5 miles'
	END as trip_mileage_band,
(100*sum(tip_amount)/sum(total_amount)) as tip_percentage
from(select distinct * from nyctaxicab2018)
as sub_query
group by trip_mileage_band
order by trip_mileage_band;
-- trip percentage increases upto 3 miles and then decreases

-- ii) This creates the view
create view daily_tip_percentage_by_distance as 
select 
extract (doy from tpep_dropoff_datetime) as _date,
CASE 
	WHEN cast(trip_distance as float) >= 0 and cast(trip_distance as float) < 1 then '0-1 mile'
	WHEN cast(trip_distance as float)>= 1 and cast(trip_distance as float)< 2 then '1-2 miles'
    WHEN cast(trip_distance as float)>= 2 and cast(trip_distance as float)< 3 then '2-3 miles'
    WHEN cast(trip_distance as float)>= 3 and cast(trip_distance as float)< 4 then '3-4 miles'
    WHEN cast(trip_distance as float)>= 4 then '>5 miles'
	END as trip_mileage_band,
(100*sum(tip_amount)/sum(total_amount)) as tip_percentage
from(select distinct * from nyctaxicab2018)
as sub_query
group by _date, trip_mileage_band
order by _date;



