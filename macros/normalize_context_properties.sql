{% macro normalize_context_properties() %}
    case
        when (context_properties ? 'payload' and context_properties->'payload' ? 'write_key') then (context_properties->'payload')::jsonb
        else context_properties::jsonb
    end as context_properties
{% endmacro %}