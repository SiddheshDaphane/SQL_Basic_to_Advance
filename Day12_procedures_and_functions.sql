select * from employee;


-- PROCEDURE

-- 1) Creating a procedure

CREATE procedure spemp AS (
SELECT *
FROM employee)


EXECUTE spemp;


-- 2) Now, I want to pass variable in this procedure. Let's say, I want employees, whos salary is greater than 100,

ALTER procedure spemp (@salary_more int) AS (
SELECT *
FROM employee
WHERE salary > @salary_more
)

EXECUTE spemp @salary_more = 10000;




ALTER procedure spemp (@salary_more int, @department_id int) AS (
SELECT *
FROM employee
WHERE salary > @salary_more AND dept_id = @department_id
)

EXECUTE spemp @salary_more = 10000, @department_id=100

EXECUTE spemp 10000,100


----- With 2 columns

ALTER procedure spemp (@salary_more int, @department_id int) AS 
SELECT *
FROM employee
WHERE salary > @salary_more AND dept_id = @department_id
select * from dept
;
EXECUTE spemp @salary_more = 10000, @department_id=100




ALTER procedure spemp (@salary_more int, @department_id int) AS 
SELECT *
FROM employee
WHERE salary > @salary_more AND dept_id = @department_id
select * from dept where dep_id = @department_id
;

EXECUTE spemp @salary_more = 10000, @department_id=100;


-- with multiple arguments 

ALTER PROCEDURE spemp (@salary_more int, @department_id1 int, @department_id2 int) AS
SELECT * FROM employee WHERE salary > @salary_more AND dept_id = @department_id1
SELECT * FROM dept WHERE dep_id = @department_id2;
;

EXECUTE spemp 10000, 100, 200


-- INSERT statement

ALTER PROCEDURE spemp (@salary_more int, @department_id int) AS

INSERT INTO dept VALUES (800, 'HR1')
SELECT * FROM employee WHERE salary > @salary_more
SELECT * FROM dept;
;

EXECUTE spemp 10000, 100

SELECT * FROM dept; -- HR1 got inserted in the table. 


--- VARIABLE 

ALTER PROCEDURE spemp (@department_id int) AS

DECLARE @cnt int

SELECT @cnt = COUNT(1) FROM employee WHERE dept_id = @department_id

if @cnt=0
print('There are no employee in this department')
else
print(@cnt)
;

EXECUTE spemp 100



---- OUT variable 

ALTER PROCEDURE spemp (@department_id int, @cnt int OUT) 
AS
SELECT @cnt = COUNT(1) FROM employee WHERE dept_id = @department_id
if @cnt=0
print('There is no employee')
;

DECLARE @cnt1 int 
EXEC spemp 100, @cnt1 OUT 
print @cnt1


---------------------- FUNCTIONS --------------------------------------

-- 1) For integers

CREATE FUNCTION fnproduct (@a int, @b int)
RETURNS INT
AS
BEGIN
return (select @a * @b)
END



SELECT [dbo].[fnproduct] (4,5)


-- 2) For decimals 

ALTER FUNCTION fnproduct (@a int, @b decimal(5,2))
RETURNS decimal(5,2)
AS
BEGIN
RETURN (select @a * @b)
END

SELECT [dbo].[fnproduct] (4,5.4)


--- 3) Default values

ALTER FUNCTION fnproduct (@a int, @b int = 200)
RETURNS decimal(5,2)
AS
BEGIN
RETURN (select @a * @b)
END

SELECT [dbo].[fnproduct] (4,default)