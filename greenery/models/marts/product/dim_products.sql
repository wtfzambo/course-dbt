WITH

products AS (
    SELECT * FROM {{ ref('int_product_orders') }}
)

, product_events AS (
    SELECT * FROM {{ ref('int_product_events') }}
)

, final AS (
    SELECT prods.product_guid
         , prods.product_name
         , prods.product_price
         , prods.quantity_in_inventory
         , prods.average_daily_orders
         , prods.average_daily_quantity_ordered
         , prod_events.total_sessions_with_page_view
         , prod_events.total_sessions_with_add_to_cart
         , prod_events.total_sessions_with_checkout
         , prods.total_product_sold
      FROM products AS prods
           LEFT JOIN product_events AS prod_events
           ON prods.product_guid = prod_events.product_guid
)

SELECT * FROM final
