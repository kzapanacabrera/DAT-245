{{ config(materialized='table') }} 
with order_details as ( 
select * from {{ ref('stg_order_details') }} 
), 
products as ( 
select * from {{ ref('stg_products') }} 
), 
categories as ( 
select  
CATEGORY_ID,  
CATEGORY_NAME  
from {{ source('northwind_raw', 'CATEGORIES') }} 
) 
select 
c.CATEGORY_NAME, 
count(distinct o.ORDER_ID) as TOTAL_ORDERS, 
sum(o.QUANTITY) as TOTAL_UNITS_SOLD, 
sum(o.NET_SALES_AMOUNT) as TOTAL_REVENUE, 
sum(p.UNITS_IN_STOCK) as CURRENT_STOCK_LEVEL, -- Ajuste para Snowflake para evitar división por cero 
round(div0(sum(o.NET_SALES_AMOUNT), count(distinct o.ORDER_ID)), 2) as 
AVG_ORDER_VALUE 
from order_details o 
join products p on o.PRODUCT_ID = p.PRODUCT_ID 
join categories c on p.CATEGORY_ID = c.CATEGORY_ID 
group by 1 
order by TOTAL_REVENUE desc