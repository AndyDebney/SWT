with qualified_orders as (
    select
        order_id,
        customer_id,
        order_status,
        order_date,
        required_date,
        shipped_date,
        store_id,
        staff_id
    from {{ ref('int_orders') }}
    where order_status = 1
),

order_item_values as (
    select
        order_id,
        count(*) as order_line_count,
        count(distinct product_id) as distinct_products_ordered,
        sum(quantity) as total_units_ordered,
        sum(quantity * list_price * (1 - discount)) as gross_order_value
    from {{ ref('int_order_items') }}
    group by 1
)

select
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_date,
    o.required_date,
    o.shipped_date,
    o.store_id,
    o.staff_id,
    coalesce(i.order_line_count, 0) as order_line_count,
    coalesce(i.distinct_products_ordered, 0) as distinct_products_ordered,
    coalesce(i.total_units_ordered, 0) as total_units_ordered,
    coalesce(i.gross_order_value, 0) as gross_order_value
from qualified_orders o
left join order_item_values i
    on o.order_id = i.order_id
