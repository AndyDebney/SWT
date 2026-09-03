with staging_data as (
    select
        _file as source_file,
        _line as record_line_no,
        _modified as updated_at,
        _fivetran_synced as loaded_at,
        product_id,
        product_name,
        brand_id,
        category_id,
        model_year,
        list_price
    from {{ ref('stg_products') }}
)

select
    source_file,
    record_line_no,
    updated_at,
    loaded_at,
    product_id,
    product_name,
    brand_id,
    category_id,
    model_year,
    list_price
from staging_data

