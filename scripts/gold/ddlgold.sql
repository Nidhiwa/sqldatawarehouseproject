DDL Script: Create Gold Views

Usage:
    - These views can be queried directly for analytics and reporting.
=======================================================================


select top 5 * from silver.crm_cust_info
select top 5 * from silver.erp_cust_az12
select  top 5 * from silver.erp_loc_a101

  -- Create Dimension: gold.dim_customers
  =======================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
    SELECT ROW_NUMBER() over(order by cst_id) as customer_key,ci.cst_id as customer_id,ci.cst_firstname as customer_firstname,
    ci.cst_lastname as customer_lastname,ci.cst_marital_status as customer_marital_status,
    case when
       ci.cst_gndr!='n/a' then ci.cst_gndr
    else coalesce(ca.gen,'n/a')
    end as
    
    customer_gender,ca.bdate as customer_birthdate,la.cntry as country ,ci.cst_create_date as customer_createdate from silver.crm_cust_info as ci 
    left JOIN
    silver.erp_cust_az12 as ca
    on ci.cst_key = ca.cid
left JOIN
silver.erp_loc_a101 as la 
ON
ci.cst_key = la.cid

go

select * from gold.dim_customers
=======================================================================
select top 5 * from silver.crm_prd_info 
select top 5 * from silver.erp_px_cat_g1v2 

-- Create Dimension: gold.dim_products
  
CREATE VIEW gold.dim_products AS
select 
ROW_NUMBER() over(order by cat_id,prd_start_dt)  as  product_key,
pd.prd_id as product_id ,pd.prd_key as product_number,
ps.cat as product_category,ps.subcat as product_subcategory,ps.maintenance as product_maintenance,
pd.prd_nm as product_name,pd.prd_cost as product_cost,
pd.prd_line as product_line,pd.prd_start_dt as start_date
from silver.crm_prd_info as pd left JOIN silver.erp_px_cat_g1v2 as ps on pd.cat_id = ps.id
WHERE pd.prd_end_dt IS NULL;
go

select top 5 * from silver.crm_sales_details 
select  top 5 * from gold. dim_customers
select  top 5 * from gold. dim_products 
select top 5 * from silver.crm_cust_info

  -- Create Fact Table: gold.fact_sales
  =======================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO
CREATE VIEW gold.fact_sales AS
select sl.sls_ord_num as order_number,dp.product_key as product_key ,dc.customer_key ascustomer_key ,
sl.sls_order_dt as order_date,sl.sls_ship_dt as ship_date ,sl.sls_due_dt as due_date,sl.sls_sales as sales,
sl.sls_quantity as qunantity,sl.sls_price as price
 from silver.crm_sales_details  as sl
 left join 
 gold.dim_products as dp
 on 
sl.sls_prd_key = dp.product_number
    left join 
 gold.dim_customers as dc
 on  sls_cust_id = dc.customer_id
go

select * from gold.fact_sales
