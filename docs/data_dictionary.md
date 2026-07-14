# Data dictionary

## Purchase-order analysis mart

| Field group | Important fields | Meaning |
|---|---|---|
| Order | `purchase_order_id`, `order_date`, `order_status`, `buyer_name` | Purchase-order header attributes |
| Supplier | `supplier_id`, `supplier_name`, `supplier_city`, `supplier_state` | Supplier master attributes |
| Product | `product_id`, `product_name`, `procurement_type` | Purchased item attributes |
| Quantity and price | `ordered_quantity`, `received_quantity`, `unit_price`, `standard_unit_price` | Commercial line details |
| Delivery | `promised_delivery_date`, `actual_delivery_date`, `days_late`, `is_on_time` | Delivery performance measures |
| Quality | `inspected_quantity`, `rejected_quantity`, `defect_category`, `defect_rate_pct` | Inspection measures |
| Financial | `order_line_value`, `price_variance_amount`, `open_order_exposure` | Spend and exposure measures |

## Supplier-performance mart

| Field | Meaning |
|---|---|
| `total_orders` | Distinct purchase orders assigned to the supplier |
| `total_order_lines` | Purchase-order lines assigned to the supplier |
| `total_spend` | Sum of order-line value |
| `total_price_variance` | Actual versus standard price variance |
| `average_days_late` | Mean promised-to-actual delivery difference |
| `on_time_delivery_pct` | Percentage of delivered lines received on time |
| `defect_rate_pct` | Rejected units divided by inspected units |
| `open_order_exposure` | Value associated with open orders |
| `supplier_risk_level` | Illustrative `HIGH`, `MEDIUM`, or `LOW` classification |
