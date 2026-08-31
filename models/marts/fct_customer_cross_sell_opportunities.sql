select
    candidates.customer_id,
    candidates.target_category_id,
    candidates.target_category_name,
    candidates.customer_opportunity_rank,
    candidates.target_category_affinity,
    candidates.avg_target_category_net_demand,
    candidates.estimated_cross_sell_demand,
    candidates.supporting_purchased_category_count,
    customers.lifetime_order_count,
    customers.lifetime_net_demand,
    customers.last_order_at,
    customers.support_risk_flag,
    customers.unresolved_interaction_count,
    customers.follow_up_required_count,
    customers.avg_csat_score,
    customers.avg_sentiment_score
from {{ ref('int_customer_category_cross_sell_candidates') }} as candidates
inner join {{ ref('fct_customer_lifetime_value') }} as customers
    on candidates.customer_id = customers.customer_id
