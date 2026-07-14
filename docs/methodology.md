# Methodology

## Reference data

Supplier, project, and product master data come from the NIST GPS Manufacturer sample dataset. They provide realistic manufacturing entities and product relationships.

## Synthetic operational data

The Snowflake scripts deterministically create 3,000 purchase orders with three lines each. They assign order dates, buyers, statuses, prices, quantities, promised dates, actual dates, and inspection outcomes. Deterministic formulas make reruns reproducible.

The generated data is designed for learning analytics engineering. It does not describe actual purchases, supplier behavior, or financial results.

## KPI definitions

- **Total spend:** sum of ordered quantity multiplied by unit price across order lines.
- **On-time delivery:** percentage of delivered order lines whose actual delivery date is on or before the promised date.
- **Defect rate:** rejected inspected units divided by total inspected units.
- **Open-order exposure:** order-line value for purchase orders with an `OPEN` status.
- **Supplier risk:** illustrative rule based on supplier on-time delivery and defect-rate thresholds.

## Validation

dbt tests check identifier uniqueness, required values, accepted order statuses, relationships between entities, and valid quantity ranges. Final output exports preserve the analysis for offline review.
