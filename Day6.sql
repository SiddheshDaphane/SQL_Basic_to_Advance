
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




-------------------------------------- String Function ---------------------------------------


-- STRING_AGG function. (Basically aggregate string using group_by clause)
SELECT dept_id, STRING_AGG(emp_name, ',') AS list_of_employees -- separated by ','
FROM employee
GROUP BY dept_id

SELECT dept_id, STRING_AGG(emp_name, ':') AS list_of_employees -- separated by ':'
FROM employee
GROUP BY dept_id

SELECT dept_id, STRING_AGG(emp_name, ':') WITHIN GROUP (ORDER BY emp_name) AS list_of_employees 
FROM employee
GROUP BY dept_id

SELECT dept_id, STRING_AGG(emp_name, ':') WITHIN GROUP (ORDER BY salary DESC) AS list_of_employees 
FROM employee
GROUP BY dept_id 


------------------------------- DATE FUNCTIONS -------------------------------

SELECT order_id, order_date
FROM orders 


----- DATEPART function :- extracting year, month and day from date. 

SELECT order_id, order_date, DATEPART(year,order_date) as year_of_orders 
FROM orders 
/* DATEPART(year, order_date), here 'year' I want to extract from 'order_date'.
Here 'year' that we extracted is INT data type.  */

SELECT order_id, order_date, DATEPART(year,order_date) as year_of_orders
FROM orders 
WHERE DATEPART(year,order_date) = 2020

SELECT order_id, order_date, DATEPART(MONTH,order_date) as month_of_orders
FROM orders 
WHERE DATEPART(month, order_date) = 3

SELECT order_id, order_date, DATEPART(week,order_date) as week_of_orders
FROM orders 

SELECT order_id, order_date, DATEPART(yyyy,order_date) as year_of_orders
FROM orders 

SELECT order_id, order_date, DATENAME(month,order_date) as month_of_orders
FROM orders 

SELECT order_id, order_date, DATENAME(weekday,order_date) as day_of_orders
FROM orders 

/* yyyy - Year
q - Quarter
m - Month
y - Day of year
d - Day
w - Weekday
ww - Week of year
h - Hour
n - Minute
s - Second */


--------- DATEADD Function :- Add and sustract something from date


SELECT order_id, order_date, 
DATEADD(day, 5, order_date) as day_of_orders
FROM orders  -- I am adding 5 days in order_date. Now you can use WHERE clause to select a particular date.

SELECT order_id, order_date, 
DATEADD(week, 5, order_date) as day_of_orders
FROM orders --  5 weeks are added 

SELECT order_id, order_date, 
DATEADD(week, -5, order_date) as day_of_orders
FROM orders -- remove 5 weeks from order_date


--------------- DATEDIFF function :- Difference between two dates

SELECT order_id, order_date, 
DATEDIFF(day,order_date, ship_date) as days_diff_in_day
FROM orders 

SELECT order_id, order_date, 
DATEDIFF(week,order_date,ship_date) as weeks_diff
FROM orders 



-------------- CASE WHEN FUNCTION -------------------

/* CASE statements are executed from TOP to BOTTOM. If one condition is satisfied then it will stop. */

SELECT order_id, profit,
CASE 
WHEN profit < 100 THEN 'Low Profit'
WHEN profit < 250 THEN 'Medium Profit'
WHEN profit < 400 THEN 'High Profit'
ELSE 'Very high profit'
END  AS profit_category
FROM orders

/*  There won't be any 'low profit' because we put medium profit above 'low profit' */
SELECT order_id, profit,
CASE 
WHEN profit < 250 THEN 'Medium Profit'
WHEN profit < 100 THEN 'Low Profit'
WHEN profit < 400 THEN 'High Profit'
ELSE 'Very high profit'
END  AS profit_category
FROM orders