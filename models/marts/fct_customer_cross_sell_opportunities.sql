with customer_order_items as (
    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        order_items.product_id,
        products.category_id,
        categories.category_name,
        order_items.quantity * order_items.list_price * (1 - order_items.discount) as net_item_demand
    from {{ source('raw', 'orders') }} as orders
    inner join {{ source('raw', 'order_items') }} as order_items
        on orders.order_id = order_items.order_id
    inner join {{ source('raw', 'products') }} as products
        on order_items.product_id = products.product_id
    inner join {{ source('raw', 'categories') }} as categories
        on products.category_id = categories.category_id
),
customer_sales as (
    select distinct customer_id
    from customer_order_items
),
customer_category_purchases as (
    select
        customer_id,
        category_id,
        category_name,
        sum(net_item_demand) as category_net_demand
    from customer_order_items
    group by customer_id, category_id, category_name
),
customer_categories as (
    select distinct
        customer_id,
        category_id,
        category_name
    from customer_category_purchases
),
category_customer_counts as (
    select
        category_id,
        count(distinct customer_id) as source_category_customer_count
    from customer_categories
    group by category_id
),
category_pairs as (
    select
        source.category_id as source_category_id,
        target.category_id as target_category_id,
        count(distinct source.customer_id) as customers_with_both_categories
    from customer_categories as source
    inner join customer_categories as target
        on source.customer_id = target.customer_id
        and source.category_id <> target.category_id
    group by 1, 2
),
category_cross_sell_affinity as (
    select
        pairs.source_category_id,
        pairs.target_category_id,
        pairs.customers_with_both_categories / nullif(source_counts.source_category_customer_count, 0) as target_category_affinity,
        target_demand.avg_target_category_net_demand
    from category_pairs as pairs
    inner join category_customer_counts as source_counts
        on pairs.source_category_id = source_counts.category_id
    inner join (
        select
            category_id,
            avg(category_net_demand) as avg_target_category_net_demand
        from customer_category_purchases
        group by category_id
    ) as target_demand
        on pairs.target_category_id = target_demand.category_id
),
eligible_customer_categories as (
    select
        customers.customer_id,
        categories.category_id as target_category_id,
        categories.category_name as target_category_name
    from customer_sales as customers
    cross join {{ source('raw', 'categories') }} as categories
    left join customer_category_purchases as purchased
        on customers.customer_id = purchased.customer_id
        and categories.category_id = purchased.category_id
    where purchased.customer_id is null
),
candidates as (
    select
        eligible.customer_id,
        eligible.target_category_id,
        eligible.target_category_name,
        max(affinity.target_category_affinity) as target_category_affinity,
        max(affinity.avg_target_category_net_demand) as avg_target_category_net_demand,
        count(distinct purchased.category_id) as supporting_purchased_category_count
    from eligible_customer_categories as eligible
    inner join customer_category_purchases as purchased
        on eligible.customer_id = purchased.customer_id
    inner join category_cross_sell_affinity as affinity
        on purchased.category_id = affinity.source_category_id
        and eligible.target_category_id = affinity.target_category_id
    group by 1, 2, 3
),
ranked_candidates as (
    select
        customer_id,
        target_category_id,
        target_category_name,
        target_category_affinity,
        avg_target_category_net_demand,
        target_category_affinity * avg_target_category_net_demand as estimated_cross_sell_demand,
        supporting_purchased_category_count,
        row_number() over (
            partition by customer_id
            order by target_category_affinity * avg_target_category_net_demand desc, target_category_id
        ) as customer_opportunity_rank
    from candidates
)

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
from ranked_candidates as candidates
inner join {{ ref('fct_customer_lifetime_value') }} as customers
    on candidates.customer_id = customers.customer_id
