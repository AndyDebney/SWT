with source as (

    select * from {{ source('raw', 'categories') }}

),

renamed as (

    select
        _FILE as _file,
        _LINE as _line,
        _MODIFIED as _modified,
        _FIVETRAN_SYNCED as _fivetran_synced,
        CATEGORY_ID as category_id,
        CATEGORY_NAME as category_name
    from source

)

select * from renamed
