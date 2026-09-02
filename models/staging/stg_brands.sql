with source_data as (
    select
        _file,
        _line,
        _modified,
        _fivetran_synced,
        brand_id,
        brand_name
    from {{ source('raw', 'brands') }}
)

select
    _file,
    _line,
    _modified,
    _fivetran_synced,
    brand_id,
    brand_name
from source_data
