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