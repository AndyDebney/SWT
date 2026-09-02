select
    customer_id,
    min(interaction_at) as first_support_interaction_at,
    max(interaction_at) as last_support_interaction_at,
    count(*) as support_interaction_count,
    count(distinct order_id) as supported_order_count,
    count(distinct product_id) as supported_product_count,
    avg(csat_score) as avg_csat_score,
    avg(sentiment_score) as avg_sentiment_score,
    avg(resolution_minutes) as avg_resolution_minutes,
    sum(case when resolved_flag then 1 else 0 end) as resolved_interaction_count,
    sum(case when not resolved_flag then 1 else 0 end) as unresolved_interaction_count,
    sum(case when follow_up_required then 1 else 0 end) as follow_up_required_count,
    sum(interaction_cost) as total_support_cost,
    sum(refund_amount) as total_refund_amount
from {{ ref('int_customer_support_interactions') }}
group by 1
