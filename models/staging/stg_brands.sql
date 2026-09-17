with source as (

    select * from {{ source('raw', 'brands') }}

),

renamed as (

    select
        _FILE as _file,
        _LINE as _line,
        _MODIFIED as _modified,
        _FIVETRAN_SYNCED as _fivetran_synced,
        BRAND_ID as brand_id,
        BRAND_NAME as brand_name
    from source

)

select * from renamed
