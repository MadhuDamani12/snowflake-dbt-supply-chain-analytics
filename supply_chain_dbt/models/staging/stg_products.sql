with source_data as (

    select *
    from {{ source('raw_supply_chain', 'raw_products') }}

),

cleaned as (

    select
        trim(id) as product_id,
        try_to_number(trim(bom_level))::integer as bom_level,
        trim(name) as product_name,
        try_to_number(trim(project_id))::integer as project_id,
        nullif(trim(revision), '') as revision,
        nullif(trim(phase), '') as product_phase,
        nullif(trim(description), '') as product_description,
        nullif(lower(trim(unit_of_measure)), '') as unit_of_measure,
        nullif(upper(trim(procurement_type)), '') as procurement_type,
        nullif(trim(part_owner), '') as part_owner,

        coalesce(
            try_to_date(trim(creation_date), 'MM/DD/YYYY'),
            try_to_date(trim(creation_date), 'MM/DD/YY')
        ) as creation_date,

        nullif(trim(manufacturer_1), '') as manufacturer_1,
        nullif(trim(manufacturer_2), '') as manufacturer_2,
        nullif(trim(vendor_1), '') as vendor_1,
        nullif(trim(vendor_2), '') as vendor_2,

        nullif(trim(supplier_id), '') as supplier_ids_raw

    from source_data

)

select *
from cleaned