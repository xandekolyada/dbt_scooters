select *
from
    {{ ref("events_clean") }} ec
left join
    {{ ref("event_types") }} et
    using (type_id)
