create database ola_rides_analysis;
use ola_rides_analysis;
-- creating table
create table bookings(
date date,
time time,
booking_id varchar(50),
booking_status varchar(50),
customer_id varchar(50),
vechicle_type varchar(50),
pickup_location varchar(100),
drop_location varchar(100),
v_tat varchar(50),
c_tat varchar(50),
canceled_rides_by_customer varchar(150),
canceled_rides_by_drivers varchar(150),
incomplete_rides varchar(50),
incomplete_rides_reason varchar(50),
booking_value int,
payment_method varchar(50),
ride_distance int,
driver_ratings varchar(50),
customer_rating varchar(50)
);
-- loading table in mysql workbench
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bookings.csv' into table bookings
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows
(date, time, booking_id, booking_status, customer_id, vechicle_type,
 pickup_location, drop_location, v_tat, c_tat, canceled_rides_by_customer,
 canceled_rides_by_drivers, incomplete_rides, incomplete_rides_reason,
 booking_value, payment_method, ride_distance, driver_ratings, customer_rating,
 @extra_column);
select count(*) from bookings;

truncate table bookings;

select * from bookings where booking_status="success"; 
select customer_id,count(*) from bookings group by customer_id having count(*)>1; -- duplicate customer id exists
 
select count(*), booking_id from bookings group by booking_id having count(*)>1; -- check duplicate id 
select distinct booking_status from bookings;
select distinct vechicle_type from bookings;
select count(distinct vechicle_type) from bookings; -- no. of different vechicle  
select distinct payment_method from bookings;
select booking_value  from bookings where booking_value<=0;
select count(c_tat) from bookings where c_tat=0;
select ride_distance  from bookings where ride_distance<0;
select min(date) as earliest_date,max(date) as latest_date from bookings; -- july month booking records 

-- booking_status percentage 
select booking_status,count(*) as total_rides ,
round(count(*)*100/(select count(*) from bookings),2) as percentage 
from bookings group by booking_status
order by total_rides ;

-- most ride bookings at which hour 
select hour(time) booking_hour,count(*) as total_booking from bookings
group by hour(time) order by total_booking desc; -- 12th hour 

-- most ride booking at which day
select dayname(date) as day_of_week, count(*) as total_bookings from bookings
group by dayname(date) order by total_bookings desc; -- tuesday
-- most used vechicle type 
select vechicle_type ,count(*) as MostUsedV from bookings group by vechicle_type order by mostusedV desc;
-- total revenue by each vechicle
select vechicle_type ,sum(booking_value) as RevenueByV,count(*) as MostUsedV from bookings group by vechicle_type order by RevenueByV desc;
-- percentage of revenue by each vechicle

select sum(booking_value) from bookings;
select sum(booking_value) from bookings where booking_status="success";

-- totalrevenue by each vechicle,percentage by all booking status revenue ,sucessful booking
select vechicle_type ,sum(booking_value),
round(sum(booking_value)*100/(select sum(booking_value) from bookings) ,2 ) as RevenueINPercentage
from bookings group by vechicle_type;

-- total revenue of vechicle by category and percentage of revenue by successful booking with bookingstatus success
select vechicle_type ,sum(booking_value),
round(sum(booking_value)*100/(select sum(booking_value) from bookings where booking_status="success"),2 )as RevenueINPercentage
from bookings where booking_status="success"group by vechicle_type;

-- percentage of rides cancelled by customer and driver
select booking_status, count(*) as total_cancelled,
round(count(*)* 100 / (select count(*) from bookings where booking_status like '%cancel%'), 2) as percentage
from bookings
where booking_status like '%cancel%'
group by booking_status;
-- top pickup location
select pickup_location,count(pickup_location) as totalpickupofLocation from bookings group by pickup_location order by totalpickupofLocation desc ;  
-- top 3 pickup location
select pickup_location,count(pickup_location) as totalpickupofLocation from bookings group by pickup_location order by totalpickupofLocation desc limit 3;
-- top 3 drop location
select drop_location,count(drop_location) as totalpickupofLocation from bookings group by pickup_location order by totalpickupofLocation desc limit 3 ;  
-- most used pament method
select payment_method, count(*) as total_transactions,
round(count(*)* 100 / (select count(*) from bookings where booking_status = 'success'), 2) as percentage
from bookings where booking_status = 'success'
group by payment_method order by total_transactions desc;
-- average ride distance
select avg(ride_distance) from bookings; -- 14 km 
-- min ,max and avg driver rating and customer rating
select min(driver_ratings), max(driver_ratings),round(avg(driver_ratings),2) from bookings;
select min(customer_rating), max(customer_rating),round(avg(customer_rating),2) from bookings;

-- top 3 customer with most rides
select customer_id ,count(*) as TopCustomer from bookings group by customer_id order by TopCustomer desc limit 3;

select count(*) as total_cancelled from bookings
where canceled_rides_by_drivers = 'Personal & Car related issue';
