WITH

products_source AS (
  SELECT * FROM {{ source('postgres', 'products') }}
),

final AS (
  SELECT
        product_id AS product_guid
      , name AS product_name
      , price AS product_price
      , inventory AS quantity_in_inventory
   FROM products_source
)

SELECT * FROM final
