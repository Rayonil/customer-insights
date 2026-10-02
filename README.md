# 🛍️ Customer Insights

Análise de ponta a ponta do comportamento de compra de clientes de varejo. O projeto cobre limpeza e preparação dos dados em Python, análise exploratória e respostas a perguntas de negócio em SQL Server, e visualização final em um dashboard interativo no Power BI.

📌 Objetivo

Entender quem são os clientes, como compram e o que gera receita, respondendo perguntas como:
- Qual gênero e faixa etária mais contribuem para a receita?
- Descontos e assinaturas realmente aumentam o gasto médio?
- Quais produtos são mais bem avaliados e mais vendidos por categoria?
- Como os clientes se distribuem entre novos, recorrentes e fiéis?

🔄 Pipeline do projeto
 Dados brutos (Excel/CSV)
          │
          ▼
 ┌─────────────────────┐
 │ 1. Python / Jupyter │  Limpeza, padronização e tratamento de nulos
 └─────────────────────┘
          │
          ▼
 ┌─────────────────────┐
 │ 2. SQL Server       │  Carga dos dados e 10 consultas de negócio
 └─────────────────────┘
          │
          ▼
 ┌─────────────────────┐
 │ 3. Power BI         │  Dashboard interativo com KPIs e segmentações
 └─────────────────────┘

 📂 Estrutura do repositório
customer-behavior-analysis/
├── data/
│   └── customer_shopping_behavior.csv     # Base de dados (3.900 compras, 18 colunas)
├── notebooks/
│   └── customer_data_cleaning.ipynb        # Etapa 1: limpeza com pandas
├── sql/
│   └── SQLQuery_customer.sql               # Etapa 2: consultas de negócio
├── dashboard/
│   └── customer_behavior_dashboard.pbix    # Etapa 3: dashboard Power BI
├── images/
│   └── dashboard.png                       # Print do dashboard
└── README.md

🗂️ Sobre os dados

A base contém 3.900 registros de compra com 18 atributos, entre eles:

Grupo	Colunas
Cliente	Customer ID, Age, Gender, Location, Subscription Status
Produto	Item Purchased, Category, Size, Color, Season
Compra	Purchase Amount (USD), Discount Applied, Promo Code Used, Payment Method, Shipping Type
Comportamento	Previous Purchases, Frequency of Purchases, Review Rating

Os produtos estão divididos em quatro categorias: Clothing, Footwear, Outerwear e Accessories. A idade dos clientes vai de 18 a 70 anos.

1️⃣ Etapa 1: Limpeza de dados com Python

Notebook: customer_data_cleaning.ipynb

Principais tratamentos:

Remoção de linhas duplicadas e de colunas irrelevantes.
Padronização de textos com expressões regulares (remoção de caracteres inválidos).
Conversão de valores como N/a, na e NA em nulos reconhecidos pelo pandas.
Padronização de colunas categóricas (ex.: Yes/No).
Tratamento de valores ausentes (ex.: Review Rating possui 37 nulos na base original).
Renomeação das colunas para snake_case (purchase_amount, review_rating, etc.).
Criação da coluna age_group (faixa etária) para as análises seguintes.
Exportação da base tratada para o SQL Server.
2️⃣ Etapa 2: Análise com SQL Server

Script: SQLQuery_customer.sql

Com os dados carregados na tabela customer, foram respondidas 10 perguntas de negócio:

#	Pergunta	Técnicas
Q1	Receita total por gênero	GROUP BY, SUM
Q2	Clientes que usaram desconto e gastaram acima da média	Subquery
Q3	Top 5 produtos com maior avaliação média	TOP, AVG, CAST
Q4	Gasto médio: frete Standard vs Express	WHERE IN, AVG
Q5	Assinantes gastam mais?	Agregações múltiplas
Q6	Produtos com maior % de compras com desconto	CASE WHEN
Q7	Segmentação: Novos, Recorrentes e Fiéis	CTE, CASE WHEN
Q8	Top 3 produtos mais comprados por categoria	CTE, ROW_NUMBER() OVER (PARTITION BY)
Q9	Compradores recorrentes tendem a assinar?	Filtro + agregação
Q10	Contribuição de cada faixa etária na receita	GROUP BY, ORDER BY

3️⃣ Etapa 3: Dashboard no Power BI

Arquivo: customer_behavior_dashboard.pbix

O dashboard reúne os principais KPIs (receita total, ticket médio, número de clientes, avaliação média) e permite filtrar por gênero, categoria, faixa etária, status de assinatura e tipo de envio.

💡 Principais insights
Receita total de US$ 233 mil, com ticket médio de cerca de US$ 59,76 por compra.
Clientes do sexo masculino geram cerca de 68% da receita (US$ 157,9 mil contra US$ 75,2 mil).
Assinatura não aumenta o ticket médio: assinantes gastam em média US$ 59,49, e não assinantes, US$ 59,87. Os não assinantes são cerca de 73% da base e concentram a maior parte da receita.
Frete Express tem ticket um pouco maior (US$ 60,48) que o Standard (US$ 58,46).
A base é majoritariamente fiel: cerca de 3.100 clientes têm mais de 10 compras anteriores, contra apenas 83 clientes novos.
Produtos mais bem avaliados: Gloves, Sandals e Boots, todos com média próxima de 3,8.
🎯 Recomendações de negócio
Rever a proposta de valor da assinatura, que hoje não se traduz em gasto maior por compra.
Criar ações de aquisição de novos clientes, já que a base depende fortemente de clientes antigos.
Desenvolver campanhas direcionadas ao público feminino, com potencial de crescimento de receita.
Usar os produtos mais bem avaliados como vitrine em campanhas e promoções.
