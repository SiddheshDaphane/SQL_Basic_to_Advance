-- Q1) write a sql to get all the orders where customers name has "a" as second character and "d" as fourth character (58 rows)

-- My Solution
SELECT *
FROM orders
WHERE customer_name LIKE '_a_d%';

-- Solution

select * 
from orders 
where customer_name like '_a_d%';


-- Q2) write a sql to get all the orders placed in the month of dec 2020 (352 rows) 

-- My solution
SELECT *
FROM orders
WHERE order_date BETWEEN '2020-12-01' AND '2020-12-31'; 

-- Solution
select * 
from orders 
where  order_date between '2020-12-01' and '2020-12-31';


-- Q3) write a query to get all the orders where ship_mode is neither in 'Standard Class' nor in 'First Class' and ship_date is after nov 2020 (944 rows)

-- My Solution
SELECT *
FROM orders
WHERE ship_mode NOT IN ('Standard Class', 'First Class') AND ship_date > '2020-11-30'; 

-- Solution

select * 
from orders 
where  ship_mode not in ('Standard Class','First Class') and ship_date > '2020-11-30';


--Q4) write a query to get all the orders where customer name neither start with "A" and nor ends with "n" (9815 rows)

-- My solution
SELECT *
FROM orders
WHERE customer_name NOT LIKE 'A%n'; 

-- Solution

select * 
from orders 
where customer_name not like 'A%n';

-- Q5) write a query to get all the orders where profit is negative (1871 rows)

-- My solution
SELECT *
FROM orders 
WHERE profit < 0;

-- Solution
select * 
from orders 
where profit<0;

-- Q6) write a query to get all the orders where either quantity is less than 3 or profit is 0 (3348)

-- My solution
SELECT *
FROM orders
WHERE quantity < 3 OR profit = 0; 

-- Solution
select * 
from orders 
where profit=0 or quantity<3;

-- Q7) your manager handles the sales for South region and he wants you to create a report of all the orders in his region where some discount is provided to the customers (815 rows)

-- My solution
SELECT *
FROM orders
WHERE region = 'South' AND discount > 0;

-- Solution
select * 
from orders 
where region='South' and discount>0;


-- Q8) write a query to find top 5 orders with highest sales in furniture category 

-- My Solution
SELECT TOP 5 *
FROM orders
WHERE category = 'Furniture'
ORDER BY sales DESC; 

-- Solution
select top 5 * 
from orders 
where category='Furniture' order by sales desc; 

-- Q9) write a query to find all the records in technology and furniture category for the orders placed in the year 2020 only (1021 rows)

-- My Solution
SELECT *
FROM orders
WHERE category IN ('Technology', 'Furniture') AND order_date BETWEEN '2020-01-01' AND '2020-12-31';

-- Solution
select   * 
from orders 
where category in ('Furniture','Technology') 
and order_date between '2020-01-01' and '2020-12-31';

-- Q10) write a query to find all the orders where order date is in year 2020 but ship date is in 2021 (33 rows)

-- My Solution
SELECT *
FROM orders
WHERE (order_date BETWEEN '2020-01-01' AND '2020-12-31') AND ship_date BETWEEN '2021-01-01' AND '2021-12-31' 

-- Solution
select * 
from orders 
where order_date between '2020-01-01' and '2020-12-31' and ship_date between '2021-01-01' and '2021-12-31'