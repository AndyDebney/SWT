with source_data as (
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
        try_to_date(shipped_date) as shipped_date,
        store_id,
        staff_id
    from {{ source('raw', 'orders') }}
)

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
from source_data
