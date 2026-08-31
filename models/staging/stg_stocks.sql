select *
from {{ source('raw', 'stocks') }}
