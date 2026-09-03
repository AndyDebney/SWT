with staging_data as (
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
    from {{ ref('stg_orders') }}
)

select
    source_file,
    record_line_no,
    updated_at,
    loaded_at,
    order_id,
    customer_id,
    order_status,
    order_date,
    required_date,
    shipped_date,
    store_id,
    staff_id
from staging_data

