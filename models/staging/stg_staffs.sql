select *
from {{ source('raw', 'staffs') }}
