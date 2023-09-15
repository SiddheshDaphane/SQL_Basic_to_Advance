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

-- Solution
select d.dep_name,avg(e.salary) as avg_sal
from employee e
inner join dept d on e.dept_id=d.dep_id
group by d.dep_name



-- Q4) write a query to print dep names where none of the emplyees have same salary.



-- Q5) write a query to print sub categories where we have all 3 kinds of returns (others,bad quality,wrong items)



-- Q6) write a query to find cities where not even a single order was returned.



-- Q7) write a query to find top 3 subcategories by sales of returned orders in east region



-- Q8) write a query to print dep name for which there is no employee



--Q9) write a query to print employees name for dep id is not avaiable in dept table


