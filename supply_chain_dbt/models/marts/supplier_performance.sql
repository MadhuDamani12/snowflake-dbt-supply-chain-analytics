with analysis as (

    select *
    from {{ ref('purchase_order_analysis') }}

)

select
    supplier_id,
    supplier_name,
    supplier_city,
    supplier_state,

    count(distinct purchase_order_id) as total_orders,
    count(*) as total_order_lines,

    round(sum(order_line_value), 2) as total_spend,
    round(sum(price_variance_amount), 2)
        as total_price_variance,

    round(avg(days_late), 2) as average_days_late,

    round(
        avg(is_on_time) * 100,
        2
    ) as on_time_delivery_pct,

    round(
        sum(rejected_quantity)
        / nullif(sum(inspected_quantity), 0) * 100,
        2
    ) as defect_rate_pct,

    round(sum(open_order_exposure), 2)
        as open_order_exposure,

    case
        when avg(is_on_time) * 100 < 70
          or (
              sum(rejected_quantity)
              / nullif(sum(inspected_quantity), 0) * 100
          ) > 3
            then 'HIGH'

        when avg(is_on_time) * 100 < 85
          or (
              sum(rejected_quantity)
              / nullif(sum(inspected_quantity), 0) * 100
          ) > 1
            then 'MEDIUM'

        else 'LOW'
    end as supplier_risk_level

from analysis

group by
    supplier_id,
    supplier_name,
    supplier_city,
    supplier_state