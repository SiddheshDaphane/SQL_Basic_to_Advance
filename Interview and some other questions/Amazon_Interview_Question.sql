-------------------------------- AMAZON INTERVIEW QUESTION ------------------------------------


/*
There are 2 tables, the first table has 5 records and the second table has 10 records.
You can assume any values in each of the tables. How many maximum and minimum records possible
in case of inner join, left join, right join and full outer join?
*/
CREATE TABLE t1
(
col_1 INT
)
INSERT INTO t1 VALUES (1)
,(1)
,(1)
,(1)
,(1)
SELECT * from t1
DROP TABLE t1




CREATE TABLE t2
(
col_1 INT
)


INSERT INTO t2 VALUES (1)
,(1)
,(1)
,(1)
,(1)
,(1)
,(1)
,(1)
,(1)
,(1)
SELECT * from t2


SELECT COUNT(*) as max_count FROM t1
INNER JOIN t2 ON t1.col_1=t2.col_1


SELECT COUNT(*) as max_count FROM t1
LEFT JOIN t2 ON t1.col_1=t2.col_1


SELECT COUNT(*) as max_count FROM t1
RIGHT JOIN t2 ON t1.col_1=t2.col_1
SELECT COUNT(*) as max_count FROM t1
FULL OUTER JOIN t2 ON t1.col_1=t2.col_1




CREATE TABLE t3
(
col_1 INT
)
INSERT INTO t3 VALUES (2)
,(2)
,(2)
,(2)
,(2)
,(2)
,(2)
,(2)
,(2)
,(2)
DROP TABLE t3
SELECT * from t3


SELECT COUNT(*) as max_count FROM t1
INNER JOIN t3 ON t1.col_1=t3.col_1


SELECT COUNT(*) as max_count FROM t1
LEFT JOIN t3 ON t1.col_1=t3.col_1


SELECT COUNT(*) as max_count FROM t1
RIGHT JOIN t3 ON t1.col_1=t3.col_1
SELECT COUNT(*) as max_count FROM t1
FULL OUTER JOIN t3 ON t1.col_1=t3.col_1