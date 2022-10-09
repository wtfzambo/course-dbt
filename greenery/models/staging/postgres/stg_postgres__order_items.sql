WITH

order_items_source AS (
  SELECT * FROM {{ source('postgres', 'order_items') }}
),

final AS (
  SELECT
        order_id AS order_guid
      , product_id AS product_guid
      , quantity
    FROM order_items_source
)

SELECT * FROM final
