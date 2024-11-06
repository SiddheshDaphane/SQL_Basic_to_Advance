select * from colors



---------------------------------------------- Creating Triggers ------------------------------------------

USE namasteSQL
GO

CREATE TRIGGER trgColor
ON colors
AFTER INSERT, UPDATE, DELETE
AS 
BEGIN
    PRINT 'Something happened to color table'
END


GO

-- Inserting into a table
INSERT INTO colors VALUES(4, 'Black')

-- Updating a value of a table
UPDATE colors 
SET color = 'Black2'
WHERE id = 4

select * from colors

-- Deleting a record from a table 

DELETE FROM colors
WHERE id = 4


--------------------------------------- Modifying Triggers ---------------------------------------


USE namasteSQL
GO

ALTER TRIGGER trgColor
ON colors
AFTER INSERT, UPDATE, DELETE
AS 
BEGIN
    PRINT 'Data was changed in the color table'
END


GO

-- Inserting into a table
INSERT INTO colors VALUES(4, 'Black')

-- Updating a value of a table
UPDATE colors 
SET color = 'Black2'
WHERE id = 4

select * from colors

-- Deleting a record from a table 

DELETE FROM colors
WHERE id = 4


----------------------------------- Deleting triggers ----------------------------------------

DROP TRIGGER trgColor



----------------------------------- Creating a INSTEAD OF triggers --------------------------------------

USE namasteSQL
GO
CREATE TRIGGER trgcolor1
ON colors
INSTEAD OF INSERT
AS
BEGIN
    RAISERROR('No more colors can be inserted',16,1)
END
GO


-- Inserting into a table
INSERT INTO colors VALUES(4, 'Black')

GO
SELECT * FROM colors WHERE id = 4 



--------------------------------- Inserted and Deleted Tables ----------------------------

USE namasteSQL
GO
ALTER TRIGGER trgcolor1
ON colors
AFTER INSERT
AS
BEGIN
    SELECT * FROM inserted
END


GO
-- Inserting into a table
INSERT INTO colors VALUES(4, 'Black') --- Even though I didn't select anything, table appeared in the output. This is system table more specifically "inserted" tabel



USE namasteSQL
GO
ALTER TRIGGER trgcolor1
ON colors
AFTER DELETE
AS
BEGIN
    SELECT * FROM inserted
END

select * from colors

GO
-- Deleting a record from a table 

DELETE FROM colors
WHERE id = 4
