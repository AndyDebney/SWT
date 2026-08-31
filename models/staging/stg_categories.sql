select
    _file as "source_file",
    _line as "record_line_no",
    _modified as "updated_at",
    _fivetran_synced as "loaded_at",
    category_id as "category_id",
    category_name as "category_name"
from {{ source('raw', 'categories') }}
