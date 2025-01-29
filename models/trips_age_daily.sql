select
    age,
    date,
    count(1) as trips,
    sum(price_rub) as revenue_rub
from
    {{ ref("trips_users") }}
group by
    age,
    date
