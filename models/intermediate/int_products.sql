with staged as (
    select
        _file,
        _line,
        _modified,
        _fivetran_synced,
        product_id,
        product_name,
        brand_id,
        category_id,
        model_year,
        list_price
    from {{ ref('stg_products') }}
)

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
from staged
