-- Day 1

-- DDL - Data Defination language
CREATE TABLE amazon_orders
(
order_id INT,
order_date DATE, -- (yyyy-mm-dd) standard format
product_name VARCHAR(50),
total_price DECIMAL(5,2), -- e.g. 888.98 (total 5 including decimals)
payment_method VARCHAR(20)
);

-- DROP TABLE amazon_orders;


-- DML - Data manipulation language
INSERT INTO amazon_orders VALUES(1,'2022-10-01','baby milk',30.5,'UPI');
INSERT INTO amazon_orders VALUES(2,'2022-10-02','baby powder',130.5,'Credit card');

DELETE FROM amazon_orders;
-- DQL - Data query language
SELECT * 
FROM amazon_orders;

SELECT TOP 2 * 
FROM amazon_orders;

SELECT * 
FROM amazon_orders
ORDER BY order_date;

SELECT * 
FROM amazon_orders
ORDER BY order_date DESC;

SELECT * 
FROM amazon_orders
ORDER BY order_date DESC, product_name;




-- Day 2


ALTER TABLE amazon_orders ALTER COLUMN order_date DATETIME; -- changed data type

ALTER TABLE amazon_orders add user_name varchar(20); -- added a column 


CREATE TABLE amazon_orders
(
order_id INT NOT NULL UNIQUE,
order_date DATE, -- (yyyy-mm-dd) standard format
product_name VARCHAR(50),
total_price DECIMAL(5,2), -- e.g. 888.98 (total 5 including decimals)
payment_method VARCHAR(20) CHECK (payment_method in ('UPI','CREDIT CARD')),
discount INT CHECK (discount < 20),
category VARCHAR(20) DEFAULT 'Mens wear'
);

INSERT INTO amazon_orders(order_id,order_date,product_name,total_price,payment_method,discount)
VALUES('2022-10-01',6,'shirt',132.5,'UPI'); 

DELETE FROM amazon_orders WHERE order_id = 4; 


UPDATE amazon_orders
SET total_price = 10
WHERE order_id = 2;   -- amazon_order ----> WHERE ------> SET ----------> UPDATE

UPDATE amazon_orders
SET total_price = 10, payment_method = 'UPI'
WHERE order_id = 2; 



----- Day 3


SELECT * FROM orders;


SELECT * 
FROM orders
ORDER BY order_date DESC;

SELECT TOP 5 * 
FROM orders
ORDER BY order_date DESC; -- So first it is getting sorted on order_date in desc and then selecting top 5

SELECT DISTINCT ship_mode
FROM orders;

SELECT DISTINCT ship_mode, segment
FROM orders;  -- Distinct combination of both columns

SELECT DISTINCT *
FROM orders; 

SELECT * 
FROM orders
WHERE ship_mode = 'First Class';

SELECT * 
FROM orders
WHERE order_date = '2020-12-08';

SELECT * 
FROM orders
WHERE quantity > 5;

SELECT TOP 5 order_date, quantity
FROM orders
WHERE quantity > 5
ORDER BY quantity DESC;    -- FROM ----> WHERE -----> ORDER BY -----> SELECT ------> TOP 5

SELECT order_date, quantity
FROM orders
WHERE quantity != 5
ORDER BY quantity;

SELECT order_date, quantity
FROM orders
WHERE quantity BETWEEN 2 AND 4
ORDER BY quantity; --- 2 and 4, both are included. 


SELECT * 
FROM orders
WHERE ship_mode IN ('First Class', 'Same Day');

SELECT order_date, quantity
FROM orders
WHERE quantity IN (2, 4, 6)
ORDER BY quantity DESC;


SELECT * 
FROM orders
WHERE ship_mode NOT IN ('First Class', 'Same Day');

SELECT * 
FROM orders
WHERE ship_mode >'First Class';

SELECT order_date, quantity, segment
FROM orders
WHERE ship_mode = 'First Class' AND segment = 'Consumer';

SELECT order_date, quantity, segment
FROM orders
WHERE ship_mode = 'First Class' OR segment = 'Consumer';

SELECT * 
FROM orders
WHERE quantity > 5 AND order_date < '2020-11-08';

SELECT CAST(order_date as date) AS order_date_new, *
FROM orders;

SELECT *, profit/sales AS ratio, profit+sales AS revenue, GETDATE()
FROM orders;

SELECT order_id, order_date, customer_name
FROM orders
WHERE customer_name LIKE 'C%'; -- First letter should be 'C' and after that you can have anything

SELECT order_id, order_date, customer_name
FROM orders
WHERE customer_name LIKE 'c%'; -- No output because it is a case sensitive. 

SELECT order_id, order_date, customer_name
FROM orders
WHERE customer_name LIKE 'Chris%';

SELECT order_id, order_date, customer_name
FROM orders
WHERE customer_name LIKE '%Schild'; -- ending with Schild

SELECT order_id, order_date, customer_name
FROM orders
WHERE customer_name LIKE '% Schild'; 

SELECT order_id, order_date, customer_name
FROM orders
WHERE customer_name LIKE '% schild';  -- again, case sensitive

SELECT order_id, order_date, customer_name, UPPER(customer_name) AS nname_upper
FROM orders
WHERE UPPER(customer_name) LIKE 'A%A'; 

SELECT order_id, order_date, customer_name
FROM orders
WHERE customer_name LIKE '%ven%';  -- start with anything and end with anything but there should be 'ven' in between

SELECT order_id, order_date, customer_name
FROM orders
WHERE customer_name LIKE 'A%a';

SELECT order_id, order_date, customer_name
FROM orders
WHERE customer_name LIKE '%ven%';

SELECT order_id, order_date, customer_name, UPPER(customer_name) AS nname_upper
FROM orders
WHERE UPPER(customer_name) LIKE '_L%'; 

SELECT order_id, order_date, customer_name
FROM orders
WHERE customer_name LIKE 'C[al]%';

SELECT order_id, order_date, customer_name
FROM orders
WHERE customer_name LIKE 'C[alo]%'; -- second charecter can be a,l,o

SELECT order_id, order_date, customer_name
FROM orders
WHERE customer_name LIKE 'C[^alo]%'; -- Cannot have 'alo' as a second charecter

SELECT order_id, order_date, customer_name
FROM orders
WHERE customer_name LIKE 'C[a-o]%'; -- second charecter can be from a to f 

SELECT order_id, order_date, customer_name
FROM orders
WHERE order_id LIKE 'CA-20[1-2][0-1]%';



----- Day 4



select * from orders;

SELECT *
FROM orders
WHERE city IS NULL;

SELECT *
FROM orders
WHERE city IS NOT NULL;

 
SELECT COUNT(*) as cnt
FROM orders;

SELECT SUM(sales) as total_sales
FROM orders;

SELECT MAX(sales) as MAX_sales
FROM orders;

SELECT AVG(sales) as avg_sales
FROM orders;


SELECT region, COUNT(*) as cnt,SUM(sales) as total_sales,MAX(sales) as MAX_sales,AVG(sales) as avg_sales
FROM orders
GROUP BY region;


SELECT region
FROM orders
GROUP BY region; -- This is similar to DISTINCT value of the region.

SELECT category, region, COUNT(*) as cnt,SUM(sales) as total_sales,MAX(sales) as MAX_sales,AVG(sales) as avg_sales
FROM orders
GROUP BY region, category
ORDER BY region;


SELECT category, region, COUNT(*) as cnt,SUM(sales) as total_sales,MAX(sales) as MAX_sales,AVG(sales) as avg_sales
FROM orders
WHERE profit > 50
GROUP BY region, category
ORDER BY region;


SELECT region, SUM(sales) as total_sales
FROM orders
WHERE profit > 50
GROUP BY region
ORDER BY total_sales DESC;


SELECT TOP 2 region, SUM(sales) as total_sales
FROM orders
WHERE profit > 50
GROUP BY region
ORDER BY total_sales DESC;



SELECT sub_category, SUM(sales) as total_sales
FROM orders
WHERE profit > 50
GROUP BY sub_category
HAVING sum(sales) > 100000
ORDER BY total_sales desc;



SELECT COUNT(DISTINCT region)
FROM orders;

SELECT COUNT(1)
FROM orders;

SELECT COUNT(city)
FROM orders;      -- Doesn't count NULL values. All the aggregate functions



--------- Day 5 - Database JOINS



select * from [returns];





select * 
from orders o
INNER JOIN [returns] r 
ON o.order_id = r.order_id;

select DISTINCT o.order_id
from orders o
INNER JOIN [returns] r 
ON o.order_id = r.order_id;

select o.* 
from orders o
INNER JOIN [returns] r 
ON o.order_id = r.order_id;

select r.* 
from orders o
INNER JOIN [returns] r 
ON o.order_id = r.order_id;

select o.order_id, o.order_date, r.return_reason, r.order_id as return_order_id
from orders o
LEFT JOIN [returns] r 
ON o.order_id = r.order_id;

select r.return_reason, SUM(sales) as total_sales
from orders o
LEFT JOIN [returns] r 
ON o.order_id = r.order_id
GROUP BY return_reason;

select * from employee;
SELECT * from dept;

select * 
FROM employee, dept;

select * 
FROM employee
INNER JOIN dept 
ON 1=1
ORDER BY employee.emp_id;

select * 
FROM employee e 
INNER JOIN dept d
ON e.dept_id = d.dep_id
ORDER BY e.emp_id;

select e.emp_id, e.emp_name, d.dep_id, d.dep_name
FROM employee e 
INNER JOIN dept d
ON e.dept_id = d.dep_id
ORDER BY e.emp_id;


select e.emp_id, e.emp_name, d.dep_id, d.dep_name
FROM employee e 
LEFT JOIN dept d
ON e.dept_id = d.dep_id
ORDER BY e.emp_id;


select e.emp_id, e.emp_name, d.dep_id, d.dep_name
FROM employee e 
RIGHT JOIN dept d
ON e.dept_id = d.dep_id
ORDER BY e.emp_id;

select e.emp_id, e.emp_name, d.dep_id, d.dep_name
FROM dept d
RIGHT JOIN  employee e 
ON e.dept_id = d.dep_id
ORDER BY e.emp_id;

select e.emp_id, e.emp_name, d.dep_id, d.dep_name
FROM dept d
FULL OUTER JOIN  employee e 
ON e.dept_id = d.dep_id
ORDER BY e.emp_id;

select * from people;

select e.emp_id, e.emp_name, d.dep_id, d.dep_name
FROM dept d
INNER JOIN employee e 
ON e.dept_id = d.dep_id
ORDER BY e.emp_id;

select o.order_id, o.product_id, r.return_reason, p.manager
from orders o
INNER JOIN [returns] r 
ON o.order_id = r.order_id
INNER JOIN people p 
ON p.region = o.region;


------ Assignments 

-- Q1) write a sql to get all the orders where customers name has "a" as second character and "d" as fourth character (58 rows)

SELECT * 
FROM orders
WHERE customer_name LIKE '_a_d%';

-- Q2) write a sql to get all the orders placed in the month of dec 2020 (352 rows)

SELECT *
FROM orders
WHERE order_date > '2020-11-30' AND order_date < '2021-01-01';

-- Q3) write a query to get all the orders where ship_mode is neither in 'Standard Class' nor in 'First Class' and ship_date is after nov 2020 (944 rows)

SELECT *
FROM orders
WHERE ship_mode NOT IN ('Standard Class','First Class') AND ship_date > '2020-11-30';

-- Q4) write a query to get all the orders where customer name neither start with "A" and nor ends with "n" (9815 rows)

SELECT *
FROM orders
WHERE customer_name NOT LIKE 'A%n';

-- Q5) write a query to get all the orders where profit is negative (1871 rows)

SELECT *
FROM orders
WHERE profit < 0;

-- Q6) write a query to get all the orders where either quantity is less than 3 or profit is 0 (3348)

SELECT * 
FROM orders 
WHERE quantity < 3 OR profit = 0;

-- Q7) your manager handles the sales for South region and he wants you to create a report of all the orders in his region where some discount is provided to the customers (815 rows)

SELECT *
FROM orders
WHERE region = 'South' AND discount > 0;

-- Q8) write a query to find top 5 orders with highest sales in furniture category

SELECT TOP 5 *
FROM orders
WHERE category = 'Furniture'
ORDER BY sales DESC;

-- Q9) write a query to find all the records in technology and furniture category for the orders placed in the year 2020 only (1021 rows)

SELECT *
FROM orders
WHERE category IN ('Technology', 'Furniture') AND (order_date >= '2020-01-01' AND order_date <= '2020-12-31');

-- Q10) write a query to find all the orders where order date is in year 2020 but ship date is in 2021 (33 rows)

SELECT *
FROM orders
WHERE (order_date >= '2020-01-01' AND order_date <= '2020-12-31') AND ship_date > '2020-12-31';

-- Q11) write a update statement to update city as null for order ids :  CA-2020-161389 , US-2021-156909

UPDATE orders
SET city = NULL
WHERE order_id IN ('CA-2020-161389','US-2021-156909');

-- Q12) write a query to find orders where city is null (2 rows)

SELECT *
FROM orders
WHERE city is NULL;

-- Q13) write a query to get total profit, first order date and latest order date for each category

SELECT category, SUM(profit) AS total_profit, MAX(order_date) AS latest_order_date, MIN(order_date) AS first_order_date
FROM orders
GROUP BY category;

-- Q14) write a query to find sub-categories where average profit is more than the half of the max profit in that sub-category

SELECT sub_category, AVG(profit) AS avg_prfit, MAX(profit)/2 AS half_of_max_profit
FROM orders 
GROUP BY sub_category
HAVING AVG(profit) > MAX(profit)/2;

-- Q15) create the exams table with below script;
create table examszz (student_id int, subject varchar(20), marks int);

insert into examszz values (1,'Chemistry',91),(1,'Physics',91),(1,'Maths',92)
,(2,'Chemistry',80),(2,'Physics',90)
,(3,'Chemistry',80),(3,'Maths',80)
,(4,'Chemistry',71),(4,'Physics',54)
,(5,'Chemistry',79);

-- write a query to find students who have got same marks in Physics and Chemistry.

select * from examszz;

SELECT student_id, marks
FROM examszz
WHERE subject IN ('Physics', 'Chemistry')
GROUP BY student_id, marks
HAVING COUNT(1) = 2;

select student_id , marks
from examszz
where subject in ('Physics','Chemistry')
group by student_id , marks
having count(1)=2


-- Q16) write a query to find total number of products in each category.

select * from orders;

SELECT category, COUNT(DISTINCT product_id)
FROM orders
GROUP BY category

-- Q17) write a query to find top 5 sub categories in west region by total quantity sold

SELECT TOP 5 sub_category,SUM(quantity) as total_qunt
FROM orders 
WHERE region = 'West'
GROUP BY sub_category
ORDER BY total_qunt DESC;

-- Q18) write a query to find total sales for each region and ship mode combination for orders in year 2020

SELECT region, ship_mode, SUM(sales) as total_sales_01
FROM orders
WHERE order_date >= '2020-01-01' AND order_date < '2021-01-01'
GROUP BY region, ship_mode;

-- Q19) write a query to get region wise count of return orders

select * from [returns];

SELECT region, COUNT(r.order_id)
FROM orders o 
INNER JOIN returns r
ON o.order_id = r.order_id
GROUP BY region;

-- Q20) write a query to get category wise sales of orders that were not returned

SELECT category, SUM(o.sales)
FROM orders o 
LEFT JOIN returns r
ON o.order_id = r.order_id
WHERE r.order_id IS NOT NULL
GROUP BY category;

-- Q21) write a query to print dep name and average salary of employees in that dep .

select * from employee;
select * from dept;

SELECT d.dep_name, AVG(salary)
FROM employee e 
INNER JOIN dept d 
ON e.dept_id = d.dep_id
GROUP BY dep_name; 

-- Q22) write a query to print dep names where none of the emplyees have same salary.

SELECT dep_name
FROM employee e 
INNER JOIN dept d 
ON e.dept_id = d.dep_id
GROUP BY dep_name
HAVING COUNT(1) = 1;

-- Solution
select d.dep_name
from employee e
inner join dept d on e.dept_id=d.dep_id
group by d.dep_name
having count(e.emp_id)=count(distinct e.salary)

-- Q23) write a query to print sub categories where we have all 3 kinds of returns (others,bad quality,wrong items)

SELECT sub_category
FROM orders o 
INNER JOIN [returns] r 
ON o.order_id = r.order_id
GROUP BY sub_category
HAVING COUNT(DISTINCT r.return_reason) = 3;

-- Q24) write a query to find cities where not even a single order was returned.

SELECT city
FROM orders o 
LEFT JOIN [returns] r 
ON o.order_id = r.order_id
GROUP BY city 
HAVING COUNT(r.order_id) = 0

-- Q25) write a query to find top 3 subcategories by sales of returned orders in east region

SELECT TOP 3 sub_category, SUM(sales)
FROM orders o  
INNER JOIN [returns] r 
ON o.order_id = r.order_id 
WHERE region = 'East'
GROUP BY sub_category;

-- Q26) write a query to print dep name for which there is no employee

SELECT dep_name
FROM dept d 
LEFT JOIN employee e 
ON d.dep_id = e.dept_id
WHERE e.emp_id IS NULL;

-- Q27) write a query to print employees name for dep id is not avaiable in dept table

SELECT emp_name
FROM employee e 
LEFT JOIN dept d 
ON e.dept_id = d.dep_id
WHERE dep_id IS NULL;


------------------- Day 6 


select * from employee;
select * from dept;

-- Self-join

SELECT e1.emp_name, e1.emp_id, e2.emp_name as manager_name,e2.manager_id
FROM employee e1 
INNER JOIN employee e2
ON e1.manager_id = e2.emp_id;

SELECT e1.emp_name, e1.emp_id, e2.emp_name as manager_name,e2.manager_id
FROM employee e1 
INNER JOIN employee e2
ON e1.manager_id = e2.emp_id
WHERE e1.salary > e2.salary;


------ String functions

select * from employee;


SELECT dept_id, STRING_AGG(emp_name,',') WITHIN GROUP (ORDER BY salary DESC) as list_of_employee
FROM employee 
GROUP BY dept_id;


---- date functions 


select order_id, order_date, DATEPART(YEAR,order_date) as year_of_order_date,
DATEPART(MONTH,order_date) as month_of_order_date,
DATEPART(week,order_date) as week_of_order_date,
DATENAME(month, order_date) as month_name,
DATENAME(WEEKDAY, order_date) as month_name
from orders
WHERE DATEPART(YEAR,order_date) = 2020;



select order_id, order_date, 
DATEADD(day,5,order_date) as days_added,
DATEADD(week,5,order_date) as week_added,
DATEADD(day,-5,order_date) as days_subtracted
/*DATEPART(YEAR,order_date) as year_of_order_date,
DATEPART(MONTH,order_date) as month_of_order_date,
DATEPART(week,order_date) as week_of_order_date,
DATENAME(month, order_date) as month_name,
DATENAME(WEEKDAY, order_date) as month_name*/
from orders
WHERE DATEPART(YEAR,order_date) = 2020;



select order_id, order_date, ship_date,
DATEDIFF(day, order_date, ship_date) as date_diff_in_days,
DATEDIFF(WEEK, order_date, ship_date) as date_diff_in_weeks
/*DATEADD(day,5,order_date) as days_added,
DATEADD(week,5,order_date) as week_added,
DATEADD(day,-5,order_date) as days_subtracted
DATEPART(YEAR,order_date) as year_of_order_date,
DATEPART(MONTH,order_date) as month_of_order_date,
DATEPART(week,order_date) as week_of_order_date,
DATENAME(month, order_date) as month_name,
DATENAME(WEEKDAY, order_date) as month_name*/
from orders
WHERE DATEPART(YEAR,order_date) = 2020;



select order_id, profit,
CASE 
WHEN profit < 100 THEN 'LOW Profit'
WHEN profit < 250 THEN 'Medium Profit'
WHEN profit < 400 THEN 'High Profit'
ELSE 'Very high profit'
END as profit_category
from orders 

-- Execution order is from top to bottom for case when statement
select order_id, profit,
CASE 
WHEN profit < 250 THEN 'Medium Profit' -- Top to bottom execution and that's why there will not be 'low profit'
WHEN profit < 100 THEN 'LOW Profit'
WHEN profit < 400 THEN 'High Profit'
ELSE 'Very high profit'
END as profit_category
from orders 



--------------------------- Day 7 


----- String functions 

select order_id, customer_name,
LEN(customer_name) as length_of_a_name,
LEFT(customer_name,4) as name_4,
RIGHT(customer_name,5) as name_5,
SUBSTRING(customer_name,4,3) as substr_45,
SUBSTRING(order_id,4,4) as substr_45,
CHARINDEX(' ', customer_name) as space_position, 
CHARINDEX('c', customer_name) as c_position,
CHARINDEX('n', customer_name) as n_position,
CHARINDEX('n', customer_name,5) as n_position_after_5th,
CHARINDEX('n', customer_name,11) as n_position_after_10th,
CHARINDEX('n', customer_name,CHARINDEX('n', customer_name,1)+1) as n_position_after_nth,
CONCAT(order_id,' ',customer_name) as concated,
order_id + ',' + customer_name,
LEFT(customer_name,CHARINDEX(' ',customer_name)) as first_name,
SUBSTRING(customer_name,1,CHARINDEX(' ', customer_name)) as first_name_different_approach,
REPLACE(order_id, 'CA','PB') as CA_is_replaced_with_PB_Case_Sensitive,
REPLACE(customer_name, 'A','B') as A_is_replaced_with_B_Case_sensitive,
TRANSLATE(customer_name,'AG','TP') as translate_A_to_T_and_G_to_P,
REVERSE(customer_name) as reversed_name,
TRIM(' Siddhesh     ') as trimed_name
from orders;




----- NULL handling function


select order_id, city,
ISNULL(city, 'unknown') as null_is_replaced_by_unknown,
COALESCE(city, 'unknown') as unknown_replaced_null,
COALESCE(city,state,region, 'unknown') as if_city_is_null_give_value_of_state_if_state_is_null_give_value_of_region_if_all_are_null_give_unknown
from orders
order by city



---- CAST 

SELECT top 5 order_id,sales, 
CAST(sales as int) as sales_int,
ROUND(sales,1) as rounded
from orders 




---- set functions 


select * from order_east
UNION ALL
SELECT * from order_west;


select * from order_east
UNION
SELECT * from order_west;

select * from order_east
INTERSECT
SELECT * from order_west;

select order_id from order_east
INTERSECT
SELECT order_id from order_west;

select order_id from order_east
EXCEPT
SELECT order_id from order_west;




------- SQL Interview questions 








