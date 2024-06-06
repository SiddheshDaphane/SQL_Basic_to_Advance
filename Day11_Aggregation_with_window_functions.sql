-- We can use window function with aggregate functions.

SELECT * FROM employee;

-- SUM

SELECT emp_id, emp_name, salary, emp_age,
SUM(salary) OVER(PARTITION BY dept_id) as sum_salry,
SUM(salary) OVER(PARTITION BY dept_id ORDER BY emp_age) AS cumsum_salary,
SUM(salary) OVER(ORDER BY emp_age) AS cumsum_of_whole_table
FROM employee



-- MAX

SELECT emp_id, emp_name, salary, dept_id,
MAX(salary) OVER(PARTITION BY dept_id) as max_salry,
MAX(salary) OVER(PARTITION BY dept_id ORDER BY emp_age) AS cumsum_max_salary,
MAX(salary) OVER(ORDER BY emp_age) AS cumsum_max_of_whole_table
FROM employee


-- AVG

SELECT emp_id, emp_name, salary, dept_id,
AVG(salary) OVER(PARTITION BY dept_id) as avg_salry,
AVG(salary) OVER(PARTITION BY dept_id ORDER BY emp_age) AS cumsum_avg_salary,
AVG(salary) OVER(ORDER BY emp_age) AS cumsum_avg_of_whole_table
FROM employee

-- VIMP observation

-- When we do ORDER BY a column and it has dublicates in it, it aggreagtes them and then give the value. In the output of the following query,
-- we can see that, "sum_salary" is starting from 10000 because it is aggregating the value. To aviod this, we need to have another column 
-- which can identify each row uniquely. 

SELECT *,
SUM(salary) OVER(order by salary) as running_sum_salary
FROM employee

-- Solution to the above issue. 
SELECT *,
SUM(salary) OVER(ORDER BY salary, emp_id) as running_sum_salary 
FROM employee

-- PRECEDING and CURRENT ROW

SELECT *,
SUM(salary) OVER(ORDER BY emp_id ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) as rolling_salary_01 -- adding 1st preceding row and current row. check the o/p
FROM employee;


SELECT *,
SUM(salary) OVER(ORDER BY emp_id ROWS BETWEEN 1 PRECEDING AND 1 following) as rolling_salary_01 -- adding 1st preceding, 1st following row and current row. check the o/p
FROM employee;

SELECT *,
SUM(salary) OVER(ORDER BY emp_id ROWS BETWEEN 5 FOLLOWING AND 10 FOLLOWING) as rolling_salary_01 -- adding between 5th following and 10th following row. check the o/p
FROM employee;