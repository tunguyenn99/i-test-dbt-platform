{% macro clean_text(column_name) -%}
    nullif(trim({{ column_name }}), '')
{%- endmacro %}
