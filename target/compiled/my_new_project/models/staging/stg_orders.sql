with
    o as (select * from raw.interview_sample_data.interview_orders)

select
    *,
    o.status as order_status,
        case
          when o.status in (
            'paid',
            'completed',
            'shipped'
          ) then 'completed'
          else o.status
        end as order_status_category
 from o