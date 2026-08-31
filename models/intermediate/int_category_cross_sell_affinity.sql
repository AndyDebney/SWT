with customer_categories as (
    select distinct
        customer_id,
        category_id,
        category_name
    from {{ ref('int_customer_category_purchases') }}
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
        source.category_name as source_category_name,
        target.category_id as target_category_id,
        target.category_name as target_category_name,
        count(distinct source.customer_id) as customers_with_both_categories
    from customer_categories as source
    inner join customer_categories as target
        on source.customer_id = target.customer_id
        and source.category_id <> target.category_id
    group by 1, 2, 3, 4
),
target_category_demand as (
    select
        category_id,
        avg(category_net_demand) as avg_target_category_net_demand
    from {{ ref('int_customer_category_purchases') }}
    group by category_id
)

select
    pairs.source_category_id,
    pairs.source_category_name,
    pairs.target_category_id,
    pairs.target_category_name,
    source_counts.source_category_customer_count,
    pairs.customers_with_both_categories,
    pairs.customers_with_both_categories / nullif(source_counts.source_category_customer_count, 0) as target_category_affinity,
    target_demand.avg_target_category_net_demand
from category_pairs as pairs
inner join category_customer_counts as source_counts
    on pairs.source_category_id = source_counts.category_id
inner join target_category_demand as target_demand
    on pairs.target_category_id = target_demand.category_id
