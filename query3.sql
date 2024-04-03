-- Which brand has the most spend among users who were created within the past 6 months?
-- Which brand has the most transactions among users who were created within the past 6 months?

-- produces the 2-1 brand with either the most spend or transaction count from users
-- created in the last 6 months
with brand_data as (
select
  b.brand_code
, sum(total_spent) as spend_total
-- assuming a "transation" = receipt_id
, count(distinct r.id) as transaction_count
from brands b
inner join receipt_items ri 
	on b.brand_code = ri.brand_code
inner join receipts r 
	on ri.receipt_id = r.id
inner join users u 
	on r.user_id = u.user_id
	-- only users created in the last 6 months
	and u.created_at >= dateadd('months', -6, current_timestamp)
group by 1
)

, ranked as (
select
  *
, rank() over(order by spend_total desc) as spend_rank
, rank() over(order by transaction_count desc) as transaction_rank
from brand_data
)

select
  *
from ranked
where true
and spend_rank=1 or transaction_rank=1

