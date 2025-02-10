select *
from
    {{ ref("revenue_monthly") }}
where
    "month" != date_trunc('month', now())
    and
    {% if is_incremental() %}
        "month" > (select max("month") from {{ this }})
    {% else %}
        "month" = (select min("month") from {{ ref("revenue_monthly") }})
    {% endif %}
    and not (users < 1000 or revenue_median < 500)
