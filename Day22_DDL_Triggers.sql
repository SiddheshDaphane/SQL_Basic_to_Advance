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

DROP TRIGGER trgNoNewTables ON DATABASE


-------------------------------------- Diasbling and Enabling Trigger ------------------------------------------
GO
DISABLE TRIGGER trgNoNewTables ON DATABASE

GO
ENABLE TRIGGER trgNoNewTables ON DATABASE

GO
DISABLE TRIGGER ALL ON DATABASE

GO
ENABLE TRIGGER ALL ON DATABASE