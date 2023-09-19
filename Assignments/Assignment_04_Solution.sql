alter table  employee add dob date;
update employee set dob = dateadd(year,-1*emp_age,getdate())

-- 1- write a query to print emp name , their manager name and diffrence in their age (in days) 

-- My solution
SELECT e1. emp_name, e2.emp_name as manager, DATEDIFF(day, e1.dob,e2.dob)
FROM employee e1 
INNER JOIN employee e2
ON e1.manager_id = e2.emp_id;

-- Solution
select e1.emp_name,e2.emp_name as manager_name , DATEDIFF(day,e1.dob,e2.dob) as diff_in_age
from employee e1
inner join employee e2 on e1.manager_id=e2.emp_id
;

 -- write a query to print emp name , their manager name and diffrence in their age (in days) 
-- for employees whose year of birth is before their managers year of birth

SELECT e1. emp_name, e2.emp_name as manager, DATEDIFF(day, e1.dob,e2.dob) AS diff_in_days_of_manager_and_employee
FROM employee e1 
INNER JOIN employee e2
ON e1.manager_id = e2.emp_id
WHERE DATEPART(year,e1.dob) < DATEPART(year, e2.dob)

-- Q2) write a query to find subcategories who never had any return orders in the month of november (irrespective of years)

-- My Solution (Wrong logic and wrong output)
SELECT sub_category
FROM orders o 
LEFT JOIN returns r 
ON o.order_id = r.order_id
WHERE DATEPART(month,o.order_date) = 11 AND r.order_id IS NULL 
GROUP BY sub_category

/* When you use the "WHERE" clause, it goes row by row, meaning it will process row by row.
In my solution, because I used r.order_id IS NULL in the WHERE clause, it is giving me the wrong output. */

-- Solution
select sub_category
from orders o
left join returns r on o.order_id=r.order_id
where DATEPART(month,order_date)=11
group by sub_category
having count(r.order_id)=0;

-- Q3) orders table can have multiple rows for a particular order_id when customers buys more than 1 product in an order.
-- write a query to find order ids where there is only 1 product bought by the customer.

-- My Solution
SELECT order_id 
FROM orders 
GROUP BY order_id
HAVING COUNT(1) = 1

-- Solution
select order_id
from orders 
group by order_id
having count(1)=1 

-- Q4)  write a query to print manager names along with the comma separated 
--list(order by emp salary) of all employees directly reporting to him.

-- My Solution
SELECT e2.emp_name AS manager_name  ,STRING_AGG(e1.emp_name, ',') WITHIN GROUP (ORDER BY e1.salary) AS list_of_employees
FROM employee e1
JOIN employee e2 
ON e1.manager_id = e2.emp_id
GROUP BY e2.emp_name

/* STRING_AGG function is very useful when you want to aggregate strings. */

-- Solution
select e2.emp_name as manager_name , string_agg(e1.emp_name,',') as emp_list
from employee e1
inner join employee e2 on e1.manager_id=e2.emp_id
group by e2.emp_name 

-- Q5) write a query to get number of business days between order_date and ship_date (exclude weekends). 
-- Assume that all order date and ship date are on weekdays only

-- My Solution
SELECT order_id, order_date, ship_date, DATEDIFF(day, order_date, ship_date) - 2*DATEDIFF(week, order_date,ship_date) AS business_days
FROM orders 

/* "2*DATEDIFF(week, order_date,ship_date)" this logic is very IMP here beacuse we want to exclude the weekend. */ 

-- Solution
select order_id,order_date,ship_date ,datediff(day,order_date,ship_date)-2*datediff(week,order_date,ship_date) as no_of_business_days
from orders

-- Q6) write a query to print 3 columns : category, total_sales and (total sales of returned orders)

select * from orders

-- My Solution
SELECT o.category, SUM(sales) as total_sales,
SUM(CASE WHEN r.order_id IS NOT NULL THEN o.sales END) AS total_sales_of_returned_orders
FROM orders o 
LEFT JOIN returns r 
ON o.order_id = r.order_id 
GROUP BY o.category

/* Because we want total sales of returned order and total sales of orders, we use LEFT JOIN. */ 

-- Solution
select o.category,sum(o.sales) as total_sales
,sum(case when r.order_id is not null then sales end) as return_orders_sales
from orders o
left join returns r on o.order_id=r.order_id
group by category


-- Q7) write a query to print below 3 columns
-- category, total_sales_2019(sales in year 2019), total_sales_2020(sales in year 2020)

-- My Solution
SELECT o.category, 
SUM(CASE WHEN DATEPART(year,order_date) = 2019 THEN o.sales END) AS total_sales_2019,
SUM(CASE WHEN DATEPART(year,order_date) = 2020 THEN o.sales END) AS total_sales_2020
FROM orders o 
GROUP BY o.category

/* Whenever you want to include a column according to some filter or condition, the CASE WHEN statement is the only way because you cannot give two different conditions in
WHERE clause to two different columns, meaning the WHERE clause filter will apply to all the columns that we selected. */ 

-- Solution
select category,sum(case when datepart(year,order_date)=2019 then sales end) as total_sales_2019
,sum(case when datepart(year,order_date)=2020 then sales end) as total_sales_2020
from orders 
group by category

-- Q8) write a query print top 5 cities in west region by average no of days between order date and ship date.

-- My Solution
SELECT TOP 5 city, AVG(DATEDIFF(day, order_date, ship_date)) as abc
FROM orders
WHERE region = 'West'
GROUP BY city
ORDER BY abc DESC

/* First, check whether your query or logic is satisfying all the conditions or not. It is very important because it can change your way of thinking and your logic. */

-- SOlution
select top 5 city, avg(datediff(day,order_date,ship_date) ) as avg_days
from orders
where region='West'
group by city
order by avg_days desc


-- Q9) write a query to print emp name, manager name and senior manager name (senior manager is manager's manager)

-- My Solution
SELECT e1.emp_name, e2.emp_name AS manager_name, e3.emp_name AS senior_manager
FROM employee e1
JOIN employee e2
ON e1.manager_id = e2.emp_id
JOIN employee e3
ON e2.manager_id = e3.emp_id

/* Just look at the JOIN condition, which is very IMP in the self-join case, because that will change the output. We want managers of employees and managers of those managers, and that is why
we joined manager_id of the left table to emp_id of the right table (in bith cases).
*/ 


-- Solution
select e1.emp_name,e2.emp_name as manager_name,e3.emp_name as senior_manager_name
from employee e1
inner join employee e2 on e1.manager_id=e2.emp_id
inner join employee e3 on e2.manager_id=e3.emp_id
