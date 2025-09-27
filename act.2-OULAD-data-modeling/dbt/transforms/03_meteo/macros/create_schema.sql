{# Disable schema creation for ClickHouse #}
{% macro clickhouse__create_schema(relation) -%}
  {%- do return(none) -%}
{%- endmacro %}
