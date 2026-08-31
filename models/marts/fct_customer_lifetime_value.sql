select
    customers.customer_id,
    customers.first_name,
    customers.last_name,
    customers.city,
    customers.state,
    coalesce(sales.lifetime_order_count, 0) as lifetime_order_count,
    coalesce(sales.lifetime_distinct_product_count, 0) as lifetime_distinct_product_count,
    coalesce(sales.lifetime_distinct_category_count, 0) as lifetime_distinct_category_count,
    coalesce(sales.lifetime_units_purchased, 0) as lifetime_units_purchased,
    coalesce(sales.lifetime_net_demand, 0) as lifetime_net_demand,
    sales.avg_order_net_demand,
    sales.first_order_at,
    sales.last_order_at,
    coalesce(sales.status_1_order_count, 0) as status_1_order_count,
    coalesce(sales.status_2_order_count, 0) as status_2_order_count,
    coalesce(sales.status_3_order_count, 0) as status_3_order_count,
    coalesce(sales.status_4_order_count, 0) as status_4_order_count,
    coalesce(support.support_interaction_count, 0) as support_interaction_count,
    support.first_support_interaction_at,
    support.last_support_interaction_at,
    coalesce(support.total_support_cost, 0) as total_support_cost,
    support.avg_support_cost_per_interaction,
    coalesce(support.total_refund_amount, 0) as total_refund_amount,
    support.avg_csat_score,
    support.avg_sentiment_score,
    coalesce(support.negative_sentiment_interaction_count, 0) as negative_sentiment_interaction_count,
    support.negative_sentiment_rate,
    coalesce(support.resolved_interaction_count, 0) as resolved_interaction_count,
    support.resolution_rate,
    support.avg_resolution_minutes_resolved,
    coalesce(support.unresolved_interaction_count, 0) as unresolved_interaction_count,
    support.unresolved_interaction_rate,
    coalesce(support.follow_up_required_count, 0) as follow_up_required_count,
    support.follow_up_required_rate,

    case
        when coalesce(support.unresolved_interaction_count, 0) > 0
            or coalesce(support.follow_up_required_count, 0) > 0
            then true
        else false
    end as support_risk_flag
from {{ ref('int_customers') }} as customers
left join {{ ref('int_customer_sales_by_customer') }} as sales
    on customers.customer_id = sales.customer_id
left join {{ ref('int_customer_support_by_customer') }} as support
    on customers.customer_id = support.customer_id
