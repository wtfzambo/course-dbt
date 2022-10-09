{% snapshot orders_snapshot %}

{{
  config(
    target_database = target.database,
    target_schema = target.schema,
    strategy='check',
    unique_key='order_guid',
    check_cols=['status'],
   )
}}

/*
All shit below was already defined in
./models/staging/stg_postgres__orders.sql. Is there a way to avoid
repeating oneself?
*/

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


{% endsnapshot %}
