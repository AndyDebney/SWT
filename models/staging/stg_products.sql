with source as (

    select * from {{ source('raw', 'products') }}

),

renamed as (

    select
        _FILE as _file,
        _LINE as _line,
        _MODIFIED as _modified,
        _FIVETRAN_SYNCED as _fivetran_synced,
        PRODUCT_ID as product_id,
        PRODUCT_NAME as product_name,
        BRAND_ID as brand_id,
        CATEGORY_ID as category_id,
        MODEL_YEAR as model_year,
        LIST_PRICE as list_price
    from source

)

select * from renamed
