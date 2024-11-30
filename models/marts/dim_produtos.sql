with
    dim_produtos as (
        select *
        from {{ ref('int_vendas__prep_produtos') }}
    )

select *
from dim_produtos
