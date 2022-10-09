WITH

addresses_source AS (
  SELECT * FROM {{ source('postgres', 'addresses') }}
),

final AS (
  SELECT 
         address_id AS address_guid
       , address
       , zipcode
       , state
       , country
    FROM addresses_source
)

SELECT * FROM final
