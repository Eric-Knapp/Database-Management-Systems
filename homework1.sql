-- Eric Knapp
-- CS561 – Programming Assignment 1

-------------------------------------------------------------------------------------------------------------
/* QUESTION 1 */ --------------------------------------------------------------------------------------------
/* 1. For each customer, compute the minimum and maximum sales quantities along with the
corresponding products (purchased), dates (i.e., dates of those minimum and maximum
sales quantities) and the states in which the sale transactions took place.  If there are >1
occurrences of the min or max, display all.
*/

WITH t1
     AS (SELECT cust,
                Min(quant) min_q, -- minimum quantity from sales
                Max(quant) max_q, -- max quantity from sales
                Avg(quant) avg_q -- average quantity from sales
         FROM   sales
         GROUP  BY cust),
     t2
     AS (SELECT t1.cust,
                t1.min_q,
                s.prod  min_prod, --prod, date, state from sales table
                s.date  min_date,
                s.state min_state,
                t1.max_q,
                t1.avg_q
         FROM   t1,
                sales s
         WHERE  t1.cust = s.cust --match on same cust - one from sales table, one from t1
                AND t1.min_q = s.quant) --match on same quantity - one from sales table, one from t1
SELECT t2.cust AS customer, -- select fields from t2, sales for final data output
       t2.min_q,
       t2.min_prod,
       t2.min_date,
       t2.min_state AS st,
       t2.max_q,
       s.prod  AS max_prod,
       s.date  AS max_date,
       s.state AS st,
       t2.avg_q
FROM   t2,
       sales s
WHERE  t2.cust = s.cust
       AND t2.max_q = s.quant; 

/* Question 2 */ --------------------------------------------------------------------------------------------
/* 2. For each year and month combination, find the “busiest” and the “slowest” day (those
days with the most and the least total sales quantities of products sold) and the
corresponding total sales quantities (i.e., SUMs).
*/

WITH t1
     AS (SELECT s.year,
                s.month,
                s.day,
                Sum(quant) AS T_sales
         FROM   sales s
         GROUP  BY s.year,
                   s.month,
                   s.day),
     t2
     AS (SELECT t1.year,
                t1.month,
                Max(t1.t_sales) AS max1, -- max sales
                Min(t1.t_sales) AS min1 -- min sales
         FROM   t1
         GROUP  BY t1.year,
                   t1.month
         ORDER  BY t1.year,
                   t1.month),
     t3
     AS (SELECT t2.year,
                t2.month,
                t1.day  AS busy_day,
                t2.max1 AS busy_totalQuant
         FROM   t1,
                t2
         WHERE  t1.year = t2.year
                AND t1.month = t2.month --match on month from t1 and t2
                AND t2.max1 = t1.t_sales --max
         ORDER  BY t1.year,
                   t1.month)
SELECT t3.year,
       t3.month,
       t3.busy_day        AS busiest_day,
       t3.busy_totalquant AS busiest_total_Q,
       t1.day             AS slowest_day,
       t2.min1            AS slowest_total_Q
FROM   t1,
       t2,
       t3
WHERE  t1.year = t3.year
       AND t1.month = t3.month ----match on month from t1 and t3
       AND t1.t_sales = t2.min1 --min

/* Question 3 */ --------------------------------------------------------------------------------------------
/* 3. For each customer, find the “most favorite” product (the product that the customer
purchased the most) and the “least favorite” product (the product that the customer
purchased the least).*/

WITH t1
     AS (SELECT DISTINCT cust
         FROM   sales),
     t2
     AS (SELECT DISTINCT prod
         FROM   sales),
     t3
     AS (SELECT DISTINCT t1.cust,
                         t2.prod
         FROM   t1,
                t2
         ORDER  BY t1.cust,
                   t2.prod),
     t4
     AS (SELECT t3.cust,
                t3.prod,
                Sum(sales.quant)
         FROM   t3
                LEFT JOIN sales using (cust, prod)
         GROUP  BY t3.cust,
                   t3.prod
         ORDER  BY t3.cust,
                   t3.prod),
     t5
     AS (SELECT t4.cust,
                Max(t4.sum),
                Min(t4.sum)
         FROM   t4
         GROUP  BY t4.cust),
     t6
     AS (SELECT t4.cust,
                t4.prod AS favProd
         FROM   t5,
                t4
         WHERE  t5.max = t4.sum),
     t7
     AS (SELECT t4.cust,
                t4.prod AS leastFavProd
         FROM   t5,
                t4
         WHERE  t4.sum = t5.min)
SELECT t6.cust         AS customer,
       t6.favprod      AS most_fav_prod,
       t7.leastfavprod AS least_fav_prod
FROM   t6,
       t7
WHERE  t6.cust = t7.cust
ORDER  BY customer 

/* Question 4 */ --------------------------------------------------------------------------------------------
/* 4. For each customer and product combination, show the average sales quantities for the
four seasons, Spring, Summer, Fall and Winter in four separate columns – Spring being
the 3 months of March, April and May; and Summer the next 3 months (June, July and
August); and so on – ignore the YEAR component of the dates (i.e., 10/25/2016 is
considered the same date as 10/25/2017, etc.).  Additionally, compute the average for the
“whole” year (again ignoring the YEAR component, meaning simply compute AVG) along
with the total quantities (SUM) and the counts (COUNT). */

WITH t1
     AS (SELECT cust,
                prod,
                Avg(quant),
                Count(quant),
                Sum(quant)
         FROM   sales
         GROUP  BY cust,
                   prod),
     t2
     AS (SELECT cust,
                prod,
                Avg(quant) AS Q1
         FROM   sales
         WHERE  month BETWEEN 1 AND 3
         GROUP  BY cust,
                   prod),
     t3
     AS (SELECT cust,
                prod,
                Avg(quant) AS Q2
         FROM   sales
         WHERE  month BETWEEN 4 AND 6
         GROUP  BY cust,
                   prod),
     t4
     AS (SELECT cust,
                prod,
                Avg(quant) AS Q3
         FROM   sales
         WHERE  month BETWEEN 7 AND 9
         GROUP  BY cust,
                   prod),
     t5
     AS (SELECT cust,
                prod,
                Avg(quant) AS Q4
         FROM   sales
         WHERE  month BETWEEN 10 AND 12
         GROUP  BY cust,
                   prod)
SELECT t1.cust AS customer,
       t1.prod AS product,
       t2.q1   AS spring_avg,
       t3.q2   AS summer_avg,
       t4.q3   AS fall_avg,
       t5.q4   AS winter_avg,
       t1.avg  AS average,
       t1.sum  AS total,
       t1.count
FROM   t1
       LEFT JOIN t2
              ON t2.cust = t1.cust
                 AND t2.prod = t1.prod
       LEFT JOIN t3
              ON t3.cust = t1.cust
                 AND t3.prod = t1.prod
       LEFT JOIN t4
              ON t4.cust = t1.cust
                 AND t4.prod = t1.prod
       LEFT JOIN t5
              ON t5.cust = t1.cust
                 AND t5.prod = t1.prod 

/* Question 5 */ --------------------------------------------------------------------------------------------
/* 5. For each product, output the maximum sales quantities for each quarter in 4 separate
columns.  Like the first report, display the corresponding dates (i.e., dates of those
corresponding maximum sales quantities). Ignore the YEAR component of the dates (i.e.,
10/25/2016 is considered the same date as 10/25/2017, etc.).
*/

WITH a1

     AS (SELECT sales.prod AS prod,
                Max(quant) AS max_quant
         FROM   sales
         WHERE  month BETWEEN 1 AND 3
         GROUP  BY prod),
     a2
     AS (SELECT sales.prod AS prod,
                Max(quant) AS max_quant
         FROM   sales
         WHERE  month BETWEEN 4 AND 6
         GROUP  BY prod),
     a3
     AS (SELECT sales.prod AS prod,
                Max(quant) AS max_quant
         FROM   sales
         WHERE  month BETWEEN 7 AND 9
         GROUP  BY prod),
     a4
     AS (SELECT sales.prod AS prod,
                Max(quant) AS max_quant
         FROM   sales
         WHERE  month BETWEEN 10 AND 12
         GROUP  BY prod),
     t1
     AS (SELECT q.prod,
                Max(q.max_quant) AS Q1Max,
                Max(sales.date)     AS date
         FROM   a1 q
                INNER JOIN sales
                        ON q.prod = sales.prod
                           AND q.max_quant = sales.quant
                           AND sales.month BETWEEN 1 AND 3
         GROUP  BY q.prod),
     t2
     AS (SELECT q.prod,
                Max(q.max_quant) AS Q2max,
                Max(sales.date)     AS date
         FROM   a2 q
                INNER JOIN sales
                        ON q.prod = sales.prod
                           AND q.max_quant = sales.quant
                           AND sales.month BETWEEN 4 AND 6
         GROUP  BY q.prod),
     t3
     AS (SELECT q.prod,
                Max(q.max_quant) AS Q3max,
                Max(sales.date)     AS date
         FROM   a3 q
                INNER JOIN sales
                        ON q.prod = sales.prod
                           AND q.max_quant = sales.quant
                           AND sales.month BETWEEN 7 AND 9
         GROUP  BY q.prod),
     t4
     AS (SELECT q.prod,
                Max(q.max_quant) AS Q4max,
                Max(sales.date)     AS date
         FROM   a4 q
                INNER JOIN sales
                        ON q.prod = sales.prod
                           AND q.max_quant = sales.quant
                           AND sales.month BETWEEN 10 AND 12
         GROUP  BY q.prod)
SELECT t1.prod  AS product,
       t1.q1max AS Q1_Max,
       t1.date,
       t2.q2max AS Q2_Max,
       t2.date,
       t3.q3max AS Q3_Max,
       t3.date,
       t4.q4max AS Q4_Max,
       t4.date
FROM   t1
       INNER JOIN t2
               ON t1.prod = t2.prod
       INNER JOIN t3
               ON t1.prod = t3.prod
       INNER JOIN t4
               ON t1.prod = t4.prod
ORDER  BY t1.prod; 
