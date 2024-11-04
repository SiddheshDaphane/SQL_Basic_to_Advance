select * from items;

-- When we add or update or delete any data from table, we do transactions within our SQL server. If we don't specify them then all the 
-- changes are save automatically and we cannot undo them and that's where TRANSACTION comes in. 


-- Beginning of Transaction

BEGIN TRAN Movie

INSERT INTO items VALUES ('Movie','2024-04-11','1000')

COMMIT TRAN Movie

select * from items

------- ROLLING back Transaction
BEGIN TRAN interstellar

INSERT INTO items VALUES ('Interstellar','2017-04-11','17680')
select * from items

ROLLBACK TRAN interstellar
select * from items


---------------------------- Conditionally commiting or rolling back-------------------------------
GO 
select * from items

DECLARE @Interstellar INT 

BEGIN TRAN interstellar 
INSERT INTO items VALUES ('Interstellar','2017-04-11','17680')

SELECT @Interstellar = COUNT(*) FROM items WHERE sub_category = 'Interstellar'

IF @Interstellar > 1
    BEGIN
        ROLLBACK TRAN interstellar
        PRINT 'Interstellar was already here'
    END
ELSE
    BEGIN 
        COMMIT TRAN interstellar
        PRINT 'Interstellar was added to the database'
    END


--------------------------------------------- Using Error Handling --------------------------------------------------
select * from items
GO

BEGIN TRY
    BEGIN TRAN Opp

    INSERT INTO items VALUES ('Oppenhiemer','2023-14-02',234254)

    UPDATE items
    SET order_date = '2025-14-02'
    WHERE sub_category = 'Oppenhiemer'

    COMMIT TRAN Opp
END TRY 
BEGIN CATCH
    ROLLBACK TRAN Opp
    PRINT 'Adding Oppenhiemer failed - Check data types'
END CATCH

SELECT * FROM items



--------------------------------------------- Nested transactions basic ----------------------------------------

BEGIN TRAN tran1
    PRINT @@TRANCOUNT
    BEGIN TRAN tran2
        PRINT @@TRANCOUNT
    COMMIT TRAN tran2    
    PRINT @@TRANCOUNT
COMMIT TRAN tran1


------------------------------------------- ROLLING BACK NESTED transactions ----------------------------------------
-- You should be very careful when doing ROLLBACK in nested transactions because it rollbacks everything 

BEGIN TRAN tran1
    PRINT @@TRANCOUNT
    BEGIN TRAN 
        PRINT @@TRANCOUNT
    ROLLBACK TRAN     
    PRINT @@TRANCOUNT -- Here count is 0 because everything rolledback
COMMIT TRAN tran1






