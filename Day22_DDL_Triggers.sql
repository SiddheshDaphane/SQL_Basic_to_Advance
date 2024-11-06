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


------------------------------- Modifying a Trigger -----------------------------
GO

ALTER TRIGGER trgNoNewTables
ON DATABASE
FOR CREATE_TABLE, DROP_TABLE, ALTER_TABLE
AS
BEGIN
    PRINT 'No changes to tables'
    ROLLBACK
END


----- Testing a trigger 

CREATE TABLE test(ID int)

DROP TABLE t1


-------------------------------------- Deleting a trigger ---------------------------------------------