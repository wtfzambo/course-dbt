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
         , prod_events.total_page_view
         , prod_events.total_add_to_cart
         , prod_events.total_checkout
         , prods.total_product_sold
      FROM products AS prods
           LEFT JOIN product_events AS prod_events
           ON prods.product_guid = prod_events.product_guid
)

SELECT * FROM final
