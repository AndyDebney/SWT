with customer_order_items as (
    select
        orders.order_id,
        orders.customer_id,
        orders.order_status,
        orders.order_date,
        order_items.item_id,
        order_items.product_id,
        products.category_id,
        order_items.quantity,
        order_items.quantity * order_items.list_price * (1 - order_items.discount) as net_item_demand
    from {{ source('raw', 'orders') }} as orders
    inner join {{ source('raw', 'order_items') }} as order_items
        on orders.order_id = order_items.order_id
    inner join {{ source('raw', 'products') }} as products
        on order_items.product_id = products.product_id
),
customer_sales as (
    select
        customer_id,
        count(distinct order_id) as lifetime_order_count,
        count(distinct product_id) as lifetime_distinct_product_count,
        count(distinct category_id) as lifetime_distinct_category_count,
        sum(quantity) as lifetime_units_purchased,
        sum(net_item_demand) as lifetime_net_demand,
        sum(net_item_demand) / nullif(count(distinct order_id), 0) as avg_order_net_demand,
        min(order_date) as first_order_at,
        max(order_date) as last_order_at,
        count(distinct case when order_status = 1 then order_id end) as status_1_order_count,
        count(distinct case when order_status = 2 then order_id end) as status_2_order_count,
        count(distinct case when order_status = 3 then order_id end) as status_3_order_count,
        count(distinct case when order_status = 4 then order_id end) as status_4_order_count
    from customer_order_items
    group by customer_id
),
customer_support as (
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
    from {{ source('raw', 'customer_support_interactions') }}
    group by customer_id
)

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
from {{ source('raw', 'customers') }} as customers
left join customer_sales as sales
    on customers.customer_id = sales.customer_id
left join customer_support as support
    on customers.customer_id = support.customer_id
