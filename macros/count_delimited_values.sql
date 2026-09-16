{% macro count_delimited_values(column_name, delimiter_pattern='\\s*,\\s*') -%}
    case
        when nullif(trim({{ column_name }}), '') is null then 0
        else cardinality(regexp_split_to_array(trim({{ column_name }}), '{{ delimiter_pattern }}'))
    end
{%- endmacro %}
