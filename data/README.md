# Data guide

## Source files

`source/` contains the NIST GPS Manufacturer sample reference data:

- `GPS_suppliers.csv`: one row per supplier
- `GPS_projects.csv`: one row per project
- `GPS_products.csv`: one row per product or component

## Output files

`outputs/` contains exports from the final dbt marts:

- `purchase_order_analysis.csv`: 9,000 purchase-order lines plus a header row
- `supplier_performance.csv`: 29 supplier summaries plus a header row

The purchase-order, price, delivery, and inspection fields in these outputs are synthetic. The files are included so the analysis remains reviewable if the Snowflake trial account becomes unavailable.
