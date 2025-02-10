with unnest_cte as (
    select
        unnest(array[started_at, finished_at]) as timestamp,
        unnest(array[1, -1]) as increment
    from
        {{ source("scooters_raw", "trips") }}
),

sum_cte as (
    select
        timestamp,
        sum(increment) as increment,
        true as preserve_row
    from
        unnest_cte
    where
        {% if is_incremental() %}
            timestamp > (select max(timestamp) from {{ this }})
        {% else %}
            timestamp <= (select min(started_at) + interval '7' hour from {{ source("scooters_raw", "trips") }} )
    {% endif %}
    group by
        timestamp
    {% if is_incremental() %}
        union all
        select
            timestamp,
            concurrency as increment,
            false as preserve_row
        from
            {{ this }}
        where
            timestamp = (select max(timestamp) from {{ this }})
    {% endif %}

),

cumsum_cte as (
    select
        timestamp,
        sum(increment) over (
            order by timestamp
        ) as concurrency,
        preserve_row
    from
        sum_cte
)

select
    timestamp,
    concurrency,
    {{ updated_at() }}
from
    cumsum_cte
where
    preserve_row
order by
    timestamp
