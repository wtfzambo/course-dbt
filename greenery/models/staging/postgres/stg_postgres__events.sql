WITH

events_source AS (
  SELECT * FROM {{ source('postgres', 'events') }}
),

final AS (
  SELECT
         event_id AS event_guid
       , session_id AS session_guid
       , user_id AS user_guid
       , event_type
       , page_url
       , created_at::TIMESTAMPNTZ AS created_at_utc
       , order_id AS order_guid
       , product_id AS product_guid
    FROM events_source
)

SELECT * FROM final
