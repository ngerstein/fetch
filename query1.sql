-- Q1 What are the top 5 brands by receipts scanned for most recent month?
-- Q2 How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?

-- Returns the top 5 brands by unique receipt ids scanned in the most recent 2 months

with brand_counts as (
select
-- assuming date_scanned is the timestamp needed here
-- also assuming all dates are already converted to timestamp values in the data warehouse
  date_trunc('month', r.date_scanned) as month
--date_trunc('month', timestamp 'epoch' + r.date_scanned * interval '1 second') as month -- convert epoch to timestamp version
, b.brand_code
-- note that this will double count receipts, but I believe that is what is meant by "receipts scanned"
, count(distinct r.id) as receipts_count 
from brands b
inner join receipt_items ri
	on b.brand_code = ri.brand_code -- this links items on receipts to brands (when receipt_items.brand_code is not an empty string)
	-- items without a brand_code will not be counted towards the receipt count
inner join receipts r
	on ri.receipt_id = r.id
where true
group by 1, 2
)

, ranked as (
select
  *
, rank() over(partition by month, brand_code order by receipts_count desc) as rank
from brand_counts
)

select
  *
from ranked
where true
and rank <=5 -- top 5 only
and month >= dateadd('month', -1, (select max(month) from ranked)) -- last 2 months only

