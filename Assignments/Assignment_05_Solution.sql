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

-- My Solution (Not able to solve this question). This question needs an sub-query or CTE. But let's decode the logic of UNION and UNION ALL meaning when to use it (line 36). 

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

/* Need to look at this question again. Once I learned about sub-queries and CTEs then I will solve this question

Explanation:-  If you look at the output ot table then we have 3 columns, that is, Team_1, Team_2, Winner. Now we want the following output (taking e.g. of India from tabel)

                team_name           no_of_matches_palyed         no_of_wins          no_of_losses
                India                       2                         2                    0            

Now, if we look at the table, we can see that India is present in Team_1 and Team_2 columns. Another observation is that, some teams are in Team_1 column and some teams are in Team_2
which basically means that we have to take teams from both the columns. Now there are two options to do that 

1) Using SELF-JOIN. So basically we use join condition on a table and join it on it-self but on Team_1 and Winner. When we run this condition, we can say that, from table 1, we can
have winner team from column 1 i.e. Team_1 and from table 2nd we can have winner from column 2 i.e. Team_2. 
After this we can use UNION ALL to get all the teams but then the question comes how to use GROUP BY clause on both these query and for that we need CTE or WINDOW function. 

2) Using UNION ALL. As you can see the solution, we can use CASE WHEN function and UNION ALL to get the output but we have to use CTE to GROUP BY teams. There is other way around.

Here we can learn when we can use UNION, UNION ALL. This is a very good example. 
 */






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

-- Q4) write a query to print customer name and no of occurence of character 'n' in the customer name.
-- customer_name , count_of_occurence_of_n

-- My Solution
SELECT customer_name,
LEN(customer_name) - LEN(REPLACE(LOWER(customer_name),'n','')) AS count_of_occurance_of_n
FROM orders
GROUP BY customer_name

/* This logic is very different from Python. In Python, we can break the characters of a name, and then we can find 'n'
in that name, which means Python can traverse charecter by charecter, but in SQL, this is not the case. SQL cannot traverse 
charecter by charecter, and hence we have to depend on the LEN function.  */

-- Solution
select customer_name , len(customer_name)-len(replace(lower(customer_name),'n','')) as count_of_occurence_of_n
from orders


/* 5-write a query to print below output from orders data. example output
hierarchy type,hierarchy name ,total_sales_in_west_region,total_sales_in_east_region
category , Technology, ,
category, Furniture, ,
category, Office Supplies, ,
sub_category, Art , ,
sub_category, Furnishings, ,
and so on all the category ,subcategory and ship_mode hierarchies */

select * from orders

/* So basially, we want to group by column name 'Category' and values in category and also group by
'Sub-category' and values in it. 
Question is how can I make a column name get attached to every row of it's value?
I */

-- My Solution
SELECT 
'category' AS hierarchy_type, category as hierarchy_name,
SUM(CASE WHEN region='West' THEN sales END) as total_sales_in_west_region,
SUM(CASE WHEN region='East' THEN sales END) as total_sales_in_east_region
FROM orders 
GROUP BY category 
UNION ALL 
SELECT 
'sub_category', sub_category,
SUM(CASE WHEN region='West' THEN sales END) as total_sales_in_west_region,
SUM(CASE WHEN region='East' THEN sales END) as total_sales_in_east_region
FROM orders 
GROUP BY sub_category
UNION ALL 
SELECT 
'ship_mode', ship_mode,
SUM(CASE WHEN region='West' THEN sales END) as total_sales_in_west_region,
SUM(CASE WHEN region='East' THEN sales END) as total_sales_in_east_region
FROM orders 
GROUP BY ship_mode

-- Solution
select 
'category' as hierarchy_type,category as hierarchy_name
,sum(case when region='West' then sales end) as total_sales_in_west_region
,sum(case when region='East' then sales end) as total_sales_in_east_region
from orders
group by category
union all
select 
'sub_category',sub_category
,sum(case when region='West' then sales end) as total_sales_in_west_region
,sum(case when region='East' then sales end) as total_sales_in_east_region
from orders
group by sub_category
union all
select 
'ship_mode ',ship_mode 
,sum(case when region='West' then sales end) as total_sales_in_west_region
,sum(case when region='East' then sales end) as total_sales_in_east_region
from orders
group by ship_mode 

-- Q6) the first 2 characters of order_id represents the country of order placed . 
-- write a query to print total no of orders placed in each country
-- (an order can have 2 rows in the data when more than 1 item was purchased in the order but it should be considered as 1 order)

select * from orders

-- My Solution
SELECT TRIM(SUBSTRING(order_id, 1, 2)) AS country_of_order, COUNT(DISTINCT order_id)
FROM orders 
GROUP BY TRIM(SUBSTRING(order_id, 1, 2))

-- Solution
select left(order_id,2) as country, count(distinct order_id) as total_orders
from orders 
group by left(order_id,2)