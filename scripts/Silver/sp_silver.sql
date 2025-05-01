

Stored Procedure: Bronze -> Silver
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
===============================================================================
	
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
---find the duplicate primaty key

select cst_id,COUNT(*) from bronze.crm_cust_info group by cst_id having COUNT(*) > 1 or cst_id is NULL

--bronze-->silver
INSERT INTO silver.crm_cust_info (
			cst_id, 
			cst_key, 
			cst_firstname, 
			cst_lastname, 
			cst_marital_status, 
			cst_gndr,
			cst_create_date
		)

select cst_id,cst_key,trim(cst_firstname)as cst_firstname,trim(cst_lastname)as cst_lastname,
case 
when upper(trim(cst_marital_status)) ='M' then 'Married'
WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
else 'n/a'
end as cst_marital_status,
case 
when upper(trim(cst_gndr)) ='M' then 'Male'
WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
else 'n/a'
end as cst_gndr,
cst_create_date
 from
(select *,ROW_NUMBER() over(partition by cst_id order by cst_create_date desc) as flag_last from bronze.crm_cust_info
where cst_id is NOT NULL)t where flag_last =1

SELECT * from silver.crm_cust_info

select * from bronze.crm_prd_info


INSERT INTO silver.crm_prd_info (
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
--select prd_id,count(*) from bronze.crm_prd_info GROUP by prd_id having COUNT(*)>1 or prd_id is NULL --- no duplicate ids
select prd_id,
replace(SUBSTRING(prd_key,1,5),'-','_') as cat_id,
SUBSTRING(prd_key,7,len(prd_key))as prd_key,
prd_nm,
ISNULL(prd_cost,0) as prd_cost,
case 
WHEN prd_line ='R' Then 'Road'
WHEN prd_line ='S' Then 'Other Sales'
WHEN prd_line ='M' Then 'Mountain'
WHEN prd_line ='T' Then 'Touring'
end As prd_line,
cast(prd_start_dt AS DATE) AS prd_start_dt,
cast(
lead(prd_start_dt) over(partition by prd_key order by prd_start_dt)-1 AS DATE) as prd_end_date 
FROM bronze.crm_prd_info;

SELECT * FROM silver.crm_prd_info

select * from bronze.crm_sales_details

insert into silver.crm_sales_details (
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)

select sls_ord_num,sls_prd_key,sls_cust_id,
case when 
len(sls_order_dt)!=8 or sls_order_dt =0 then null
else cast(cast(sls_order_dt as varchar) as date) end as sls_order_dt,
case when 
len(sls_ship_dt)!=8 or sls_ship_dt =0 then null
else cast(cast(sls_ship_dt as varchar) as date) end as sls_ship_dt,
case when 
len(sls_due_dt)!=8 or sls_due_dt =0 then null
else cast(cast(sls_due_dt as varchar) as date) end as sls_due_date,
case 
when
sls_sales is null or sls_sales <=0 or sls_sales != sls_quantity * ABS(sls_price) then sls_quantity * ABS(sls_price) 
else sls_price END AS sls_sales, 
			sls_quantity,
case when
sls_price <=0 or sls_price is null
then sls_sales/nullif(sls_quantity,0)
else sls_price
end as sls_price
from bronze.crm_sales_details

select * from bronze.erp_cust_az12

INSERT INTO silver.erp_cust_az12 (
			cid,
			bdate,
			gen
		)
select case when
cid like 'NAS%' then substring(cid,4,len(cid))
else cid 
END as cid,
case 
when bdate> GETDATE() then null
else bdate
end as bdate,
case 
when UPPER(TRIM(gen)) IN ('M', 'Male ') THEN 'Male' 
when UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female' 
else 'n/a'
end as gen

 from bronze.erp_cust_az12

---removed special character after male or female 
UPDATE bronze.erp_cust_az12
SET gen = REPLACE(gen, CHAR(13), '');

select * from silver.erp_cust_az12
 
INSERT INTO silver.erp_loc_a101 (
			cid,
			cntry
		) 

  select replace(cid,'-','') as cid, case 
  when TRIM(cntry) is null  OR cntry ='' then 'n/a'
  when TRIM(cntry) in ('US','USA') THEN 'United States'
  when TRIM(cntry) ='DE' THEN 'Germany'
  else TRIM(cntry)
  end as 
  cntry
   from bronze.erp_loc_a101

  select distinct(cntry) from bronze.erp_loc_a101

 select * from  silver.erp_loc_a101

 select * from bronze.erp_px_cat_g1v2
 UPDATE  bronze.erp_px_cat_g1v2
SET maintenance = REPLACE(maintenance, CHAR(13), '');

INSERT INTO silver.erp_px_cat_g1v2 (
			id,
			cat,
			subcat,
			maintenance
		)
		SELECT
			id,
			cat,
			subcat,
			maintenance
		FROM bronze.erp_px_cat_g1v2;

        END

        EXEC silver.load_silver
