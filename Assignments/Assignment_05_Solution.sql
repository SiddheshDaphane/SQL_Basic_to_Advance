create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

SELECT * FROM icc_world_cup

-- Q1) write a query to produce below output from icc_world_cup table.
-- team_name, no_of_matches_played , no_of_wins , no_of_losses

-- My Solution (Cannot able to solve this question)

    (SELECT i1.Team_1 AS team_name,
    CASE WHEN i1.Team_1 = i2.Winner THEN 1 ELSE 0 END AS win 
    FROM icc_world_cup i1
    LEFT JOIN icc_world_cup i2 
    ON i1.Winner = i2.Team_1 
    GROUP BY i1.Team_1, i2.Winner) 
    UNION ALL 
    (SELECT i1.Team_2 AS team_name,
    CASE WHEN i1.Team_2 = i2.Winner THEN 1 ELSE 0 END AS win 
    FROM icc_world_cup i1
    LEFT JOIN icc_world_cup i2 
    ON i1.Winner = i2.Team_2
    GROUP BY i1.Team_2, i2.Winner) 

/* Need to look at this question again. Once I learned about sub-queries and CTEs then I will solve this question */

-- Solution
with all_teams as 
(select Team_1 as team, case when Team_1=Winner then 1 else 0 end as win_flag from icc_world_cup
union all
select Team_2 as team, case when Team_2=Winner then 1 else 0 end as win_flag from icc_world_cup)

select team,count(1) as total_matches_played , sum(win_flag) as matches_won,count(1)-sum(win_flag) as matches_lost
from all_teams



-- Q2) write a query to print first name and last name of a customer using orders table(everything after first space can be considered as last name)
-- customer_name, first_name,last_name

-- My Solution
SELECT
customer_name,
TRIM(SUBSTRING(customer_name,1,CHARINDEX(' ', customer_name))) AS first_name,
SUBSTRING(customer_name,CHARINDEX(' ', customer_name)+1,LEN(customer_name)-CHARINDEX(' ', customer_name)+1) AS last_name 
FROM orders 

-- Solution
select customer_name , trim(SUBSTRING(customer_name,1,CHARINDEX(' ',customer_name))) as first_name
, SUBSTRING(customer_name,CHARINDEX(' ',customer_name)+1,len(customer_name)-CHARINDEX(' ',customer_name)+1) as second_name
from orders

