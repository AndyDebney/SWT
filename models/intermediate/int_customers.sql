with staging_data as (
    select
        _file as source_file,
        _line as record_line_no,
        _modified as updated_at,
        _fivetran_synced as loaded_at,
        customer_id,
        first_name,
        last_name,
        phone,
        email,
        street,
        city,
        state,
        zip_code
    from {{ ref('stg_customers') }}
)

select
    source_file,
    record_line_no,
    updated_at,
    loaded_at,
    customer_id,
    first_name,
    last_name,
    phone,
    email,
    street,
    city,
    state,
    zip_code
from staging_data

