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

