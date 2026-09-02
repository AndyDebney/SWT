with customers as (
    select
        customer_id,
        first_name,
        last_name,
        phone,
        email,
        street,
        city,
        state,
        zip_code
    from {{ ref('int_customers') }}
),

customer_order_metrics as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as last_order_date,
        count(*) as lifetime_order_count,
        sum(gross_order_value) as lifetime_gross_revenue,
        avg(gross_order_value) as avg_order_value,
        sum(total_units_ordered) as lifetime_units_ordered,
        sum(order_line_count) as lifetime_order_line_count
    from {{ ref('int_customer_order_value') }}
    group by 1
),

customer_product_metrics as (
    select
        o.customer_id,
        count(distinct i.product_id) as lifetime_distinct_products_ordered
    from {{ ref('int_customer_order_value') }} o
    left join {{ ref('int_order_items') }} i
        on o.order_id = i.order_id
    group by 1
),

customer_support_metrics as (
    select
        customer_id,
        first_support_interaction_at,
        last_support_interaction_at,
        support_interaction_count,
        supported_order_count,
        supported_product_count,
        avg_csat_score,
        avg_sentiment_score,
        avg_resolution_minutes,
        resolved_interaction_count,
        unresolved_interaction_count,
        follow_up_required_count,
        total_support_cost,
        total_refund_amount
    from {{ ref('int_customer_support_summary') }}
)

select
    c.customer_id,
    c.first_name,
    c.last_name,
    c.phone,
    c.email,
    c.street,
    c.city,
    c.state,
    c.zip_code,
    o.first_order_date,
    o.last_order_date,
    coalesce(o.lifetime_order_count, 0) as lifetime_order_count,
    coalesce(o.lifetime_gross_revenue, 0) as lifetime_gross_revenue,
    o.avg_order_value,
    coalesce(o.lifetime_units_ordered, 0) as lifetime_units_ordered,
    coalesce(o.lifetime_order_line_count, 0) as lifetime_order_line_count,
    coalesce(p.lifetime_distinct_products_ordered, 0) as lifetime_distinct_products_ordered,
    case
        when coalesce(o.lifetime_order_count, 0) > 1 then true
        else false
    end as is_repeat_customer,
    datediff('day', o.first_order_date, o.last_order_date) as customer_lifespan_days,
    datediff('day', o.last_order_date, current_date) as days_since_last_order,
    s.first_support_interaction_at,
    s.last_support_interaction_at,
    coalesce(s.support_interaction_count, 0) as support_interaction_count,
    coalesce(s.supported_order_count, 0) as supported_order_count,
    coalesce(s.supported_product_count, 0) as supported_product_count,
    s.avg_csat_score,
    s.avg_sentiment_score,
    s.avg_resolution_minutes,
    coalesce(s.resolved_interaction_count, 0) as resolved_interaction_count,
    coalesce(s.unresolved_interaction_count, 0) as unresolved_interaction_count,
    coalesce(s.follow_up_required_count, 0) as follow_up_required_count,
    coalesce(s.total_support_cost, 0) as total_support_cost,
    coalesce(s.total_refund_amount, 0) as total_refund_amount
from customers c
left join customer_order_metrics o
    on c.customer_id = o.customer_id
left join customer_product_metrics p
    on c.customer_id = p.customer_id
left join customer_support_metrics s
    on c.customer_id = s.customer_id
