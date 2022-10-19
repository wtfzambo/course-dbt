WITH

orders AS (
    SELECT * FROM {{ ref('int_orders_promos') }}
)

SELECT * FROM orders
