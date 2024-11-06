select * from orders

GO
----------------------------- Creating a DDL trigger -------------------------------------


CREATE TRIGGER trgNoNewTables
ON DATABASE
FOR CREATE_TABLE
AS
BEGIN
    PRINT 'No new tables'
    ROLLBACK
END


----- Testing a trigger 

CREATE TABLE test(ID int)


