with company_cte as (
    select
        company,
        count(1) as trips
    from
        {{ ref("trips_prep") }} as t
    left join
        {{ ref("scooters") }} as s
        on t.scooter_hw_id = s.hardware_id
    group by
        company
)

select
    company_cte.company as company,
    trips,
    scooters,
    trips / scooters::float as trips_per_scooter
from
    company_cte
left join
    {{ ref("companies") }} as c
    on company_cte.company = c.company
