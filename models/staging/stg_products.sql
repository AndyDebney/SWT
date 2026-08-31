select
    _file as "source_file",
    _line as "record_line_no",
    _modified as "updated_at",
    _fivetran_synced as "loaded_at",
    product_id as "product_id",
    product_name as "product_name",
    brand_id as "brand_id",
    category_id as "category_id",
    model_year as "model_year",
    list_price as "list_price"
from {{ source('raw', 'products') }}
