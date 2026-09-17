with source as (

    select * from {{ source('raw', 'stocks') }}

),

renamed as (

    select
        _FILE as _file,
        _LINE as _line,
        _MODIFIED as _modified,
        _FIVETRAN_SYNCED as _fivetran_synced,
        STORE_ID as store_id,
        PRODUCT_ID as product_id,
        QUANTITY as quantity
    from source

)

select * from renamed
