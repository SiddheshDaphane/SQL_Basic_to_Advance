-------------------------- STRING FUNCTIONS -------------------------------------


-- 1) LEN() - Gives the length of a string
SELECT order_id, customer_name, 
LEN(customer_name) AS  Len_of_Cus,
LEN(' Claire Gute       ') AS Len_with_space -- Only counting leading spaces
FROM orders


--- All IMP string functions
SELECT order_id, customer_name,
LEFT(customer_name,4) AS left_char,
RIGHT(customer_name, 6) AS right_char,
SUBSTRING(customer_name, 4, 5) AS char_in_between,
SUBSTRING(order_id, 4, 4) AS year_in_order_id,  -- 4 is included here.
CHARINDEX(' ', customer_name) AS space_position,
CHARINDEX('C', customer_name) AS C_position,
CHARINDEX('c', customer_name) AS C_position, -- case sensitive
CHARINDEX('n', customer_name) AS n_position, -- If it is repeating, then it will give the position of the first occurrence.
CHARINDEX('n', customer_name,5) AS from_5th_to_find_n_position,
CHARINDEX('n', customer_name,11) AS from_11th_to_find_n_position,
CHARINDEX('n', customer_name,CHARINDEX('n', customer_name)+1) AS from_second_position_onwards,
CONCAT(order_id, customer_name) AS concated_without_space, -- Attached without space
CONCAT(order_id,' ', customer_name) AS concated_with_space,
(order_id+customer_name) AS by_using_sign,
(order_id+' '+ customer_name) AS adding_space_also,
REPLACE(order_id, 'CA','PB') AS replaced_CA_to_PB_in_order_id,
REPLACE(customer_name, 'A','B') AS A_is_replaced_with_B, -- Case Sensitive
TRANSLATE(customer_name,'AG','TA') AS A_with_T_and_G_with_A,
TRANSLATE(customer_name,' ','') AS Replacing_space_with_Nothing,
REVERSE(customer_name) AS reversed_name,
TRIM(' Siddhesh    ') AS removed_spaces,
TRIM(' Siddhesh Daphane    '    ) AS Doesnt_remove_in_between_spaces
FROM orders



--2) LEFT, RIGHT :- give number of characters
SELECT order_id, customer_name,
LEFT(customer_name,4) AS left_char,
RIGHT(customer_name, 6) AS right_char 
FROM orders

-- 3) SUBSTRING function ---> If you want string in between
SELECT order_id, customer_name,
SUBSTRING(customer_name, 4, 5)
FROM orders

-- 4) CHARINDEX() ---> It gives a position of a character. 
SELECT order_id, customer_name,
CHARINDEX(' ', customer_name) AS space_position,
CHARINDEX('C', customer_name) AS C_position,
CHARINDEX('c', customer_name) AS C_position, -- case sensitive
CHARINDEX('n', customer_name) AS n_position, -- If it is repeating, then it will give the position of the first occurrence.
CHARINDEX('n', customer_name,5) AS from_5th_to_find_n_position,
CHARINDEX('n', customer_name,11) AS from_11th_to_find_n_position,
CHARINDEX('n', customer_name,CHARINDEX('n', customer_name)+1) AS from_second_position_onwards
FROM orders

-- 4) CONCAT --> Attach two columns
SELECT order_id, customer_name,
CONCAT(order_id, customer_name) AS concated_without_space, -- Attached without space
CONCAT(order_id,' ', customer_name) AS concated_with_space,
(order_id+customer_name) AS by_using_sign,
(order_id+' '+ customer_name) AS adding_space_also
FROM orders

-- REPLACE() :- Function name is enough to know what it does.
SELECT order_id, customer_name,
REPLACE(order_id, 'CA','PB') AS replaced_CA_to_PB_in_order_id,
REPLACE(customer_name, 'A','B') AS A_is_replaced_with_B -- Case sensitive
FROM orders

-- TRANSLATE() :- It will replace charecter by charecter
SELECT order_id, customer_name,
TRANSLATE(customer_name,'AG','TA') AS A_with_T_and_G_with_A,
TRANSLATE(customer_name,' ','') AS Replacing_space_with_Nothing
FROM orders

-- REVERSE() --> reverse the string
SELECT order_id, customer_name,
REVERSE(customer_name) AS reversed_name 
FROM orders

-- TRIM() 
SELECT order_id, customer_name,
TRIM(' Siddhesh    ') AS removed_spaces,
TRIM(' Siddhesh Daphane    '    ) AS Doesnt_remove_in_between_spaces
FROM orders 

SELECT order_id, customer_name
FROM orders 


------------------------------------ NULL HANDLING FUNCTIONS --------------------------

SELECT order_id, city 
FROM orders 
WHERE city IS NULL 

-- ISNULL function --> replace the null value with what you gave
SELECT order_id, city,
ISNULL(city,'unknown') AS new_city 
FROM orders 
WHERE city IS NULL 

-- COALESCE ------> Can take multiple values and it takes first not null values
SELECT order_id, city, state, 
COALESCE(city,state,region,'unknown') AS new_city -- If city is null, it will take State value, if state is NULL, it will take region value and if everything is null then it will take unknown value that we gave
FROM orders 
WHERE city IS NULL 



