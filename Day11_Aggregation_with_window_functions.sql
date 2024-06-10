-- We can use window function with aggregate functions.

SELECT * FROM employee;

-- SUM

SELECT emp_id, emp_name, salary, emp_age,
SUM(salary) OVER(PARTITION BY dept_id) as sum_salry,
SUM(salary) OVER(PARTITION BY dept_id ORDER BY emp_age) AS cumsum_salary,
SUM(salary) OVER(ORDER BY emp_age) AS cumsum_of_whole_table
FROM employee



-- MAX

SELECT emp_id, emp_name, salary, dept_id,
MAX(salary) OVER(PARTITION BY dept_id) as max_salry,
MAX(salary) OVER(PARTITION BY dept_id ORDER BY emp_age) AS cumsum_max_salary,
MAX(salary) OVER(ORDER BY emp_age) AS cumsum_max_of_whole_table
FROM employee


-- AVG

SELECT emp_id, emp_name, salary, dept_id,
AVG(salary) OVER(PARTITION BY dept_id) as avg_salry,
AVG(salary) OVER(PARTITION BY dept_id ORDER BY emp_age) AS cumsum_avg_salary,
AVG(salary) OVER(ORDER BY emp_age) AS cumsum_avg_of_whole_table
FROM employee

-- VIMP observation

-- When we do ORDER BY a column and it has dublicates in it, it aggreagtes them and then give the value. In the output of the following query,
-- we can see that, "sum_salary" is starting from 10000 because it is aggregating the value. To aviod this, we need to have another column 
-- which can identify each row uniquely. 

SELECT *,
SUM(salary) OVER(order by salary) as running_sum_salary
FROM employee

-- Solution to the above issue. 
SELECT *,
SUM(salary) OVER(ORDER BY salary, emp_id) as running_sum_salary 
FROM employee

-- PRECEDING and CURRENT ROW

SELECT *,
SUM(salary) OVER(ORDER BY emp_id ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) as rolling_salary_01 -- adding 1st preceding row and current row. check the o/p
FROM employee;


SELECT *,
SUM(salary) OVER(ORDER BY emp_id ROWS BETWEEN 1 PRECEDING AND 1 following) as rolling_salary_01 -- adding 1st preceding, 1st following row and current row. check the o/p
FROM employee;

SELECT *,
SUM(salary) OVER(ORDER BY emp_id ROWS BETWEEN 5 FOLLOWING AND 10 FOLLOWING) as rolling_salary_01 -- adding between 5th following and 10th following row. check the o/p
FROM employee;


SELECT *,
SUM(salary) OVER(PARTITION BY dept_id ORDER BY emp_id ROWS BETWEEN 1 PRECEDING AND 1 following) as rolling_salary_01 -- adding 1st preceding, 1st following row and current row. check the o/p
FROM employee;

SELECT *,
SUM(salary) OVER(PARTITION BY dept_id ORDER BY emp_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as rolling_sum_salary
FROM employee;

SELECT *,
SUM(salary) OVER(ORDER BY emp_id),
SUM(salary) OVER(PARTITION BY dept_id ORDER BY emp_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as rolling_sum_salary
FROM employee;


-- FIRST_VALUE and LAST_VALUE

SELECT *,
FIRST_VALUE(salary) OVER(ORDER BY salary) AS first_salary,
FIRST_VALUE(salary) OVER(ORDER BY salary desc) AS last_salary,
LAST_VALUE(salary) OVER(ORDER BY salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_salary_as_well,
LAST_VALUE(salary) OVER(ORDER BY salary ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOwiNG) AS last_salary_also
FROM employee



-- I want rolling 3 month sum of sales.


with month_wise_sales AS 
(
SELECT DATEPART(YEAR, order_date) AS year_order, DATEPART(MONTH, order_date) AS month_order, SUM(sales) AS total_sales
FROM orders
GROUP BY DATEPART(YEAR, order_date), DATEPART(MONTH, order_date)
)
SELECT *,
SUM(total_sales) OVER(ORDER BY year_order, month_order ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_3_sales
FROM month_wise_sales



-------------------------------------- Assignmnet

-- 1- write a sql to find top 3 products in each category by highest rolling 3 months total sales for Jan 2020.

WITH month_wise_sales AS (
SELECT category, product_id, DATEPART(YEAR, order_date) as o_year, DATEPART(MONTH, order_date) as o_month ,SUM(sales) as total_sales
FROM orders
WHERE DATEPART(YEAR, order_date) = 2019 OR DATEPART(YEAR, order_date) = 2020
GROUP BY category, product_id, DATEPART(YEAR, order_date), DATEPART(MONTH, order_date))
, win_func AS (
SELECT *,
SUM(total_sales) OVER(PARTITION BY category, product_id ORDER BY o_year, o_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as rolling_3_sales
FROM month_wise_sales)
, rnk_table AS (
SELECT *,
RANK() OVER(PARTITION BY category ORDER BY rolling_3_sales DESC) as rnk
FROM win_func
WHERE o_year = 2020 AND o_month = 1)
SELECT *
FROM rnk_table
WHERE rnk <= 3;



with xxx as (select category,product_id,datepart(year,order_date) as yo,datepart(month,order_date) as mo, sum(sales) as sales
from orders 
group by category,product_id,datepart(year,order_date),datepart(month,order_date))
,yyyy as (
select *,sum(sales) over(partition by category,product_id order by yo,mo rows between 2 preceding and current row ) as roll3_sales
from xxx)
select * from (
select *,rank() over(partition by category order by roll3_sales desc) as rn from yyyy 
where yo=2020 and mo=1) A
where rn<=3




-- 2- write a query to find products for which month over month sales has never declined.


-- need to solve this again. 



-- Solution
with xxx as (select product_id,datepart(year,order_date) as yo,datepart(month,order_date) as mo, sum(sales) as sales
from orders 
group by product_id,datepart(year,order_date),datepart(month,order_date))
,yyyy as (
select *,lag(sales,1,0) over(partition by product_id order by yo,mo) as prev_sales
from xxx)
select COUNT(distinct product_id) from yyyy where product_id not in
(select product_id from yyyy where sales<prev_sales group by product_id)



-- 3- write a query to find month wise sales for each category for months where sales is more than the combined sales of previous 2 months for that category.

with cat_sales AS (
SELECT category, DATEPART(YEAR, order_date) as yy, DATEPART(MONTH, order_date) AS mm, SUM(sales) as total_sales
FROM orders 
GROUP BY category,  DATEPART(YEAR, order_date), DATEPART(MONTH, order_date))
, mon_2_sales AS (
SELECT *,
SUM(total_sales) OVER(PARTITION BY category ORDER BY yy,mm ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING) AS month_2_sales
FROM cat_sales )
SELECT *
FROM mon_2_sales
WHERE total_sales > month_2_sales



with xxx as (select category,datepart(year,order_date) as yo,datepart(month,order_date) as mo, sum(sales) as sales
from orders 
group by category,datepart(year,order_date),datepart(month,order_date))
,yyyy as (
select *,sum(sales) over(partition by category order by yo,mo rows between 2 preceding and 1 preceding ) as prev2_sales
from xxx)
select * from yyyy where  sales>prev2_sales

