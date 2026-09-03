with staging_data as (
    select
        _file as source_file,
        _line as record_line_no,
        _modified as updated_at,
        _fivetran_synced as loaded_at,
        order_id,
        item_id,
        product_id,
        quantity,
        list_price,
        discount
    from {{ ref('stg_order_items') }}
)

select
    source_file,
    record_line_no,
    updated_at,
    loaded_at,
    order_id,
    item_id,
    product_id,
    quantity,
    list_price,
    discount
from staging_data

