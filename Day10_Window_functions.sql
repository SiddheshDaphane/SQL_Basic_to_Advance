select * from employee;

-- In sub-query lesson, we calculated the employee with highest salary in each department. Which means that, we needed only 1 employee from each
-- department. Because we needed only 1 employee, we used "GROUP BY" clause with sub-query or CTE. Now my question is different.

-- I WANT TOP 2 EMPLOYEES FROM EACH DEPARTMENT WITH HIGHEST SALARY. 

-- Above question is a case of window functions. At first glance, we get in a false perception that we can solve this by using sub-query or CTE,
-- but we cannot do that because we need to use "GROUP BY" clause on "dept_id" and it will return only 1 output because of aggragted function. 
-- there is no way to get only top 2 employees from each department in a single output. This is the reason why we need to use window function.


-- Give me top 2 emplyees from each department based on their salary. 
 -- I need to create windows in the table based on department id's so that I can grab top 2 employees based on their salary from each department
 -- in the output and that's why I am using windows function.

-- Here I am assigning row numbers for each department based on their salary in desc order. 
SELECT *,
ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY salary desc) rn
FROM employee

-- What happens if I dont use "PARTITION BY" clause. (The whole table is "window" now and numbers are getting assigned by salary in desc order)
SELECT *,
ROW_NUMBER() OVER(ORDER BY salary desc) rn
FROM employee

-- What happens if I dont use "ORDER BY" clause. (It will give an error because database doesn't know on what it has to give rank to table)
SELECT *,
ROW_NUMBER() OVER(PARTITION BY dept_id) rn
FROM employee

------- SOLUTION FOR ABOVE QUESTION
WITH table_01 AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY salary desc) as rn
FROM employee ) 
SELECT * FROM table_01
WHERE rn <= 2



-------- Different window functions

-- See the difference between various window functions output
SELECT *,
ROW_NUMBER() OVER( ORDER BY salary) as rn,
RANK() OVER( ORDER BY salary) as rnk,
DENSE_RANK() OVER( ORDER BY salary) as d_rnk
FROM employee


SELECT *,
ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY salary) as rn,
RANK() OVER(PARTITION BY dept_id ORDER BY salary) as rnk,
DENSE_RANK() OVER(PARTITION BY dept_id ORDER BY salary) as d_rnk
FROM employee


--- print top 5 selling product from each category by sell

select DISTINCT product_id from orders;


with total AS (
SELECT category, product_id, sum(sales) as total_sales
FROM orders
GROUP BY category, product_id),
window_func AS (
SELECT *,
RANK() OVER(PARTITION BY category ORDER BY total_sales desc ) rn
FROM total)
SELECT * 
FROM window_func
WHERE rn <= 5 ; 

--- OR

with 
window_func AS (
SELECT category, product_id, SUM(sales) AS total_sales,
RANK() OVER(PARTITION BY category ORDER BY sum(sales) desc ) rn
FROM orders 
GROUP BY category, product_id
)
SELECT * 
FROM window_func
WHERE rn <= 5 ; 



--------- LEAD and LAG function

-- I am getting values of next row of "salary" by using LEAD() function. 
SELECT emp_id, emp_name, salary, 
LEAD(salary,1) OVER(ORDER BY salary desc) AS salary_of_next_row
FROM employee

SELECT emp_id, emp_name, salary, dept_id,
LEAD(salary,1) OVER(PARTITION BY dept_id ORDER BY salary desc) AS salary_of_next_row
FROM employee


-- LAG function (I am getting previous value of salary)

SELECT emp_id, emp_name, salary, 
LAG(salary,1) OVER(ORDER BY salary desc) AS salary_of_next_row
FROM employee

SELECT emp_id, emp_name, salary, 
LAG(salary,1) OVER(PARTITION BY dept_id ORDER BY salary desc) AS salary_of_next_row
FROM employee

-- BOTH at the same time. We can achieve same result just by chaging order by with ASC and DESC
SELECT emp_id, emp_name, salary, 
LAG(salary,1) OVER(PARTITION BY dept_id ORDER BY salary asc) AS salary_of_previous_row,
LEAD(salary,1) OVER(PARTITION BY dept_id ORDER BY salary desc) AS salary_of_next_row
FROM employee

SELECT emp_id, emp_name, salary, 
LAG(emp_age,1) OVER(PARTITION BY dept_id ORDER BY salary asc) AS age_of_previous_row,
LEAD(emp_age,1) OVER(PARTITION BY dept_id ORDER BY salary desc) AS age_of_next_row
FROM employee


--- FIRST VALUES

SELECT emp_id, emp_name,emp_age, salary, 
FIRST_VALUE(emp_age) OVER(PARTITION BY dept_id ORDER BY salary desc) AS first_age_value
FROM employee


--------- Assignment


-- 1- write a query to print 3rd highest salaried employee details for each department (give preferece to younger employee in case of a tie). 
-- In case a department has less than 3 employees then print the details of highest salaried employee in that department.

select * from employee;

-- My solution
with rnk AS (
select *,
DENSE_RANK() OVER(PARTITION BY dept_id ORDER BY salary desc) as rn
FROM employee),
cnt AS (
SELECT dept_id, count(1) as no_of_employees
FROM employee
GROUP BY dept_id)
SELECT *
FROM rnk 
INNER JOIN cnt 
ON rnk.dept_id = cnt.dept_id
WHERE rn = 3 OR (no_of_employees < 3 and rn=1)

-- or 

with rnk as (
select *, dense_rank() over(partition by dept_id order by salary desc) as rn
,count(1) over(partition by dept_id ) as no_of_emp
from employee)
select
*
from 
rnk 
where rn=3 or  (no_of_emp<3 and rn=1) 


--- Solution

with rnk as (
select *, dense_rank() over(partition by dept_id order by salary desc) as rn
from employee)
,cnt as (select dept_id,count(1) as no_of_emp from employee group by dept_id)
select
rnk.*
from 
rnk 
inner join cnt on rnk.dept_id=cnt.dept_id
where rn=3 or  (no_of_emp<3 and rn=1); 


-- 2) write a query to find top 3 and bottom 3 products by sales in each region.

select * from orders

with sales_by_region AS (
select region, product_id, SUM(sales) as total_sales_by_region
from orders
GROUP BY region, product_id)
, window_func AS ( 
SELECT *,
RANK() OVER(PARTITION BY region ORDER BY total_sales_by_region desc) as d_rnk,
RANK() OVER(PARTITION BY region ORDER BY total_sales_by_region ASC) as a_rnk
FROM sales_by_region)
SELECT region,product_id,total_sales_by_region,
CASE WHEN d_rnk <= 3 THEN 'Top 3' ELSE 'Bottom 3' END AS top_bottom
FROM window_func
WHERE d_rnk <=3 OR a_rnk <= 3;


with region_sales as (
select region,product_id,sum(sales) as sales
from orders
group by region,product_id
)
,rnk as (select *, rank() over(partition by region order by sales desc) as drn
, rank() over(partition by region order by sales asc) as arn
from region_sales
)
select region,product_id,sales,case when drn <=3 then 'Top 3' else 'Bottom 3' end as top_bottom
from rnk
where drn <=3 or arn<=3


-- 3- Among all the sub categories..which sub category had highest month over month growth by sales in Jan 2020.

select * from orders


-- My solution
WITH sub_cat_sales AS (
SELECT sub_category, TRIM(CONCAT(YEAR(order_date),MONTH(order_date))) as ym, SUM(sales) as sub_sales
FROM orders
GROUP BY sub_category, CONCAT(YEAR(order_date),MONTH(order_date)))
, win_fun AS (
SELECT *,
LAG(sub_sales,1) OVER(PARTITION BY sub_category ORDER BY ym) as prev_sales
FROM sub_cat_sales )
SELECT *,(sub_sales - prev_sales)/prev_sales AS mom_growth
FROM win_fun
WHERE ym = '20201'
order by mom_growth


-- solution
with sbc_sales as (
select sub_category,format(order_date,'yyyyMM') as year_month, sum(sales) as sales
from orders
group by sub_category,format(order_date,'yyyyMM')
)
, prev_month_sales as (select *,lag(sales) over(partition by sub_category order by year_month) as prev_sales
from sbc_sales)
select  top 1 * , (sales-prev_sales)/prev_sales as mom_growth
from prev_month_sales
where year_month='202001'
order by mom_growth desc



-- 4) 4- write a query to print top 3 products in each category by year over year sales growth in year 2020. (IMP problem)

-- Need to try it again

WITH cat_sales AS (
SELECT category, product_id, YEAR(order_date) AS o_year, SUM(sales) as sum_sales
FROM orders 
GROUP BY category, product_id, YEAR(order_date) )
, win_func AS (
SELECT *,
LAG(sum_sales,1) OVER(PARTITION BY category, product_id ORDER BY o_year desc) as prev_sales
FROM cat_sales )
, rnk_func AS (
SELECT *,
RANK() OVER(PARTITION BY  category ORDER BY (sum_sales - prev_sales)/prev_sales desc) as rnk
FROM win_func
WHERE o_year = '2020' )
SELECT *
FROM rnk_func
WHERE rnk <= 3




-- Solution
with cat_sales as (
select category,product_id,datepart(year,order_date) as order_year, sum(sales) as sales
from orders
group by category,product_id,datepart(year,order_date)
)
, prev_year_sales as (select *,lag(sales) over(partition by category,product_id order by order_year) as prev_year_sales
from cat_sales)
,rnk as (
select   * ,rank() over(partition by category order by (sales-prev_year_sales)/prev_year_sales desc) as rn
from prev_year_sales
where order_year='2020'
)
select * from rnk where rn<=3



-- 5) create below 2 tables 

create table call_start_logs
(
phone_number varchar(10),
start_time datetime
);
insert into call_start_logs values
('PN1','2022-01-01 10:20:00'),('PN1','2022-01-01 16:25:00'),('PN2','2022-01-01 12:30:00')
,('PN3','2022-01-02 10:00:00'),('PN3','2022-01-02 12:30:00'),('PN3','2022-01-03 09:20:00')

create table call_end_logs
(
phone_number varchar(10),
end_time datetime
);
insert into call_end_logs values
('PN1','2022-01-01 10:45:00'),('PN1','2022-01-01 17:05:00'),('PN2','2022-01-01 12:55:00')
,('PN3','2022-01-02 10:20:00'),('PN3','2022-01-02 12:50:00'),('PN3','2022-01-03 09:40:00')
;

-- write a query to get start time and end time of each call from above 2 tables.Also create a column of call duration in minutes.  Please do take into account that
-- there will be multiple calls from one phone number and each entry in start table has a corresponding entry in end table.

select * from call_start_logs;
select * from call_end_logs;

-- My solution
with start_calls AS (
SELECT *, cast(start_time as time) AS start_time_, cast(start_time as date) AS start_date_,
RANK() OVER(ORDER BY start_time) as s_rnk
FROM call_start_logs)
, end_calls AS (
SELECT *, cast(end_time as time) AS end_time_, cast(end_time as date) AS end_date_,
RANK() OVER(ORDER BY end_time) as e_rnk
FROM call_end_logs )
SELECT s.phone_number,s.start_time,e.end_time, DATEDIFF(MINUTE,start_time_, end_time_) AS call_duration
FROM start_calls s 
INNER JOIN end_calls e 
ON s.s_rnk = e.e_rnk
ORDER BY phone_number, start_time

-- Approach logic. 
/*
1) I need to separate time and date from both start_time and end_time because we need to create call_duration column.
2) Then I will use RANK() OVER(ORDER BY start_time) and RANK() OVER(ORDER BY end_time) to give ranks. I used order by time because I want to 
rank them 1st call to last call. 
3) based on ranks, I will INNER join both tables because we need to find out call_duration
4) I save results of both queries in CTE and then use DATEDIFF() to calculate difference in min
*/




select s.phone_number,s.rn,s.start_time,e.end_time, datediff(minute,start_time,end_time) as duration
from 
(select *,row_number() over(partition by phone_number order by start_time) as rn  from call_start_logs) s
inner join (select *,row_number() over(partition by phone_number order by end_time) as rn  from call_end_logs) e
on s.phone_number = e.phone_number and s.rn=e.rn;

