with source as (

    select * from {{ source('raw', 'customers') }}

),

renamed as (

    select
        _FILE as _file,
        _LINE as _line,
        _MODIFIED as _modified,
        _FIVETRAN_SYNCED as _fivetran_synced,
        CUSTOMER_ID as customer_id,
        FIRST_NAME as first_name,
        LAST_NAME as last_name,
        PHONE as phone,
        EMAIL as email,
        STREET as street,
        CITY as city,
        STATE as state,
        ZIP_CODE as zip_code
    from source

)

select * from renamed
