{% test not_null_columns_lowercase(model, column_names) %}

select *
from {{ model }}
where
    {% for column_name in column_names %}
    {{ adapter.quote(column_name) }} is null{% if not loop.last %}
        or{% endif %}
    {% endfor %}

{% endtest %}
