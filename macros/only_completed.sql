{% macro only_completed(status_column) %}
    {{ status_column }} = 'completed'
{% endmacro %}
