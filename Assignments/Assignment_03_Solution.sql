-- Q1) 1- write a query to get region wise count of return orders

SELECT * FROM orders
SELECT * FROM returns

-- My Solution
SELECT region, COUNT(DISTINCT o.order_id) as no_of_return_orders
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

-- My Solution
SELECT category, SUM(sales) as total_sales
FROM orders o
LEFT JOIN returns r 
ON o.order_id = r.order_id
WHERE r.return_reason IS NULL
GROUP BY category 

-- INNER JOIN will not work, why?  because, we want orders that were not returned meaning which are not present in "returns" table. That's why LEFT JOIN is necessary. 
SELECT category, SUM(sales) as total_sales
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
SELECT * FROM dept
SELECT * FROM employee

-- My solution

SELECT dep_name, AVG(e.salary) as avg_salary_of_employees
FROM employee e
LEFT JOIN dept d 
ON e.dept_id = d.dep_id
GROUP BY dep_name 

-- Solution
select d.dep_name,avg(e.salary) as avg_sal
from employee e
inner join dept d on e.dept_id=d.dep_id
group by d.dep_name


-- Q4) write a query to print dep names where none of the emplyees have same salary.


-- My Solution
SELECT d.dep_name
FROM employee e 
INNER JOIN dept d 
ON e.dept_id = d.dep_id
GROUP BY d.dep_name
HAVING COUNT(e.emp_id) = COUNT(DISTINCT e.salary)


-- Solution
select d.dep_name
from employee e
inner join dept d on e.dept_id=d.dep_id
group by d.dep_name
having count(e.emp_id)=count(distinct e.salary)


-- Q5) write a query to print sub categories where we have all 3 kinds of returns (others,bad quality,wrong items)
/*
Little bit of a confusing question. Need to look at the solution


Solution logic is more accurate
*/


select * from orders
select * from returns


select count(DISTINCT city) from orders


-- My answer
SELECT sub_category
FROM orders o
INNER JOIN returns r
ON o.order_id = r.order_id
WHERE return_reason IN ('Other', 'Wrong Items', 'Bad Quality')
GROUP BY sub_category -- The question says all 3 kinds of records 
– so that means we are not talking at row level but at a group level
– meaning assume that if a sub-category has 2 out of 3 kinds of returns and we use the – WHERE clause. Now WHERE goes row by row meaning a sub-category having 2 out of 3 – – – kinds of return will also get selected but we want all 3 kinds of returns. 
– If a question says that either in any kind of return then I can use the WHERE clause.
– Extremely important concept 


-- Solution
select o.sub_category
from orders o
inner join returns r on o.order_id=r.order_id
group by o.sub_category
having count(distinct r.return_reason)=3




-- Q6) write a query to find cities where not even a single order was returned.


/*
konta barobar ahe ki donhi chukicha ahe
*/


-- My Answer 1
SELECT city
FROM orders o
LEFT JOIN returns r
ON o.order_id=r.order_id
WHERE r.order_id IS NULL
GROUP BY city -- Very important concept ahe and mothi mistake ahe ya logic madhe.
-- jar r.order_id IS NULL asa lihla tar process kasa hoil te baghayla pahije.
-- WHERE row by row jata and having group var lagta.
-- Jenvha me ithe 'WHERE r.order_id IS NULL' use kela tenva row by row gela
-- atta assume kar ki eak city ahe (Pune) jithun order 2 order return zalya ahet
-- pune badquality
-- pune NULL
-- atta ithe 'WHERE r.order_id IS NULL' ya condition pramane pune qualify zali karan NULL ahe
-- Pan question madhe mhantla ahe ki eak pan single order nako city madhun mhanje logic chukla maza
-- So where kadhi vaparaycha he khup IMP ahe. Confusion hou shakta we are talking about city (group) level not at row level and that’s why WHERE cannot be used here.




-- My answer 2
SELECT city, COUNT(r.order_id)
FROM orders o
LEFT JOIN returns r
ON o.order_id=r.order_id
GROUP BY city
HAVING COUNT(r.order_id) = 0


-- Solution
select city
from orders o
left join returns r on o.order_id=r.order_id
group by city
having count(r.order_id)=0




-- Q7) write a query to find top 3 subcategories by sales of returned orders in east region


/*
SUM(o.sales) he aggregate function ahe and jar tyala apan alias kela nahi tar ORDER BY madhe sales lihta yenar nahi.
and mag required output yenar nahi
*/


-- My answers
SELECT TOP 3 o.sub_category, SUM(o.sales) AS returned_sales
FROM orders o
INNER JOIN returns r
ON o.order_id = r.order_id
WHERE o.region = 'East'
GROUP BY o.sub_category
ORDER BY returned_sales DESC


SELECT TOP 3 o.sub_category, SUM(o.sales)
FROM orders o
INNER JOIN returns r
ON o.order_id = r.order_id
WHERE o.region = 'East'
GROUP BY o.sub_category
ORDER BY SUM(o.sales)DESC


-- Solution
select top 3 sub_category,sum(o.sales) as return_sales
from orders o
inner join returns r on o.order_id=r.order_id
where o.region='East'
group by sub_category
order by return_sales desc




-- Q8) write a query to print dep name for which there is no employee
select * from dept
select * from employee


-- My answer
SELECT d.dep_name
FROM dept d
LEFT JOIN employee e
ON d.dep_id=e.dept_id
WHERE e.emp_id IS NULL


-- Solution
select d.dep_id,d.dep_name
from dept d
left join employee e on e.dept_id=d.dep_id
group by d.dep_id,d.dep_name
having count(e.emp_id)=0;


--Q9) write a query to print employees name for dep id is not avaiable in dept table


-- My answer
SELECT e.emp_name
FROM employee e
LEFT JOIN dept d
ON e.dept_id=d.dep_id
WHERE dep_name IS NULL


-- solution
select e.*
from employee e
left join dept d on e.dept_id=d.dep_id
where d.dep_id is null;
