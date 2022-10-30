{{-
    config(
        materialized='table'
    )
-}}
WITH

users AS (
    SELECT * FROM {{ ref('int_users_addresses_events') }}
)

, orders AS (
    SELECT * FROM {{ ref('fct_orders') }}
)

, sessions_ AS (
    SELECT * FROM {{ ref('int_session_user_events') }}
)

, orders_stats_per_user AS (
    SELECT user_guid
     , date_trunc('day', min(created_at_utc)) AS first_order_date
     , date_trunc('day', max(created_at_utc)) AS last_order_date
     , count(distinct order_guid) AS total_user_orders
     , sum(order_total) AS user_lifetime_value
  FROM orders
 GROUP BY 1
)

, sessions_stats_per_user AS (
    {%- 
        set column_names = dbt_utils.get_filtered_columns_in_relation(
            from = ref('int_session_user_events'),
            except = ["session_guid", "user_guid", "did_package_shipped"]
            ) 
    %}
    SELECT
        user_guid
        , count(distinct session_guid) as total_sessions
        {% for column_name in column_names -%}
        , sum({{column_name}}) AS total_sessions_with{{column_name[3:]}}
        {% endfor -%}
    FROM sessions_
    GROUP BY 1        
)

, final AS (
    SELECT
    {# possible to use dbt_utils.star here? #}
        users.user_guid
        , user_orders.first_order_date
        , user_orders.last_order_date
        , user_orders.total_user_orders
        , user_orders.user_lifetime_value
        , session_stats.total_sessions
        , session_stats.total_sessions_with_page_view
        , session_stats.total_sessions_with_add_to_cart
        , session_stats.total_sessions_with_checkout
      FROM users
           LEFT JOIN orders_stats_per_user AS user_orders
           ON users.user_guid = user_orders.user_guid

           LEFT JOIN sessions_stats_per_user AS session_stats
           ON users.user_guid = session_stats.user_guid
)

SELECT * FROM final
