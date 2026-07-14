with orders as (

    select *
    from {{ ref('stg_purchase_orders') }}

),

order_lines as (

    select *
    from {{ ref('stg_purchase_order_lines') }}

),

suppliers as (

    select *
    from {{ ref('stg_suppliers') }}

),

products as (

    select *
    from {{ ref('stg_products') }}

),

inspections as (

    select *
    from {{ ref('stg_inspections') }}

)

select
    order_lines.purchase_order_line_id,
    orders.purchase_order_id,
    orders.order_date,
    orders.order_status,
    orders.buyer_name,

    suppliers.supplier_id,
    suppliers.supplier_name,
    suppliers.city as supplier_city,
    suppliers.state as supplier_state,

    products.product_id,
    products.product_name,
    products.procurement_type,

    order_lines.ordered_quantity,
    order_lines.received_quantity,
    order_lines.unit_price,
    order_lines.standard_unit_price,
    order_lines.promised_delivery_date,
    order_lines.actual_delivery_date,

    inspections.inspection_date,
    coalesce(inspections.inspected_quantity, 0)
        as inspected_quantity,
    coalesce(inspections.rejected_quantity, 0)
        as rejected_quantity,
    inspections.defect_category,

    round(
        order_lines.ordered_quantity * order_lines.unit_price,
        2
    ) as order_line_value,

    round(
        order_lines.ordered_quantity *
        (
            order_lines.unit_price -
            order_lines.standard_unit_price
        ),
        2
    ) as price_variance_amount,

    case
        when order_lines.actual_delivery_date is null
            then null
        else datediff(
            day,
            order_lines.promised_delivery_date,
            order_lines.actual_delivery_date
        )
    end as days_late,

    case
        when order_lines.actual_delivery_date is null
            then null
        when order_lines.actual_delivery_date
             <= order_lines.promised_delivery_date
            then 1
        else 0
    end as is_on_time,

    case
        when inspections.inspected_quantity > 0
            then round(
                inspections.rejected_quantity
                / inspections.inspected_quantity * 100,
                2
            )
        else 0
    end as defect_rate_pct,

    case
        when orders.order_status = 'OPEN'
            then round(
                order_lines.ordered_quantity *
                order_lines.unit_price,
                2
            )
        else 0
    end as open_order_exposure

from order_lines

join orders
    on order_lines.purchase_order_id =
       orders.purchase_order_id

join suppliers
    on orders.supplier_id =
       suppliers.supplier_id

join products
    on order_lines.product_id =
       products.product_id

left join inspections
    on order_lines.purchase_order_line_id =
       inspections.purchase_order_line_id