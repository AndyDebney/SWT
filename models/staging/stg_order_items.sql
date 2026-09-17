with source as (

    select * from {{ source('raw', 'order_items') }}

),

renamed as (

    select
        _FILE as _file,
        _LINE as _line,
        _MODIFIED as _modified,
        _FIVETRAN_SYNCED as _fivetran_synced,
        ORDER_ID as order_id,
        ITEM_ID as item_id,
        PRODUCT_ID as product_id,
        QUANTITY as quantity,
        LIST_PRICE as list_price,
        DISCOUNT as discount
    from source

)

select * from renamed
