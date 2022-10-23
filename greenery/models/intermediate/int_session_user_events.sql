WITH

events AS (
    SELECT * FROM {{ ref('stg_postgres__events') }}
)

, final AS (
    {%- set event_types = dbt_utils.get_column_values(table=ref('stg_postgres__events'), column='event_type') %}
    select
        session_guid
        , user_guid
        {% for event_type in event_types -%}
        , sum(case when event_type = '{{event_type}}' then 1 else 0 end) as total_{{event_type}}
        {% endfor -%}
    from events
    group by 1, 2
)

select * from final