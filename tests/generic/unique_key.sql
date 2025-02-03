{% test unique_key(model, columns) %}
    select
    {% for column_name in columns %}
        {% if not loop.last %}
            "{{ column_name }}"::text ||
        {% else %}
            "{{ column_name }}"::text
        {% endif %}
    {% endfor %}
    from
        {{ model }}
    group by
        1
    having
        count(1) > 1
{% endtest %}
