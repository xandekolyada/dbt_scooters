with weekly_destination_morning_trip_days_cte as (
    select
        user_id,
        st_snaptogrid(
            st_makepoint(finish_lon, finish_lat), 0.001
        ) as destination,
        date_trunc('week', "date") as "week",
        count(
            distinct
            case
                when
                    extract(
                        hour from started_at at time zone 'Europe/Moscow'
                    ) between 6 and 10
                    then "date"
            end
        ) as morning_trip_days
    from
        {{ ref("trips_prep") }}
    group by
        user_id,
        destination,
        "week"
),

prep_weekly_destination_trips_cte as (
    select
        user_id,
        destination,
        avg(morning_trip_days) as avg_morning_trip_days
    from
        weekly_destination_morning_trip_days_cte
    group by
        user_id,
        destination
)

select
    user_id,
    max(avg_morning_trip_days) >= 3 as to_work
from
    prep_weekly_destination_trips_cte
group by
    user_id
