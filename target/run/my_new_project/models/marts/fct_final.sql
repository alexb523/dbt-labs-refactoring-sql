
  create or replace  view PE_ALEXANDER_B.abrown_dbt_interview.fct_final 
  
   as (
    with
  o  as (select * from PE_ALEXANDER_B.abrown_dbt_interview.stg_orders),
  do as (select * from PE_ALEXANDER_B.abrown_dbt_interview.intr_device_orders),
  ct as (select * from PE_ALEXANDER_B.abrown_dbt_interview.intr_ctry_type),
  pa as (select * from PE_ALEXANDER_B.abrown_dbt_interview.intr_payments),
  ut as (select * from PE_ALEXANDER_B.abrown_dbt_interview.intr_user_type),

  final as (

    select
        o.order_id,
        o.user_id,
        o.created_at,
        o.updated_at,
        o.shipped_at,
        o.currency,
        o.order_status,
        o.order_status_category,
        ct.country_type,
        o.shipping_method,
        do.purchase_device_type,
        do.device as purchase_device,
        ut.user_type,
        o.amount_total_cents,
        pa.gross_total_amount_cents,
        pa.total_amount_cents,
        pa.gross_tax_amount_cents,
        pa.gross_amount_cents,
        pa.gross_amount_shipping_cents
      from o

      left join do
        on do.order_id = o.order_id

      left join ut
        on o.order_id = ut.order_id

      left join ct 
        on ct.order_id = o.order_id

      left join pa
        on pa.order_id = o.order_id
  )

-- select statement


select
  *,
  amount_total_cents / 100 as amount_total,
  gross_total_amount_cents/ 100 as gross_total_amount,
  total_amount_cents/ 100 as total_amount,
  gross_tax_amount_cents/ 100 as gross_tax_amount,
  gross_amount_cents/ 100 as gross_amount,
  gross_amount_shipping_cents/ 100 as gross_shipping_amount

from final
  );
