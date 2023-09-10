-- Importing an table from different database (master) to namasteSQL
SELECT * into namasteSQL.dbo.returns FROM returns -- change the database to master and then run it


SELECT *
FROM returns

CREATE TABLE returns
(
order_id VARCHAR(20),
return_reason VARCHAR(20)
)


INSERT INTO returns
SELECT * FROM returns_backup


SELECT * FROM returns

---------------------------------- JOINS -----------------------------------------

-- 1) INNER JOIN

SELECT o.order_id, o.order_date, return_reason
FROM orders o
INNER JOIN returns r
ON o.order_id = r.order_id


SELECT DISTINCT o.order_id, o.order_date, return_reason
FROM orders o
INNER JOIN returns r
ON o.order_id = r.order_id


SELECT DISTINCT o.*, return_reason
FROM orders o
INNER JOIN returns r
ON o.order_id = r.order_id


SELECT DISTINCT o.*, r.*
FROM orders o
INNER JOIN returns r
ON o.order_id = r.order_id -- See the order_id of 1st three rows. order_id is same and return reason is also same but this can be wrong. Maybe only 1 item is returned but not all. So what's the solution?


-- Not a solution of above question
SELECT DISTINCT o.*, r.*
FROM orders o -- This is the left table
LEFT JOIN returns r
ON o.order_id = r.order_id




SELECT o.order_id, o.product_id, r.return_reason, r.order_id as ret
FROM orders o -- this is the left table
LEFT JOIN returns r
ON o.order_id = r.order_id


-- Q) I want all the records which are not present in returns table meaning I want records which are not being return (Interview question)

SELECT o.order_id, o.product_id, r.return_reason, r.order_id as ret
FROM orders o -- this is the left table
LEFT JOIN returns r
ON o.order_id = r.order_id
WHERE r.order_id IS NULL


