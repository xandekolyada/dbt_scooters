select
    date,
    sum(price_rub) as revenue_rub,
    {{ updated_at() }}
from
    {{ ref("trips_prep") }}
{% if is_incremental() %}
    where
        date > (select max(date) - interval '3' day from {{ this }} )
{% endif %}
group by
    date
order by
    date