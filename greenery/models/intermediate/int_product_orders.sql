/* Is this model too long / complex? */
WITH

products AS (
    SELECT * FROM {{ ref('stg_postgres__products') }}
)

, orders AS (
    SELECT * FROM {{ ref('stg_postgres__orders') }}
)

, order_items AS (
    SELECT * FROM {{ ref('stg_postgres__order_items') }}
)

, product_daily_orders AS (
    SELECT oi.product_guid
         , date_trunc('day', o.created_at_utc) AS order_date
         , oi.quantity
      FROM order_items AS oi
           LEFT JOIN orders AS o
           USING (order_guid)
)

, daily_totals AS (
    SELECT product_guid
         , order_date
         , count(product_guid) AS daily_orders_on_product
         , sum(quantity) AS daily_total_ordered
      FROM product_daily_orders
     GROUP BY 1, 2
)

, product_stats AS (
    SELECT product_guid
         , avg(daily_orders_on_product) AS average_daily_orders
         , avg(daily_total_ordered) AS average_daily_quantity_ordered
         , sum(daily_total_ordered) AS total_product_sold
      FROM daily_totals
  GROUP BY 1
)

, final AS (
    SELECT s.product_guid
         , p.product_name
         , p.product_price
         , p.quantity_in_inventory
         , s.average_daily_orders
         , s.average_daily_quantity_ordered
         , s.total_product_sold
      FROM product_stats AS s
           LEFT JOIN products AS p
           USING (product_guid)
)

SELECT * FROM final
