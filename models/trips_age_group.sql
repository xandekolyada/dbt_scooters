with trips_age_groups_cte as (
    select
        "group" as age_group,
        price_rub
    from
        {{ ref("trips_users") }} t
    cross join
        {{ ref("age_groups") }}
    where
        age >= age_start
        and
        age <= age_end
)

select
    age_group,
    count(1) as trips,
    sum(price_rub) as revenue_rub
from
    trips_age_groups_cte
group by
    age_group
