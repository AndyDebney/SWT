select
    _file as "source_file",
    _line as "record_line_no",
    _modified as "updated_at",
    _fivetran_synced as "loaded_at",
    brand_id as "brand_id",
    brand_name as "brand_name"
from {{ source('raw', 'brands') }}
