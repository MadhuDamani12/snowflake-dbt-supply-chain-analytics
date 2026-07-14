# Supplier Risk and Procurement Performance

## The problem—in simple words

Imagine a company like **Apple** making a new phone. Apple cannot build the phone alone. It buys screens, batteries, chips, cameras, and many other parts from different suppliers.

Now imagine three things happen:

- The screen supplier delivers two weeks late.
- The battery supplier delivers on time, but some batteries are defective.
- A large chip order is still unfinished, leaving millions of dollars tied to an open order.

A supplier may offer a low price and still cost the company money through delays, defects, and unfinished orders. A procurement manager therefore needs to know more than **“Who is cheapest?”**

The manager needs to ask:

1. How much are we spending?
2. Are suppliers delivering on time?
3. Are the delivered products passing inspection?
4. How much money is connected to unfinished orders?
5. Which suppliers may need attention?

This project builds a simple data system to answer those questions.

> **Important:** Apple is only an easy-to-understand example. This project does not contain Apple data. Supplier and product reference files come from a NIST sample dataset, while the purchase orders, deliveries, prices, and inspections are synthetic.

## What I built

I built a small end-to-end analytics pipeline:

```text
Supplier, product, and purchasing data
                  ↓
        Snowflake stores the data
                  ↓
    dbt cleans, joins, tests, and calculates
                  ↓
      Tableau shows the final dashboard
```

[View the interactive Tableau dashboard](https://public.tableau.com/views/SupplierRiskandProcurementPerformance/Dashboard1?:showVizHome=no)

![Supplier Risk and Procurement Performance dashboard](dashboard/supplier_risk_dashboard.png)

## What each tool does

### Snowflake: the organized storage room

Snowflake is a cloud data warehouse. Think of it as a large, organized storage room for data.

In this project, Snowflake stores:

- Suppliers
- Products and projects
- Purchase orders
- Individual items within each order
- Promised and actual delivery dates
- Quality-inspection results

The data is separated into layers:

- **RAW:** the original loaded and generated data
- **STAGING:** cleaned and consistently named data
- **INTERMEDIATE:** reusable relationships between data
- **MARTS:** final tables prepared for business analysis

### dbt: the recipe book and quality checker

Raw data is rarely ready for a dashboard. Names may be inconsistent, related information may be stored in different tables, and invalid records may exist.

dbt tells Snowflake how to transform that raw data. In this project, dbt:

- Cleans supplier and product information
- Connects orders to the correct suppliers and products
- Calculates spend and price variance
- Compares promised and actual delivery dates
- Calculates delivery and defect rates
- Calculates open-order exposure
- Tests for missing IDs, duplicate IDs, broken relationships, and impossible quantities

dbt does not replace Snowflake. **Snowflake performs and stores the work; dbt organizes the transformation logic and tests.**

### Tableau: the picture of the answer

Tableau connects to the final analysis tables and presents the results visually. A procurement manager can understand the major risks without reading thousands of database rows.

## The data story

Suppose one purchase order contains 1,000 batteries:

```text
Promised delivery: March 1
Actual delivery:   March 8
Inspected units:   1,000
Rejected units:    20
```

dbt turns those facts into useful information:

- The order arrived **7 days late**.
- It was **not delivered on time**.
- Its defect rate was **2%** because 20 of 1,000 inspected units were rejected.

The same calculation is repeated across all order lines. The results can then be grouped by supplier and displayed in Tableau.

## Main measurements

| Measurement | Simple meaning |
|---|---|
| **Total spend** | Total value of all ordered products |
| **On-time delivery** | Percentage of delivered order lines received by the promised date |
| **Defect rate** | Rejected units divided by inspected units |
| **Open-order exposure** | Value of orders that are still open |
| **Supplier risk** | A simple classification based on delivery and quality performance |

## Results from this synthetic scenario

| KPI | Result |
|---|---:|
| Total procurement spend | $528.14M |
| On-time delivery | 21.58% |
| Defect rate | 0.96% |
| Open-order exposure | $27.41M |

These are results from a **fictional learning scenario**, not real company results. The low on-time rate creates an obvious delivery problem that can be explored in the dashboard.

## How the tables connect

```text
SUPPLIERS ──< PURCHASE ORDERS ──< ORDER LINES >── PRODUCTS
                                      │
                                      └── INSPECTIONS
```

- One supplier can receive many purchase orders.
- One purchase order can contain many order lines.
- Each order line identifies a product.
- A delivered order line can have a quality inspection.

dbt joins these pieces into `purchase_order_analysis`, where each row represents one purchase-order line. It then summarizes those rows into `supplier_performance`, where each row represents one supplier.

## What I learned

This project was created to understand the basic modern analytics workflow—not to imitate a senior data-engineering platform.

Through the project, I learned:

- How Snowflake warehouses, databases, schemas, and tables are organized
- How CSV data is loaded into Snowflake
- Why raw data should be separated from final reporting tables
- How dbt models transform data with SQL
- How `source()` points to raw tables
- How `ref()` connects dbt models and controls build order
- How dbt tests detect missing, duplicate, unrelated, or invalid data
- How a final dbt mart becomes a Tableau data source
- How raw files become a business dashboard

The project intentionally does **not** include Airflow, machine learning, APIs, or complicated cloud infrastructure. Those tools are not necessary for understanding this workflow.

## Project structure

```text
snowflake/
  SQL scripts that create the environment, tables, and synthetic records

supply_chain_dbt/
  dbt staging, intermediate, and mart models plus data tests

data/source/
  NIST GPS supplier, project, and product sample files

data/outputs/
  CSV exports of the final dbt analysis tables

dashboard/
  Tableau dashboard image and public-dashboard link

docs/
  Architecture, methodology, and data dictionary
```

## How to reproduce it

1. Create or open a Snowflake account.
2. Run the SQL files in `snowflake/` in numeric order.
3. After script 02, load the three files from `data/source/`:
   - `GPS_suppliers.csv` into `RAW_SUPPLIERS`
   - `GPS_projects.csv` into `RAW_PROJECTS`
   - `GPS_products.csv` into `RAW_PRODUCTS`
4. Run scripts 03–06 to create the synthetic purchase orders, order lines, and inspections.
5. Copy `supply_chain_dbt/profiles.example.yml` to your dbt profiles location and update its settings if needed.
6. Run the dbt project:

   ```bash
   dbt run --target dev
   dbt test --target dev
   ```

7. Connect Tableau to the final marts, or use the included CSV exports.

The Snowflake trial may expire, but the SQL, dbt code, output files, dashboard image, and documentation remain available in this repository.

## How I would explain it in an interview

> Procurement teams cannot evaluate suppliers using price alone because late deliveries, defective products, and unfinished orders can create additional cost and risk. I built this academic project to understand a modern analytics workflow. I stored supplier and purchasing data in Snowflake, used dbt to clean and connect the data, calculated and tested procurement KPIs, and presented the final results in Tableau. The transactions are synthetic, so the project demonstrates the technical process rather than claiming real company findings.

## Limitations

- The operational transactions are synthetic.
- The supplier-risk rules are simple learning rules, not a production risk model.
- The dashboard demonstrates analysis techniques and should not be used for real purchasing decisions.
- Tableau Public is public and should never contain confidential company data.

## Author

Madhu Damani
