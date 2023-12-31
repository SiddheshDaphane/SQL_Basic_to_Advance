-- Q1) 1- write a query to get region wise count of return orders

SELECT * FROM orders
SELECT * FROM returns

-- My solution
SELECT region, COUNT(DISTINCT r.order_id)
FROM orders o 
INNER JOIN returns r
ON o.order_id = r.order_id
GROUP BY region

-- Solution
select region,count(distinct o.order_id) as no_of_return_orders
from orders o
inner join returns r on o.order_id=r.order_id
group by region



-- Q2) write a query to get category wise sales of orders that were not returned

-- My solution
SELECT category, SUM(o.sales)
FROM orders o 
LEFT JOIN returns r 
ON o.order_id = r.order_id
WHERE r.return_reason IS NULL 
GROUP BY category

/* Why not this solution? I used INNER JOIN and not LEFT JOIN. I am seeing nothing in my output. why? Answer....


When we use INNER JOIN, then the common records from both tables get attached, and in the end, those will come.
Here we want the records that were not returned, meaning they don't have a return_id.
If an order doesn't have a return_id, it means that the order has not been returned. But in the returns table, all the orders that were returned are stored.
To check if an order is not returned, we need returned_id = 0 for some order_id, and that's why we are using LEFT JOIN.


Now, my solution is not wrong, but not 100% correct. Because an order that was returned may not have a return reason.
On this record, it is giving me the correct solution but not a 100% correct query.
*/
SELECT category, SUM(o.sales)
FROM orders o 
INNER JOIN returns r 
ON o.order_id = r.order_id
WHERE r.return_reason IS NULL 
GROUP BY category

-- Solution
select category,sum(o.sales) as total_sales
from orders o
left join returns r on o.order_id=r.order_id
where r.order_id is null
group by category


-- Q3) write a query to print dep name and average salary of employees in that dep .

SELECT * FROM employee
SELECT * FROM dept 

-- My solution
SELECT dep_name, AVG(salary) AS avg_salary
FROM employee e 
INNER JOIN dept d 
ON e.dept_id = d.dep_id
GROUP BY dep_name 

/*  First understand the question : We want the average salary of the department. Which means we want the data from that table where the department name is mentioned. In this case, that is the department.


1) Let's look at the first left join. We use employee as LEFT TABLE, which means all the employees will come. Now, ideally, every employee in the company will belong to some department, but
This is not the case here. If you look at the output, it has NULL as the department name and AVG salary, which means there is an employee who doesn't belong to any department.


2) Now let's look at the 2nd left table. We used the department table as the left table because we want all the departments. The output is showing us that there is a "Text Analytics" department, but
It doesn't have any employees. So you need to be careful about joining the table, especially if it is left-table.


In my solution, I used INNER JOIN because I wanted the data of only those departments that had employees in them. 

*/
-- Using LEFT JOIN
SELECT dep_name, AVG(salary) AS avg_salary
FROM employee e 
LEFT JOIN dept d 
ON e.dept_id = d.dep_id
GROUP BY dep_name 

-- Switching tables in LEFT JOIN
SELECT dep_name, AVG(salary) AS avg_salary
FROM dept d 
LEFT JOIN employee e  
ON e.dept_id = d.dep_id
GROUP BY dep_name 

-- Solution
select d.dep_name,avg(e.salary) as avg_sal
from employee e
inner join dept d on e.dept_id=d.dep_id
group by d.dep_name



-- Q4) write a query to print dep names where none of the emplyees have same salary.

-- My solution
SELECT dep_name
FROM employee e 
INNER JOIN dept d 
ON e.dept_id = d.dep_id 
GROUP BY dep_name 
HAVING COUNT(DISTINCT salary) = 1

/* 
Look at the question. "Where none of the employees have the same salary". Does COUNT(DISTINCT SALARY) = 1 satisfy this condition?
Because no two employees have the same salary, the salary for that department must be DISTINCT. Do we need COUNT(e.emp_id) = COUNT(DISTINCT e.salary)?
*/

-- Solution
select d.dep_name
from employee e
inner join dept d on e.dept_id=d.dep_id
group by d.dep_name
having count(e.emp_id)=count(distinct e.salary)



-- Q5) write a query to print sub categories where we have all 3 kinds of returns (others,bad quality,wrong items)

select * from orders
select * from returns
-- My Solution
SELECT sub_category
FROM orders o 
INNER JOIN returns r 
ON o.order_id = r.order_id
WHERE r.return_reason IN ('Wrong Items', 'Bad Quality', 'Others')

/* I completely missed the question. "IN" operator uses "OR," so every sub-category will come. The question is which subcategories have all three kinds of returns.   */

-- Solution
select o.sub_category
from orders o
inner join returns r on o.order_id=r.order_id
group by o.sub_category
having count(distinct r.return_reason)=3

-- Q6) write a query to find cities where not even a single order was returned.

-- My Solution
SELECT city, COUNT(r.order_id) 
FROM orders o 
LEFT JOIN returns r 
ON o.order_id = r.order_id 
GROUP BY city
HAVING COUNT(r.order_id) = 0 

/* LEFT JOIN because we want the orders that were not returned, which means those cities in which o.order_id doesn't have r.order_id attached to them. */

-- Solution
select city
from orders o
left join returns r on o.order_id=r.order_id
group by city
having count(r.order_id)=0



-- Q7) write a query to find top 3 subcategories by sales of returned orders in east region

-- My Solution
SELECT TOP 3 sub_category, SUM(sales) as sales_returned
FROM orders o 
INNER JOIN returns r 
ON o.order_id = r.order_id
WHERE region = 'East' 
GROUP BY sub_category
ORDER BY sales_returned DESC

/* INNER JOIN because we only want the sales of returned orders, which means the sales of phones are the highest. */

-- Solution
select top 3 sub_category,sum(o.sales) as return_sales
from orders o
inner join returns r on o.order_id=r.order_id
where o.region='East'
group by sub_category
order by return_sales  desc

-- Q8) write a query to print dep name for which there is no employee
SELECT * from employee
SELECT * FROM dept

-- My Solution
SELECT d.dep_name, dep_id
FROM dept d 
LEFT JOIN employee e 
ON d.dep_id = e.dept_id
WHERE emp_id IS NULL

/* Again, my solution is correct in this case only because it will be correct if dep_id is the primary key. But COUNT() is a generic approach. I used LEFT join because we want
of all employees so that we can get the department that doesn't have employees.  */

-- Another experiment. Why this is not giving output?
SELECT d.dep_name, dep_id
FROM employee e 
LEFT JOIN dept d  
ON d.dep_id = e.dept_id
WHERE e.emp_id IS NULL
/* In this query, we are getting all the records from the employee table. Now, we want the department that doesn't have employees. When we use LEFT JOIN, we get all the records.
from the left table, and we get only matched records from another table, and that's why we need to use the first query to get the desired output. */

-- Solution
select d.dep_id,d.dep_name
from dept d 
left join employee e on e.dept_id=d.dep_id
group by d.dep_id,d.dep_name
having count(e.emp_id)=0;

--Q9) write a query to print employees name for dep id is not avaiable in dept table

-- My Soluion
SELECT e.*
FROM employee e 
LEFT JOIN dept d 
ON e.dept_id = d.dep_id
WHERE d.dep_id IS NULL

/* We use LEFT JOIN because we need the value from the employee table, which is the left table and has no match in the department table. Meaning we want those records from the left table.
which will not get attached to another table in the given column. */

-- Solution
select e.*
from employee e 
left join dept d  on e.dept_id=d.dep_id
where d.dep_id is null;