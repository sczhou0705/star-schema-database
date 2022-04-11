INSERT INTO `dav6100_db_2_rpt`.`dim_supplier`
(
`supplier_id`,
`supplier_name`,
`supplier_status`,
`country_label`)
(SELECT DISTINCT ss.sup_id, ss.sup_name_en, t.status_label_en, cl.country_label_en FROM dav6100_db_2.r_base_stat t 
INNER JOIN dav6100_db_2.t_sup_supplier ss ON ss.status_code = t.status_code 
INNER JOIN dav6100_db_2.r_ctry cl ON ss.country_code = cl.country_code
WHERE t.tdesc_name = 't_sup_supplier'
);
-- SELECT * FROM `dav6100_db_2_rpt`.`dim_suppliers`
INSERT INTO `dav6100_db_2_rpt`.`dim_product`
(
`product_id`,
`item_id`,
`product_description`,
`product_category`)
(SELECT DISTINCT  prod_id, item_id, prod_desc, comm_cd FROM dav6100_db_2.r_prod);
-- SELECT * FROM `dav6100_db_2_rpt`.`dim_product`
INSERT INTO `dav6100_db_2_rpt`.`dim_date`
(
`date_string`,
`date_year`,
`date_month`,
`date_day`,
`date_quarter`,
`date_weekday`,
`date_week`)
(SELECT t.ord_disp_dt, Year(dT), Month(dT), Day(dT), Quarter(dT), WeekDay(dT), Week(dT) from 
(
SELECT DISTINCT  ord_disp_dt, STR_TO_DATE(ord_disp_dt, '%m/%d/%Y') dT FROM dav6100_db_2.t_ord_order) t
);
-- SELECT * FROM `dav6100_db_2_rpt`.`dim_date`
INSERT INTO `dav6100_db_2_rpt`.`dim_orders`
(
`order_id`,
`order_amount`)
(SELECT tp.ord_id,
CASE
	WHEN tp.amt <= 100000 THEN "Between 0 and $100,000"
    else "Larger than $100,000"
END ord_amount_str
 FROM (
SELECT oo.ord_id, sum(i.ord_item_amt) amt
 FROM dav6100_db_2.t_ord_order oo 
 INNER JOIN dav6100_db_2.t_ord_item i ON oo.ord_id = i.ord_id 
 GROUP BY oo.ord_id ) tp);
 -- SELECT * FROM `dav6100_db_2_rpt`.`dim_orders`
 
 INSERT INTO `dav6100_db_2_rpt`.`fact_orders`
(`product_key`,
`order_key`,
`date_key`,
`supplier_key`,
`item_quantity`,
`item_amount`)
(
WITH cte AS (
 select o.ord_id, o.ord_disp_dt, i.item_id, i.prod_id, i.sup_id, i.ord_item_qty item_quantity, i.ord_item_amt item_amount from 
	 dav6100_db_2.t_ord_order o, 
	 dav6100_db_2.t_ord_item i, 
	 dav6100_db_2.r_prod p
	 where o.ord_id = i.ord_id 
	 and i.item_id = p.item_id
     )
     
SELECT dp.product_key, dm.order_key, dd.date_key, ds.supplier_key, sum(cte.item_quantity), sum(cte.item_amount) 
FROM cte,
dav6100_db_2_rpt.dim_orders dm,
 dav6100_db_2_rpt.dim_product dp,
 dav6100_db_2_rpt.dim_date dd,
 dav6100_db_2_rpt.dim_suppliers ds
 where cte.ord_id = dm.order_id
 -- and ori_oip.prod_id = dp.product_id
 and cte.item_id = dp.item_id
 and cte.ord_disp_dt = dd.date_string
 and cte.sup_id = ds.supplier_id
 group by dp.product_key, dm.order_key, dd.date_key, ds.supplier_key);
 -- SELECT * FROM `dav6100_db_2_rpt`.`fact_orders`