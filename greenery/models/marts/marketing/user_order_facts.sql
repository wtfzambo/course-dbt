{{
    config(
        materialized='table'
    )
}}
WITH

users AS (
    SELECT * FROM {{ ref('int_users_addresses_events') }}
)

, orders AS (
    SELECT * FROM {{ ref('fct_orders') }}
)

, orders_stats_per_user AS (
    SELECT user_guid
     , date_trunc('day', min(created_at_utc)) AS first_order_date
     , date_trunc('day', max(created_at_utc)) AS last_order_date
     , count(distinct order_guid) AS total_user_orders
     , sum(order_total) AS user_lifetime_value
  FROM orders
 GROUP BY 1
)

, final AS (
    SELECT *
      FROM users
           LEFT JOIN orders_stats_per_user
           USING (user_guid)
)

SELECT * FROM final
