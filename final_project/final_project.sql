--Group 1 Final Project Code

--Members: Kyla Browne, Ashley V. Santiago DeJesus, Osman Khan, Masroor Khonkhodzhaev

--this creates a table so that we can import our data from fiscal 2023 parking violations.
drop table if exists project.public.pvf2023;
create table project.public.pvf2023(
"Summons Number" varchar,
"Plate ID" varchar,
"Registration State" varchar,
"Plate Type" varchar,
"Issue Date" timestamp,
"Violation Code" bigint,
"Vehicle Body Type" varchar,
"Vehicle Make" varchar,
"Issuing Agency" varchar,
"Street Code1" bigint,
"Street Code2" bigint,
"Street Code3" bigint,
"Vehicle Expiration Date" bigint,
"Violation Location" varchar,
"Violation Precinct" bigint,
"Issuer Precinct" bigint,
"Issuer Code" bigint,	
"Issuer Command" varchar,
"Issuer Squad" varchar,	
"Violation Time" varchar,
"Time First Observed" varchar,
"Violation County" varchar,
"Violation In Front Of Or Opposite" varchar,
"House Number" varchar,
"Street Name" varchar,
"Intersecting Street" varchar,
"Date First Observed" bigint,
"Law Section" bigint,
"Sub Division" varchar,
"Violation Legal Code" varchar,
"Days Parking In Effect" varchar,
"From Hours In Effect" varchar,
"To Hours In Effect" varchar,
"Vehicle Color" varchar,
"Unregistered Vehicle?" varchar,
"Vehicle Year" bigint,
"Meter Number" varchar,
"Feet From Curb" bigint,
"Violation Post Code" varchar,
"Violation Description" varchar,
"No Standing or Stopping Violation" varchar,
"Hydrant Violation" varchar,
"Double Parking Violation" varchar
);
--this creates a table so that we can import our data from fiscal 2024 parking violations.
drop table if exists project.public.pvf2024;
create table project.public.pvf2024(
"Summons Number" varchar,
"Plate ID" varchar,
"Registration State" varchar,
"Plate Type" varchar,
"Issue Date" timestamp,
"Violation Code" bigint,
"Vehicle Body Type" varchar,
"Vehicle Make" varchar,
"Issuing Agency" varchar,
"Street Code1" bigint,
"Street Code2" bigint,
"Street Code3" bigint,
"Vehicle Expiration Date" bigint,
"Violation Location" varchar,
"Violation Precinct" bigint,
"Issuer Precinct" bigint,
"Issuer Code" bigint,	
"Issuer Command" varchar,
"Issuer Squad" varchar,	
"Violation Time" varchar,
"Time First Observed" varchar,
"Violation County" varchar,
"Violation In Front Of Or Opposite" varchar,
"House Number" varchar,
"Street Name" varchar,
"Intersecting Street" varchar,
"Date First Observed" bigint,
"Law Section" bigint,
"Sub Division" varchar,
"Violation Legal Code" varchar,
"Days Parking In Effect" varchar,
"From Hours In Effect" varchar,
"To Hours In Effect" varchar,
"Vehicle Color" varchar,
"Unregistered Vehicle?" varchar,
"Vehicle Year" bigint,
"Meter Number" varchar,
"Feet From Curb" bigint,
"Violation Post Code" varchar,
"Violation Description" varchar,
"No Standing or Stopping Violation" varchar,
"Hydrant Violation" varchar,
"Double Parking Violation" varchar
);
	
--this creates a table so that we can import our data from open parking and camera violations 2023.
drop table if exists project.public.opcv2023;
create table project.public.opcv2023(
"Plate" varchar,
"State" varchar,
"License Type" varchar,
"Summons Number" varchar,
"Issue Date" varchar,
"Violation Time" varchar,
"Violation" varchar,
"Judgment Entry Date" varchar,
"Fine Amount" float,
"Penalty Amount" float,
"Interest Amount" float,
"Reduction Amount" float,
"Payment Amount" float,
"Amount Due" float,
"Precinct" varchar,
"County" varchar,
"Issuing Agency" varchar,
"Violation Status" varchar,
"Summons Image" varchar
);
--this copies data from csv to sql
--C:\Users\Public\Downloads
copy project.public.pvf2024 from 'D:\\172_project\pvf2024.csv'  DELIMITER ',' CSV HEADER;
copy project.public.pvf2023 from 'D:\\172_project\pvf2023.csv'  DELIMITER ',' CSV HEADER;
copy project.public.opcv2023 from 'D:\\172_project\opcv2023.csv'  DELIMITER ',' CSV HEADER;


select count(distinct "Summons Number")from project.public.pvf2024;--12,008,298
select count(*) from project.public.pvf2024;--12,008,298
select count(distinct "Summons Number")from project.public.pvf2023;--21,563,258
select count(*) from project.public.pvf2023;--21,563,258
select count(distinct "Summons Number")from project.public.;--
select count(*) from project.public.;--
--this gives us the count of the number of rows/tuples with illegal dates
select count(*) from project.public.opcv2023 where "Issue Date" = '06/31/2023';--3
select count(*) from project.public.opcv2023 where "Issue Date" = '02/29/2023'; --2
select count(*) from project.public.opcv2023 where "Issue Date" = '09/31/2023';
--we deleted rows/tuples that had the dates Feb 29th, June 31st, Sept 31st, which DNE.
delete from project.public.opcv2023 where "Issue Date" = '02/29/2023';
delete from project.public.opcv2023 where "Issue Date" = '06/31/2023';
delete from project.public.opcv2023 where "Issue Date" = '09/31/2023';
--this gives us the count of the number of rows/tuples with illegal dates
select count(*) from project.public.opcv2023 where "Issue Date" = '06/31/2023';--3
select count(*) from project.public.opcv2023 where "Issue Date" = '02/29/2023'; --2
select count(*) from project.public.opcv2023 where "Issue Date" = '09/31/2023';


--Altering data to timestamp for join (Year 2023 only)
ALTER TABLE public.opcv2023 ALTER COLUMN "Issue Date" TYPE timestamp USING "Issue Date"::timestamp;


select count(distinct "Summons Number")from project.public.opcv2023;
--12,171,097
select count(*) from project.public.opcv2023;
--12,171,097 all
SELECT
 column_name
FROM
 information_schema.columns
WHERE
 table_name = 'opcv2023'
ORDER BY
 ordinal_position;
-- Join tables pvf2023 and pvf2024 into one new table with all rows from both tables
-- 9.3GB in total before filtering
CREATE TABLE pvf_joined AS
SELECT *
FROM pvf2023 p
UNION
SELECT *
FROM pvf2024 p;
--Check the number of rows
select count(distinct "Summons Number")from project.public.pvf_joined;--29,320,679
select count(*) from project.public.pvf_joined;--30,985,971
-- Delete rows with year not 2023. Filter out to only keep 2023
DELETE FROM pvf_joined
WHERE EXTRACT(YEAR FROM "Issue Date") <> 2023;
--Check if there are less rows now
select count(distinct "Summons Number")from project.public.pvf_joined;--16,616,208
select count(*) from project.public.pvf_joined;--18,281,080
-- Dropped these three columns as they don't have data, "No Standing or Stopping Violation", "Hydrant Violation", "Double Parking Violation";
-- created a new table with only unique "Summons Number"
create table unique_pvf as
select distinct "Summons Number",
"Plate ID",
"Registration State",
"Plate Type",
"Issue Date",
"Violation Code",
"Vehicle Body Type",
"Vehicle Make",
"Issuing Agency",
"Street Code1",
"Street Code2",
"Street Code3",
"Vehicle Expiration Date",
"Violation Location",
"Violation Precinct",
"Issuer Precinct",
"Issuer Code",
"Issuer Command",
"Issuer Squad",
"Violation Time",
"Time First Observed",
"Violation County",
"Violation In Front Of Or Opposite",
"House Number",
"Street Name",
"Intersecting Street",
"Date First Observed",
"Law Section",
"Sub Division",
"Violation Legal Code",
"Days Parking In Effect",
"From Hours In Effect",
"To Hours In Effect",
"Vehicle Color",
"Unregistered Vehicle?",
"Vehicle Year",
"Meter Number",
"Feet From Curb",
"Violation Post Code",
"Violation Description"
from pvf_joined;
—- confirm we have unique Summons Number
select count(distinct "Summons Number")from project.public.unique_pvf;--16,616,208
select count(*) from project.public.unique_pvf;--16,616,208
—- free up space taken by deleted tuples.
vacuum full;
SELECT
 column_name
FROM
 information_schema.columns
WHERE
 table_name = 'pvf_joined'
ORDER BY
 ordinal_position;
--join by summons number & filter by state = NY
-–Store results in a new table; used overlapped columns to minimize duplication
create table all_combined as
select
	t1."Summons Number",
	"State",
	"License Type",
	t1."Issue Date",
	"Violation Code",
	"Vehicle Body Type",
	"Vehicle Make",
	t1."Issuing Agency",
	"Street Code1",
	"Street Code2",
	"Street Code3",
	"Vehicle Expiration Date",
	"Violation Location",
	"Precinct",
	"Issuer Precinct",
	"Issuer Code",
	"Issuer Command",
	"Issuer Squad",
	t1."Violation Time",
	"Time First Observed",
	"County",
	"Violation In Front Of Or Opposite",
	"House Number",
	"Street Name",
	"Intersecting Street",
	"Date First Observed",
	"Law Section",
	"Sub Division",
	"Violation Legal Code",
	"Days Parking In Effect",
	"From Hours In Effect",
	"To Hours In Effect",
	"Vehicle Color",
	"Unregistered Vehicle?",
	"Vehicle Year",
	"Meter Number",
	"Feet From Curb",
	"Violation Post Code",
	"Violation Description",
	"Judgment Entry Date",
	"Fine Amount",
	"Penalty Amount",
	"Interest Amount",
	"Reduction Amount",
	"Payment Amount",
	"Amount Due",
	"Violation Status",
	"Summons Image"
from
	project.public.opcv2023 as t1
left join
	project.public.unique_pvf as t2
on t1."Summons Number" = t2."Summons Number"
where "State" = 'NY';
-- Check cardinality of the joined table
--Establishing Primary Key:
create table
	cardinality_of_columns as
select
	count(distinct "Summons Number") as Summons_Number,
	count(distinct "State") as State,
	count(distinct "License Type") as License_Type,
	count(distinct "Issue Date") as Issue_Date,
	count(distinct "Violation Code") as Violation_Code,
	count(distinct "Vehicle Body Type") as Vehicle_Body_Tpe,
	count(distinct "Vehicle Make") as Vehicle_Make,
	count(distinct "Issuing Agency") as Issuing_Agency,
	count(distinct "Street Code1") as Street_Code1,
	count(distinct "Street Code2") as Street_Code2,
	count(distinct "Street Code3") as Street_Code3,
	count(distinct "Vehicle Expiration Date") as Vehicle_Expiration_Date,
	count(distinct "Violation Location") as Vehicle_Location,
	count(distinct "Precinct") as Precint,
	count(distinct "Issuer Precinct") as Issuer_Precinct,
	count(distinct "Issuer Code") as Issuer_Code,
	count(distinct "Issuer Command") as Issuer_Command,
	count(distinct "Issuer Squad") as Issuer_Squad,
	count(distinct "Violation Time") as Violation_Time,
	count(distinct "Time First Observed") as Time_First_Observed,
	count(distinct "County") as County,
	count(distinct "Violation In Front Of Or Opposite") as Violation_In_Front_Of_Or_Opposite,
	count(distinct "House Number") as House_Number,
	count(distinct "Street Name") as Street_Name,
	count(distinct "Intersecting Street") as Intersecting_Street,
	count(distinct "Date First Observed") as Date_First_Observed,
	count(distinct "Law Section") as Law_Section,
	count(distinct "Sub Division") as Sub_Division,
	count(distinct "Violation Legal Code") as Violation_Legal_Code,
	count(distinct "Days Parking In Effect") as Days_Parking_In_Effect,
	count(distinct "From Hours In Effect") as From_Hours_In_Effect,
	count(distinct "To Hours In Effect") as To_Hours_in_Effect,
	count(distinct "Vehicle Color") as Vehicle_Color,
	count(distinct "Unregistered Vehicle?") as Unregistered_Vehicle,
	count(distinct "Vehicle Year") as Vehicle_Year,
	count(distinct "Meter Number") as Meter_Number,
	count(distinct "Feet From Curb") as Feet_From_Curb,
	count(distinct "Violation Post Code") as Violation_Post_Code,
	count(distinct "Violation Description") as Violation_Description,
	count(distinct "Judgment Entry Date") as Judgment_Entry_Date,
	count(distinct "Fine Amount") as Fine_Amount,
	count(distinct "Penalty Amount") as Penalty_Amount,
	count(distinct "Interest Amount") as Interest_Amount,
	count(distinct "Reduction Amount") as Reduction_Amount,
	count(distinct "Payment Amount") as Payment_Amount,
	count(distinct "Amount Due") as Amount_Due,
	count(distinct "Violation Status") as Violation_Status,
	count(distinct "Summons Image") as Summons_Image
from
	all_combined ac;
--save as a markdown table
select * from cardinality_of_columns;
--see if Summons Number can work as primary key
select count(distinct "Summons Number")from project.public.all_combined;--12,171,097
select count(*) from project.public.all_combined;--13,317,894


--this creates a table with unique summons number
create table unique_combined as
select
	distinct "Summons Number",
	"State",
	"License Type",
	"Issue Date",
	"Violation Code",
	"Vehicle Body Type",
	"Vehicle Make",
	"Issuing Agency",
	"Street Code1",
	"Street Code2",
	"Street Code3",
	"Vehicle Expiration Date",
	"Violation Location",
	"Precinct",
	"Issuer Precinct",
	"Issuer Code",
	"Issuer Command",
	"Issuer Squad",
	"Violation Time",
	"Time First Observed",
	"County",
	"Violation In Front Of Or Opposite",
	"House Number",
	"Street Name",
	"Intersecting Street",
	"Date First Observed",
	"Law Section",
	"Sub Division",
	"Violation Legal Code",
	"Days Parking In Effect",
	"From Hours In Effect",
	"To Hours In Effect",
	"Vehicle Color",
	"Unregistered Vehicle?",
	"Vehicle Year",
	"Meter Number",
	"Feet From Curb",
	"Violation Post Code",
	"Violation Description",
	"Judgment Entry Date",
	"Fine Amount",
	"Penalty Amount",
	"Interest Amount",
	"Reduction Amount",
	"Payment Amount",
	"Amount Due",
	"Violation Status",
	"Summons Image"
from all_combined;


select count(distinct "Summons Number")from project.public.unique_combined;--12,171,097
select count(*) from project.public.unique_combined;--12,171,097




--apply primary key to the table.
alter table unique_combined
ADD Primary KEY ("Summons Number");


--download as csv for tableau
COPY project.public.unique_combined TO 'D:\172_project\unique_combined.csv' DELIMITER ',' CSV HEADER;
