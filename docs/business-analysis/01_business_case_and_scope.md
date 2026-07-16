# Business case and scope

## Executive summary

An electronics manufacturer may purchase screens, batteries, microcontrollers, and other components from many suppliers. Selecting a supplier on price alone can hide delivery delays, quality failures, and unfinished purchase-order commitments. The information needed to assess those risks is often distributed across master data, purchase orders, order lines, delivery dates, and inspection records.

This case study defines a consolidated supplier-performance view that enables procurement, operations, quality, and finance stakeholders to work from common KPI definitions. The implemented learning solution uses Snowflake, dbt, SQL, and Tableau. It is a decision-support prototype, not a production procurement platform.

## Problem statement

The procurement team lacks a single trusted view of supplier performance. Manual reconciliation creates inconsistent definitions, slow follow-up, and limited visibility into whether low prices are accompanied by late deliveries, rejected units, or open commitments.

## Business objective

Create an analysis-ready view that helps stakeholders answer five questions:

1. What is the value of purchase-order lines placed with suppliers?
2. Are delivered lines arriving on or before their promised dates?
3. What percentage of inspected units is rejected?
4. How much purchase-order value remains associated with open orders?
5. Which suppliers warrant further review based on delivery and quality indicators?

## Decisions supported

- Which suppliers require escalation or a performance review?
- Where should buyers investigate late-delivery patterns?
- Which open commitments deserve follow-up based on value exposure?
- Where should quality teams investigate rejected quantities?
- Which KPI definitions must procurement and finance approve before production use?

## In scope

- Supplier, project, and product reference data
- Synthetic purchase orders, purchase-order lines, deliveries, prices, and inspections
- Batch data storage and transformation in Snowflake and dbt
- Line-level and supplier-level analytical marts
- Spend, delivery, quality, price-variance, exposure, and illustrative risk metrics
- Tableau dashboard and offline CSV outputs
- Data-quality tests for identifiers, relationships, accepted values, and quantity ranges
- BA artifacts covering requirements, process design, traceability, UAT, and recommendations

## Out of scope

- Live ERP, procurement, or supplier-portal integration
- Real-time ingestion and workflow notifications
- Contract, payment, invoice, lead-time, or inventory optimization
- Statistical validation of supplier-risk thresholds
- Supplier corrective-action workflow
- Production identity management, row-level security, or confidential data controls
- Measured cost savings, supplier improvement, or operational impact

## Assumptions

- A purchase-order line has one supplier through its purchase-order header and one product.
- On-time delivery applies only when an actual delivery date exists.
- Defect rate is weighted by units: total rejected units divided by total inspected units.
- Open-order exposure includes line value only when the purchase-order status is `OPEN`.
- Risk thresholds are illustrative and require business calibration before operational use.
- The current `total_spend` metric is total ordered line value across all statuses, not realized accounting spend.

## Constraints

- Operational records are synthetic, so recommendations are scenario-based.
- Tableau uses exported mart data, providing portability but not a governed live production connection.
- The learning build uses manual execution and does not include orchestration, CI/CD, or monitoring.
- The Snowflake trial environment and broad development role are not a production security design.

## Measures of success

The prototype is successful when:

- Stakeholders can find the five core metrics in one view.
- KPI definitions are documented and traceable to dbt models.
- The line mart contains one row per purchase-order line and the supplier mart contains one row per supplier.
- Automated tests identify invalid keys, relationships, statuses, and quantity ranges.
- Tableau results reconcile with the approved Snowflake/dbt outputs.
- Limitations and unresolved business-definition decisions are visible rather than hidden.

These measures evaluate solution quality. They do not claim that the prototype produced real savings or supplier-performance improvements.

## Principal risks and responses

| Risk | Potential effect | Response |
|---|---|---|
| Inconsistent KPI definitions | Conflicting reports and decisions | Maintain a KPI catalog and decision log; obtain procurement and finance approval |
| Synthetic scenario mistaken for company results | Misleading business claims | Label synthetic results throughout the repository and dashboard documentation |
| Risk thresholds classify every supplier as HIGH | No useful prioritization | Treat the current label as diagnostic evidence and recalibrate with real distributions and risk appetite |
| Cancelled lines included in total ordered value | Metric may be interpreted as realized spend | Rename the metric or exclude cancelled/open lines after stakeholder approval |
| Manual refresh | Stale reporting and operational delay | Add scheduled ingestion, dbt jobs, freshness checks, and notifications in a production release |
| Broad development access | Excessive privileges | Implement least-privilege roles and environment separation before production deployment |
