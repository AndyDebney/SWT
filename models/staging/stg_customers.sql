select
    _file as "source_file",
    _line as "record_line_no",
    _modified as "updated_at",
    _fivetran_synced as "loaded_at",
    customer_id as "customer_id",
    first_name as "first_name",
    last_name as "last_name",
    phone as "phone",
    email as "email",
    street as "street",
    city as "city",
    state as "state",
    zip_code as "zip_code"
from {{ source('raw', 'customers') }}
