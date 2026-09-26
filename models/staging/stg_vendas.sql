select
    order_id,
    customer_id,
    product,
    category,
    quantity,
    unit_price,
    quantity * unit_price as total_value,
    order_date::date as order_date,
    status
from {{ ref('vendas') }}
