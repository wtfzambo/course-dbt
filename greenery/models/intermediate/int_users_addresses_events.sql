WITH

users AS (
    SELECT * FROM {{ ref('stg_postgres__users') }}
),

addresses AS (
    SELECT * FROM {{ ref('stg_postgres__addresses') }}
),

events AS (
    SELECT * FROM {{ ref('stg_postgres__events') }}
)

user_events AS (
    SELECT user_guid
         , sum(iff(event_type = 'page_view', 1, 0)) AS total_user_pageviews
         , sum(iff(event_type = 'add_to_cart', 1, 0)) AS total_user_add_to_cart
         , sum(iff(event_type = 'checkout', 1, 0)) AS total_user_checkouts
         , count(DISTINCT session_guid) AS total_user_sessions
      FROM events
     GROUP BY 1
)

SELECT
       u.user_guid
     , u.first_name
     , u.last_name
     , u.user_email
     , u.user_phone_number
     , a.address AS user_address
     , a.zipcode AS user_zipcode
     , a.state AS user_state
     , a.country AS user_country
     , u.created_at_utc AS user_created_at_utc
     , u.updated_at_utc AS user_updated_at_utc
     , e.total_user_pageviews
     , e.total_user_add_to_cart
     , e.total_user_checkouts
     , e.total_user_sessions

  FROM users AS u
       LEFT JOIN addresses AS a
       USING (address_guid)
       LEFT JOIN user_events AS e
       USING (user_guid)
