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