-- Q11.
SELECT p.product_id, p.product_name, p.list_price, c.category_name, s.quantity AS stock_qty
FROM production.products p
JOIN production.categories c 
ON p.category_id = c.category_id
JOIN production.stocks s 
ON s.product_id = p.product_id
LIMIT 10


-- Q12. 
SELECT p.product_name, b.brand_name, c.category_name, p.model_year, p.list_price
FROM production.products p
JOIN production.brands b 
ON b.brand_id = p.brand_id
JOIN production.categories c 
ON c.category_id = p.category_id
WHERE p.model_year BETWEEN 2017 AND 2018
AND p.product_name LIKE '_u________%a%' 
ORDER BY p.model_year DESC, p.list_price ASC


-- Q13.
SELECT c.first_name, c.last_name, sto.store_name, sta.first_name AS served_by
FROM sales.orders o
JOIN sales.customers c 
ON c.customer_id = o.customer_id
JOIN sales.stores sto 
ON sto.store_id = o.store_id
JOIN sales.staffs sta 
ON sta.staff_id = o.staff_id


-- Q14.
SELECT c.category_name, p.product_name
FROM production.products p
JOIN production.categories c 
ON c.category_id = p.category_id
WHERE p.product_name LIKE '_u______%6'


-- Q15. 
SELECT o.order_date, o.store_id, COUNT(customer_id) AS numb_cust
FROM sales.orders o
WHERE order_date BETWEEN '2016-01-01' AND '2016-12-31'
GROUP BY order_date, store_id
HAVING COUNT(customer_id) = 1
ORDER BY order_date ASC


-- Q16. 
SELECT order_id, list_price, discount, (list_price - (list_price * discount)) final, SUM(quantity) AS no_items
FROM sales.order_items
WHERE discount < 0.10
GROUP BY order_id, list_price, discount
HAVING SUM(quantity) > 1
ORDER BY order_id ASC


-- Q17.
SELECT model_year, category_id, list_price, AVG(list_price)
FROM production.products
WHERE list_price > 500 
GROUP BY model_year, category_id, list_price
HAVING AVG(list_price) BETWEEN 800 AND 2000
ORDER BY model_year DESC, category_id ASC


-- Q18.
SELECT p.product_name, p.model_year, p.list_price, t1.most_sold
FROM (
	SELECT o.product_id, COUNT (quantity) AS most_sold
	FROM sales.order_items o
	GROUP BY product_id
	ORDER BY most_sold DESC
	LIMIT 1
	) t1
JOIN production.products p 
ON t1.product_id = p.product_id


-- Q19.
WITH highest_lp AS (
	SELECT p.category_id, p.product_name, p.list_price
	FROM production.products p
	ORDER BY p.list_price DESC
	LIMIT 1
	) 
SELECT hlp.product_name, hlp.list_price, c.category_name
FROM production.categories c
JOIN highest_lp hlp
ON hlp.category_id = c.category_id


-- Q20.
WITH most_staff AS (
	SELECT s.store_id, COUNT (staff_id) AS no_staffs
	FROM sales.staffs s
	GROUP BY store_id
	ORDER BY no_staffs DESC
	LIMIT 1
	)

SELECT ms.store_id, ms.no_staffs, COUNT(order_id) AS no_orders
FROM sales.orders o
JOIN most_staff ms
ON ms.store_id = o.store_id
GROUP BY ms.store_id, ms.no_staffs
