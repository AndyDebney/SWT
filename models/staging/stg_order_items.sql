with source_data as (
    select
        _file,
        _line,
        _modified,
        _fivetran_synced,
        order_id,
        item_id,
        product_id,
        quantity,
        list_price,
        discount
    from {{ source('raw', 'order_items') }}
)

select
    _file,
    _line,
    _modified,
    _fivetran_synced,
    order_id,
    item_id,
    product_id,
    quantity,
    list_price,
    discount
from source_data
