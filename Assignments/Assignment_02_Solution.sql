-- Q1) write a update statement to update city as null for order ids :  CA-2020-161389 , US-2021-156909

-- My solution
UPDATE orders
SET city = NULL
WHERE order_id IN ('CA-2020-161389', 'US-2021-156909')

-- Solution
update orders 
set city=null 
where order_id in ('CA-2020-161389','US-2021-156909')

-- Q2) write a query to find orders where city is null (2 rows)

-- My solution
SELECT *
FROM orders
WHERE city IS NULL 

-- Solution
select * 
from orders 
where city is null

-- Q3) write a query to get total profit, first order date and latest order date for each category

-- My Solution
SELECT category, SUM(profit) as total_profit, MAX(order_date) as latest_order_date, MIN(order_date) as first_order_date
FROM orders
GROUP BY category

-- Solution
select category , sum(profit) as total_profit, min(order_date) as first_order_date
,max(order_date) as latest_order_date
from orders
group by category 

-- Q4) write a query to find sub-categories where average profit is more than the half of the max profit in that sub-category

-- My solution
SELECT sub_category, AVG(profit) as avg_profit, MAX(profit) as max_profit
FROM orders
GROUP BY sub_category
HAVING AVG(profit) > (MAX(profit)*0.5)

-- Solution
select sub_category
from orders
group by sub_category
having avg(profit) > max(profit)/2

/* Q5) create the exams table with below script;
create table exams (student_id int, subject varchar(20), marks int);

insert into exams values (1,'Chemistry',91),(1,'Physics',91),(1,'Maths',92)
,(2,'Chemistry',80),(2,'Physics',90)
,(3,'Chemistry',80),(3,'Maths',80)
,(4,'Chemistry',71),(4,'Physics',54)
,(5,'Chemistry',79);

write a query to find students who have got same marks in Physics and Chemistry. */

create table exams (student_id int, subject varchar(20), marks int);

insert into exams values (1,'Chemistry',91),(1,'Physics',91),(1,'Maths',92)
,(2,'Chemistry',80),(2,'Physics',90)
,(3,'Chemistry',80),(3,'Maths',80)
,(4,'Chemistry',71),(4,'Physics',54)
,(5,'Chemistry',79);

-- My Solution
SELECT student_id, marks
FROM exams 
WHERE subject IN ('Physics', 'Chemistry')
GROUP BY student_id
HAVING COUNT(1) = 2

-- Solution
select student_id , marks
from exams
where subject in ('Physics','Chemistry')
group by student_id , marks
having count(1)=2

-- Q6) write a query to find total number of products in each category.

-- My solution
SELECT category, COUNT(DISTINCT product_id)
FROM orders
GROUP BY category

-- Solution
select category,count(distinct product_id) as no_of_products
from orders
group by category

-- Q7) write a query to find top 5 sub categories in west region by total quantity sold

-- My solution
SELECT TOP 5 sub_category, SUM(quantity) as total_quantity
FROM orders 
WHERE region = 'West' 
GROUP BY sub_category
ORDER BY total_quantity DESC

-- Solution
select top 5  sub_category, sum(quantity) as total_quantity
from orders
where region='West'
group by sub_category
order by total_quantity desc

--Q8) write a query to find total sales for each region and ship mode combination for orders in year 2020

-- My solution
SELECT region, ship_mode, SUM(quantity) 
FROM orders
WHERE order_id BETWEEN '2020-01-01' AND '2020-12-31'
GROUP BY region, ship_mode

-- Solution
select region,ship_mode ,sum(sales) as total_sales
from orders
where order_date between '2020-01-01' and '2020-12-31'
group by region,ship_mode
