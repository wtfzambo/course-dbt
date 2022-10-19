WITH

products AS (
    SELECT * FROM {{ ref('int_product_orders') }}
)

, product_events AS (
    SELECT * FROM {{ ref('stg_postgres__events') }}
     WHERE product_guid IS NOT null
)

, product_events_totals AS (
    SELECT product_guid
        , sum(iff(event_type = 'page_view', 1, 0)) AS total_product_pageviews
        , sum(iff(event_type = 'add_to_cart', 1, 0)) AS total_product_add_to_cart_events
    FROM product_events
    GROUP BY 1
)

, final AS (
    SELECT p.product_guid
         , p.product_name
         , p.product_price
         , p.quantity_in_inventory
         , p.average_daily_orders
         , et.total_product_pageviews
         , et.total_product_add_to_cart_events
         , p.total_product_sold
      FROM products AS p
           LEFT JOIN product_events_totals AS et
           USING (product_guid)
)

SELECT * FROM final
