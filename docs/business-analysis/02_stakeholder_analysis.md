# Stakeholder analysis

## Stakeholder map

| Stakeholder | Primary decision | Information needed | Influence | Interest | Engagement approach |
|---|---|---|---|---|---|
| Procurement Manager | Supplier selection, negotiation, escalation | Spend, delivery, quality, exposure, risk components | High | High | Define KPI rules, approve requirements, review UAT and recommendations |
| Buyer / Category Manager | Follow up on orders and supplier performance | Open orders, order value, delivery status, supplier detail | Medium | High | Validate usability and exception-level detail |
| Operations / Production Planner | Protect production schedules | Promised versus actual delivery, late days, affected products | High | High | Validate delivery definitions and escalation needs |
| Quality Manager | Investigate incoming-material problems | Inspected units, rejected units, defect category, supplier rate | High | High | Approve weighted defect-rate definition and quality thresholds |
| Finance Manager | Understand commitments and purchasing value | Ordered value, price variance, open exposure, status treatment | High | Medium | Approve financial terminology and reconciliation rules |
| Executive Sponsor | Monitor strategic supplier risk | Concise KPIs, trends, material exceptions, actions | High | Medium | Review outcomes and approve production investment |
| Data Owner / Steward | Maintain trustworthy master and transaction data | Completeness, relationships, accepted values, issue ownership | Medium | High | Assign data-quality ownership and remediation process |
| Data Analyst / Analytics Engineer | Deliver consistent analytical outputs | Source definitions, grain, transformations, tests, refresh rules | Medium | High | Maintain models, documentation, tests, and traceability |

## Power-interest approach

- **Manage closely:** Procurement Manager, Operations Planner, Quality Manager, Finance Manager.
- **Keep satisfied:** Executive Sponsor.
- **Keep informed:** Buyers, Data Owner, Data Analyst, and Analytics Engineer.

## Discovery questions

### Procurement

- What event should cause a supplier performance review?
- Should risk be based on fixed thresholds, peer comparison, historical baseline, or a combination?
- Should order value be analyzed by supplier, product, project, buyer, or category?

### Operations

- Is a delivery on the promised date considered on time?
- Should partial receipts be treated differently from full delivery?
- How many days late constitute an operational exception?

### Quality

- Should defect rate use rejected units, failed inspection lots, or both?
- Are defect categories comparable across suppliers and products?
- What minimum inspection volume is required before evaluating a supplier?

### Finance

- Does “spend” mean ordered, committed, received, invoiced, or paid value?
- Should cancelled orders be excluded from all financial measures?
- Should open exposure use full ordered value or only undelivered value?

### Data and technology

- What systems own supplier, order, receipt, inspection, and invoice records?
- How current must the dashboard be?
- Who can see supplier pricing and performance data?
- What should happen when a data-quality test fails?

## RACI for the prototype

| Activity | Procurement | Operations | Quality | Finance | Data Team | Executive Sponsor |
|---|---|---|---|---|---|---|
| Approve business requirements | A/R | C | C | C | C | I |
| Define delivery KPI | C | A/R | I | I | C | I |
| Define defect KPI | C | I | A/R | I | C | I |
| Define financial metrics | C | I | I | A/R | C | I |
| Build and test data models | C | C | C | C | A/R | I |
| Execute UAT | A | R | R | R | C | I |
| Approve production release | C | C | C | C | R | A |
| Monitor and improve KPIs | A/R | C | C | C | R | I |

**R:** Responsible · **A:** Accountable · **C:** Consulted · **I:** Informed
