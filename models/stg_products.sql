with source as ( 
    select * from {{ source('northwind_raw', 'PRODUCTS') }} 
) 
select 
    PRODUCT_ID, 
    PRODUCT_NAME, 
    CATEGORY_ID, 
    UNIT_PRICE, 
    UNITS_IN_STOCK, 
    -- transformación mínima  
    case when DISCONTINUED = 1 then true else false end as IS_DISCONTINUED 
from source