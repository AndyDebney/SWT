with staged as (
    select
        _file,
        _line,
        _modified,
        _fivetran_synced,
        order_id,
        customer_id,
        order_status,
        order_date,
        required_date,
        shipped_date,
        store_id,
        staff_id
    from {{ ref('stg_orders') }}
)

select
    _file as source_file,
    _line as record_line_no,
    _modified as updated_at,
    _fivetran_synced as loaded_at,
    order_id,
    customer_id,
    order_status,
    order_date,
    required_date,
    shipped_date,
    store_id,
    staff_id
from staged
