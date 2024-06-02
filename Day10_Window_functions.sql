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

