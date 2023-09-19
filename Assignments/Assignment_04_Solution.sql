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