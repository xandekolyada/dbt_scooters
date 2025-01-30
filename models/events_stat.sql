select
    count(type = 'cancel_search' or null) / count(type = 'start_search' or null)::float as cancel_pct
from
    {{ ref("events_full") }}
