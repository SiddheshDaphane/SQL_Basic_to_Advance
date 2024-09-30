-- Creating a store procedure.


USE namasteSQL -- datbase that I am using. 
GO -- begins a new batch because to create a store procedure "CREATE PROC" must be first line in a batch. 
CREATE PROC spSalaryStat -- "spSalaryStat" is the name of the procedure. 
AS
BEGIN
    SELECT dept_id, AVG(salary) AS avg_dept_salary, SUM(salary) AS total_dept_salry
    FROM employee
    GROUP BY dept_id
END


EXEC spSalaryStat; --  Executing the created procedure. 



---- Modifying store procedure. 

GO
ALTER PROC spSalaryStat
AS
BEGIN
    SELECT dept_id, AVG(salary) AS avg_dept_salary, SUM(salary) AS total_dept_salry
    FROM employee
    GROUP BY dept_id
    ORDER BY avg_dept_salary desc, total_dept_salry desc
END


EXEC spSalaryStat;



--- Deleting procedure. (You can also delete from sidebar.)

DROP PROC spSalaryStat;

Go
EXEC spSalaryStat;



select * from employee;

----------------- Store procedures Parameters ---------------------

USE namasteSQL
GO
CREATE PROC spSalary(@salaryNo AS INT)
AS
BEGIN 
    SELECT emp_id, emp_name, salary, dept_id
    FROM employee
    WHERE salary > @salaryNo
END


EXEC spSalary 10000;