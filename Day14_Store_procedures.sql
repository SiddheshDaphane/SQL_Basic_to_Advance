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
CREATE PROC spSalary(@salaryNo AS INT) -- Added parameter and used that parameter in WHERE clause. 
AS
BEGIN 
    SELECT emp_id, emp_name, salary, dept_id
    FROM employee
    WHERE salary > @salaryNo
END


EXEC spSalary 10000;


------------- Store procedure with multiple parameters --------------

GO 
CREATE PROC spFilters(@age AS INT, @salaryNo AS INT)
AS 
BEGIN
    SELECT emp_name, dept_id, salary, emp_age
    FROM employee
    WHERE @salaryNo > 5000 AND @age < 40
END



GO 
ALTER PROC spFilters(@age AS INT, @salaryNo AS INT)
AS 
BEGIN
    SELECT emp_name, dept_id, salary, emp_age
    FROM employee
    WHERE salary > @salaryNo AND emp_age < @age
END



EXEC spFilters 40, 10000;



----------------- TEXT parameter ------------------

GO
ALTER PROC spFilters
    (
        @age AS INT, 
        @salaryNo AS INT,
        @name AS VARCHAR(MAX))
AS 
BEGIN
    SELECT emp_id, emp_name, salary, emp_age
    FROM employee
    WHERE emp_age < @age AND salary > @salaryNo AND emp_name LIKE '%' + @name + '%'
END 



EXEC spFilters @age = 40, @salaryNo = 5000, @name = 'S';



------- NULL as default value ---------

GO 
ALTER PROC spFilters
    (
        @age AS INT = NULL, 
        @salaryNo AS INT = NULL,
        @name AS VARCHAR(MAX))
AS 
BEGIN
    SELECT emp_id, emp_name, salary, emp_age
    FROM employee
    WHERE (@age IS NULL OR emp_age < @age) AND (@salaryNo IS NULL OR salary > @salaryNo) AND emp_name LIKE '%' + @name + '%'
END 



EXEC spFilters @name = 'A';



-------------------------------------------- VARIABLE ---------------------------------------------

select * from order_east
select * from order_west


Go 

DECLARE @OrdID1 AS INT
DECLARE @OrdID2 AS INT
SET @OrdID1 = 4
SET @OrdID2 = 3

SELECT order_id, region, sales
FROM order_east
WHERE order_id IN (@OrdID1, @OrdID2)

UNION ALL 

SELECT order_id, region, sales
FROM order_west
WHERE order_id IN (@OrdID1,@OrdID2)



------------------------------------------------ Assiging values to variable from SELECT ---------------------------------------------------

