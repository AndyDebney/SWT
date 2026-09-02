with source_data as (
    select
        _file,
        _line,
        _modified,
        _fivetran_synced,
        category_id,
        category_name
    from {{ source('raw', 'categories') }}
)

select
    _file,
    _line,
    _modified,
    _fivetran_synced,
    category_id,
    category_name
from source_data
