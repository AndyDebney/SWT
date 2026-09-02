with source_data as (
    select
        _file,
        _line,
        _modified,
        _fivetran_synced,
        store_id,
        product_id,
        quantity
    from {{ source('raw', 'stocks') }}
)

select
    _file,
    _line,
    _modified,
    _fivetran_synced,
    store_id,
    product_id,
    quantity
from source_data
