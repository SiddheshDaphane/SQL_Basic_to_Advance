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


select * from employee

Go 
DECLARE @Sal AS INT 
DECLARE @Depart AS INT 
SET @Sal = (SELECT COUNT(*) FROM employee)
SET @Depart = (SELECT COUNT(DISTINCT dept_id) FROM employee)

SELECT 'Number of employees' , @Sal
UNION ALL 
SELECT 'Number of Departments', @Depart


------------------------------ Print the values of the varibales in "message" ----------------------------------
PRINT  @Sal
PRINT @Depart


Print 'Number of Employees are = ' + CAST(@Sal AS VARCHAR(MAX))
Print 'Number of Departments are = ' + CAST(@Depart AS VARCHAR(MAX))




-------------------------------- Printing many values in a single varibale ----------------------------------


select * from employee


Go 
DECLARE @emp_name AS VARCHAR(MAX)
SET @emp_name = ''

SELECT @emp_name = @emp_name + emp_name + ', '
FROM employee
WHERE emp_age < 40


print 'Names of the employees are [' + @emp_name + ']'


--------------- Printing on different line

Go 
DECLARE @emp_name AS VARCHAR(MAX)
SET @emp_name = ''

SELECT @emp_name = @emp_name + emp_name + CHAR(10)
FROM employee
WHERE emp_age < 40


print 'Names of the employees are ' + @emp_name




Go 
DECLARE @emp_name AS VARCHAR(MAX)
SET @emp_name = ''

SELECT @emp_name = @emp_name + emp_name + CHAR(10) + CHAR(13)
FROM employee
WHERE emp_age < 40


print 'Names of the employees are '+ CHAR(10) + CHAR(13) + @emp_name




----------------- Some Global variables ----------------------

SELECT @@SERVERNAME, @@VERSION, @@FETCH_STATUS   -- and many more.




--------------------------------------------- OUTPUT parameters and Return Values -------------------------------------------------------------

USE namasteSQL
GO

select * from orders

-- Here I am using global variable to get count of customers.
GO
CREATE PROC spCustInfo
        (
            @Prof AS INT,
            @CusName AS VARCHAR(MAX) OUTPUT,
            @CusCnt AS INT OUTPUT
        )
AS 
BEGIN
    DECLARE @Names AS VARCHAR(MAX)
    SET @Names = ''
    SELECT @Names = @Names + customer_name + ', '
    FROM orders 
    WHERE profit > @Prof 
    ORDER BY customer_name

    SET @CusCnt = @@ROWCOUNT -- Number of customers using global variable
    SET @CusName = @Names
END


DECLARE @CustomerNames AS VARCHAR(MAX)
DECLARE @CustomerCounts AS INT

EXEC spCustInfo @Prof = 50,
     @CusCnt = @CustomerCounts OUTPUT,
     @CusName = @CustomerNames OUTPUT

SELECT @CustomerCounts AS [Customer Counts], @CustomerNames AS [Customer Names]


-- Lets see if we can get count of unique customers using select statement. 

GO 
ALTER PROC spCutInfo 
            (
                @prof AS INT,
                @CusName AS VARCHAR(MAX) OUTPUT,
                @CusCnt AS INT OUTPUT
            )
AS 
BEGIN
    DECLARE @NamesOfCustomers AS VARCHAR(MAX)
    SET @NamesOfCustomers = ''
    SELECT @NamesOfCustomers = @NamesOfCustomers + customer_name + ', '
    FROM orders
    WHERE profit > @prof
    ORDER BY customer_name

    SET @CusCnt = (SELECT COUNT(DISTINCT customer_name) FROM orders WHERE profit > @prof)
    SET @CusName = @NamesOfCustomers
END

DECLARE @CountOfCust AS INT 
DECLARE @CustomerNames AS VARCHAR(MAX)

EXEC spCutInfo @prof = 50,
     @CusCnt = @CountOfCust OUTPUT,
     @CusName = @CustomerNames OUTPUT

SELECT @CountOfCust AS [Count of Unique Customers], @CustomerNames AS [Customer Names]
  -- Now, How do we knwo that "Customer Names" are also unique, let's cross check this. 

DECLARE @SplitCusCnt AS INT
SELECT @SplitCusCnt = COUNT(*)
FROM string_split(@CustomerNames, ',')

SELECT 
    @CountOfCust AS [Unique Customer Count],
    @SplitCusCnt AS [Split Customer Name Count],
    CASE WHEN @CountOfCust = @SplitCusCnt THEN 'Match' ELSE 'Mismatch' END AS [Verification];

-- Result showed us that it is a mismatch which means we have count of unique customers but we don't have unique customers names
-- Now how to solve this problem? 





---- Unique customer counts and also unique customer names solution. (VIMP)
Go 

ALTER PROC spCusInfo
        (
            @prof AS INT,
            @CusName AS VARCHAR(MAX) OUTPUT,
            @CusCnt AS INT OUTPUT
        )
AS 
BEGIN

    DECLARE @Names AS VARCHAR(MAX)
    SET @Names = ''
    SELECT @Names = STRING_AGG(CAST(customer_name AS VARCHAR(MAX)), ', ') WITHIN GROUP (ORDER BY customer_name)
    FROM (SELECT DISTINCT customer_name
          FROM orders
          WHERE profit > @prof  ) AS UniqueCustomers
    

    SET @CusCnt = (SELECT COUNT(DISTINCT customer_name) FROM orders WHERE profit > @prof)
    SET @CusName = @Names
END

DECLARE @Name AS VARCHAR(MAX)
DECLARE @Cnt AS INT

EXEC spCusInfo @prof = 50,
        @CusName = @Name OUTPUT,
        @CusCnt = @Cnt OUTPUT

SELECT @Cnt AS [Unique Customer Count], @Name AS [Customer Names]

DECLARE @SplitCusCnt AS INT
SELECT @SplitCusCnt = COUNT(*)
FROM string_split(@Name, ',')

SELECT 
    @Cnt AS [Unique Customer Count],
    @SplitCusCnt AS [Split Customer Name Count],
    CASE WHEN @Cnt = @SplitCusCnt THEN 'Match' ELSE 'Mismatch' END AS [Verification];