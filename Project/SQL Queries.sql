USE Divvy;

describe Stations;
-- We have id (int), name(text), latitude(double), longitude(double), dpcapacity (int), landmark (int), online date(text)
-- There is a mistake: name should be VARCHAR, online date should be DATE
-- For some reason, there's "YES" under Null column - could lead to issues with the data

describe Trips;
-- We have trip_id (int), start_time (text), end_time (text), bikeid (int), tripduration (text), from_station_id (int),
-- to_station_id (int), usertype (text), gender (text), birthyear (double)
-- There are some mistakes: start_time should be TIMESTAMP, end_time should be TIMESTAMP, tripduration should be INT,
-- usertype should be VARCHAR, and birthyear should be YEAR
-- For some reason, there's "YES" under Null column - could lead to issues with the data

select count(*), count(distinct id) from Stations;
select count(*), count(distinct trip_id) from Trips;
-- Checking for duplicates in both tables 

select * from Stations
inner join Trips on Stations.id = Trips.from_station_id
order by id asc;

select * from Stations
inner join Trips on Stations.id = Trips.to_station_id
order by id asc;
-- It looks like that the common key between two tables is the id - "id" from the "Stations" and "from/to_station_id" from Trips

-- Step 1: Writing a query to know which station IDs in the "from_station_id" field are not in the Stations table.
-- Then doing the same for the column "to_station_id".

select distinct from_station_id from Trips 
where from_station_id not in (select id from Stations);
-- and we do the same for the "to_station_id"
select distinct to_station_id from Trips 
where to_station_id not in (select id from Stations);

-- Step 2: Now, combining our two tables in STEP 1, using the keyword UNION.
-- This will essentially represent the number of all missing stations.

select count(*) from (select distinct from_station_id from Trips
	where from_station_id not in (select id from Stations)
	union 
	select distinct to_station_id from Trips 
	where to_station_id not in (select id from Stations))
as Missing;
-- Now we count how many entries are present in "from_station_id" and "to_station_id" in Trips
-- that are not present in Stations table

-- Step 3: Using the same UNION keyword, we count the total number of different stations in the two columns of the Trips table
-- (i.e., from_station_id and to_station_id).

select count(distinct from_station_id) from 
	(select from_station_id from Trips
    union
    select to_station_id from Trips)
as Total;
-- Now, we count the total amoujnt of different stations from from_station_id and _to_station_id

-- Step 4: Finally, we write a query that displays the percentage of missing stations from the Stations table.
select
	(select count(*) from
		(select distinct from_station_id from Trips
		where from_station_id not in (select id from Stations)
		union 
		select distinct to_station_id from Trips 
		where to_station_id not in (select id from Stations))
	as Missing)
	/
	(select count(distinct from_station_id) from 
		(select from_station_id from Trips
		union
		select to_station_id from Trips)
	as Total)
	* 100.0
	as Percentage;
-- Now, we count the percentage of missing trips by dividing the number of
-- missing stations by the total amount of stations from Trips table, and then
-- multiply the result by 100 to get the percentage amount

-- This concludes the SQL part!