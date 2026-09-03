with source_data as (
    select
        _file,
        _line,
        _modified,
        _fivetran_synced,
        staff_id,
        first_name,
        last_name,
        email,
        phone,
        active,
        store_id,
        manager_id
    from {{ source('raw', 'staffs') }}
)

select
    _file,
    _line,
    _modified,
    _fivetran_synced,
    staff_id,
    first_name,
    last_name,
    email,
    phone,
    active,
    store_id,
    manager_id
from source_data
