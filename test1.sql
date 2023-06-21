table_count_channel as(						
						
select airline, count(distinct channel) as count_channel, round(sum(tickets), 2) as sum_tickets						
						
from tickets_airline ta						
						
group by 1						
						
),						
						
table_avg_count_city as(						
						
select category, round(avg(count_city), 2) as avg_count_city						
						
from city_category						
						
group by 1						
						
)						
						
select coalesce (airline_id, airline) as airline, sum_sales, count_channel, sum_tickets, avg_count_city						
						
from table_sum_sales tss						
						
full join table_count_channel tcc on tcc.airline = tss.airline_id						
						
left join table_avg_count_city tacc on tacc.category = tss.category						
						
order by 1						