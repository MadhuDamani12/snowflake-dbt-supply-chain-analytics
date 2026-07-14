with source_data as (

    select *
    from {{ source('raw_supply_chain', 'raw_purchase_orders') }}

),

cleaned as (

    select
        trim(purchase_order_id) as purchase_order_id,
        trim(supplier_id) as supplier_id,
        order_date,
        trim(buyer_name) as buyer_name,
        upper(trim(order_status)) as order_status
    from source_data

)

select *
from cleaned