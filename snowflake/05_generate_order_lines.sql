USE ROLE ACCOUNTADMIN;
USE WAREHOUSE SUPPLY_CHAIN_WH;
USE DATABASE SUPPLY_CHAIN_ANALYTICS;
USE SCHEMA RAW;


-- Makes this script safely rerunnable
TRUNCATE TABLE RAW_PURCHASE_ORDER_LINES;


INSERT INTO RAW_PURCHASE_ORDER_LINES (
    PURCHASE_ORDER_LINE_ID,
    PURCHASE_ORDER_ID,
    LINE_NUMBER,
    PRODUCT_ID,
    ORDERED_QUANTITY,
    UNIT_PRICE,
    STANDARD_UNIT_PRICE,
    PROMISED_DELIVERY_DATE,
    ACTUAL_DELIVERY_DATE,
    RECEIVED_QUANTITY
)
WITH orders AS (
    SELECT
        PURCHASE_ORDER_ID,
        SUPPLIER_ID,
        ORDER_DATE,
        ORDER_STATUS,
        ROW_NUMBER() OVER (
            ORDER BY PURCHASE_ORDER_ID
        ) - 1 AS ORDER_NUMBER
    FROM RAW_PURCHASE_ORDERS
),

suppliers AS (
    SELECT
        ID AS SUPPLIER_ID,
        ROW_NUMBER() OVER (ORDER BY ID) AS SUPPLIER_NUMBER
    FROM RAW_SUPPLIERS
),

products AS (
    SELECT
        ID AS PRODUCT_ID,
        ROW_NUMBER() OVER (ORDER BY ID) AS PRODUCT_NUMBER
    FROM RAW_PRODUCTS
),

product_count AS (
    SELECT COUNT(*) AS NUMBER_OF_PRODUCTS
    FROM products
),

line_numbers AS (
    SELECT COLUMN1::INTEGER AS LINE_NUMBER
    FROM VALUES (1), (2), (3)
),

line_seed AS (
    SELECT
        orders.PURCHASE_ORDER_ID,
        orders.ORDER_NUMBER,
        orders.ORDER_DATE,
        orders.ORDER_STATUS,
        suppliers.SUPPLIER_NUMBER,
        line_numbers.LINE_NUMBER,

        MOD(
            orders.ORDER_NUMBER * 3 +
            line_numbers.LINE_NUMBER * 7,
            product_count.NUMBER_OF_PRODUCTS
        ) + 1 AS SELECTED_PRODUCT_NUMBER

    FROM orders
    JOIN suppliers
        ON orders.SUPPLIER_ID = suppliers.SUPPLIER_ID
    CROSS JOIN product_count
    CROSS JOIN line_numbers
),

line_details AS (
    SELECT
        line_seed.*,
        products.PRODUCT_ID,

        50 + MOD(
            line_seed.ORDER_NUMBER * 37 +
            line_seed.LINE_NUMBER * 101,
            951
        ) AS ORDERED_QUANTITY,

        15 + MOD(
            products.PRODUCT_NUMBER * 113,
            1985
        ) / 10.0 AS STANDARD_UNIT_PRICE,

        14 + MOD(
            line_seed.ORDER_NUMBER +
            line_seed.LINE_NUMBER * 7,
            31
        ) AS PROMISED_LEAD_DAYS,

        MOD(
            line_seed.ORDER_NUMBER * 3 +
            line_seed.LINE_NUMBER * 5,
            16
        ) - 3
        +
        CASE
            WHEN MOD(line_seed.SUPPLIER_NUMBER, 7) = 0
                THEN 8
            ELSE 0
        END AS DELIVERY_VARIANCE_DAYS

    FROM line_seed
    JOIN products
        ON products.PRODUCT_NUMBER =
           line_seed.SELECTED_PRODUCT_NUMBER
)

SELECT
    PURCHASE_ORDER_ID
        || '-L'
        || LPAD(LINE_NUMBER::VARCHAR, 2, '0')
        AS PURCHASE_ORDER_LINE_ID,

    PURCHASE_ORDER_ID,
    LINE_NUMBER,
    PRODUCT_ID,
    ORDERED_QUANTITY,

    ROUND(
        STANDARD_UNIT_PRICE *
        (
            0.94 +
            MOD(
                ORDER_NUMBER + LINE_NUMBER * 11,
                130
            ) / 1000.0
        ),
        2
    ) AS UNIT_PRICE,

    ROUND(STANDARD_UNIT_PRICE, 2)
        AS STANDARD_UNIT_PRICE,

    DATEADD(
        DAY,
        PROMISED_LEAD_DAYS,
        ORDER_DATE
    ) AS PROMISED_DELIVERY_DATE,

    CASE
        WHEN ORDER_STATUS IN ('OPEN', 'CANCELLED')
            THEN NULL
        ELSE DATEADD(
            DAY,
            PROMISED_LEAD_DAYS + DELIVERY_VARIANCE_DAYS,
            ORDER_DATE
        )
    END AS ACTUAL_DELIVERY_DATE,

    CASE
        WHEN ORDER_STATUS IN ('OPEN', 'CANCELLED')
            THEN 0
        WHEN MOD(ORDER_NUMBER + LINE_NUMBER, 13) = 0
            THEN ORDERED_QUANTITY -
                 CEIL(ORDERED_QUANTITY * 0.05)
        ELSE ORDERED_QUANTITY
    END AS RECEIVED_QUANTITY

FROM line_details;