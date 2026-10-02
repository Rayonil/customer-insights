--Q1. Qual é a receita total gerada por clientes do sexo masculino em comparação com os do sexo feminino?
SELECT 
	gender,
	SUM(purchase_amount) AS revenue
FROM
	customer
GROUP BY
	gender

--Q2. Quais clientes utilizaram um desconto, mas ainda assim gastaram acima do valor médio de compra?
SELECT
	customer_id,
	purchase_amount
FROM
	customer
WHERE
	discount_applied = 'Yes' and purchase_amount >= (SELECT AVG(purchase_amount) FROM customer)


--Q3. Quais são os 5 produtos com as maiores avaliações médias?
SELECT
	TOP 5 item_purchased,
	ROUND(AVG(CAST(review_rating AS DECIMAL(10,2))), 2) AS 'Average Product Rating'
FROM
	customer
GROUP BY
	item_purchased
ORDER BY 
	AVG(review_rating) desc


--Q4. Compare os valores médios de compra entre as modalidades de envio Padrão e Expresso.
SELECT
	shipping_type,
	ROUND(AVG(purchase_amount), 2) AS 'avg_purchase_amount'
FROM	
	customer
WHERE
	shipping_type in ('Standard', 'Express')
GROUP BY
	shipping_type

--Q5. Clientes assinantes gastam mais? Compare o gasto médio e a receita total
--entre assinantes e não assinantes.
SELECT
	subscription_status,
	COUNT(customer_id) AS 'total_customers',
	ROUND(AVG(purchase_amount),2) AS 'avg_spend',
	ROUND(SUM(purchase_amount), 2) as 'total_revenue'
FROM
	customer
GROUP BY
	subscription_status
ORDER BY
	total_revenue, avg_spend DESC

--Q6. Quais são os 5 produtos com a maior porcentagem de compras com desconto aplicado?
SELECT
	item_purchased,
	ROUND(100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*), 2) AS 'discount_rate'
FROM
	customer
GROUP BY
	item_purchased
ORDER BY
	discount_rate DESC

--Q7. Segmente os clientes em Novos, Recorrentes e Fiéis com base no número total
--de compras anteriores e apresente a contagem de cada segmento.
WITH customer_type AS(
SELECT 
	customer_id,
	previous_purchases,
CASE 
	WHEN previous_purchases = 1 THEN 'New'
	WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
	ELSE 'Loyal'
	END AS customer_segment

FROM
	customer
)

SELECT
	customer_segment,
	COUNT(*) AS 'Number of Customers'
FROM
	customer_type
GROUP BY
	customer_segment

--Q8. Quais são os 3 produtos mais comprados em cada categoria?
WITH item_counts AS(
SELECT
	category,
	item_purchased,
	COUNT(customer_id) AS 'total_orders',
	ROW_NUMBER() OVER(PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS 'item_rank'
FROM
	customer
GROUP BY
	category, item_purchased
)

SELECT
	item_rank,
	category,
	item_purchased,
	total_orders
FROM
	item_counts
WHERE
	item_rank <= 3

--Q9. Clientes que realizam compras recorrentes (mais de 5 compras anteriores) também têm maior probabilidade de assinar o serviço?
SELECT
	subscription_status,
	COUNT(customer_id) AS 'repeat_buyers'
FROM
	customer
WHERE
	previous_purchases > 5
GROUP BY
	subscription_status

--Q10. Qual é a contribuição de cada faixa etária para a receita?
SELECT
	age_group,
	SUM(purchase_amount) AS 'total_revenue'
FROM
	customer
GROUP BY
	age_group
ORDER BY
	total_revenue DESC