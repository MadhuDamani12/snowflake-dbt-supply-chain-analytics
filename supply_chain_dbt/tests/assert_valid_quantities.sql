select
    'ORDER_LINE' as record_type,
    purchase_order_line_id as record_id
from {{ ref('stg_purchase_order_lines') }}
where ordered_quantity <= 0
   or received_quantity < 0
   or received_quantity > ordered_quantity
   or unit_price < 0
   or standard_unit_price < 0

union all

select
    'INSPECTION' as record_type,
    inspection_id as record_id
from {{ ref('stg_inspections') }}
where inspected_quantity < 0
   or rejected_quantity < 0
   or rejected_quantity > inspected_quantity