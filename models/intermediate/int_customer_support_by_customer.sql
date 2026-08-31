select
    customer_id,
    count(*) as support_interaction_count,
    min(interaction_at) as first_support_interaction_at,
    max(interaction_at) as last_support_interaction_at,
    sum(interaction_cost) as total_support_cost,
    avg(interaction_cost) as avg_support_cost_per_interaction,
    sum(refund_amount) as total_refund_amount,
    avg(csat_score) as avg_csat_score,
    avg(sentiment_score) as avg_sentiment_score,
    count_if(sentiment_label = 'negative') as negative_sentiment_interaction_count,
    count_if(sentiment_label = 'negative') / nullif(count(*), 0) as negative_sentiment_rate,
    count_if(resolved_flag) as resolved_interaction_count,
    count_if(resolved_flag) / nullif(count(*), 0) as resolution_rate,
    avg(case when resolved_flag then resolution_minutes end) as avg_resolution_minutes_resolved,
    count_if(not resolved_flag) as unresolved_interaction_count,
    count_if(not resolved_flag) / nullif(count(*), 0) as unresolved_interaction_rate,
    count_if(follow_up_required) as follow_up_required_count,
    count_if(follow_up_required) / nullif(count(*), 0) as follow_up_required_rate
from {{ ref('int_customer_support_interactions') }}
group by customer_id
