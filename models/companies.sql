select
    company,
    count(distinct model) as models,
    sum(scooters) as scooters
from
    {{ ref("scooters") }}
group by
    company
