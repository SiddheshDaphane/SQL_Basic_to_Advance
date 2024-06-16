SELECT * FROM employee;
SELECT * FROM dept;

SELECT * INTO employee_bck FROM employee;
SELECT * INTO dept_bck FROM dept;

SELECT * FROM employee_bck;
SELECT * FROM dept_bck;


--- DCL (Data Control Language) and TCL (Transaction COntrol Language)

GRANT select on employee to guest

REVOKE select on employee to guest


CREATE ROLE role_sales;

GRANT select ON employee TO role_sales;

ALTER ROLE role_sales ADD member_guest;

ALTER TABLE employee ADD dep_name VARCHAR(20)


UPDATE employee
SET dep_name = d.dep_name
FROM employee e 
INNER JOIN dept d 
ON e.dept_id = d.dep_id;

select * from employee;

ALTER TABLE employee
DROP COLUMN dep_name;


