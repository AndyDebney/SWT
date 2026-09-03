with staging_data as (
    select
        _file as source_file,
        _line as record_line_no,
        _modified as updated_at,
        _fivetran_synced as loaded_at,
        store_id,
        product_id,
        quantity
    from {{ ref('stg_stocks') }}
)

select
    source_file,
    record_line_no,
    updated_at,
    loaded_at,
    store_id,
    product_id,
    quantity
from staging_data

