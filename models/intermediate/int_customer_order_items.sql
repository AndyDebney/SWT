select
    orders.order_id,
    orders.customer_id,
    orders.order_status,
    orders.order_date,
    order_items.item_id,
    order_items.product_id,
    products.category_id,
    categories.category_name,
    order_items.quantity,
    order_items.list_price,
    order_items.discount,
    order_items.quantity * order_items.list_price * (1 - order_items.discount) as net_item_demand
from {{ ref('int_orders') }} as orders
inner join {{ ref('int_order_items') }} as order_items
    on orders.order_id = order_items.order_id
inner join {{ ref('int_products') }} as products
    on order_items.product_id = products.product_id
inner join {{ ref('int_categories') }} as categories
    on products.category_id = categories.category_id
