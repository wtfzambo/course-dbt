WITH

orders_source AS (
  SELECT * FROM {{ source('postgres', 'orders') }}
),

final AS (
SELECT
       order_id AS order_guid
     , promo_id AS promo_guid
     , user_id AS user_guid
     , address_id AS address_guid
     , created_at::TIMESTAMPNTZ AS created_at_utc
     , order_cost
     , shipping_cost
     , order_total
     , tracking_id AS tracking_guid
     , shipping_service
     , estimated_delivery_at::TIMESTAMPNTZ AS estimated_delivery_at_utc
     , delivered_at::TIMESTAMPNTZ AS delivered_at_utc
     , status
  FROM orders_source
)

SELECT * FROM final
