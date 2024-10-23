```
Table: Transactions

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| country       | varchar |
| state         | enum    |
| amount        | int     |
| trans_date    | date    |
+---------------+---------+
```
id is the primary key of this table.
The table has information about incoming transactions.
The state column is an enum of type ["approved", "declined"].
 

Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.

Return the result table in any order.

The query result format is in the following example.

 
```
Example 1:

Input: 
Transactions table:
+------+---------+----------+--------+------------+
| id   | country | state    | amount | trans_date |
+------+---------+----------+--------+------------+
| 121  | US      | approved | 1000   | 2018-12-18 |
| 122  | US      | declined | 2000   | 2018-12-19 |
| 123  | US      | approved | 2000   | 2019-01-01 |
| 124  | DE      | approved | 2000   | 2019-01-07 |
+------+---------+----------+--------+------------+
Output: 
+----------+---------+-------------+----------------+--------------------+-----------------------+
| month    | country | trans_count | approved_count | trans_total_amount | approved_total_amount |
+----------+---------+-------------+----------------+--------------------+-----------------------+
| 2018-12  | US      | 2           | 1              | 3000               | 1000                  |
| 2019-01  | US      | 1           | 1              | 2000               | 2000                  |
| 2019-01  | DE      | 1           | 1              | 2000               | 2000                  |
+----------+---------+-------------+----------------+--------------------+-----------------------+
```





# SOLUTION 


-- Using CTE
```
# Write your MySQL query statement below
WITH monthly_reportCTE AS (
    SELECT
        DATE_FORMAT(trans_date, '%Y-%m') AS month,
        country,
        COUNT(id) AS trans_count,
        SUM(IF(state = 'approved', 1, 0)) AS approved_count,
        SUM(amount) AS trans_total_amount,
        SUM(IF(state = 'approved', amount, 0)) AS approved_total_amount
    FROM Transactions
    GROUP BY month, country
)
SELECT * FROM monthly_reportCTE;

```


-- OTHER
```
SELECT 
    LEFT(trans_date, 7) AS month,
    country, 
    COUNT(id) AS trans_count,
    SUM(state = 'approved') AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM((state = 'approved') * amount) AS approved_total_amount
FROM 
    Transactions
GROUP BY 
    month, country;
```


-- Approach

Extract Month and Year:
Use the LEFT function to get the YYYY-MM part from the trans_date. The LEFT() function extracts a number of characters from a string (starting from left).

Group By Month and Country:
Group the transactions by the extracted month and country.

Count Transactions:
Use COUNT(id) to count all transactions per group.

Count Approved Transactions:
Use SUM(state = 'approved') to count approved transactions, leveraging the fact that boolean expressions return 1 for true and 0 for false.

Sum Total Amounts:
Use SUM(amount) to sum the transaction amounts for all transactions per group.

Sum Approved Amounts:
Use SUM((state = 'approved') * amount) to sum the transaction amounts for approved transactions, ensuring only approved amounts are summed.

