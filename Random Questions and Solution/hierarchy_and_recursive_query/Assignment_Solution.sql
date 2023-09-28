-- Q1) Write one query to show org structure with employee name indented by spaces based on level, 
-- show department, employee salary, and employee’s department salary average and sum. Sort rows by 
-- id path to CEO.


-- Solution

WITH RECURSIVE EHierarchy AS (

    SELECT

        o.employee_id,

		o.manager_id,

        o.employee_name,

		o.employee_title,

        o.department_name,

        o.salary,

        0 AS level,

        ARRAY[o.employee_name] AS path_to_ceo

    FROM

        organizational_data o

    WHERE

        o.manager_id IS NULL 

    UNION ALL

    SELECT

        o.employee_id,

		o.manager_id,

        o.employee_name,

		o.employee_title,

        o.department_name,

        o.salary,

        eh.level + 1,

        eh.path_to_ceo || o.employee_name

    FROM

        organizational_data o

    JOIN

        EHierarchy eh ON o.manager_id = eh.employee_id

)

SELECT

    manager_id,

	LPAD('', level * 2, ' ') || employee_name AS indented_name,

    department_name,

	employee_title,

    salary,

    AVG(salary) OVER (PARTITION BY department_name) AS department_avg_salary,

    SUM(salary) OVER (PARTITION BY department_name) AS department_total_salary

    

FROM

    EHierarchy

ORDER BY

    path_to_ceo;






-- Q2) Write one query to pivot the data to display the count of electric vehicles by models and model 
-- years for all 5 Tesla models. The result should have models as columns, model years as rows, 
-- and the count of vehicles as values. Show ‘All’ top row with totals, and a ‘Tesla’ left column with totals.

-- Solution

CREATE TABLE vehicle (
VIN_1_10 VARCHAR(300),
County VARCHAR(30),
City VARCHAR(30),
State VARCHAR(3),
Postal_Code BIGINT,
Model_Year INT,
Make VARCHAR(30),
Model VARCHAR(30),
Electric_Vehicle_Type VARCHAR(70),
Clean_Alternative_Fuel_Vehicle_CAFV_Eligibility VARCHAR(150),
Electric_Range BIGINT,
Base_MSRP BIGINT,
Legislative_District BIGINT,
DOL_Vehicle_ID BIGINT,
Vehicle_Location VARCHAR(200),
Electric_Utility VARCHAR(200),
Census_Tract_2020 BIGINT
	) 
	
ALTER TABLE vehicle
ALTER COLUMN census_tract_2020 TYPE NUMERIC(18, 0);

DROP TABLE vehicle




SELECT

  "model_year",

  "Tesla",

  "Tesla Model S",

  "Tesla Model 3",

  "Tesla Model X",

  "Tesla Model Y",

  "Tesla Roadster"

FROM (

  SELECT

    'All'::text AS "model_year",

    COUNT(*) FILTER (WHERE make = 'TESLA') AS "Tesla",

    COUNT(*) FILTER (WHERE model = 'MODEL S') AS "Tesla Model S",

    COUNT(*) FILTER (WHERE model = 'MODEL 3') AS "Tesla Model 3",

    COUNT(*) FILTER (WHERE model = 'MODEL X') AS "Tesla Model X",

    COUNT(*) FILTER (WHERE model = 'MODEL Y') AS "Tesla Model Y",

    COUNT(*) FILTER (WHERE model = 'ROADSTER') AS "Tesla Roadster"

  FROM

    vehicle

  UNION ALL

  SELECT

    model_year ::text,

    COUNT(*) FILTER (WHERE make = 'TESLA') AS "Tesla",

    COUNT(*) FILTER (WHERE model = 'MODEL S') AS "Tesla Model S",

    COUNT(*) FILTER (WHERE model = 'MODEL 3') AS "Tesla Model 3",

    COUNT(*) FILTER (WHERE model = 'MODEL X') AS "Tesla Model X",

    COUNT(*) FILTER (WHERE model = 'MODEL Y') AS "Tesla Model Y",

    COUNT(*) FILTER (WHERE model = 'ROADSTER') AS "Tesla Roadster"

  FROM

    vehicle

  GROUP BY

    "model_year"

) AS subquery

ORDER BY

  CASE WHEN "model_year" = 'All' THEN 0 ELSE 1 END, "model_year" DESC;
  
  
  
  

SELECT model, model_year--, COUNT(vin_1_10) 
FROM vehicle
WHERE make = 'TESLA'
ORDER BY model desc
WHERE model = 'MODEL Y'
GROUP BY model, model_year;


SELECT model, COUNT(model)
FROM vehicle 
WHERE make = 'TESLA'
GROUP BY model;

SELECT make, COUNT(model)
FROM vehicle
WHERE model_year = 1997 AND make = 'TESLA'
GROUP BY make;

