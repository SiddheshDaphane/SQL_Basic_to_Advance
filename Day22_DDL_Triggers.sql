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



---------------------------------------- Scoped Triggers --------------------------------------
GO

CREATE TRIGGER trgNoNewTables
ON ALL SERVER
FOR CREATE_TABLE
AS
BEGIN
    PRINT 'No new tables'
    ROLLBACK
END


DROP TRIGGER trgNoNewTables ON ALL SERVER


GO
DISABLE TRIGGER trgNoNewTables ON ALL SERVER

GO
ENABLE TRIGGER trgNoNewTables ON ALL SERVER

GO
DISABLE TRIGGER ALL ON ALL SERVER

GO
ENABLE TRIGGER ALL ON ALL SERVER


------------------------------------------------- Set Trigger Order -------------------------------------------------------
USE namasteSQL
GO

DISABLE TRIGGER trgNoNewTables ON ALL SERVER

GO 
CREATE TRIGGER trgSecondTrigger ON DATABASE
FOR CREATE_TABLE AS
    PRINT 'This is Second Trigger'

GO
CREATE TRIGGER trgFirstTrigger ON DATABASE
FOR CREATE_TABLE AS
    PRINT 'This is First Trigger'

GO
CREATE TABLE test(ID int)

------- In the output right now, we don't know which trigger will give output first and that's why we need to set an order of triggers. 


USE namasteSQL
GO

EXEC sp_settriggerorder
    @triggername = 'trgFirstTrigger',
    @order = 'first',
    @stmttype = 'CREATE_TABLE',
    @namespace = 'DATABASE'


DROP TABLE test

CREATE TABLE test(ID int) -- Now we know that First trigger will execute first and then Second trigger because of @order. 



USE namasteSQL
GO

EXEC sp_settriggerorder
    @triggername = 'trgFirstTrigger',
    @order = 'last',
    @stmttype = 'CREATE_TABLE',
    @namespace = 'DATABASE'



DROP TABLE test

CREATE TABLE test(ID int) -- Now we know that First trigger will execute last and then Second trigger because of @order. 





USE namasteSQL
GO

EXEC sp_settriggerorder
    @triggername = 'trgFirstTrigger',
    @order = 'none',
    @stmttype = 'CREATE_TABLE',
    @namespace = 'DATABASE'


DROP TABLE test
CREATE TABLE test(ID int) -- Now we don't know what is the order because of @order='none'