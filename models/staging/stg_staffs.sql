with source as (

    select * from {{ source('raw', 'staffs') }}

),

renamed as (

    select
        _FILE as _file,
        _LINE as _line,
        _MODIFIED as _modified,
        _FIVETRAN_SYNCED as _fivetran_synced,
        STAFF_ID as staff_id,
        FIRST_NAME as first_name,
        LAST_NAME as last_name,
        EMAIL as email,
        PHONE as phone,
        ACTIVE as active,
        STORE_ID as store_id,
        MANAGER_ID as manager_id
    from source

)

select * from renamed
