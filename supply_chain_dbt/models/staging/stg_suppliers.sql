with source_data as (

    select *
    from {{ source('raw_supply_chain', 'raw_suppliers') }}

),

cleaned as (

    select
        trim(id) as supplier_id,
        trim(name) as supplier_name,
        nullif(trim(street_address), '') as street_address,
        nullif(trim(city), '') as city,
        nullif(upper(trim(state)), '') as state,
        nullif(trim(zip), '') as zip_code,
        nullif(trim(website), '') as website,
        nullif(trim(contact_name), '') as contact_name,
        nullif(lower(trim(contact_email)), '') as contact_email,
        nullif(trim(contact_phone), '') as contact_phone
    from source_data

)

select *
from cleaned
