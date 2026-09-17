with source as (

    select * from {{ source('raw', 'customer_support_interactions') }}

),

renamed as (

    select
        _FILE as _file,
        _LINE as _line,
        _MODIFIED as _modified,
        _FIVETRAN_SYNCED as _fivetran_synced,
        INTERACTION_ID as interaction_id,
        CUSTOMER_ID as customer_id,
        ORDER_ID as order_id,
        PRODUCT_ID as product_id,
        INTERACTION_AT as interaction_at,
        CHANNEL as channel,
        INTERACTION_TYPE as interaction_type,
        ISSUE_CATEGORY as issue_category,
        SENTIMENT_SCORE as sentiment_score,
        SENTIMENT_LABEL as sentiment_label,
        CSAT_SCORE as csat_score,
        RESOLVED_FLAG as resolved_flag,
        RESOLUTION_MINUTES as resolution_minutes,
        FOLLOW_UP_REQUIRED as follow_up_required,
        INTERACTION_COST as interaction_cost,
        REFUND_AMOUNT as refund_amount,
        SUPPORT_AGENT_ID as support_agent_id,
        INTERACTION_SUMMARY as interaction_summary
    from source

)

select * from renamed
