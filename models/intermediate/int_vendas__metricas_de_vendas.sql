with
    ordens as (
        select *
        from {{ ref('stg_erp__ordens') }}
    )

    , pedido_itens as (
        select *
        from {{ ref('stg_erp__ordem_itens') }}
    )

    , joined as (
        select
            pedido_itens.PK_PEDIDO_ITEM
            , pedido_itens.FK_PRODUTO
            , ordens.FK_FUNCIONARIO
            , ordens.FK_CLIENTE
            , ordens.FK_TRANSPORTADORA
            , ordens.DATA_DO_PEDIDO
            , ordens.DATA_DO_ENVIO
            , ordens.DATA_REQUERIDA_ENTREGA
            , pedido_itens.DESCONTO_PERC
            , pedido_itens.PRECO_DA_UNIDADE
            , pedido_itens.QUANTIDADE
            , ordens.FRETE
            , ordens.NUMERO_PEDIDO
            , ordens.NM_DESTINATARIO
            , ordens.CIDADE_DESTINATARIO
            , ordens.REGIAO_DESTINATARIO
            , ordens.PAIS_DESTINATARIO
        from pedido_itens
        inner join ordens on pedido_itens.fk_pedido = ordens.pk_pedido
    )
    
    , metricas as (
        select 
            PK_PEDIDO_ITEM
            , FK_PRODUTO
            , FK_FUNCIONARIO
            , FK_CLIENTE
            , FK_TRANSPORTADORA
            , DATA_DO_PEDIDO
            , DATA_DO_ENVIO
            , DATA_REQUERIDA_ENTREGA
            , DESCONTO_PERC
            , PRECO_DA_UNIDADE
            , QUANTIDADE
            , FRETE
            , PRECO_DA_UNIDADE * QUANTIDADE as total_bruto
            , PRECO_DA_UNIDADE * (1 - DESCONTO_PERC) * QUANTIDADE as total_liquido
            , cast((FRETE /  count(*) over(partition by numero_pedido)) as numeric(18,2)) as frete_rateado
            , case
                when DESCONTO_PERC > 0 then true
                else false
            end as teve_desconto
            , NUMERO_PEDIDO
            , NM_DESTINATARIO
            , CIDADE_DESTINATARIO
            , REGIAO_DESTINATARIO
            , PAIS_DESTINATARIO
        from joined
    )

select *
from metricas
