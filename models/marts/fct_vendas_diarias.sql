select
    order_date,
    category,
    count(distinct order_id) as total_orders,
    sum(total_value) as total_revenue
from {{ ref('stg_vendas') }}
where {{ only_completed('status') }}
group by 1, 2
order by 1, 2
