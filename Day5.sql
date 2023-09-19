-- Importing an table from different database (master) to namasteSQL
SELECT * into namasteSQL.dbo.returns FROM returns -- change the database to master and then run it


SELECT *
FROM returns

CREATE TABLE returns
(
order_id VARCHAR(20),
return_reason VARCHAR(20)
)


INSERT INTO returns
SELECT * FROM returns_backup


SELECT * FROM returns

---------------------------------- JOINS -----------------------------------------

-- 1) INNER JOIN

SELECT o.order_id, o.order_date, return_reason
FROM orders o 
INNER JOIN returns r 
ON o.order_id = r.order_id -- 800 rows in the output becuase there are multiple products for each order_id but all records from return table is present here

SELECT * FROM orders -- 9994 records

SELECT * FROM returns -- 296 records

SELECT DISTINCT o.order_id
FROM orders o
INNER JOIN returns r
ON o.order_id = r.order_id -- 296 rows in the output because we are only joining on DISTINCT order_id and return table has 296 rows


SELECT DISTINCT o.*, return_reason
FROM orders o
INNER JOIN returns r
ON o.order_id = r.order_id


SELECT DISTINCT o.*, r.*
FROM orders o
INNER JOIN returns r
ON o.order_id = r.order_id -- See the order_id of 1st three rows. order_id is same and return reason is also same but this can be wrong. Maybe only 1 item is returned but not all. So what's the solution?


-- Not a solution of above question
SELECT DISTINCT o.order_id, o.product_id, r.return_reason, r.order_id as return_order_id
FROM orders o -- This is the left table
LEFT JOIN returns r
ON o.order_id = r.order_id  -- 9994 rows because we did left join and also return_reason is NULL and r.order_id is NULL




SELECT o.order_id, o.product_id, r.return_reason, r.order_id as ret
FROM orders o -- this is the left table
LEFT JOIN returns r
ON o.order_id = r.order_id


-- Q) I want all the records which are not present in returns table meaning I want records which are not being return (Interview question)

SELECT o.order_id, o.product_id, r.return_reason, r.order_id as ret
FROM orders o -- this is the left table
LEFT JOIN returns r
ON o.order_id = r.order_id
WHERE r.order_id IS NULL  -- 9194 records meaning 800 records were joined which were returned.

-- How much sales I lost because of return orders?
SELECT r.return_reason, SUM(sales) as total_sales
FROM orders o 
LEFT JOIN returns r 
ON o.order_id = r.order_id
GROUP BY r.return_reason  -- Because of left join, I am also getting "NULL" in my output. NULL means those orders were never returned

SELECT r.return_reason, SUM(sales) as total_sales
FROM orders o 
INNER JOIN returns r 
ON o.order_id = r.order_id
GROUP BY r.return_reason -- I will not get "NULL" in my output.


----------------------------- FOR CROSS JOIN ----------------------------------

/* In cross join you will get (number of records in 1 table)*(number of records in another) as number of output.
*/
create table employee(
emp_id int,
emp_name varchar(20),
dept_id int,
salary int,
manager_id int,
emp_age int
);




insert into employee values(1,'Ankit',100,10000,4,39);
insert into employee values(2,'Mohit',100,15000,5,48);
insert into employee values(3,'Vikas',100,10000,4,37);
insert into employee values(4,'Rohit',100,5000,2,16);
insert into employee values(5,'Mudit',200,12000,6,55);
insert into employee values(6,'Agam',200,12000,2,14);
insert into employee values(7,'Sanjay',200,9000,2,13);
insert into employee values(8,'Ashish',200,5000,2,12);
insert into employee values(9,'Mukesh',300,6000,6,51);
insert into employee values(10,'Rakesh',500,7000,6,50);
select * from employee;






create table dept(
dep_id int,
dep_name varchar(20)
);
insert into dept values(100,'Analytics');
insert into dept values(200,'IT');
insert into dept values(300,'HR');
insert into dept values(400,'Text Analytics');
select * from dept;

SELECT * FROM employee  -- 10 records
SELECT * FROM dept  --  4 rows

--- New syntax.

SELECT *
FROM employee,dept
ORDER BY employee.emp_id  -- 40 reccords. So number of records are 10*4 that is 40. This is a cross join

-- This give same output as above query
SELECT *
FROM employee
INNER JOIN dept
ON 1=1 -- or you can say 100=100
ORDER BY employee.emp_id

-- What is a difference between two queries?
SELECT *
FROM employee
LEFT JOIN dept
ON 1=1 -- or you can say 100=100
ORDER BY employee.emp_id

----------------------------- Important observation
/*
There is no 400 dept_id in employee table and there is no 500 dept_id in department table
*/

SELECT *
FROM employee,dept
ORDER BY employee.emp_id --- Cross join so 40 records



-- This give same output as above query
SELECT *
FROM employee
INNER JOIN dept
ON 1=1 -- or you can say 100=100
ORDER BY employee.emp_id ---- Cross join so 40 records


SELECT e.emp_id, e.emp_name, e.dept_id, d.dep_name
FROM employee e
INNER JOIN dept d
ON e.dept_id = d.dep_id ----- Inner join so total 9 records. Column names are not same but values should be same


SELECT e.emp_id, e.emp_name, e.dept_id, d.dep_name
FROM employee e
LEFT JOIN dept d
ON e.dept_id = d.dep_id ----- Left Join so 10 records because it will take every value from employee table


SELECT e.emp_id, e.emp_name, e.dept_id, d.dep_name
FROM employee e
RIGHT JOIN dept d
ON e.dept_id = d.dep_id ------ Right join so 10 records and 500 is not present


SELECT e.emp_id, e.emp_name, e.dept_id,d.dep_id, d.dep_name
FROM employee e
FULL OUTER JOIN dept d
ON e.dept_id = d.dep_id ------- Whatever common in left both table will come and also whatever unique in both tables will also come. 11 rows.

/* FULL OUTER JOIN is very different from UNION ALL because UNION ALL will not join the records from both tables even though they have common joining ID and 
if you take a COUNT of that query, then in this case it will be 14 but count of FULL OUTER JOIN is 11 */



CREATE TABLE people
(
manager VARCHAR(20),
region VARCHAR(10)
)
DROP TABLE people
INSERT INTO people
VALUES('Ankit','West')
,('Deepak','East')
,('Vishal','Central')
,('Sanjay','South')


SELECT * FROM people
SELECT * FROM orders

SELECT o.order_id , o.product_id, r.return_reason, p.manager
FROM orders o
INNER JOIN returns r ON o.order_id = r.order_id
INNER JOIN people p ON p.region = o.region
-- You can also use the returns table if there is the same column. AND the result of first inner join will be inner joined with people table
