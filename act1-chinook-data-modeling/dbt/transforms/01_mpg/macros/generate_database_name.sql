
{% macro generate_database_name(custom_database_name, node) -%}
  {%- if custom_database_name -%}
    {{ custom_database_name }}
  {%- else -%}
    {{ target.database }}
  {%- endif -%}
{%- endmacro %}
