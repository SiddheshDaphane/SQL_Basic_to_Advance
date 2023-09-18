
SELECT * FROM employee
-- In this employee table, manager_id is referring to employee-id meaning table is referring to itself

SELECT * FROM dept

-- I want to know the manager name of each employee

/* When you do self-join, always imagine that there are two tables. Now you need to be extremely careful when joining the tables. Because that will change the output.
In this case, we are joining e1.manager_id to e2.emp_id because we want the manager of the employee, and hence we must join the manager_id of the 1st table to the employee_id of the 2nd table.
Now it is very important to know from which table you are taking employee_name and manager_name. We are joining manager_id of the first table to employee_id of a second table, which means
We should take employee_name from the first table and manager_name from the second table.
   */


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






