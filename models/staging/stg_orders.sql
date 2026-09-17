with source as (

    select * from {{ source('raw', 'orders') }}

),

renamed as (

    select
        _FILE as _file,
        _LINE as _line,
        _MODIFIED as _modified,
        _FIVETRAN_SYNCED as _fivetran_synced,
        ORDER_ID as order_id,
        CUSTOMER_ID as customer_id,
        ORDER_STATUS as order_status,
        ORDER_DATE as order_date,
        REQUIRED_DATE as required_date,
        SHIPPED_DATE as shipped_date,
        STORE_ID as store_id,
        STAFF_ID as staff_id
    from source

)

select * from renamed
