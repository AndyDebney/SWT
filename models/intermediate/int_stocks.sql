with staged as (
    select
        _file,
        _line,
        _modified,
        _fivetran_synced,
        store_id,
        product_id,
        quantity
    from {{ ref('stg_stocks') }}
)

select
    _file as source_file,
    _line as record_line_no,
    _modified as updated_at,
    _fivetran_synced as loaded_at,
    store_id,
    product_id,
    quantity
from staged
