# As-is and to-be process

## As-is process

```mermaid
flowchart LR
    A[Supplier master file] --> E[Manual reconciliation]
    B[Product and project files] --> E
    C[Purchase-order and delivery records] --> E
    D[Inspection records] --> E
    E --> F[Separate calculations]
    F --> G[Inconsistent supplier reviews]
    G --> H[Reactive follow-up]
```

### As-is pain points

1. Supplier, order, delivery, and quality records are reviewed separately.
2. Analysts may calculate delivery, defects, and spending differently.
3. Manual joins and spreadsheet logic are difficult to audit and repeat.
4. Open commitments can be overlooked when attention is focused only on closed orders.
5. Supplier reviews are reactive and may overemphasize price.
6. Data issues may be discovered after a report is distributed.

## To-be process implemented in the prototype

```mermaid
flowchart LR
    A[NIST reference data] --> C[Snowflake RAW]
    B[Synthetic procurement transactions] --> C
    C --> D[dbt staging and standardization]
    D --> E[dbt tests]
    E -->|Pass| F[Line and supplier marts]
    E -->|Fail| G[Investigate invalid records]
    F --> H[Tableau decision view]
    H --> I[Supplier review and follow-up]
```

### To-be improvements

- One transformation layer contains the agreed KPI logic.
- Model grain and entity relationships are explicit.
- Automated tests identify key and quantity issues before reporting.
- Procurement, operations, quality, and finance can review common measures.
- The dashboard combines executive KPIs with supplier and time-based views.
- Requirements and UAT evidence are traceable to outputs.

## Future production process

```mermaid
flowchart LR
    A[ERP / procurement system] --> D[Automated ingestion]
    B[Receipt and logistics system] --> D
    C[Quality system] --> D
    D --> E[Snowflake governed layers]
    E --> F[Scheduled dbt build and tests]
    F -->|Pass| G[Certified marts and dashboard refresh]
    F -->|Fail| H[Alert and remediation workflow]
    G --> I[Supplier review / corrective action]
    I --> J[Outcome and threshold feedback]
    J --> F
```

## Process controls

| Control point | Rule | Owner | Prototype evidence |
|---|---|---|---|
| Source completeness | Required identifiers must not be null | Data Owner | dbt `not_null` tests |
| Entity integrity | Orders, lines, products, suppliers, and inspections must relate correctly | Data Team | dbt relationship tests |
| Valid status | Order status must be OPEN, CLOSED, or CANCELLED | Procurement / Data Owner | dbt accepted-values test |
| Quantity validity | Received cannot exceed ordered; rejected cannot exceed inspected | Operations / Quality | Singular dbt test |
| KPI approval | Delivery, defect, spend, and exposure definitions require business sign-off | Functional owners | Requirements and decision log |
| Report reconciliation | Tableau results must match certified mart outputs | Data Analyst / UAT users | UAT workbook |

## Change impact

| Area | As-is behavior | To-be behavior | Adoption consideration |
|---|---|---|---|
| KPI ownership | Calculations may vary by analyst | Definitions are approved and reusable | Assign one owner per KPI |
| Supplier review | Price and anecdotal issues may dominate | Delivery, quality, value, and exposure are reviewed together | Train users to inspect components rather than only the risk label |
| Data quality | Issues are found during reporting | Tests identify issues before mart publication | Define who investigates and when reporting is paused |
| Reporting | Manual refresh and reconciliation | Repeatable transformation and dashboard output | Set refresh expectations and publish data timestamps |
| Risk classification | Informal judgement | Transparent rule as a starting point | Recalibrate with real history and minimum-volume rules |
