WITH

orders AS (
    SELECT * FROM {{ ref('stg_postgres__orders') }}
),

promos AS (
    SELECT * FROM {{ ref('stg_postgres__promos') }}
)

SELECT
       o.order_guid
     , o.user_guid
     , o.address_guid
     , o.created_at_utc
     , o.order_cost
     , o.shipping_cost
     , o.order_total
     , o.promo_id
     , coalesce(p.promo_discount, 0) AS promo_discount
     , o.tracking_guid
     , o.shipping_service
     , o.estimated_delivery_at_utc
     , o.delivered_at_utc
     , timestampdiff('hour', o.created_at_utc, o.delivered_at_utc) AS delivery_time_in_hours
     , o.status AS order_status
  FROM orders o
       LEFT JOIN promos AS p
       USING (promo_id)
