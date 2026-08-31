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
from {{ ref('int_customer_order_items') }}
group by customer_id
