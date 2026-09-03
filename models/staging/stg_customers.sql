with source_data as (
    select
        _file,
        _line,
        _modified,
        _fivetran_synced,
        customer_id,
        first_name,
        last_name,
        phone,
        email,
        street,
        city,
        state,
        zip_code
    from {{ source('raw', 'customers') }}
)

select
    _file,
    _line,
    _modified,
    _fivetran_synced,
    customer_id,
    first_name,
    last_name,
    phone,
    email,
    street,
    city,
    state,
    zip_code
from source_data
