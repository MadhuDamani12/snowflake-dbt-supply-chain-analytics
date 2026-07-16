# Business analysis case study

This folder reframes the Supplier Risk and Procurement Performance build as a business-analysis case study. The technical implementation is unchanged: Snowflake stores and processes the data, dbt applies transformation and validation logic, and Tableau presents the final marts. These documents show how the solution connects to stakeholders, requirements, decisions, acceptance criteria, and recommended actions.

## Case-study question

How can a procurement team combine fragmented supplier, purchase-order, delivery, price, and inspection data into a trusted view that helps it identify delivery risk, quality risk, and unfinished financial commitments?

## Deliverables

| Deliverable | Purpose |
|---|---|
| [Business case and scope](01_business_case_and_scope.md) | Defines the problem, objectives, scope, constraints, assumptions, and measures of success |
| [Stakeholder analysis](02_stakeholder_analysis.md) | Identifies users, decisions, information needs, influence, and engagement approach |
| [As-is and to-be process](03_as_is_to_be_process.md) | Shows the current pain points and how the proposed analytics workflow changes the process |
| [Business requirements](04_business_requirements.md) | Records business, functional, data-quality, and non-functional requirements with priorities and status |
| [User stories and acceptance criteria](05_user_stories_and_acceptance_criteria.md) | Converts stakeholder needs into testable outcomes |
| [Findings and recommendations](06_findings_and_recommendations.md) | Connects scenario results to decisions while clearly separating evidence from recommendations |
| [Decision log](07_decision_log.md) | Preserves the rationale, trade-offs, and unresolved decisions behind important KPI definitions |
| `08_requirements_traceability_and_uat.xlsx` | Links requirements to models, dashboard outputs, and UAT evidence in an auditable workbook |

## How to review the case study

1. Start with the business case and stakeholder analysis.
2. Compare the as-is and to-be workflows.
3. Review the prioritized requirements and user stories.
4. Open the traceability and UAT workbook to see how requirements connect to data models and evidence.
5. Finish with the recommendations and decision log to understand the limitations and next decisions.

## Important disclosure

Supplier, product, and project reference records come from a NIST sample dataset. Purchase orders, order lines, delivery outcomes, prices, and inspections are synthetic and deterministic. Results demonstrate analytical logic and decision framing; they do not represent the measured performance of a real company.
