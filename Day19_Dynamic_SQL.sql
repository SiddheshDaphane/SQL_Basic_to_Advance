-- Q) What is dyanamic SQL?
-- Dynamic SQL is a programming technique you can use to build SQL statements as textual strings and execute them later. There are 2 different techniques to execute


-- 1st method
EXEC ('SELECT * FROM orders')  --- Converting original SQL statement to string and then using EXEC to run it is one way to execute dynamic SQL.


--- 2nd Method (Using system store procedure)

EXEC sp_executesql N'SELECT * FROM orders'  -- To run system store procedure we need to convert the string to unicode string (NVARCHAR) and that's why 'N' is added before string.


---- Concatenating an SQL string (Because of this we can use differnet table names )

GO

DECLARE @Tablename NVARCHAR(128)
DECLARE @SQLString NVARCHAR(MAX)

SET @Tablename = N'orders'

SET @SQLString = N'SELECT * FROM ' + @Tablename

EXEC sp_executesql @SQLString



-------------------- Creating a store procedure ---------------------------
GO

CREATE PROC spVariableTable 
(
    @TableName NVARCHAR(128)
)
AS
BEGIN
    DECLARE @SQLString NVARCHAR(MAX)

    SET @SQLString = N'SELECT * FROM ' + @TableName

    EXEC sp_executesql @SQLString
END


EXEC spVariableTable 'orders';
EXEC spVariableTable 'employee';
EXEC spVariableTable 'dept';


--------- Multiple parameters

GO

ALTER PROC spVariableTable 
(
    @TableName NVARCHAR(128),
    @Number INT
)
AS
BEGIN
    DECLARE @SQLString NVARCHAR(MAX)
    DECLARE @NumberString NVARCHAR(4)

    SET @NumberString = CAST(@Number AS NVARCHAR(4))

    SET @SQLString = N'SELECT TOP ' + @NumberString + '* FROM ' + @TableName

    EXEC sp_executesql @SQLString
END


EXEC spVariableTable 'orders',10; 
EXEC spVariableTable 'employee',3; 



--------------- Parameters of sp_executesql -------------------------
select * from orders

GO
EXEC sp_executesql
    N'SELECT customer_name,sales,discount,product_name  
    FROM orders
    WHERE discount < @disValeu AND
    sales > @salesValue',
    N'@disValeu INT, @salesValue INT',
    @disValeu = 10, @salesValue = 20