with source_data as (

    select *
    from {{ source('raw_supply_chain', 'raw_purchase_order_lines') }}

),

cleaned as (

    select
        trim(purchase_order_line_id) as purchase_order_line_id,
        trim(purchase_order_id) as purchase_order_id,
        line_number,
        trim(product_id) as product_id,
        ordered_quantity,
        unit_price,
        standard_unit_price,
        promised_delivery_date,
        actual_delivery_date,
        received_quantity
    from source_data

)

select *
from cleaned