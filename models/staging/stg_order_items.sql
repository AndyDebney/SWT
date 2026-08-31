select
    _file as "source_file",
    _line as "record_line_no",
    _modified as "updated_at",
    _fivetran_synced as "loaded_at",
    order_id as "order_id",
    item_id as "item_id",
    product_id as "product_id",
    quantity as "quantity",
    list_price as "list_price",
    discount as "discount"
from {{ source('raw', 'order_items') }}
