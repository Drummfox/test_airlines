CREATE TABLE airline_clicks (
airline int,
traffic_clicks int
)

CREATE TABLE prices (
id_competitor int,
price decimal(19, 2),
airline int,
id_flight int
)

SELECT * FROM airline_clicks

select * from prices p 


with table_all_unicue_flight as(
select airline, count(distinct id_flight) as all_unic_flight
from prices 
group by 1 
),
table_clicks as(
select tauf.airline as airline, coalesce(traffic_clicks / all_unic_flight, 0) as clics_on_one_flight
from airline_clicks ac
right join table_all_unicue_flight tauf using (airline)
),
total as (
select 
p.id_competitor,
row_number()over(partition by p.id_flight, p.airline order by p.price, p.id_competitor) as place_by_price,
clics_on_one_flight
from prices p 
left join table_clicks tc on tc.airline = p.airline
),
traffic as(
select id_competitor,
round(sum(case when place_by_price = 1 then clics_on_one_flight * 0.5
	 when place_by_price = 2 then clics_on_one_flight * 0.25
	 when place_by_price = 3 then clics_on_one_flight * 0.15
	 when place_by_price = 4 then clics_on_one_flight * 0.05
	 when place_by_price = 5 then clics_on_one_flight * 0.05
	 else clics_on_one_flight * 0
end), 2) as traffic
from total
group by 1
),
sum_traffic as (
select sum(traffic_clicks) as total from airline_clicks
),
seven_five_seven_traffic as (
select traffic_clicks as clicks from airline_clicks where airline = 757 
)
select id_competitor,
round(traffic/(select * from sum_traffic)*100, 2) as percentage_of_total,
round(traffic/(select * from seven_five_seven_traffic)*100, 2) as percentage_of_757
from traffic
order by 2 desc

