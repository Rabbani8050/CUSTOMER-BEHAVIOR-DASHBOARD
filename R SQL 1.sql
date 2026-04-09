SHOW DATABASES;
USE customer;
SHOW TABLES;
SELECT * FROM customers;

select gender , SUM(purchase_amount) as revenue
from customers
group by gender


Select customer_id , purchase_amount
from customers
where discount_applied = 'Yes' and purchase_amount >=(select AVG(purchase_amount) from customers)

SELECT item_purchased,
       ROUND(AVG(review_rating), 2) AS Average_Product_Rating
FROM customers
GROUP BY item_purchased
ORDER BY Average_Product_Rating DESC
LIMIT 5;


select shipping_type , ROUND(AVG(purchase_amount),2)
from customers
where shipping_type in ('standard','Express')
group by shipping_type


select subscription_status,
COUNT(customer_id) as total_customers,
ROUND(AVG(purchase_amount),2)as avg_spend,
ROUND(SUM(purchase_amount),2) as total_revenue
from customers
group by subscription_status
order by total_revenue, avg_spend desc;



SELECT item_purchased,
       ROUND(
           SUM(CASE 
                   WHEN UPPER(discount_applied) = 'YES' THEN 1 
                   ELSE 0 
               END) * 100.0 / COUNT(*),
       2) AS discount_rate
FROM customers
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;

with customer_type as(
select customer_id , previous_purchases,
CASE 
     WHEN previous_purchases = 1 THEN 'new'
     WHEN previous_purchases BETWEEN 2 AND 10 THEN 'returning'
     ELSE ' loyel'
     END AS customer_segment
from customers
)

select customer_segment , count(*) as "number of  customers"
from customer_type
group by customer_segment


WITH item_counts AS (
    SELECT category,
           item_purchased,
           COUNT(customer_id) AS total_orders,
           ROW_NUMBER() OVER (
               PARTITION BY category 
               ORDER BY COUNT(customer_id) DESC
           ) AS item_rank
    FROM customers
    GROUP BY category, item_purchased
)

SELECT item_rank, item_purchased, total_orders
FROM item_counts
WHERE item_rank <= 3;




SELECT age_group,
       SUM(purchase_amount) AS total_revenue
FROM customers
GROUP BY age_group
ORDER BY total_revenue DESC;