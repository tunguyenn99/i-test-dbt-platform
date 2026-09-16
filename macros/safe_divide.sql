{% macro safe_divide(numerator, denominator) -%}
    case
        when {{ denominator }} is null or {{ denominator }} = 0 then null
        else ({{ numerator }})::numeric / ({{ denominator }})
    end
{%- endmacro %}
