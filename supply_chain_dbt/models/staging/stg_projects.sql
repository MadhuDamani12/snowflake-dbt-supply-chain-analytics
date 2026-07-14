with source_data as (

    select *
    from {{ source('raw_supply_chain', 'raw_projects') }}

),

cleaned as (

    select
        try_to_number(trim(id))::integer as project_id,
        trim(project_level) as project_level,
        trim(name) as project_name
    from source_data

)

select *
from cleaned