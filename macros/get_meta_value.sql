{% macro get_meta_value(model, meta_key, def_value="null") %}
    {% if execute %}
        {% set model_node = (
            graph.nodes.values() |
            selectattr("resource_type", "equalto", "model") |
            selectattr("alias", "equalto", model.name) |
            first
        ) %}
            {{ return(model_node.get("meta", {}).get(meta_key, def_value)) }}
    {% else %}
        {{ return(def_value) }}
    {% endif %}
{% endmacro %}
