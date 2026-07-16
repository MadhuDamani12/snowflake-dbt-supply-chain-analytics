# Decision log

The decision log records why important choices were made and which choices still require stakeholder approval.

| ID | Decision | Status | Rationale | Trade-off / follow-up | Owner |
|---|---|---|---|---|---|
| DEC-001 | Use one row per purchase-order line as the detailed mart grain. | Accepted for prototype | Preserves product, quantity, delivery, price, and inspection detail while supporting aggregation. | Users must avoid double-counting purchase-order headers when counting orders. | Data Team |
| DEC-002 | Calculate supplier defect rate as total rejected units divided by total inspected units. | Accepted for prototype | Produces a volume-weighted rate; large inspections contribute proportionally. | Add minimum-volume rules and product criticality before supplier evaluation. | Quality Manager |
| DEC-003 | Include only delivered lines in on-time delivery. | Accepted for prototype | Open/cancelled lines have no actual delivery date and should not be counted as late deliveries. | A separate open-order aging metric is needed for unfinished commitments. | Operations Planner |
| DEC-004 | Treat delivery on the promised date as on time. | Accepted for prototype | Matches the common business interpretation of “on or before promise.” | Confirm cut-off time, partial receipt, and timezone rules in production. | Operations Planner |
| DEC-005 | Define open-order exposure as full ordered line value when order status is OPEN. | Accepted for prototype | Provides a simple view of value associated with unfinished orders. | Production may require only undelivered value and due-date aging. | Procurement + Finance |
| DEC-006 | Use fixed delivery and defect thresholds for an illustrative risk label. | Prototype only | Demonstrates transparent rule-based classification. | All suppliers become HIGH; recalibration is mandatory before operational use. | Procurement Manager |
| DEC-007 | Use deterministic synthetic operational transactions. | Accepted for learning scope | Makes the scenario reproducible without exposing company data. | Results cannot support claims about actual supplier performance or savings. | Project Owner |
| DEC-008 | Export mart data to CSV for Tableau portability. | Accepted for prototype | Keeps the dashboard usable after the Snowflake trial ends. | Production should use a governed live or scheduled connection. | Data Team |
| DEC-009 | Label the current sum of all order-line values as “total spend.” | Open—rename recommended | This was the original dashboard terminology. | Finance should approve a definition; “Total Ordered Value” is more accurate because cancelled/open lines are included. | Finance Manager |
| DEC-010 | Keep business logic in dbt rather than reproducing it in Tableau. | Accepted | Centralizes definitions, improves testability, and creates reusable marts. | Tableau should contain presentation calculations only where practical. | Data Team |
| DEC-011 | Omit orchestration, CI/CD, and production security from the learning build. | Accepted for prototype | Keeps the scope focused on understanding Snowflake, dbt, SQL, and Tableau. | These capabilities become mandatory in the production roadmap. | Project Owner |

## Open decisions before production

1. What does the organization mean by spend: ordered, committed, received, invoiced, or paid value?
2. Should cancelled orders be excluded from all reporting or retained for cancellation analysis?
3. Should exposure use full line value or only the outstanding undelivered quantity?
4. What minimum delivery and inspection volumes are required before rating a supplier?
5. Should supplier risk use fixed thresholds, historical baselines, peer categories, or a weighted score?
6. Which system owns each KPI and who approves changes?
7. What refresh frequency, availability target, and failure-notification process are required?
8. Which users can access supplier pricing, quality, and performance data?
