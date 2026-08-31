select
    _file as "source_file",
    _line as "record_line_no",
    _modified as "updated_at",
    _fivetran_synced as "loaded_at",
    staff_id as "staff_id",
    first_name as "first_name",
    last_name as "last_name",
    email as "email",
    phone as "phone",
    active as "active",
    store_id as "store_id",
    manager_id as "manager_id"
from {{ source('raw', 'staffs') }}
