select * from orders;


-- Let's find the avg of the orders from order's table. (Remember there are multiple rows of same order_id)

select * from orders where order_id = 'CA-2020-152156'

-- 1) Following query is not correct because there are multiple rows of a same order_id. I need to sum sales by order_id and then take avg of that result
select avg(sales) as false_avg_sales
from orders

-- 2)
SELECT AVG(order_sales) as correct_avg_sales
FROM
(select order_id, sum(sales) as order_sales
from orders
GROUP BY order_id) as aggragted_sales 


-- Find the order_id's where sales greater than avg_sales


-- Method 1

SELECT order_id, SUM(sales) as sum_sales, (SELECT AVG(sum_sales) as avg_sales
FROM
(SELECT order_id, SUM(sales) as sum_sales
FROM orders
GROUP BY order_id) aggreagted_sales) as avg_sales
FROM orders
GROUP BY order_id
HAVING sum(sales) > 
(SELECT AVG(sum_sales) as avg_sales
FROM
(SELECT order_id, SUM(sales) as sum_sales
FROM orders
GROUP BY order_id) aggreagted_sales)


-- Method 2 (using JOINS)

SELECT order_id
FROM
(SELECT order_id, SUM(sales) as sum_sales, (SELECT AVG(sum_sales) as avg_sales
FROM
(SELECT order_id, SUM(sales) as sum_sales
FROM orders
GROUP BY order_id) aggreagted_sales) as avg_sales
FROM orders
GROUP BY order_id) A
INNER JOIN
(SELECT AVG(sum_sales) as avg_sales
FROM
(SELECT order_id, SUM(sales) as sum_sales
FROM orders
GROUP BY order_id) aggreagted_sales) B
ON 1=1
WHERE A.sum_sales > B.avg_sales

-- Find a employee who's department id is not present in the department table.

-- Method 1.

SELECT *
FROM employee
WHERE dept_id = 
(select dept_id from employee
EXCEPT
select dep_id from dept);

-- METHOD 2

SELECT *
FROM employee
WHERE dept_id NOT IN (select dep_id from dept);





SELECT * from employee;

-- I want avg dep salary infornt of every employee of that department

SELECT *
FROM employee as A
INNER JOIN
(select dept_id, AVG(salary) as avg_dep_salary
FROM employee
GROUP BY dept_id) as B
ON A.dept_id = B.dept_id



select * from icc_world_cup

SELECT team_name, COUNT(1) AS number_of_matches_played, SUM(win_flag) as matches_win, COUNT(1)-SUM(win_flag) AS lost_matches
FROM
(SELECT Team_1 AS team_name, Winner,
CASE WHEN Team_1 = Winner THEN 1 ELSE 0 END AS win_flag
FROM icc_world_cup
UNION ALL
SELECT Team_2 AS team_name, Winner,
CASE WHEN Team_2 = Winner THEN 1 ELSE 0 END AS win_flag
FROM icc_world_cup) A 
GROUP BY team_name