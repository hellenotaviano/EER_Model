-- ========================================================================================================================================================
-- 										REQUISICOES AO BANCO DE DADOS DO ECOMMERCE
-- Sistema: E-commerce Hellen
-- As Querys sao propostas nao em cima de um caso real mais de um projeto lógico de um BD de ecommerce e as provaveis requisicoes que 
-- poderiam ter sido feitas dentro desse contexto
-- ========================================================================================================================================================



-- Recuperações simples com SELECT Statement.

SELECT idProduct, Supplier_idSupplier  
FROM Product;

-- Explicando a query:
-- Seleciona as colunas do Supplier do ID do produto da tabela Product

SELECT Stock_idStock, Product_idProduct, Quantity 
FROM Inventory;

-- Explicando a query:
-- Seleciona as colunas do Id do Stock, ID do produto e a quantidade da tabela de Inventory
-- ___________________________________________________________________________________________________________________________



-- Filtros com WHERE Statement

SELECT idAdress, Adress_Name, City, State_Acronym  
FROM Adress
WHERE Adress_Type = 'residencial' AND State_Acronym = 'SP';

-- Explicando a query:
-- Seleciona as colunas de Endereco, Cidade e Estado com filtro do tipo de endereco e sigla de estado

SELECT Stock_idStock, Product_idProduct, Quantity 
FROM Inventory
WHERE Quantity < 5 ;

-- Explicando a query:
-- Seleciona as colunas do Id do Stock, ID do produto e a quantidade da tabela de Inventory e 
-- utiliza o filtro de WHERE para saber quais produtos estao em baixa nos Stocks

-- ___________________________________________________________________________________________________________________________



-- Expressões para gerar atributos derivados.

SELECT 	
    idOrder, 
    Value_Delivery AS Valor_Original_Frete,
    (Value_Delivery * 1.15) AS Frete_Com_Taxa_Derivada,
    ROUND((Value_Delivery * 0.15), 2) AS Custo_Adicional
FROM Order_Register;

-- Explicando a query:
-- Seleciona a coluna de valor de frete da tabela de Order_Registrer, 
-- agrega um aumento de 1.5 para analisar a viabilidade de adicionar uma taxa de contigencia no valor do frete

SELECT 
    idOrder AS Numero_Pedido,
    Date_Order AS Data_do_Pedido,
    Date_Delivery AS Data_Prometida_Entrega,
    DATEDIFF(Date_Delivery, NOW()) AS Dias_Restantes_Para_Entrega
FROM Order_Register;

-- Explicando a query:
-- Seleciona a coluna do Id da ordem, as datas do pedido e da entrega, 
-- utiliza o DATEDIFF + NOW para calcular o tempo de entrega e trazer esses dados na coluna Dias_Restantes_Para_Entrega


-- ___________________________________________________________________________________________________________________________



-- Ordenações dos dados com ORDER BY.

SELECT Stock_idStock, Product_idProduct, Quantity  
FROM Inventory
ORDER BY Quantity DESC;

-- Explicando a query:
-- Seleciona as colunas de ID do stock, ID do produto e quantida e ordena de forma decrescente

SELECT 
    idOrder AS Numero_Pedido,
    Date_Order AS Data_do_Pedido,
    Date_Delivery AS Data_Prometida_Entrega,
    DATEDIFF(Date_Delivery, NOW()) AS Dias_Restantes_Para_Entrega,
    CASE 
        WHEN DATEDIFF(Date_Delivery, NOW()) > 0 THEN CONCAT('Faltam ', DATEDIFF(Date_Delivery, NOW()), ' dias')
        WHEN DATEDIFF(Date_Delivery, NOW()) = 0 THEN 'Entrega é HOJE!'
        ELSE CONCAT('ATRASADO há ', ABS(DATEDIFF(Date_Delivery, NOW())), ' dias')
    END AS Status_Prazo
FROM Order_Register
ORDER BY Dias_Restantes_Para_Entrega ASC;

-- Explicando a query:
-- Seleciona a coluna do Id da ordem, as datas do pedido e da entrega, 
-- utiliza o DATEDIFF + NOW para calcular o tempo de entrega e trazer esses dados na coluna Dias_Restantes_Para_Entrega
-- Usando o CASE para tornar a visualizacao dos dados mais amigavel e informar a urgencia de cada entrega
-- Ao final utilizando um ORDER BY para organizar do menor tempo de entrega para o maior



-- ___________________________________________________________________________________________________________________________



-- Condições de filtros aos grupos – HAVING Statement

SELECT  
    Product_idProduct, 
    COUNT(idOrder) AS Total_Pedidos,
    AVG(Value_Delivery) AS Media_Frete
FROM Order_Register
GROUP BY Product_idProduct
HAVING AVG(Value_Delivery) > 25.00;

-- Explicando a query:
-- Seleciona os pedidos realizadado, conta o total de pedido, faz a media do frete desses pedido, 
-- organiza pelo ID onde os frete possuem valor medio superior a 25

SELECT  
    Product_idProduct, 
    Quantity AS Total_Produtos,
    AVG(Weight) AS Media_Peso
FROM Inventory
GROUP BY Product_idProduct
HAVING AVG(Weight) > 2.00;

-- Explicando a query:
-- Seleciona a coluna de ID de produto, a quantidade de produtos e faz a media de peso de casa produto
-- organiza pelo ID onde dos produtos e informa os produtos com pesos superior a 2 



-- ___________________________________________________________________________________________________________________________



-- Junções entre tabelas para fornecer uma perspectiva mais complexa dos dados

SELECT 
    O.idOrder AS Numero_Pedido,
    R.Register_Name AS Nome_Cliente,
    R.Email AS Email_Contato,
    O.Product_idProduct AS Codigo_Produto,
    O.Date_Order AS Data_Compra,
    S.StatusType AS Status_Atual
FROM Order_Register O
INNER JOIN Client_Register C ON O.Client_idClient = C.idClient
INNER JOIN Register R        ON C.Register_idRegister = R.idRegister
INNER JOIN Status_Order S    ON O.idOrder = S.Order_idOrder
ORDER BY O.Date_Order DESC;

-- Explicando a query:
-- Seleciona os dados de cliente e das ordens de produtos para entender o perfil do consumidor e seu comportamento, 
-- esse query junta as tabelas da ordem e produto, junto com a de cliente para fazer um analise mais complexa.

SELECT 
    O.idOrder AS Numero_Pedido,
    O.Date_Order AS Data_da_Compra,
    O.Product_idProduct AS Codigo_Produto,
    R.Register_Name AS Nome_Fornecedor,
    R.Email AS Email_Fornecedor
FROM Order_Register O
INNER JOIN Product P  ON O.Product_idProduct = P.idProduct
INNER JOIN Supplier S ON P.Supplier_idSupplier = S.idSupplier
INNER JOIN Register R ON S.Register_idRegister = R.idRegister
ORDER BY O.Date_Order DESC;

-- Explicando a query:
-- Seleciona as colunas relacionada pedido e forncedor através da juncao entre as tabelas de Produto, Registro e Fornecedor
-- para saber o produto que foi vendido e de qual fornecedor ele vem.



-- ___________________________________________________________________________________________________________________________
