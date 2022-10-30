WITH

events AS (
    SELECT * FROM {{ ref('stg_postgres__events') }}
)

, order_items AS (
    SELECT * FROM {{ ref('stg_postgres__order_items') }}
)

, event_order_items AS (
    select 
        events.session_guid
        , events.event_type
        , events.order_guid
        , coalesce(events.product_guid, order_items.product_guid) AS product_guid
    from  events
    left join order_items ON events.order_guid = order_items.order_guid
)

, final AS (
    {%- set product_events = ['page_view', 'add_to_cart', 'checkout']%}
    select
        product_guid
        {% for product_event in product_events -%}
        , count(DISTINCT (CASE WHEN event_type = '{{product_event}}' THEN session_guid END)) AS total_sessions_with_{{product_event}}
        {% endfor -%}
    from event_order_items
    group by 1
)

select * from final
