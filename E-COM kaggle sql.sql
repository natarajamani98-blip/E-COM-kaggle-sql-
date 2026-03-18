create database E_commerce_project;
use E_commerce_project;

-- # avg order value per month; 

select date_format(o.order_date , "%y-%m") as month_, -- # from order date to year and month using date_format()
	   sum(oi.quantity * oi.item_price) as monthly_revenue, -- # normal total calculation 
       count(distinct o.order_id ) as total_orders, -- # from order_id counting distinct order_id  == unique
       sum(oi.quantity * oi.item_price) / count(distinct o.order_id ) as monthly_AOV  -- # avg (total / no of order) as avg value per order 
	from orders o
    join order_items oi -- # normal joins 
    on o.order_id = oi.order_id
    where o.order_status = "completed"  -- # filter only completed
    group by month_  
    order by month_;
    
-- # Average Number of Items per Order per Month

SELECT 
    month_,
    AVG(total_items_per_order) AS avg_items_per_order
FROM (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS month_,
        o.order_id,
        SUM(oi.quantity) AS total_items_per_order
    FROM orders o
    JOIN order_items oi 
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'completed'
    GROUP BY month_, o.order_id
) AS order_level
GROUP BY month_
ORDER BY month_;

-- # Revenue by Category

select p.category,
       sum(oi.quantity * oi.item_price) as category_revenue,

       sum(oi.quantity * oi.item_price) /  sum(sum(oi.quantity * oi.item_price)) over() * 100 as revenue_percentage -- # rev per category / total rev * 100
from products p 
join order_items oi 
on p.product_id = oi.product_id
join orders o 
on oi.order_id = o.order_id 
where o.order_status = "completed"
group by p.category
order by category_revenue desc; 

-- # Revenue Per Customer

select  u.name ,
        sum(oi.quantity * oi.item_price) as total_revenue,
        sum(oi.quantity * oi.item_price) / sum(sum(oi.quantity * oi.item_price)) over() * 100 as revenue_percentage
from users u 
join order_items oi 
on u.user_id = oi.user_id 
join orders o 
on oi.order_id = o.order_id
where o.order_status = "completed"
group by u.name
order by total_revenue desc
limit 10;
    
-- # Repeat Purchase Rate 

select u.user_id , u.name ,
       count( distinct o.order_id ) as total_orders
from users u 
join orders o 
on u.user_id = o.user_id
where o.order_status = "completed" 
group by u.user_id , u.name 
having count( distinct o.order_id ) >= 2;
    
-- # repeat purchase rate 

select sum(case when total_orders >= 2  then 1 else 0 end ) / 
        count(*) * 100 as RPR 
from (
select user_id , count(distinct order_id ) as total_orders 
from orders 
where order_status = "completed"
group by user_id 
) as customers_orders;


-- # repeat vs one time

select customer_type , 
sum(total_revenue) as revenue,
sum(sum(total_revenue)) over () as full_revenue ,
sum(total_revenue) / sum(sum(total_revenue)) over() * 100 as revenue_percentage
from (
select o.user_id , count(distinct oi.order_id ) as total_orders , 
sum(oi.quantity * oi.item_price ) as total_revenue,
case 
when count(distinct oi.order_id ) >= 2 then "repeat" 
else "one_time"
end as customer_type
from orders o
join order_items oi 
on o.order_id = oi.order_id 
where o.order_status = "completed"
group by o.user_id 
) as summary
group by customer_type ;

-- # Simple Event-Level Conversion

select event_type , sum(times_) as times_,
sum(times_) / sum(sum(times_)) over() * 100 as convertion_percentage
from (
select event_type, 
       count(*) as times_ 
from events 
where event_type in ("purchase","view")
group by event_type
) as table_
group by event_type
order by convertion_percentage asc ;

-- # User-Level Conversion Rate 

select sum(case when event_type = "purchase" then uni_user_event end ) / 
	   sum(case when event_type = "view" then uni_user_event end ) * 100 as conversion_rate , 
       100 - sum(case when event_type = "purchase" then uni_user_event end ) / 
	   sum(case when event_type = "view" then uni_user_event end ) * 100 as remaining_
from(
select event_type ,
       count(distinct user_id) as uni_user_event
from events 
where event_type = "view" or event_type = "purchase"
group by event_type 
) as uni_;


-- # cohort analysis
-- # Customers who signed up in Month X , How many of them purchased again in later months?

with cohert_acitivty as 
(select
       date_format(u.signup_date , "%Y-%m") as signup_month ,
       date_format(o.order_date, "%Y-%m") as order_month,
       count(distinct u.user_id) as users_
 from users u 
 join orders o 
 on u.user_id = o.user_id 
 where o.order_status = "completed" and o.order_date >= u.signup_date
 group by signup_month , order_month ) ,
 cohert_total as 
 (SELECT DATE_FORMAT(signup_date, '%Y-%m') AS signup_month,
       COUNT(*) AS total_signups
FROM users
GROUP BY signup_month
ORDER BY signup_month)

select a.signup_month ,
	   a. order_month,
       a. users_,
       c.total_signups,
       (a.users_ / c.total_signups) * 100 as retention_percentage
from cohert_acitivty a 
join cohert_total c 
on a.signup_month = c.signup_month
ORDER BY a.signup_month, a.order_month asc;
       
 -- # rank top product 
 
 with top_ as ( 
 select p.product_id as product_,
        p.product_name,
        sum(oi.quantity * oi.item_price) as total_revenue 
		from products p 
        join order_items oi 
        on p.product_id = oi.product_id
        join orders o
        on oi.order_id = o.order_id 
        where o.order_status = "completed"
        group by p.product_id , p.product_name
        order by total_revenue desc
        ) 
select product_name , total_revenue,
       dense_rank() over ( order by total_revenue desc) as product_rank 
from top_;
       
       
select event_type , count(*)
from events
group by event_type;

select count(*) as total_orders 
from orders ;