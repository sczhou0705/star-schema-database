-- ​1) How many Orders by Supplier by Quarter are there? Use the Order Dispatched Date to identify the appropriate date in the date dimension.

select s.supplier_key, d.date_quarter, count(item_quantity) from fact_orders o, dim_suppliers s, dim_date d
where o.supplier_key = s.supplier_key
and o.date_key = d.date_key
group by s.supplier_key, d.date_quarter
order by s.supplier_key, d.date_quarter;
-- Answer: Find the answer from M6 answer 1 export.

​-- 2) What is the count of orders by the supplier? Who are the top 5 suppliers that receive orders based on total orders?

	select s.supplier_key, count(item_quantity)  from fact_orders o, dim_suppliers s
	where o.supplier_key = s.supplier_key
	group by s.supplier_key
	order by s.supplier_key;
    
 -- Answer: Find the answer from M6 answer 2.1 export.   
select s.supplier_key, s.supplier_name, count(item_quantity)  from fact_orders o, dim_suppliers s
where o.supplier_key = s.supplier_key
group by s.supplier_key
order by count(item_quantity) desc
limit 5;
 -- Answer: Find the answer from M6 answer 2.2 export.   
-- 3) How many orders per quarter?

select d.date_quarter, count(item_quantity)s from fact_orders o, dim_suppliers s, dim_date d
where o.supplier_key = s.supplier_key
and o.date_key = d.date_key
group by d.date_quarter
order by  d.date_quarter;
 -- Answer: Find the answer from M6 answer 3 export.   
