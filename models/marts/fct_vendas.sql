with
    fct_vendas as (
        select *
        from {{ ref('int_vendas__metricas_de_vendas') }}
    )

select *
from fct_vendas
