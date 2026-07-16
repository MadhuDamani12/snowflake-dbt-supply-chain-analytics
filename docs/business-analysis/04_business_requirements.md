# Business requirements

## Prioritization method

Requirements use MoSCoW prioritization:

- **Must:** required for the decision-support prototype to be usable.
- **Should:** materially improves interpretation or control but is not essential to the first prototype.
- **Could:** valuable future enhancement.
- **Won't now:** intentionally outside the current scope.

The Excel traceability matrix is the detailed source of truth. The table below summarizes the approved case-study scope.

## Business and functional requirements

| ID | Requirement | Priority | Primary stakeholder | Current status |
|---|---|---|---|---|
| BR-001 | Provide one consolidated view of supplier spending, delivery, quality, and open-order exposure. | Must | Procurement Manager | Implemented |
| BR-002 | Enable supplier-performance comparison using consistent definitions. | Must | Procurement Manager | Implemented |
| BR-003 | Preserve transparent KPI definitions and known limitations for decision makers. | Must | All functional owners | Implemented |
| FR-001 | Calculate line value as ordered quantity multiplied by unit price. | Must | Finance Manager | Implemented |
| FR-002 | Calculate on-time delivery using only lines with an actual delivery date and treat delivery on the promised date as on time. | Must | Operations Planner | Implemented |
| FR-003 | Calculate weighted defect rate as total rejected units divided by total inspected units. | Must | Quality Manager | Implemented |
| FR-004 | Calculate open-order exposure for purchase orders with an OPEN status. | Must | Finance / Procurement | Implemented |
| FR-005 | Provide line-level detail and one supplier-level summary row per supplier. | Must | Procurement / Data Analyst | Implemented |
| FR-006 | Provide monthly ordered-value trends and supplier performance comparisons in Tableau. | Should | Procurement / Executive Sponsor | Implemented |
| FR-007 | Calculate price variance against standard unit price. | Should | Finance / Buyer | Implemented in mart |
| FR-008 | Display the component metrics behind the supplier-risk label. | Must | Procurement Manager | Implemented |
| FR-009 | Separate ordered, committed, received, invoiced, and paid value after source availability and definition approval. | Should | Finance Manager | Planned |
| FR-010 | Support supplier, product, project, buyer, status, and date drill-down after usability validation. | Should | Buyers / Operations | Planned |
| FR-011 | Replace fixed illustrative risk thresholds with approved, volume-aware thresholds. | Must before production | Procurement / Quality / Operations | Planned |

## Data-quality requirements

| ID | Requirement | Priority | Current status |
|---|---|---|---|
| DQ-001 | Primary identifiers must be complete and unique. | Must | Implemented |
| DQ-002 | Purchase orders must reference valid suppliers; lines must reference valid orders and products; inspections must reference valid lines. | Must | Implemented |
| DQ-003 | Order status must be OPEN, CLOSED, or CANCELLED. | Must | Implemented |
| DQ-004 | Ordered quantities must be positive; received quantities must be between zero and ordered quantities. | Must | Implemented |
| DQ-005 | Inspected and rejected quantities must be non-negative; rejected quantities cannot exceed inspected quantities. | Must | Implemented |
| DQ-006 | Production sources must have freshness and volume-anomaly controls. | Must before production | Planned |
| DQ-007 | Financial outputs must reconcile to the system of record and approved status treatment. | Must before production | Planned |

## Non-functional requirements

| ID | Requirement | Priority | Current status |
|---|---|---|---|
| NFR-001 | Transformations and tests must be repeatable from version-controlled code. | Must | Implemented |
| NFR-002 | Business logic must be centralized in dbt rather than duplicated across Tableau sheets. | Must | Implemented |
| NFR-003 | KPI definitions, grain, source lineage, and limitations must be documented. | Must | Implemented |
| NFR-004 | Development compute should minimize idle Snowflake usage through a small warehouse and auto-suspend. | Should | Implemented |
| NFR-005 | Production access must use least-privilege roles and separate development, test, and production environments. | Must before production | Planned |
| NFR-006 | Production builds and dashboard refreshes must be scheduled, monitored, and recoverable. | Must before production | Planned |
| NFR-007 | Sensitive pricing and supplier data must not be published to a public visualization platform. | Must before production | Planned |

## Requirement exclusions

- The prototype does not predict future delivery or defects.
- It does not initiate purchase orders or supplier corrective actions.
- It does not replace ERP, procurement, quality, or accounting systems.
- It does not establish a validated financial return on investment.

## Definition of done for a requirement

A requirement is considered implemented when:

1. Its business definition and owner are recorded.
2. The supporting source/model and output are identified.
3. Relevant automated tests pass.
4. UAT evidence matches the agreed expected result.
5. Limitations and open decisions are documented.
