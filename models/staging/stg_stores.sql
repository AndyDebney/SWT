with source_data as (
    select
        _file,
        _line,
        _modified,
        _fivetran_synced,
        store_id,
        store_name,
        phone,
        email,
        street,
        city,
        state,
        zip_code
    from {{ source('raw', 'stores') }}
)

select
    _file,
    _line,
    _modified,
    _fivetran_synced,
    store_id,
    store_name,
    phone,
    email,
    street,
    city,
    state,
    zip_code
from source_data
