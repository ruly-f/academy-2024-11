/*  
    This test ensures that the gross sales for 2012 match
    the audited accounting value:
    R$ 230,784.68
*/

with
    sales_in_2012 as (
        select sum(gross_total) as sum_gross_total
        from {{ ref('int_order_items__metrics') }}
        where order_date between '2012-01-01' and '2012-12-31'
    )

select sum_gross_total
from sales_in_2012
where sum_gross_total not between 230784.00 and 230785.00
