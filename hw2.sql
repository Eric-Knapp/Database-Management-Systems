-- Eric Knapp
-- CS561 – Programming Assignment 2
-------------------------------------------------------------------------------------------------------------------------
/* 
1. For each customer, product and month, count the number of sales transactions 
that were between the previous and the following month's average sales quantities. 
For January and December, display <NULL> or 0.
*/

WITH T AS 
(
SELECT
    cust,
    prod,
    MONTH,
    AVG(quant) AS avg_quantity -- average quantity
FROM
    sales
GROUP BY
    cust,
    prod,
    MONTH
)
--selecting customer, product, month, and count between averages- along with giving capital Alias for each
SELECT
    sales.cust as "CUSTOMER",
    sales.prod as "PRODUCT",
    sales.MONTH as "MONTH",
    COUNT(1) AS "SALES_COUNT_BETWEEN_AVGS"
FROM
    sales
-- table joins- left joins for T1 & T2
LEFT JOIN T T1
ON
    T1.cust = sales.Cust
    AND 
    T1.prod = sales.Prod
    AND
    T1.MONTH = sales.MONTH-1
LEFT JOIN T T2
ON
    T2.cust = sales.Cust
    AND 
T2.prod = sales.Prod
    AND
T2.MONTH = sales.MONTH + 1
WHERE
-- sales quant between least avg_Quantity of t1,t2 and greatest t1,t2 avg_quant
    sales.quant BETWEEN (LEAST(T1.avg_quantity, T2.avg_quantity)) AND (GREATEST(T1.avg_quantity, T2.avg_quantity))
GROUP BY
    sales.cust,
    sales.prod,
    sales.MONTH 

-------------------------------------------------------------------------------------------------------------------------		  
/*
2. For customer and product, show the average sales before, during and after each month 
(e.g., for February, show average sales of January and March. For “before” January and 
“after” December, display <NULL>. The “YEAR” attribute is not considered for this query 
– for example, both January of 2017 and January of 2018 are considered January regardless of the year.
*/

-- all months one by one from jan - december selected rounding average of quant by each month
WITH jan
     AS (SELECT cust,
                prod,
                Round(Avg(quant), 0) AS QUANT
         FROM   sales
         WHERE  month = 1 -- giving each month a number 1 - 12
         GROUP  BY cust,
                   prod),
     feb
     AS (SELECT cust,
                prod,
                Round(Avg(quant), 0) AS QUANT
         FROM   sales
         WHERE  month = 2
         GROUP  BY cust,
                   prod),
     mar
     AS (SELECT cust,
                prod,
                Round(Avg(quant), 0) AS QUANT
         FROM   sales
         WHERE  month = 3
         GROUP  BY cust,
                   prod),
     apr
     AS (SELECT cust,
                prod,
                Round(Avg(quant), 0) AS QUANT
         FROM   sales
         WHERE  month = 4
         GROUP  BY cust,
                   prod),
     may
     AS (SELECT cust,
                prod,
                Round(Avg(quant), 0) AS QUANT
         FROM   sales
         WHERE  month = 5
         GROUP  BY cust,
                   prod),
     jun
     AS (SELECT cust,
                prod,
                Round(Avg(quant), 0) AS QUANT
         FROM   sales
         WHERE  month = 6
         GROUP  BY cust,
                   prod),
     jul
     AS (SELECT cust,
                prod,
                Round(Avg(quant), 0) AS QUANT
         FROM   sales
         WHERE  month = 7
         GROUP  BY cust,
                   prod),
     aug
     AS (SELECT cust,
                prod,
                Round(Avg(quant), 0) AS QUANT
         FROM   sales
         WHERE  month = 8
         GROUP  BY cust,
                   prod),
     sept
     AS (SELECT cust,
                prod,
                Round(Avg(quant), 0) AS QUANT
         FROM   sales
         WHERE  month = 9
         GROUP  BY cust,
                   prod),
     oct
     AS (SELECT cust,
                prod,
                Round(Avg(quant), 0) AS QUANT
         FROM   sales
         WHERE  month = 10
         GROUP  BY cust,
                   prod),
     nov
     AS (SELECT cust,
                prod,
                Round(Avg(quant), 0) AS QUANT
         FROM   sales
         WHERE  month = 11
         GROUP  BY cust,
                   prod),
     dec
     AS (SELECT cust,
                prod,
                Round(Avg(quant), 0) AS QUANT
         FROM   sales
         WHERE  month = 12
         GROUP  BY cust,
                   prod),
     months -- base table after creating for all 12 mos
     AS (SELECT cust,
                prod
         FROM   sales
         GROUP  BY cust,
                   prod),
     t1
     AS (SELECT B.cust,
                B.prod,
                Cast('1' AS INT)      AS MONTH,-- grabbing january
                Cast(NULL AS NUMERIC) AS BEFORE_AVG,--before- before Jan
                jan.quant             AS DURING_AVG,-- during- Jan
                feb.quant             AS AFTER_AVG -- after- after Jan (feb)
         FROM   months AS B -- joining base table
                LEFT JOIN jan using(cust, prod)
                LEFT JOIN feb using(cust, prod)),
     t2
     -- continue of same process for each, repeating except now before_avg will have a not null month
     AS (SELECT B.cust,
                B.prod,
                Cast('2' AS INT) AS MONTH,
                jan.quant        AS BEFORE_AVG,
                feb.quant        AS DURING_AVG,
                mar.quant        AS AFTER_AVG
         FROM   months AS B
                LEFT JOIN jan using(cust, prod)
                LEFT JOIN feb using(cust, prod)
                LEFT JOIN mar using(cust, prod)),
     t3
     AS (SELECT B.cust,
                B.prod,
                Cast('3' AS INT) AS MONTH,
                feb.quant        AS BEFORE_AVG,
                mar.quant        AS DURING_AVG,
                apr.quant        AS AFTER_AVG
         FROM   months AS B
                LEFT JOIN feb using(cust, prod)
                LEFT JOIN mar using(cust, prod)
                LEFT JOIN apr using(cust, prod)),
     t4
     AS (SELECT B.cust,
                B.prod,
                Cast('4' AS INT) AS MONTH,
                mar.quant        AS BEFORE_AVG,
                apr.quant        AS DURING_AVG,
                may.quant        AS AFTER_AVG
         FROM   months AS B
                LEFT JOIN mar using(cust, prod)
                LEFT JOIN apr using(cust, prod)
                LEFT JOIN may using(cust, prod)),
     t5
     AS (SELECT B.cust,
                B.prod,
                Cast('5' AS INT) AS MONTH,
                apr.quant        AS BEFORE_AVG,
                may.quant        AS DURING_AVG,
                jun.quant        AS AFTER_AVG
         FROM   months AS B
                LEFT JOIN apr using(cust, prod)
                LEFT JOIN may using(cust, prod)
                LEFT JOIN jun using(cust, prod)),
     t6
     AS (SELECT B.cust,
                B.prod,
                Cast('6' AS INT) AS MONTH,
                may.quant        AS BEFORE_AVG,
                jun.quant        AS DURING_AVG,
                jul.quant        AS AFTER_AVG
         FROM   months AS B
                LEFT JOIN may using(cust, prod)
                LEFT JOIN jun using(cust, prod)
                LEFT JOIN jul using(cust, prod)),
     t7
     AS (SELECT B.cust,
                B.prod,
                Cast('7' AS INT) AS MONTH,
                jun.quant        AS BEFORE_AVG,
                jul.quant        AS DURING_AVG,
                aug.quant        AS AFTER_AVG
         FROM   months AS B
                LEFT JOIN jun using(cust, prod)
                LEFT JOIN jul using(cust, prod)
                LEFT JOIN aug using(cust, prod)),
     t8
     AS (SELECT B.cust,
                B.prod,
                Cast('8' AS INT) AS MONTH,
                jul.quant        AS BEFORE_AVG,
                aug.quant        AS DURING_AVG,
                sept.quant       AS AFTER_AVG
         FROM   months AS B
                LEFT JOIN jul using(cust, prod)
                LEFT JOIN aug using(cust, prod)
                LEFT JOIN sept using(cust, prod)),
     t9
     AS (SELECT B.cust,
                B.prod,
                Cast('9' AS INT) AS MONTH,
                aug.quant        AS BEFORE_AVG,
                sept.quant       AS DURING_AVG,
                oct.quant        AS AFTER_AVG
         FROM   months AS B
                LEFT JOIN aug using(cust, prod)
                LEFT JOIN sept using(cust, prod)
                LEFT JOIN oct using(cust, prod)),
     t10
     AS (SELECT B.cust,
                B.prod,
                Cast('10' AS INT) AS MONTH,
                sept.quant        AS BEFORE_AVG,
                oct.quant         AS DURING_AVG,
                nov.quant         AS AFTER_AVG
         FROM   months AS B
                LEFT JOIN sept using(cust, prod)
                LEFT JOIN oct using(cust, prod)
                LEFT JOIN nov using(cust, prod)),
     t11
     AS (SELECT B.cust,
                B.prod,
                Cast('11' AS INT) AS MONTH,
                oct.quant         AS BEFORE_AVG,
                nov.quant         AS DURING_AVG,
                dec.quant         AS AFTER_AVG
         FROM   months AS B
                LEFT JOIN oct using(cust, prod)
                LEFT JOIN nov using(cust, prod)
                LEFT JOIN dec using(cust, prod)),
     t12
     AS (SELECT B.cust,
                B.prod,
                Cast('12' AS INT)     AS MONTH,
                nov.quant             AS BEFORE_AVG,
                dec.quant             AS DURING_AVG,
                Cast(NULL AS NUMERIC) AS AFTER_AVG
         FROM   months AS B
                LEFT JOIN nov using(cust, prod)
                LEFT JOIN dec using(cust, prod)),
     t13
     -- joining of all results for each month's before_avg, during_avg, and after avg. Also bringing in cust, prod
     AS (SELECT *
         FROM   t1
                FULL OUTER JOIN t2 using (cust, prod, month, before_avg,
                                          during_avg, after_avg)
                FULL OUTER JOIN t3 using (cust, prod, month, before_avg,
                                          during_avg, after_avg)
                FULL OUTER JOIN t4 using (cust, prod, month, before_avg,
                                          during_avg, after_avg)
                FULL OUTER JOIN t5 using (cust, prod, month, before_avg,
                                          during_avg, after_avg)
                FULL OUTER JOIN t6 using (cust, prod, month, before_avg,
                                          during_avg, after_avg)
                FULL OUTER JOIN t7 using (cust, prod, month, before_avg,
                                          during_avg, after_avg)
                FULL OUTER JOIN t8 using (cust, prod, month, before_avg,
                                          during_avg, after_avg)
                FULL OUTER JOIN t9 using (cust, prod, month, before_avg,
                                          during_avg, after_avg)
                FULL OUTER JOIN t10 using (cust, prod, month, before_avg,
                                           during_avg, after_avg)
                FULL OUTER JOIN t11 using (cust, prod, month, before_avg,
                                           during_avg, after_avg)
                FULL OUTER JOIN t12 using (cust, prod, month, before_avg,
                                           during_avg, after_avg))
-- Creating capial Alias for each column                       
SELECT t13.cust       AS "CUSTOMER",
       t13.prod       AS "PRODUCT",
       t13.month      AS "MONTH",
       t13.before_avg AS "BEFORE_AVG",
       t13.during_avg AS "DURING_AVG",
       t13.after_avg  AS "AFTER_AVG"
FROM   t13
--ordering- cust, prod, month
ORDER  BY cust,
          prod,
          month 
		  
-------------------------------------------------------------------------------------------------------------------------
/*
3. For each customer, product and state combination, compute (1) the product’s average sale of this customer 
for the state (i.e., the simple AVG for the group-by attributes – this is the easy part), (2) the average 
sale of the product and the state but for all of the other customers, (3) the customer’s average sale for 
the given state, but for all of the other products, and (4) the customer’s average sale for the given product, 
but for all of the other states.
*/
WITH t1
     AS (SELECT prod,
                cust,
                state,
                Round(Avg(quant), 0) AS PROD_AVG -- round average quant
         FROM   sales
         GROUP  BY prod,
                   cust,
                   state),
     t2
     AS (SELECT t1.prod,
                t1.cust,
                t1.state,
                t1.prod_avg,
                Round(Avg(S.quant), 0) AS OTHER_CUST_AVG -- round other average quant
         FROM   t1,
                sales AS S
         WHERE  t1.cust != S.cust
                AND t1.prod = S.prod
                AND t1.state = S.state
         GROUP  BY t1.prod,
                   t1.cust,
                   t1.state,
                   t1.prod_avg),
     t3
     AS (SELECT t1.prod,
                t1.cust,
                t1.state,
                t1.prod_avg,
                Round(Avg(S.quant), 0) AS OTHER_PROD_AVG -- create and round other prod average
         FROM   t1,
                sales AS S
         WHERE  t1.cust = S.cust
                AND t1.prod != S.prod
                AND t1.state = S.state
         GROUP  BY t1.prod,
                   t1.cust,
                   t1.state,
                   t1.prod_avg),
     t4
     AS (SELECT t1.cust,
                t1.prod,
                t1.state,
                t1.prod_avg,
                Round(Avg(S.quant), 0) AS OTHER_STATE_AVG -- create and round other state average
         FROM   t1,
                sales AS S
         WHERE  t1.cust = S.cust
                AND t1.state != S.state
                AND t1.prod = S.prod
         GROUP  BY t1.cust,
                   t1.prod,
                   t1.state,
                   t1.prod_avg)
-- create capital alias for each
SELECT t1.cust            AS "CUSTOMER",
       t1.prod            AS "PRODUCT",
       t1.state           AS "STATE",
       t1.prod_avg        AS "PROD_AVG",
       t2.other_cust_avg  AS "OTHER_CUST_AVG",
       t3.other_prod_avg  AS "OTHER_PROD_AVG",
       t4.other_state_avg AS "OTHER_STATE_AVG"
FROM   t1,
       t2,
       t3,
       t4
WHERE  t1.cust = t2.cust
       AND t1.prod = t2.prod
       AND t1.state = t2.state
       AND t1.cust = t3.cust
       AND t1.prod = t3.prod
       AND t1.state = t3.state
       AND t1.cust = t4.cust
       AND t1.prod = t4.prod
       AND t1.state = t4.state
ORDER  BY t1.cust,
          t1.prod,
          t1.state 
		  
-------------------------------------------------------------------------------------------------------------------------
/*
4. Find the customers with the top 3 highest quantities purchased in New Jersey (NJ). Show the customer’s name, 
the quantity and product purchased, and the date they purchased it. If there are ties, show all – refer to the 
sample output below.

Teacher's comment (should be worded as " for each customer, find the top 3 quantities of purchases in NJ")
*/
WITH t1
     AS (SELECT cust,
                quant,
                prod,
                date
         FROM   sales
         WHERE  state = 'NJ'), -- filter for state that is NJ
     t2
     AS (SELECT t1.cust,
                Max(t1.quant) AS q1
         FROM   t1
         GROUP  BY t1.cust),
     t3
     AS (SELECT t1.cust,
                Max(t1.quant) AS q2
         FROM   t1,
                t2
         WHERE  t1.quant < t2.q1
         GROUP  BY t1.cust),
     t4
     AS (SELECT t1.cust,
                Max(t1.quant) AS q3
         FROM   t1,
                t3
         WHERE  t1.quant < t3.q2
         GROUP  BY t1.cust),
     t5
     AS (SELECT t1.cust AS cust,
                t1.quant AS q4
         FROM   t1,
                t4
         WHERE  t1.quant >= t4.q3
         GROUP  BY t1.cust,
                   t1.quant)
SELECT *
FROM   t5
ORDER  BY cust,
          q4 DESC 
-------------------------------------------------------------------------------------------------------------------------
/*
5. For each product, find the median sales quantity (assume an odd number of sales for simplicity of presentation). 
(NOTE – “median” is defined as “denoting or relating to a value or quantity lying at the midpoint of a frequency 
distribution of observed values or quantities, such that there is an equal probability of falling above or below 
it.” 
E.g., Median value of the list {13, 23, 12, 16, 15, 9, 29} is 15.
For example, given the following sales transactions for Bread, the median quant for Bread is 3.
PRODUCT QUANT 
======= ===== 
Bread 	  1 
Bread 	  1 
Bread 	  1 
Bread 	  2 
Bread 	  2 
Bread 	  3 
Bread 	  4 
Bread 	  5 
Bread 	  6 
Bread 	  7 
Bread 	  7
*/

WITH t1
     AS (SELECT prod,
                Count(quant) / 2 + 1 AS MEDIAN_QUANT
         -- median calculation- counting quant divided by 2 + 1 (calculation done for all t1-t10)
         FROM   sales
         WHERE  prod IN (SELECT prod
                         FROM   sales
                         WHERE  prod = 'Fish')
         -- nested query for sales where prod = fish (same nested query used for each different prod)
         GROUP  BY prod),
     t2
     AS (SELECT prod,
                Count(quant) / 2 + 1 AS MEDIAN_QUANT
         FROM   sales
         WHERE  prod IN (SELECT prod
                         FROM   sales
                         WHERE  prod = 'Butter')
         GROUP  BY prod),
     t3
     AS (SELECT prod,
                Count(quant) / 2 + 1 AS MEDIAN_QUANT
         FROM   sales
         WHERE  prod IN (SELECT prod
                         FROM   sales
                         WHERE  prod = 'Eggs')
         GROUP  BY prod),
     t4
     AS (SELECT prod,
                Count(quant) / 2 + 1 AS MEDIAN_QUANT
         FROM   sales
         WHERE  prod IN (SELECT prod
                         FROM   sales
                         WHERE  prod = 'Dates')
         GROUP  BY prod),
     t5
     AS (SELECT prod,
                Count(quant) / 2 + 1 AS MEDIAN_QUANT
         FROM   sales
         WHERE  prod IN (SELECT prod
                         FROM   sales
                         WHERE  prod = 'Ham')
         GROUP  BY prod),
     t6
     AS (SELECT prod,
                Count(quant) / 2 + 1 AS MEDIAN_QUANT
         FROM   sales
         WHERE  prod IN (SELECT prod
                         FROM   sales
                         WHERE  prod = 'Cherry')
         GROUP  BY prod),
     t7
     AS (SELECT prod,
                Count(quant) / 2 + 1 AS MEDIAN_QUANT
         FROM   sales
         WHERE  prod IN (SELECT prod
                         FROM   sales
                         WHERE  prod = 'Grapes')
         GROUP  BY prod),
     t8
     AS (SELECT prod,
                Count(quant) / 2 + 1 AS MEDIAN_QUANT
         FROM   sales
         WHERE  prod IN (SELECT prod
                         FROM   sales
                         WHERE  prod = 'Jellies')
         GROUP  BY prod),
     t9
     AS (SELECT prod,
                Count(quant) / 2 + 1 AS MEDIAN_QUANT
         FROM   sales
         WHERE  prod IN (SELECT prod
                         FROM   sales
                         WHERE  prod = 'Apple')
         GROUP  BY prod),
     t10
     AS (SELECT prod,
                Count(quant) / 2 + 1 AS MEDIAN_QUANT
         FROM   sales
         WHERE  prod IN (SELECT prod
                         FROM   sales
                         WHERE  prod = 'Ice')
         GROUP  BY prod) SELECT t1.prod         AS "PRODUCT",
       -- remamed first select statment to show all capital "PRODUCT" Alias
       t1.median_quant AS "MEDIAN_QUANT"
-- remamed median_quant to show all capital "MEDIAN_QUANT" Alias
FROM   t1
UNION ALL -- select and union all tables from t1 - t10
SELECT t2.prod,
       t2.median_quant
FROM   t2
UNION ALL
SELECT t3.prod,
       t3.median_quant
FROM   t3
UNION ALL
SELECT t4.prod,
       t4.median_quant
FROM   t4
UNION ALL
SELECT t5.prod,
       t5.median_quant
FROM   t5
UNION ALL
SELECT t6.prod,
       t6.median_quant
FROM   t6
UNION ALL
SELECT t7.prod,
       t7.median_quant
FROM   t7
UNION ALL
SELECT t8.prod,
       t8.median_quant
FROM   t8
UNION ALL
SELECT t9.prod,
       t9.median_quant
FROM   t9
UNION ALL
SELECT t10.prod,
       t10.median_quant
FROM   t10 





