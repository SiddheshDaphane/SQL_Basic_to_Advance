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



-------------------- Creating a store procedure
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