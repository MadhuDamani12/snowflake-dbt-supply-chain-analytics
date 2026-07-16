# Findings and recommendations

## Scenario results

| Measure | Synthetic result | Interpretation |
|---|---:|---|
| Total ordered line value | $528,137,485.05 | Value placed across all order statuses; not the same as realized accounting spend |
| On-time delivery | 21.58% | Delivery performance is the dominant issue in the generated scenario |
| Defect rate | 0.96% | Aggregate incoming quality is materially stronger than delivery performance |
| Open-order exposure | $27,407,880.34 | Approximately 5.19% of total ordered line value is associated with OPEN orders |
| Supplier risk classification | 29 HIGH | The fixed threshold does not segment the generated supplier population and requires recalibration |

## Finding 1 — Delivery performance is the primary scenario risk

Only 1,748 of 8,100 delivered lines arrived on or before the promised date. The result is intentionally poor in the synthetic scenario and makes delivery performance visible as a decision problem.

**Recommended action:** Review suppliers using delivery performance alongside order value and product criticality. In a production setting, investigate carrier, lane, product, lead-time, and buyer patterns before attributing delays solely to suppliers.

## Finding 2 — Aggregate quality is stronger than delivery

The weighted defect rate is approximately 0.96%, based on rejected and inspected units. This does not mean quality is acceptable for every product or supplier; aggregate results can hide high-impact pockets.

**Recommended action:** Add minimum inspection-volume rules and drill down by supplier, product, project, and defect category. Quality stakeholders should approve thresholds based on component criticality and the cost of failure.

## Finding 3 — Open commitments deserve value-based follow-up

Open-order exposure is $27.41M in the generated scenario. A value-based view can help buyers prioritize follow-up, but exposure alone does not establish that an order is late or at risk.

**Recommended action:** Combine value with promised date, days until due, product criticality, and available inventory before prioritizing action.

## Finding 4 — The risk rule is not decision-ready

All 29 suppliers are classified HIGH because their on-time delivery rates fall below the illustrative 70% threshold. A classification that places the entire population in one category provides no prioritization.

**Recommended action:** Recalibrate risk using stakeholder risk appetite, supplier-specific history, minimum volumes, peer or category benchmarks, and separate delivery, quality, financial, and concentration components. Preserve component metrics so the score remains explainable.

## Finding 5 — “Total spend” requires a business-definition decision

The current metric sums ordered quantity multiplied by unit price for all lines, including cancelled and open orders. It is accurate as total ordered line value but should not be presented as paid or realized spend.

**Recommended action:** Rename it to **Total Ordered Value** in the next dashboard revision unless finance explicitly approves a different definition. If the required measure is actual spend, add receipt, invoice, and payment data and define status treatment.

## Prioritized recommendation backlog

| Priority | Recommendation | Business owner | Expected decision value | Evidence required |
|---|---|---|---|---|
| 1 | Approve financial terminology and treatment of cancelled/open lines | Finance + Procurement | Prevents misinterpretation of the largest KPI | ERP/accounting definitions and reconciliation |
| 2 | Recalibrate supplier-risk logic | Procurement + Operations + Quality | Produces meaningful supplier segmentation | Real history, volumes, outcomes, and risk appetite |
| 3 | Add supplier/product/project/status/date drill-down | Procurement + Operations | Improves root-cause investigation | User validation and dashboard usability testing |
| 4 | Prioritize open commitments using due date and product criticality | Procurement + Planning | Focuses follow-up on operationally material orders | Inventory, lead-time, and criticality data |
| 5 | Automate ingestion, dbt execution, tests, and alerts | Data Team | Improves timeliness and reliability | Production platform and service-level requirements |
| 6 | Add least-privilege access and environment separation | Data Governance | Protects commercial data and change control | Security and compliance requirements |

## Benefit hypotheses—not measured outcomes

A production solution could reduce manual reconciliation, improve supplier-review consistency, and focus follow-up on higher-risk orders. Those are hypotheses to validate through baseline timing, usage, action tracking, and controlled outcome measurement. This prototype does not claim realized savings, reduced defects, or improved delivery.

## Suggested production success measures

- Time required to prepare a supplier performance review
- Percentage of KPIs reconciled to approved systems of record
- Percentage of open high-value orders reviewed before promised date
- Supplier corrective actions opened and resolved
- On-time delivery and defect trends after controlling for supplier mix and order volume
- Dashboard adoption and percentage of decisions supported by documented evidence
- Data-quality failure rate and average remediation time
