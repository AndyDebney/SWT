with source_data as (
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
    from {{ source('raw', 'products') }}
)

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
from source_data
