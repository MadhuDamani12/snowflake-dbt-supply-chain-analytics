USE ROLE ACCOUNTADMIN;
USE WAREHOUSE SUPPLY_CHAIN_WH;
USE DATABASE SUPPLY_CHAIN_ANALYTICS;
USE SCHEMA RAW;


-- Makes this synthetic-data script safely rerunnable
TRUNCATE TABLE RAW_INSPECTIONS;


INSERT INTO RAW_INSPECTIONS (
    INSPECTION_ID,
    PURCHASE_ORDER_LINE_ID,
    INSPECTION_DATE,
    INSPECTED_QUANTITY,
    REJECTED_QUANTITY,
    DEFECT_CATEGORY
)
WITH suppliers AS (
    SELECT
        ID AS SUPPLIER_ID,
        ROW_NUMBER() OVER (ORDER BY ID) AS SUPPLIER_NUMBER
    FROM RAW_SUPPLIERS
),

delivered_lines AS (
    SELECT
        lines.PURCHASE_ORDER_LINE_ID,
        lines.ACTUAL_DELIVERY_DATE,
        lines.RECEIVED_QUANTITY,
        suppliers.SUPPLIER_NUMBER,

        ROW_NUMBER() OVER (
            ORDER BY lines.PURCHASE_ORDER_LINE_ID
        ) AS INSPECTION_NUMBER

    FROM RAW_PURCHASE_ORDER_LINES AS lines
    JOIN RAW_PURCHASE_ORDERS AS orders
        ON lines.PURCHASE_ORDER_ID =
           orders.PURCHASE_ORDER_ID
    JOIN suppliers
        ON orders.SUPPLIER_ID =
           suppliers.SUPPLIER_ID

    WHERE lines.ACTUAL_DELIVERY_DATE IS NOT NULL
      AND lines.RECEIVED_QUANTITY > 0
),

inspection_rates AS (
    SELECT
        *,

        CASE
            -- Most inspections have no rejected units
            WHEN MOD(INSPECTION_NUMBER, 10) < 6
                THEN 0

            -- Selected suppliers have elevated quality risk
            WHEN MOD(SUPPLIER_NUMBER, 8) = 0
                THEN 0.05

            -- Other failures range from 1% to 3%
            ELSE
                0.01 +
                MOD(INSPECTION_NUMBER, 3) * 0.01
        END AS REJECTION_RATE

    FROM delivered_lines
),

inspection_results AS (
    SELECT
        *,
        CEIL(RECEIVED_QUANTITY * REJECTION_RATE)
            AS REJECTED_UNITS
    FROM inspection_rates
)

SELECT
    'INSP-' || PURCHASE_ORDER_LINE_ID
        AS INSPECTION_ID,

    PURCHASE_ORDER_LINE_ID,

    DATEADD(
        DAY,
        1,
        ACTUAL_DELIVERY_DATE
    ) AS INSPECTION_DATE,

    RECEIVED_QUANTITY AS INSPECTED_QUANTITY,

    REJECTED_UNITS AS REJECTED_QUANTITY,

    CASE
        WHEN REJECTED_UNITS = 0
            THEN NULL
        WHEN MOD(INSPECTION_NUMBER, 4) = 0
            THEN 'DIMENSIONAL'
        WHEN MOD(INSPECTION_NUMBER, 4) = 1
            THEN 'ELECTRICAL'
        WHEN MOD(INSPECTION_NUMBER, 4) = 2
            THEN 'COSMETIC'
        ELSE 'PACKAGING'
    END AS DEFECT_CATEGORY

FROM inspection_results;

SELECT COUNT(*) AS INVALID_INSPECTIONS
FROM RAW_INSPECTIONS
WHERE REJECTED_QUANTITY > INSPECTED_QUANTITY
   OR REJECTED_QUANTITY < 0;