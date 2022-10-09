WITH

users_source AS (
  SELECT * FROM {{ source('postgres', 'users') }}
),

final AS (
  SELECT
        user_id AS user_guid
      , first_name
      , last_name
      , email AS user_email
      , phone_number AS user_phone_number
      , created_at::TIMESTAMPNTZ AS created_at_utc
      , updated_at::TIMESTAMPNTZ AS updated_at_utc
      , address_id AS address_guid
   FROM users_source
)

SELECT * FROM final
