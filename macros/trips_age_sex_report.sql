{% macro trips_age_sex_report(trips_table, granularity) %}
    select
    {% if granularity == 'daily' %}
        "date",
    {% elif granularity == 'weekly' %}
        date_trunc('week', "date")::date as "week",
    {% elif granularity == 'monthly' %}
        date_trunc('month', "date")::date as "month",
    {% else %}
        {{ exceptions.raise_compiler_error("Invalid granularity: " ~ granularity) }}
    {% endif %}
        age,
        coalesce(sex, 'UNKNOWN') as sex,
        count(1) as trips,
        sum(price_rub) as revenue_rub
    from
        {{ trips_table }}
    GROUP BY
        1,
        2,
        3
{% endmacro %}