---------------------------------- VIEW -----------------------------------------
DROP VIEW orders_vw

CREATE VIEW orders_vw AS
SELECT * FROM orders;

select * from orders_vw

/* What is an advantage of view? So basically 'orders' table have data in it meaning it is stored in the database. 
But 'orders_vw' doesn't hold any data. When we call the view,  it will run it's defination that is it will run the query 
in the database. There is no data in the view. It is just structure and defination. */

CREATE VIEW [dbo].[orders_vw] AS -- This is the defination of the view. 
SELECT * FROM orders
GO

/*  Why are views IMP?
1) What if you want to share a query which is large. You can store that query in the view and then you can share the view.
2) You just want to share a data to a specific person about their specific role and region meaning you don't want to share
extra data which will not be useful then also you can use view.x  */


CREATE VIEW orders_south_vw AS 
SELECT *
FROM orders 
WHERE region = 'South';  

DROP VIEW orders_south_vw

SELECT * FROM orders_south_vw  


-- Can VIEW be created from different databses?

CREATE VIEW return_vw AS 
SELECT * FROM master.dbo.[returns]

select * from return_vw


----------------------- CONSTRAINTS -------------------------------

select * from employee
select * from dept

-- REFERENCES :- Basically I am referencing primary key of the of 'dept' table which is 'dept_id'
CREATE TABLE emp 
(
emp_id INT,
emp_name VARCHAR(10),
dept_id INT references dept(dept_id)
)

--  I am altering the table because primary key was not defined and it should be NOT NULL because of primary key. 
ALTER TABLE dept ALTER COLUMN dep_id INT NOT NULL
ALTER TABLE dept ADD CONSTRAINT primary_key PRIMARY KEY(dep_id)


INSERT INTO emp VALUES (1,'Siddhesh',100)
INSERT INTO emp VALUES (1,'Siddhesh')
INSERT INTO emp VALUES (1,'Siddhesh',500) -- This will give an error because of reference constraint. The error is becasue of 500 because it is not present in 'dept' table.

SELECT * from emp 

----------------- IDENTITY ------------------

/* So if you don't have primary key in a particular table, then we can use IDENTITY to generate the keys.
In this case, identity(1,1) means start with 1 and increament by 1.   */ 

drop table dept1 
CREATE TABLE dept1
(
id INT identity(1,1), -- first '1' is starting and second '1' is increament by. 
dep_id INT,
dep_name VARCHAR(10) 
)

INSERT INTO dept1(dep_id, dep_name) VALUES (100,'HR')
INSERT INTO dept1(dep_id, dep_name) VALUES (200,'Analytics')
INSERT INTO dept1(dep_id, dep_name) VALUES (300,'RnD')
INSERT INTO dept1 VALUES (400,'ML') -- Don't need to give names of columns. It identify itself.

select * from dept1 


