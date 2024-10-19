------------- WHILE loop ------------------

select * from orders

GO
DECLARE @Num AS INT 
SET @Num = 1

WHILE @Num < 10
    BEGIN
        PRINT @Num
        SET @Num = @Num + 1
    END



GO
DECLARE @CountQunatity AS INT 
DECLARE @CusName AS INT
SET @CountQunatity = 0
SET @CusName = 0

WHILE @CountQunatity < 5
        BEGIN
            SET @CusName = 
                    (SELECT COUNT(customer_name) FROM orders WHERE quantity = @CountQunatity)
            
            PRINT 'Qunatity is ' + CAST(@CountQunatity AS VARCHAR(2)) + ' Count of Customers of this quantity is ' + CAST(@CusName AS VARCHAR(5))

            SET @CountQunatity = @CountQunatity + 1
        END





GO
DECLARE @CountQunatity AS INT 
DECLARE @CusName AS VARCHAR(MAX)
DECLARE @CusCnt AS INT 
SET @CountQunatity = 0
SET @CusName = ''
SET @CusCnt = 0

WHILE @CountQunatity < 5
        BEGIN
            SELECT @CusName = STRING_AGG(CAST(customer_name AS VARCHAR(MAX)),', ') 
            FROM (SELECT DISTINCT customer_name FROM orders WHERE quantity = @CountQunatity) AS DistinctCustomers

            SET @CusCnt = (SELECT COUNT(DISTINCT customer_name)FROM orders WHERE quantity = @CountQunatity)
            
            PRINT 'Qunatity is ' + CAST(@CountQunatity AS VARCHAR(2)) + ' Count of Customers of this quantity is ' + CAST(@CusCnt AS VARCHAR(5)) + CHAR(10) + CHAR(13) 
                    + ' [' + @CusName +'   ]' + CHAR(10) + CHAR(13) 
            SET @CountQunatity = @CountQunatity + 1
        END

