USE ROLE ACCOUNTADMIN;
USE WAREHOUSE SUPPLY_CHAIN_WH;
USE DATABASE SUPPLY_CHAIN_ANALYTICS;
USE SCHEMA RAW;


/*
This clears only the synthetic purchase-order table so the script
can be rerun without creating duplicate records.
*/
TRUNCATE TABLE RAW_PURCHASE_ORDERS;


/*
Generate 3,000 fictional purchase orders.

Supplier IDs come from the real NIST supplier reference table.
Dates, buyers, and statuses are generated deterministically.
*/
INSERT INTO RAW_PURCHASE_ORDERS (
    PURCHASE_ORDER_ID,
    SUPPLIER_ID,
    ORDER_DATE,
    BUYER_NAME,
    ORDER_STATUS
)
WITH suppliers AS (
    SELECT
        ID AS SUPPLIER_ID,
        ROW_NUMBER() OVER (ORDER BY ID) AS SUPPLIER_NUMBER
    FROM RAW_SUPPLIERS
),
supplier_count AS (
    SELECT COUNT(*) AS NUMBER_OF_SUPPLIERS
    FROM suppliers
),
order_sequence AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1 AS ORDER_NUMBER
    FROM TABLE(GENERATOR(ROWCOUNT => 3000))
)
SELECT
    'PO-' || LPAD((ORDER_NUMBER + 10001)::VARCHAR, 5, '0')
        AS PURCHASE_ORDER_ID,

    suppliers.SUPPLIER_ID,

    DATEADD(
        DAY,
        MOD(ORDER_NUMBER * 17, 1000),
        '2023-01-01'::DATE
    ) AS ORDER_DATE,

    CASE MOD(ORDER_NUMBER, 5)
        WHEN 0 THEN 'Alex Morgan'
        WHEN 1 THEN 'Jordan Lee'
        WHEN 2 THEN 'Priya Shah'
        WHEN 3 THEN 'Daniel Kim'
        ELSE 'Sofia Martinez'
    END AS BUYER_NAME,

    CASE
        WHEN MOD(ORDER_NUMBER, 20) = 0 THEN 'CANCELLED'
        WHEN MOD(ORDER_NUMBER, 10) = 0 THEN 'OPEN'
        ELSE 'CLOSED'
    END AS ORDER_STATUS

FROM order_sequence
CROSS JOIN supplier_count
JOIN suppliers
    ON suppliers.SUPPLIER_NUMBER =
       MOD(order_sequence.ORDER_NUMBER, supplier_count.NUMBER_OF_SUPPLIERS) + 1;

SELECT
    COUNT(*) AS TOTAL_ROWS,
    COUNT(DISTINCT PURCHASE_ORDER_ID) AS UNIQUE_ORDER_IDS
FROM RAW_PURCHASE_ORDERS;