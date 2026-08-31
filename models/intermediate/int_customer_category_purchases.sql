select
    customer_id,
    category_id,
    category_name,
    count(distinct order_id) as category_order_count,
    count(distinct product_id) as category_distinct_product_count,
    sum(quantity) as category_units_purchased,
    sum(net_item_demand) as category_net_demand,
    min(order_date) as first_category_order_at,
    max(order_date) as last_category_order_at
from {{ ref('int_customer_order_items') }}
group by customer_id, category_id, category_name
