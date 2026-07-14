# Architecture and model flow

## Snowflake layers

| Layer | Purpose | Objects |
|---|---|---|
| RAW | Preserve loaded reference data and generated transactions | Suppliers, projects, products, purchase orders, order lines, inspections |
| STAGING | Clean names, types, dates, and categorical values | Six `stg_` views |
| INTERMEDIATE | Resolve reusable business relationships | Product-to-supplier mapping |
| MARTS | Provide analysis-ready business tables | Purchase-order analysis and supplier performance |

## Why dbt is used

Snowflake stores and processes the data. dbt organizes the transformation SQL into models, determines dependency order through `ref()` and `source()`, and runs automated data tests. Tableau consumes the resulting marts rather than rebuilding business logic in the visualization layer.

## Grain

- `purchase_order_analysis`: one row per purchase-order line
- `supplier_performance`: one row per supplier
- `int_product_suppliers`: one row per product and parsed supplier value
