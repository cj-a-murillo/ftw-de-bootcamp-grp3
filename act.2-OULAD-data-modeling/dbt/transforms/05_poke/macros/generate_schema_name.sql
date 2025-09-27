{# Use the folder's +schema verbatim (e.g., "clean" or "mart") without prefixing target.schema #}
{% macro generate_schema_name(custom_schema_name, node) -%}
  {%- if custom_schema_name -%}
    {{ custom_schema_name | trim }}
  {%- else -%}
    {{ target.schema }}
  {%- endif -%}
{%- endmacro %}
