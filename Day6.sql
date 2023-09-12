
SELECT * FROM employee
-- In this employee table, manager_id is referring to employee-id meaning table is referring to itself

SELECT * FROM dept

-- I want to know the manager name of each employee

SELECT e1.emp_id, e1.emp_name, e2.emp_id as manager_id, e2.emp_name as manager_name 
FROM employee e1
INNER JOIN employee e2 
ON e1.manager_id = e2.emp_id


-- Find the employee whose salary is greater than his/her manager
SELECT e1.emp_id, e1.emp_name, e2.emp_id as manager_id, e2.emp_name as manager_name, e1.salary
FROM employee e1
INNER JOIN employee e2 
ON e1.manager_id = e2.emp_id
WHERE e1.salary > e2.salary 

