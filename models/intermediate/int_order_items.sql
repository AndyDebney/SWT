select
    _file as "source_file",
    _line as "record_line_no",
    _modified as "updated_at",
    _fivetran_synced as "loaded_at",
    order_id,
    item_id,
    product_id,
    quantity,
    list_price,
    discount
from {{ ref('stg_order_items') }}
