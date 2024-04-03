-- SQL version = amazon redshift

-- When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
-- When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?

-- Produces a query that shows the average spend amount and total items purchased count for only accepted or rejected receipts, grouped by status
select
  case when rewards_receipt_status = 'FINISHED' then 'ACCEPTED' else rewards_receipt_status end as rewards_receipt_status
, avg(total_spent) as avg_spent
, sum(purchased_item_count) as purchased_item_count
from receipts
where true
-- assuming rewards_receipt_status='FINISHED' means 'Accepted'
and rewards_receipt_status in ('FINISHED', 'REJECTED')
group by 1
order by 1