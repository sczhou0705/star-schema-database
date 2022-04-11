alter table dav6100_db_2_rpt.dim_orders add column eff_date varchar(100) default null;
alter table dav6100_db_2_rpt.dim_orders add column end_date varchar(100) default null;
alter table dav6100_db_2_rpt.dim_orders add column order_status varchar(100) default null;

-- DROP TRIGGER dav6100_db_2.t_ord_order_update_trigger
delimiter $$
CREATE TRIGGER  dav6100_db_2.t_ord_order_update_trigger
	AFTER update ON dav6100_db_2.t_ord_order FOR EACH ROW 
	BEGIN
		DECLARE date_str varchar(200);
        DECLARE order_key_tmp int;
        DECLARE order_amount_tmp varchar(200);
        DECLARE date_dt date;
        
        select order_key, order_amount INTO order_key_tmp, order_amount_tmp 
			from dav6100_db_2_rpt.dim_orders 
            where order_id = old.ord_id and end_date is null;
        
		update dav6100_db_2_rpt.dim_orders set eff_date = new.ord_disp_dt, order_status = new.status_code where order_key = order_key_tmp;
        
        INSERT INTO `dav6100_db_2_rpt`.`dim_orders`
			(`order_id`, `order_amount`, `order_status`, `eff_date`, `end_date`)
            values
            (old.ord_id, order_amount_tmp, old.status_code, old.ord_disp_dt, new.ord_disp_dt);

	END $$
    
-- Run the update script.
update `dav6100_db_2`.t_ord_order
set 
ord_id = '1543',
status_code = 'ini',
ord_disp_dt = '02/21/2020'
where 
ord_id in('1543');

update `dav6100_db_2`.t_ord_item
set 
ord_id = '1543',
status_code = 'cur'
where 
oitem_id in('2142', '8044', '476', '7462');
-- Execute the transformation script
select * from dav6100_db_2_rpt.dim_orders where order_id in('1543');