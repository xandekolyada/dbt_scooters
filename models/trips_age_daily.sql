select
    extract(year from age(date, birth_date)) as age,
    date,
    count(1) as trips,
    sum(price_rub) as revenue_rub
from
    {{ ref("trips_prep") }} t
inner join
    {{ source("scooters_raw", "users") }} u
on t.user_id = u.id
group by
    age,
    date
