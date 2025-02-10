select
    user_id,
    avg(days_per_week) >= 6 as fan,
    avg(days_per_week) >= 3 as regular
from (
    select
        user_id,
        date_trunc('week', "date") as "week",
        count(distinct date("date")) as days_per_week
    from
        {{ ref("trips_prep") }}
    group by
        user_id,
        "week"
)
group by
    user_id
