# Week 1 questions

## How many users do we have?
```sql
SELECT count(DISTINCT user_guid) AS user_count
  FROM stg_postgres__users
 LIMIT 10;
```
`Answer: 130`

## On average, how many orders do we receive per hour?
```sql
WITH

hourly_count AS (
  SELECT date_trunc('hour', created_at_utc) AS hour
       , count(order_guid) AS order_count
    FROM stg_postgres__orders
   GROUP BY 1
)

SELECT round(avg(order_count), 1)
  FROM hourly_count;
```
`Answer: 7.5`

## On average, how long does an order take from being placed to being delivered?
```sql
WITH

avg_delivery_time AS (
    SELECT round(avg(timestampdiff('minute', created_at_utc, delivered_at_utc))) AS delivery_time_in_minutes
      FROM stg_postgres__orders
     WHERE delivered_at_utc IS NOT null
)

SELECT floor(delivery_time_in_minutes / (60 * 24)) AS days,
       floor(delivery_time_in_minutes / 60) % 24 AS hours,
       delivery_time_in_minutes % 60 AS minutes
  FROM avg_delivery_time;
```
`Answer: 3 days, 21 hours, 24 minutes`

## How many users have only made one purchase? Two purchases? Three+ purchases?
```sql
WITH

order_count_per_user AS (
  SELECT user_guid
       , count(DISTINCT order_guid) AS order_count
    FROM stg_postgres__orders
   GROUP BY 1
)

SELECT iff(order_count>=3, '3+', order_count::VARCHAR) AS order_counts
     , count(user_guid) AS user_counts
  FROM order_count_per_user
 GROUP BY 1
 ORDER BY 1 ASC;
```
`Answer: 1 order = 25, 2 orders= 28, 3+ orders= 71`

## On average, how many unique sessions do we have per hour?
```sql
WITH

hourly_count AS (
  SELECT date_trunc('hour', created_at_utc) AS hour
       , count(DISTINCT session_guid) AS session_count
    FROM stg_postgres__events
   GROUP BY 1
)

SELECT round(avg(session_count), 1)
  FROM hourly_count;
```
`Answer: 16.3`
