select distinct
    user_id,
    timestamp,
    type_id,
    {{ updated_at() }}
from
    {{ source("scooters_raw", "events") }}
where
{% if is_incremental() %}
    timestamp > (select max(timestamp) from {{ this }})
    and
    timestamp <= (select date(max(timestamp)) + interval '2' month from {{ this }})
{% else %}
    timestamp <= '2023-08-01'::date
{% endif %}