
{% set cols = ['tax_amount', 'amount', 'amount_shipping'] %}

with
    o as (select * from {{ ref('stg_orders') }} ),
    p as (select * from {{ ref('stg_payments') }}),

    p1 as (
    select
        p.order_id,

        {%- for c in cols %}
            round(sum(case when status = 'completed' then p.{{c}}_cents else 0 end) / 100, 2) as gross_{{c}}
            {%- if not loop.last %}
                ,
            {%- endif %}
        {%- endfor %}

    from p
    group by order_id
    ),

    p2 as (
        select
            p1.*,
            round(
                p1.gross_tax_amount +
                p1.gross_amount +
                p1.gross_amount_shipping,
                2) as gross_total_amount
            
        from p1
    ),
    
    pa as (

        select
            p2.order_id,
            p2.gross_tax_amount,
            p2.gross_amount,
            p2.gross_amount_shipping,

            case
                when lower(o.currency) = 'usd' then round(o.amount_total_cents / 100, 2)
                else p2.gross_total_amount
            end as gross_total_amount
            
        from p2
        left join o
        on p2.order_id = o.order_id
    )

select * from pa