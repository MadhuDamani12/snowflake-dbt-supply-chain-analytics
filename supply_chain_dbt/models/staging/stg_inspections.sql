with source_data as (

    select *
    from {{ source('raw_supply_chain', 'raw_inspections') }}

),

cleaned as (

    select
        trim(inspection_id) as inspection_id,
        trim(purchase_order_line_id) as purchase_order_line_id,
        inspection_date,
        inspected_quantity,
        rejected_quantity,
        nullif(upper(trim(defect_category)), '') as defect_category
    from source_data

)

select *
from cleaned