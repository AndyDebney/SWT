with staging_data as (
    select
        _file as source_file,
        _line as record_line_no,
        _modified as updated_at,
        _fivetran_synced as loaded_at,
        category_id,
        category_name
    from {{ ref('stg_categories') }}
)

select
    source_file,
    record_line_no,
    updated_at,
    loaded_at,
    category_id,
    category_name
from staging_data

