with products as (

    select
        product_id,
        supplier_ids_raw
    from {{ ref('stg_products') }}
    where supplier_ids_raw is not null

),

suppliers as (

    select
        supplier_id
    from {{ ref('stg_suppliers') }}

),

split_supplier_values as (

    select
        products.product_id,
        trim(flattened.value::varchar) as supplier_id_raw

    from products,
    lateral flatten(
        input => split(products.supplier_ids_raw, ';')
    ) as flattened

),

matched_suppliers as (

    select
        split_supplier_values.product_id,
        split_supplier_values.supplier_id_raw,
        suppliers.supplier_id as matched_supplier_id,

        case
            when suppliers.supplier_id is not null
                then 'MATCHED'
            else 'NOT_IN_SUPPLIER_MASTER'
        end as supplier_match_status

    from split_supplier_values

    left join suppliers
        on upper(split_supplier_values.supplier_id_raw)
         = upper(suppliers.supplier_id)

)

select distinct
    md5(
        product_id || '|' || supplier_id_raw
    ) as product_supplier_key,

    product_id,
    supplier_id_raw,
    matched_supplier_id,
    supplier_match_status

from matched_suppliers