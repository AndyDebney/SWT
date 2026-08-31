select *
from {{ source('raw', 'brands') }}
