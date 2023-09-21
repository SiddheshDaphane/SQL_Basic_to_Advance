create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

SELECT * FROM icc_world_cup

-- Q1) write a query to produce below output from icc_world_cup table.
-- team_name, no_of_matches_played , no_of_wins , no_of_losses

-- My Solution (Cannot able to solve this question)

    (SELECT i1.Team_1 AS team_name,
    CASE WHEN i1.Team_1 = i2.Winner THEN 1 ELSE 0 END AS win 
    FROM icc_world_cup i1
    LEFT JOIN icc_world_cup i2 
    ON i1.Winner = i2.Team_1 
    GROUP BY i1.Team_1, i2.Winner) 
    UNION ALL 
    (SELECT i1.Team_2 AS team_name,
    CASE WHEN i1.Team_2 = i2.Winner THEN 1 ELSE 0 END AS win 
    FROM icc_world_cup i1
    LEFT JOIN icc_world_cup i2 
    ON i1.Winner = i2.Team_2
    GROUP BY i1.Team_2, i2.Winner) 

/* Need to look at this question again. Once I learned about sub-queries and CTEs then I will solve this question */

-- Solution
with all_teams as 
(select Team_1 as team, case when Team_1=Winner then 1 else 0 end as win_flag from icc_world_cup
union all
select Team_2 as team, case when Team_2=Winner then 1 else 0 end as win_flag from icc_world_cup)

select team,count(1) as total_matches_played , sum(win_flag) as matches_won,count(1)-sum(win_flag) as matches_lost
from all_teams



-- Q2) write a query to print first name and last name of a customer using orders table(everything after first space can be considered as last name)
-- customer_name, first_name,last_name

-- My Solution
SELECT
customer_name,
TRIM(SUBSTRING(customer_name,1,CHARINDEX(' ', customer_name))) AS first_name,
SUBSTRING(customer_name,CHARINDEX(' ', customer_name)+1,LEN(customer_name)-CHARINDEX(' ', customer_name)+1) AS last_name 
FROM orders 

-- Solution
select customer_name , trim(SUBSTRING(customer_name,1,CHARINDEX(' ',customer_name))) as first_name
, SUBSTRING(customer_name,CHARINDEX(' ',customer_name)+1,len(customer_name)-CHARINDEX(' ',customer_name)+1) as second_name
from orders



create table drivers(id varchar(10), start_time time, end_time time, start_loc varchar(10), end_loc varchar(10));
insert into drivers values('dri_1', '09:00', '09:30', 'a','b'),('dri_1', '09:30', '10:30', 'b','c'),('dri_1','11:00','11:30', 'd','e');
insert into drivers values('dri_1', '12:00', '12:30', 'f','g'),('dri_1', '13:30', '14:30', 'c','h');
insert into drivers values('dri_2', '12:15', '12:30', 'f','g'),('dri_2', '13:30', '14:30', 'c', 'h');

SELECT * FROM drivers


-- Q3) write a query to print below output using drivers table. Profit rides are the no of rides where end location of a ride is same as start location of immediate next ride for a driver
-- id, total_rides , profit_rides
-- dri_1,5,1
-- dri_2,2,0

-- My Solution
SELECT d1.id, COUNT(d1.id), COUNT(d2.id)
FROM drivers d1 
LEFT JOIN drivers d2 
ON d1.id = d2.id AND d1.end_loc = d2.start_loc
GROUP BY d1.id

/* I want to try to solve this question without using window fucntion because I have not learned any window functions till now
but I think it is not possible to solve this question. Regardless, I have given a solution which uses window fucntion. */

-- Solution
--lead function window
select id, count(1) as total_rides
,sum(case when end_loc=next_start_location then 1 else 0 end ) as profit_rides
from (
select *
, lead(start_loc,1) over(partition by id order by start_time asc) as next_start_location
from drivers) A
group by id;

--self join
with rides as (
select *,row_number() over(partition by id order by start_time asc) as rn
from drivers)
select r1.id , count(1) total_rides, count(r2.id) as profit_rides
from rides r1
left join rides r2
on r1.id=r2.id and r1.end_loc=r2.start_loc and r1.rn+1=r2.rn
group by r1.id