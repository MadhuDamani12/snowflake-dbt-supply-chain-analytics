# User stories and acceptance criteria

## US-001 — Consolidated supplier review

**As a procurement manager, I want to compare supplier delivery, quality, ordered value, and open exposure so that I can identify suppliers requiring review.**

Acceptance criteria:

- Each supplier appears once in the supplier-performance mart.
- The component metrics remain visible rather than being replaced by only a risk label.
- Metrics use the approved delivery, quality, and exposure definitions.
- A user can identify suppliers with weaker performance for further investigation.

## US-002 — Delivery performance

**As an operations planner, I want to compare promised and actual delivery dates so that I can identify schedule risk.**

Acceptance criteria:

- Delivery on or before the promised date is counted as on time.
- Lines without an actual delivery date are excluded from the on-time denominator.
- `days_late` is calculated as actual date minus promised date.
- The synthetic scenario reconciles to 1,748 on-time delivered lines out of 8,100 delivered lines, or 21.58%.

## US-003 — Incoming quality

**As a quality manager, I want a weighted supplier defect rate so that large and small inspections contribute proportionally.**

Acceptance criteria:

- Defect rate equals total rejected units divided by total inspected units.
- Rejected quantity cannot exceed inspected quantity.
- A zero inspected denominator does not cause a calculation failure.
- The synthetic scenario reconciles to 40,762 rejected units out of 4,241,165 inspected units, or approximately 0.96%.

## US-004 — Open commitments

**As a finance or procurement manager, I want to see the value associated with open purchase orders so that high-value unfinished commitments can be reviewed.**

Acceptance criteria:

- Only purchase orders with an `OPEN` status contribute to open-order exposure.
- Exposure is calculated from ordered quantity multiplied by unit price.
- Closed and cancelled orders contribute zero to this KPI.
- The synthetic scenario reconciles to $27,407,880.34.

## US-005 — Ordered-value visibility

**As a finance manager, I want the financial measure clearly defined so that users do not confuse ordered value with accounting spend.**

Acceptance criteria:

- The current calculation is documented as total ordered line value.
- Users are told that it includes OPEN, CLOSED, and CANCELLED order lines.
- Before production, stakeholders decide whether cancelled lines should be excluded and whether received, invoiced, or paid value is required.

## US-006 — Data trust

**As a data owner, I want automated data-quality controls so that invalid records are identified before reporting.**

Acceptance criteria:

- Required keys are tested for completeness and uniqueness.
- Entity relationships are tested for orphaned records.
- Status values are restricted to the approved list.
- Received quantity cannot exceed ordered quantity.
- Rejected quantity cannot exceed inspected quantity.

## US-007 — Consistent reporting logic

**As a data analyst, I want KPI logic maintained in dbt so that Tableau and offline outputs use the same definitions.**

Acceptance criteria:

- Tableau uses the final marts or their exported outputs.
- Line-level logic is built once in `purchase_order_analysis`.
- Supplier-level aggregation is built from the line mart.
- Tableau totals reconcile to certified mart outputs.

## US-008 — Transparent supplier risk

**As a procurement manager, I want to understand why a supplier receives a risk classification so that I can take an appropriate action.**

Acceptance criteria:

- The risk label is accompanied by on-time delivery, defect rate, and exposure metrics.
- The thresholds are documented as illustrative.
- The current result that all 29 suppliers are HIGH risk is treated as a calibration problem, not as proof that every supplier is unacceptable.
- Production thresholds require stakeholder approval, minimum-volume rules, and historical validation.

## US-009 — Repeatable refresh

**As an analytics engineer, I want reproducible transformations and tests so that the solution can be rebuilt consistently.**

Acceptance criteria:

- SQL and dbt code are version controlled.
- `source()` and `ref()` establish lineage and build order.
- Re-running the deterministic generation scripts produces the intended scenario structure.
- Production implementation adds scheduling, environment promotion, monitoring, and failure alerts.

## US-010 — Executive interpretation

**As an executive sponsor, I want a concise dashboard and decision summary so that I can understand the main exposure and the action required.**

Acceptance criteria:

- The dashboard presents ordered value, on-time delivery, defect rate, and open exposure prominently.
- Trend and supplier views provide supporting context.
- Results are labeled as synthetic.
- The decision summary distinguishes findings, interpretations, recommendations, and limitations.
