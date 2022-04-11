drop table dav6100_db_2_rpt.fact_orders;
drop table dav6100_db_2_rpt.dim_date;
drop table dav6100_db_2_rpt.dim_product;
drop table dav6100_db_2_rpt.dim_orders;
drop table dav6100_db_2_rpt.dim_suppliers;
use dav6100_db_2_rpt;
CREATE DATABASE  IF NOT EXISTS `dav6100_db_2_rpt`;
USE `dav6100_db_2_rpt`;
CREATE TABLE IF NOT EXISTS `dim_orders` (
  `order_key` int PRIMARY KEY AUTO_INCREMENT,
  `order_id` varchar(255),
  `order_amount` varchar(255)
);

CREATE TABLE IF NOT EXISTS `dim_product` (
  `product_key` int PRIMARY KEY AUTO_INCREMENT,
  `product_id` int,
  `item_id` int,
  `product_description` varchar(1024),
  `product_category` int
);
-- drop table fact_orders
CREATE TABLE IF NOT EXISTS `fact_orders` (
  `product_key` int,
  `order_key` int,
  `date_key` int,
  `supplier_key` int,
  `item_quantity` int,
  `item_amount` decimal(19,4)
);
select * from fact_orders
-- drop table dim_suppliers
CREATE TABLE IF NOT EXISTS `dim_suppliers` (
  `supplier_key` int PRIMARY KEY AUTO_INCREMENT,
  `supplier_id` varchar(255),
  `supplier_name` varchar(255),
  `supplier_status` varchar(255),
  `country_label` varchar(255)
);

CREATE TABLE IF NOT EXISTS `dim_date` (
  `date_key` int PRIMARY KEY AUTO_INCREMENT,
  `date_string` varchar(255),
  `date_year` int,
  `date_month` int,
  `date_day` int,
  `date_quarter` int,
  `date_weekday` int,
  `date_week` int
);


ALTER TABLE `fact_orders` ADD FOREIGN KEY (`date_key`) REFERENCES `dim_date` (`date_key`);
ALTER TABLE `fact_orders` ADD FOREIGN KEY (`order_key`) REFERENCES `dim_orders` (`order_key`);

ALTER TABLE `fact_orders` ADD FOREIGN KEY (`supplier_key`) REFERENCES `dim_suppliers` (`supplier_key`);

ALTER TABLE `fact_orders` ADD FOREIGN KEY (`product_key`) REFERENCES `dim_product` (`product_key`);
