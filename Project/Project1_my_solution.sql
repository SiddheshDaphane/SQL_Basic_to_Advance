select * from credit_card_transcations;

-- Understanding data and cheking of there are any duplicates.
SELECT COUNT(transaction_id) AS total_count FROM credit_card_transcations;
SELECT COUNT(DISTINCT (transaction_id)) AS total_distinct_count FROM credit_card_transcations;


select * from credit_card_transcations;
-- 1) write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends

WITH city_wise_trans AS (
SELECT city, SUM(amount) AS city_trans
FROM credit_card_transcations
GROUP BY city)
, t_trans AS (
SELECT SUM(amount) as total_trans
FROM credit_card_transcations)
SELECT top 5 c.*, round(city_trans*1.0/total_trans * 100,2) as percentage_contribution -- Need to multiply by "1.0" otherwise o/p will come 0. 
FROM city_wise_trans c 
INNER JOIN t_trans t 
ON 1 = 1
ORDER BY percentage_contribution DESC;


-- 2) write a query to print highest spend month and amount spent in that month for each card type

select * from credit_card_transcations;

-- My solution

with cte1 AS (
SELECT card_type, DATEPART(YEAR, transaction_date) AS yt, DATEPART(MONTH, transaction_date) AS mt, SUM(amount) AS t_spend
FROM credit_card_transcations
GROUP BY card_type, DATEPART(YEAR, transaction_date), DATEPART(MONTH, transaction_date))
, cte2 AS (
SELECT *,
RANK() OVER(PARTITION BY card_type ORDER BY t_spend desc) as rnk
FROM cte1)
SELECT *
FROM cte2 
WHERE rnk = 1; 


-- 3) write a query to print the transaction details(all columns from the table) for each card type when
-- it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)

select * from credit_card_transcations;
-- My solution

WITH cte1 AS (
SELECT *,
SUM(amount) OVER(PARTITION BY card_type ORDER BY transaction_date, transaction_id ) as sum_spend -- need transaction_date because we need when it reaches cumulative of 1000000
FROM credit_card_transcations)
, cte2 AS (
SELECT *,
RANK() OVER(PARTITION BY card_type ORDER BY sum_spend) as rnk
FROM cte1
WHERE sum_spend >= 1000000)
SELECT *
FROM cte2 
WHERE rnk = 1;


-- 4) write a query to find city which had lowest percentage spend for gold card type

select * from credit_card_transcations

 
-- total spent by city with gold wise spent by city percentage

WITH cte1 AS (
SELECT city, SUM(amount) as total_spend
FROM credit_card_transcations
GROUP BY city)
, cte2 AS (
SELECT city, card_type, SUM(amount) as gold_spend
FROM credit_card_transcations
WHERE card_type = 'Gold'
GROUP BY city, card_type)
SELECT TOP 1 c2.*,c1.total_spend, (c2.gold_spend * 1.0 / total_spend)*100 AS perc
FROM cte1 c1
INNER JOIN cte2 c2 
ON c1.city = c2.city
ORDER BY perc;


-- Total gold spent with city wise gold spent percentage

with cte1 AS (
SELECT city, SUM(amount) as gold_t
FROM credit_card_transcations
WHERE card_type = 'Gold'
GROUP BY city)
, cte2 AS (
SELECT SUM(amount) as total_gold_card_spend
FROM credit_card_transcations
WHERE card_type = 'Gold' )
SELECT TOP 1 c1.*,((gold_t * 1.0 / total_gold_card_spend)*100) AS perc
FROM  cte1 c1
INNER JOIN cte2 c2 
ON 1=1
ORDER BY perc;




-- 5) write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)

select * from credit_card_transcations;

with cte1 AS (
SELECT  city,exp_type, sum(amount) AS total_amount 
FROM credit_card_transcations
GROUP BY city,exp_type)
, cte2 AS (
SELECT *
,RANK() OVER(partition by city order by total_amount desc) rn_desc
,rank() over(partition by city order by total_amount asc) rn_asc
from cte1)
SELECT city,
max(case when rn_asc=1 then exp_type end) as lowest_exp_type
, min(case when rn_desc=1 then exp_type end) as highest_exp_type
FROM cte2
GROUP BY city;



-- 6) write a query to find percentage contribution of spends by females for each expense type

select * from credit_card_transcations;

with cte1 AS (
SELECT exp_type, gender, SUM(amount) as f_spend
FROM credit_card_transcations
WHERE gender = 'F'
GROUP BY exp_type, gender )
, cte2 AS (
SELECT exp_type, SUM(amount) as t_spend
FROM credit_card_transcations
GROUP BY exp_type )
SELECT c1.*, c2.t_spend,
(f_spend * 1.0 / t_spend)*100 AS f_perc
FROM cte1 c1
INNER JOIN cte2 c2 
ON c1.exp_type = c2.exp_type
ORDER BY c1.exp_type;

-- OR

select exp_type,
sum(case when gender='F' then amount else 0 end)*1.0/sum(amount) as percentage_female_contribution
from credit_card_transcations
group by exp_type
order by percentage_female_contribution desc;


-- 7) which card and expense type combination saw highest month over month growth in Jan-2014

select * from credit_card_transcations;

WITH cte1 AS (
SELECT card_type, exp_type, DATEPART(MONTH, transaction_date) as mt,DATEPART(YEAR, transaction_date) as yt,  SUM(amount) as t_spend
FROM credit_card_transcations
GROUP BY card_type, exp_type, DATEPART(MONTH, transaction_date), DATEPART(YEAR, transaction_date))
, cte2 AS (
SELECT *
, LAG(t_spend,1) OVER(PARTITION BY card_type, exp_type ORDER BY yt, mt) as prev_spend
FROM cte1 )
SELECT TOP 1 *, (t_spend - prev_spend) as m_o_m_growth
FROM cte2 
WHERE yt = 2014 AND mt=1
ORDER BY m_o_m_growth desc;


-- 8) during weekends which city has highest total spend to total no of transcations ratio 

select * from credit_card_transcations;

SELECT TOP 1 city, SUM(amount)*1.0 / COUNT(1) as ratio 
FROM credit_card_transcations
WHERE DATENAME(weekday, transaction_date) IN ('Saturday', 'Sunday')
GROUP BY city 
ORDER BY ratio desc;


-- 9) which city took least number of days to reach its 500th transaction after the first transaction in that city


with cte as (
select *
,row_number() over(partition by city order by transaction_date,transaction_id) as rn
from credit_card_transcations)
select top 1 city,datediff(day,min(transaction_date),max(transaction_date)) as datediff1
from cte
where rn=1 or rn=500
group by city
having count(1)=2
order by datediff1 
