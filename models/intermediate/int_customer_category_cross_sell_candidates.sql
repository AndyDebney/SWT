with eligible_customer_categories as (
    select
        customers.customer_id,
        categories.category_id as target_category_id,
        categories.category_name as target_category_name
    from {{ ref('int_customer_sales_by_customer') }} as customers
    cross join {{ ref('int_categories') }} as categories
    left join {{ ref('int_customer_category_purchases') }} as purchased
        on customers.customer_id = purchased.customer_id
        and categories.category_id = purchased.category_id
    where purchased.customer_id is null
),
customer_target_affinity as (
    select
        eligible.customer_id,
        eligible.target_category_id,
        eligible.target_category_name,
        max(affinity.target_category_affinity) as target_category_affinity,
        max(affinity.avg_target_category_net_demand) as avg_target_category_net_demand,
        count(distinct purchased.category_id) as supporting_purchased_category_count
    from eligible_customer_categories as eligible
    inner join {{ ref('int_customer_category_purchases') }} as purchased
        on eligible.customer_id = purchased.customer_id
    inner join {{ ref('int_category_cross_sell_affinity') }} as affinity
        on purchased.category_id = affinity.source_category_id
        and eligible.target_category_id = affinity.target_category_id
    group by 1, 2, 3
)

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
from customer_target_affinity
