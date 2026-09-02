with staged as (
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
    from {{ ref('stg_staffs') }}
)

select
    _file as source_file,
    _line as record_line_no,
    _modified as updated_at,
    _fivetran_synced as loaded_at,
    staff_id,
    first_name,
    last_name,
    email,
    phone,
    active,
    store_id,
    manager_id
from staged
