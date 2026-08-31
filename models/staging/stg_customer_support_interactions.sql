select *
from {{ source('raw', 'customer_support_interactions') }}
