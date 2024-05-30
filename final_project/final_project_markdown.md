# Group 1 Final Project Markdown

Members: Kyla Browne, Ashley V. Santiago DeJesus, Osman Khan, Masroor Khonkhodzhaev

## Collecting Our Data: Assumptions and Restrictions

When beginning our project, we made multiple executive decisions. The first decision was to minimize our initial data in the Open Parking and Camera Violations dataset, which had data from 2016 to present. We had an issue downloading all the data because of its size, so we decided on restricting our data to violations committed in the last year (2023). This significantly decreased our data but also made it more manageable for our goal. 

An assumption we made was that those that have a state license plate of “NY” were the only residents of New York. This is a big assumption to make considering many car owners may go out of state to register their car for cheaper insurance rates, etc. This would be excluding a portion of the population that is part of our analysis. However, it works in our favor since this portion includes  those who are just passing by through NY to get to their destination. Hence, we avoid including those who are unaware of NY law and regulations. To us, this was a fair tradeoff so that we could focus on residents of NY. We assume that no one would register their car here from out-of-state, since New York is an expensive state with a higher cost of living and therefore defeating the purpose of a car owner registering out-of-state. This guarantees that our data includes residents only.

We checked the data quality of the data sets. Accuracy was checked using the summons image, which had all the data that the columns had. Data was from 2023, so it checked off timeliness. We counted the number of unique summons id and found it was equal to the total number of rows, giving us unique data. We assumed as it came from the official NYC Open Data, that the data had integrity. The data is not complete, as there are a lot of cells with null. The data is consistent, as columns only have specific values. 12 million unique summons seemed reasonable. 

## Combining Our Data

Continuing our process, we now had our three tables: “Open Parking and Camera Violations”, “Parking Violations Fiscal Year 2023”, and “Parking Violations Fiscal Year 2024”.  With both dataset that were for Fiscal Year ‘23 and Fiscal Year ‘24, there was an issue after we wanted to join them together to filter for dates only in 2023. So the adjustment we made was making sure that all issue dates were in the data type of “timestamp”. However, we ran into an error because the data had dates that did not exist in the year of 2023. For example we were receiving errors because of the dates “02/29/2023”, “06/31/2023”, and “09/31/2023”. So we proceeded by deleting these tuples from the data since these are clearly mistakes.
```
--this gives us the count of the number of rows/tuples with illegal dates

select count(*) from project.public.opcv2023 where "Issue Date" = '06/31/2023';--3
select count(*) from project.public.opcv2023 where "Issue Date" = '02/29/2023'; --2
select count(*) from project.public.opcv2023 where "Issue Date" = '09/31/2023';



--we deleted rows/tuples that had the dates Feb 29th, June 31st, Sept 31st, which DNE.
delete from project.public.opcv2023 where "Issue Date" = '02/29/2023';
delete from project.public.opcv2023 where "Issue Date" = '06/31/2023';
delete from project.public.opcv2023 where "Issue Date" = '09/31/2023';


--this gives us the count of the number of rows/tuples with illegal dates
select count(*) from project.public.opcv2023 where "Issue Date" = '06/31/2023';--0
select count(*) from project.public.opcv2023 where "Issue Date" = '02/29/2023'; --0
select count(*) from project.public.opcv2023 where "Issue Date" = '09/31/2023';--0
```
After successfully changing “Issue date” from varchar to timestamp, we proceeded with our join. We did a left join twice. First between Parking Violations Fiscal Year 2023 and 2024 using “Summons Number”. Both Parking Violations Fiscal Year 2023 and 2024 had dates from years we’re not interested in, so joining these first for filtering made sense. But our “Open Parking and Camera Violations” dataset was already restricted to only dates in the year 2023, so naturally in our join this issue is taken care of. We continued by joining the second time between our newly joined table, named pvf_ and “Open Parking and Camera Violations” using “Summons Number” again. We now could filter for license plates only in NY.
```
CREATE TABLE pvf_joined AS
SELECT *
FROM pvf2023 p
UNION ALL
SELECT *
FROM pvf2024 p;


DELETE FROM pvf_joined
WHERE EXTRACT(YEAR FROM "Issue Date") <> 2023;
```

## Establishing a Primary Key and Foreign Key
	
We were now set to work on our data analysis. We wanted to implement a primary key and began by running a cardinality count on “Summons Number” in the “Open Parking and Camera Violations” table before our join. This was the biggest dataset of them all and we wanted to gain an understanding of what our join would’ve looked like and if cardinality would be preserved afterward.
```
-- Cardinality count for possible primary key
select count(distinct "Summons Number")from project.public.opcv2023;
--12,171,097, unique summons number
select count(*) from project.public.opcv2023;
--12,171,106 all

--see if Summons Number can work as primary key
select count(distinct "Summons Number")from project.public.all_combined;
--12,171,097


select count(*) from project.public.all_combined;
--15,270,531
```
We saw that when checking for cardinality for the “Open Parking” dataset before our join, there was complete uniqueness. However, We noticed that “Summons Number” changed drastically when checking the cardinality for the joined tables.. Therefore, we retraced our steps by checking the cardinality in both Fiscal Year ‘23 and Fiscal Year ‘24.
```
select count(distinct "Summons Number")from project.public.pvf2024;--12,008,298
select count(*) from project.public.pvf2024;
--12,008,298
select count(distinct "Summons Number")from project.public.pvf2023;--21,563,258
select count(*) from project.public.pvf2023;
—-21,563,258
```
Fiscal Year ‘23 and ‘24 had complete uniqueness for “Summons Number” as well. So, we assumed the issue resided in our union. Both Fiscal Year ‘23 and ‘24 have the exact same columns, so we resorted to a union. Originally we did “union all”:
```
CREATE TABLE pvf_joined AS
SELECT *
FROM pvf2023 p
UNION ALL
SELECT *
FROM pvf2024 p;


select count(distinct "Summons Number")from project.public.pvf_joined;
--29,320,679
select count(*) from project.public.pvf_joined;
--33,571,556
```
But a “union all” collects all rows from both tables, including the duplicates. Therefore, there wasn’t uniqueness for “Summons Number” in the new combined table. So, we reran the code, using “union”. After checking its cardinality, this time the uniqueness was better, but still a large number of duplicates.
```
select count(distinct "Summons Number") from project.public.pvf_joined;
--29,320,679
select count(*) from project.public.pvf_joined;
--30,985,971
```
We used the following to get only unique “Summons Number”:
```
create table unique_combined as
select
	distinct "Summons Number",
	"State",
…
```

And then used the following to assign a primary key:
```
alter table unique_combined
ADD Primary KEY ("Summons Number");
```
And then we exported the filed as a csv into Tableu.



## Visualizations
Now having our final data, we exported our final set and imported it into Tableau. Here, we began running queries and creating visualizations based on our hypothesis. We hypothesized that Manhattan would have the highest number of violations. This assumption was made due to the high volumes of traffic that it has, the amount of tourism it experiences, and the lack of parking in this area. So, we first counted the number of violations by county (aka borough) to determine which had the highest number of violations. It turned out to be Brooklyn. Therefore, our hypothesis was wrong.

Furthermore, we looked into the other stats like top 10 committed violations, total fine amounts per type of violation, and total amount fined in 2023. In 2023, an astonishing total of 995 million dollars were fined based on the data. Due to this high total, we brokedown total fine amount by borough, the time period for the most violations, and whether or not these payments were made on time. 
In conclusion, according to this data, Brooklyn had the highest total number of violations, Bronx was the worst at paying fines off, and the highest violation committed was “School Zone Speeding Ticket”. 
