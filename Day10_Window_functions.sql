select * from employee;

-- In sub-query lesson, we calculated the employee with highest salary in each department. Which means that, we needed only 1 employee from each
-- department. Because we needed only 1 employee, we used "GROUP BY" clause with sub-query or CTE. Now my question is different.

-- I WANT TOP 2 EMPLOYEES FROM EACH DEPARTMENT WITH HIGHEST SALARY. 

-- Above question is a case of window functions. At first glance, we get in a false perception that we can solve this by using sub-query or CTE,
-- but we cannot do that because we need to use "GROUP BY" clause on "dept_id" and it will return only 1 output because of aggragted function. 
-- there is no way to get only top 2 employees from each department in a single output. This is the reason why we need to use window function.


-- Give me top 2 emplyees from each department based on their salary. 
 -- I need to create windows in the table based on department id's so that I can grab top 2 employees based on their salary from each department
 -- in the output and that's why I am using windows function.

-- Here I am assigning row numbers for each department based on their salary in desc order. 
SELECT *,
ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY salary desc) rn
FROM employee

-- What happens if I dont use "PARTITION BY" clause. (The whole table is "window" now and numbers are getting assigned by salary in desc order)
SELECT *,
ROW_NUMBER() OVER(ORDER BY salary desc) rn
FROM employee

-- What happens if I dont use "ORDER BY" clause. (It will give an error because database doesn't know on what it has to give rank to table)
SELECT *,
ROW_NUMBER() OVER(PARTITION BY dept_id) rn
FROM employee

------- SOLUTION FOR ABOVE QUESTION
WITH table_01 AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY salary desc) as rn
FROM employee ) 
SELECT * FROM table_01
WHERE rn <= 2



-------- Different window functions

-- See the difference between various window functions output
SELECT *,
ROW_NUMBER() OVER( ORDER BY salary) as rn,
RANK() OVER( ORDER BY salary) as rnk,
DENSE_RANK() OVER( ORDER BY salary) as d_rnk
FROM employee


SELECT *,
ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY salary) as rn,
RANK() OVER(PARTITION BY dept_id ORDER BY salary) as rnk,
DENSE_RANK() OVER(PARTITION BY dept_id ORDER BY salary) as d_rnk
FROM employee


--- print top 5 selling product from each category by sell

select DISTINCT product_id from orders;


with total AS (
SELECT category, product_id, sum(sales) as total_sales
FROM orders
GROUP BY category, product_id),
window_func AS (
SELECT *,
RANK() OVER(PARTITION BY category ORDER BY total_sales desc ) rn
FROM total)
SELECT * 
FROM window_func
WHERE rn <= 5 ; 

--- OR

with 
window_func AS (
SELECT category, product_id, SUM(sales) AS total_sales,
RANK() OVER(PARTITION BY category ORDER BY sum(sales) desc ) rn
FROM orders 
GROUP BY category, product_id
)
SELECT * 
FROM window_func
WHERE rn <= 5 ; 



--------- LEAD and LAG function

-- I am getting values of next row of "salary" by using LEAD() function. 
SELECT emp_id, emp_name, salary, 
LEAD(salary,1) OVER(ORDER BY salary desc) AS salary_of_next_row
FROM employee

SELECT emp_id, emp_name, salary, dept_id,
LEAD(salary,1) OVER(PARTITION BY dept_id ORDER BY salary desc) AS salary_of_next_row
FROM employee


-- LAG function (I am getting previous value of salary)

SELECT emp_id, emp_name, salary, 
LAG(salary,1) OVER(ORDER BY salary desc) AS salary_of_next_row
FROM employee

SELECT emp_id, emp_name, salary, 
LAG(salary,1) OVER(PARTITION BY dept_id ORDER BY salary desc) AS salary_of_next_row
FROM employee

-- BOTH at the same time. We can achieve same result just by chaging order by with ASC and DESC
SELECT emp_id, emp_name, salary, 
LAG(salary,1) OVER(PARTITION BY dept_id ORDER BY salary asc) AS salary_of_previous_row,
LEAD(salary,1) OVER(PARTITION BY dept_id ORDER BY salary desc) AS salary_of_next_row
FROM employee

SELECT emp_id, emp_name, salary, 
LAG(emp_age,1) OVER(PARTITION BY dept_id ORDER BY salary asc) AS age_of_previous_row,
LEAD(emp_age,1) OVER(PARTITION BY dept_id ORDER BY salary desc) AS age_of_next_row
FROM employee


--- FIRST VALUES

SELECT emp_id, emp_name,emp_age, salary, 
FIRST_VALUE(emp_age) OVER(PARTITION BY dept_id ORDER BY salary desc) AS first_age_value
FROM employee