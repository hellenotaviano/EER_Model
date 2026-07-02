-- ========================================================================================================================================================
-- 													PROJETO LÓGICO DE BANCO DE DADOS 
-- Sistema: E-commerce Hellen
-- ========================================================================================================================================================

-- 0. CRIA BANCO DE DADOS
-- ___________________________________________________________________________________________

CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- 1. TABELAS INDEPENDENTES 
-- ___________________________________________________________________________________________

-- Criar Tabela Adress
CREATE TABLE Adress (
    idAdress INT NOT NULL AUTO_INCREMENT,
    Adress_Type ENUM ('trabalho', 'residencial', 'hotel', 'outros'),
    Adress_Name VARCHAR(150),
    Number_Exterior INT,
    Complement VARCHAR(45),
    Number_Interior INT,
    Neighborhood VARCHAR(45),
    City VARCHAR(45),
    State_Acronym VARCHAR(4),
    State_Name VARCHAR(45),
    Zip_Code VARCHAR(15), 
    Country VARCHAR(45),
    PRIMARY KEY (idAdress)
);

-- Criar Tabela ID_Cards
CREATE TABLE Id_Cards (
    idCards INT NOT NULL AUTO_INCREMENT,
    Card_Number VARCHAR(20), 
    Date_Register DATETIME,
    Issuing_Body VARCHAR(45),
    Date_Expiration DATETIME,
    PRIMARY KEY (idCards)
);

-- Criar Tabela Pix_Pay
CREATE TABLE Pix_Pay (
    idPix_Pay INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (idPix_Pay)
);

-- Criar Tabela Ticket_Pay
CREATE TABLE Ticket_Pay (
    idTicket INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (idTicket)
);

-- Criar Tabela Card_Pay
CREATE TABLE Card_Pay (
    idCard_Pay INT NOT NULL AUTO_INCREMENT,
    Flag VARCHAR(45),
    CVC INT,
    Expiration_Date DATETIME, 
    CardName VARCHAR(45),
    PRIMARY KEY (idCard_Pay)
);


-- 2. TABELAS DE SEGUNDO NÍVEL 
-- ___________________________________________________________________________________________

-- Criar Tabela Register
CREATE TABLE Register (
    idRegister INT NOT NULL AUTO_INCREMENT,
    Register_Name VARCHAR(200),
    Email VARCHAR(150),
    Telephone VARCHAR(20), 
    Identificador_idIdentificador INT NOT NULL,
    Endereço_idEndereco INT NOT NULL,
    PRIMARY KEY (idRegister),
    FOREIGN KEY (Identificador_idIdentificador) REFERENCES Id_Cards (idCards),
    FOREIGN KEY (Endereço_idEndereco) REFERENCES Adress (idAdress)
);

-- Criar Tabela Payment_Method
CREATE TABLE Payment_Method (
    idPayment_Method INT NOT NULL AUTO_INCREMENT,
    Ticket_Pay_idTicket_Pay INT NOT NULL, 
    Card_Pay_idCard_Pay INT NOT NULL,     
    Pix_Pay_idPix_Pay INT NOT NULL,       
    PRIMARY KEY (idPayment_Method),
    FOREIGN KEY (Ticket_Pay_idTicket_Pay) REFERENCES Ticket_Pay (idTicket),
    FOREIGN KEY (Card_Pay_idCard_Pay) REFERENCES Card_Pay (idCard_Pay),
    FOREIGN KEY (Pix_Pay_idPix_Pay) REFERENCES Pix_Pay (idPix_Pay)
);

-- Criar Tabela Stock
CREATE TABLE Stock (
    idStock INT NOT NULL AUTO_INCREMENT,
    Adress_idAdress INT NOT NULL,
    PRIMARY KEY (idStock),
    FOREIGN KEY (Adress_idAdress) REFERENCES Adress (idAdress)
);


-- 3. ATORES DO SISTEMA E FLUXO DE PRODUTOS
-- ___________________________________________________________________________________________

-- Criar Tabela Supplier
CREATE TABLE Supplier (
    idSupplier INT NOT NULL AUTO_INCREMENT,
    Register_idRegister INT NOT NULL,
    PRIMARY KEY (idSupplier),
    FOREIGN KEY (Register_idRegister) REFERENCES Register (idRegister)
);

-- Criar Tabela Affiliate_Seller
CREATE TABLE Affiliate_Seller (
    idAffiliate_Seller INT NOT NULL AUTO_INCREMENT,
    Register_idRegister INT NOT NULL,
    PRIMARY KEY (idAffiliate_Seller),
    FOREIGN KEY (Register_idRegister) REFERENCES Register (idRegister)
);

-- Criar Tabela Product
CREATE TABLE Product (
    idProduct INT NOT NULL AUTO_INCREMENT,
    Supplier_idSupplier INT NOT NULL,
    PRIMARY KEY (idProduct),
    FOREIGN KEY (Supplier_idSupplier) REFERENCES Supplier (idSupplier)
);


-- 4. PROCESSOS COMERCIAIS E TABELAS INTERMEDIÁRIAS
-- ___________________________________________________________________________________________

-- Criar Tabela Client_Register 
CREATE TABLE Client_Register (
    idClient INT NOT NULL AUTO_INCREMENT,
    Register_idRegister INT NOT NULL,
    Payment_Method_idPayment_Method INT NOT NULL,
    PRIMARY KEY (idClient),
    FOREIGN KEY (Register_idRegister) REFERENCES Register (idRegister),
    FOREIGN KEY (Payment_Method_idPayment_Method) REFERENCES Payment_Method (idPayment_Method)
);

-- Criar Tabela Order_Register 
CREATE TABLE Order_Register (
    idOrder INT NOT NULL AUTO_INCREMENT,
    Client_idClient INT NOT NULL, 
    Product_idProduct INT NOT NULL,
    Date_Delivery DATETIME,
    Value_Delivery FLOAT,
    Date_Order DATETIME,
    PRIMARY KEY (idOrder),
    FOREIGN KEY (Client_idClient) REFERENCES Client_Register (idClient),
    FOREIGN KEY (Product_idProduct) REFERENCES Product (idProduct)
);

-- Criar Tabela Inventory
CREATE TABLE Inventory (
    Stock_idStock INT NOT NULL,
    Product_idProduct INT NOT NULL,
    Product_Supplier_idSupplier INT NOT NULL,
    Quantity INT,
    Weight FLOAT,
    Dimensions FLOAT,
    PRIMARY KEY (Stock_idStock, Product_idProduct, Product_Supplier_idSupplier),
    FOREIGN KEY (Stock_idStock) REFERENCES Stock (idStock),
    FOREIGN KEY (Product_idProduct) REFERENCES Product (idProduct),
    FOREIGN KEY (Product_Supplier_idSupplier) REFERENCES Supplier (idSupplier)
);

-- Criar Tabela Affiliate_Sales 
CREATE TABLE Affiliate_Sales (
    Product_idProduct INT NOT NULL,
    Product_Supplier_idSupplier INT NOT NULL,
    Affiliate_Seller_idAffiliate_Seller INT NOT NULL, 
    PRIMARY KEY (Product_idProduct, Product_Supplier_idSupplier, Affiliate_Seller_idAffiliate_Seller),
    FOREIGN KEY (Product_idProduct) REFERENCES Product (idProduct),
    FOREIGN KEY (Product_Supplier_idSupplier) REFERENCES Supplier (idSupplier),
    FOREIGN KEY (Affiliate_Seller_idAffiliate_Seller) REFERENCES Affiliate_Seller (idAffiliate_Seller)
);

-- Criar Tabela Status_Order
CREATE TABLE Status_Order (
    idStatus_Order INT NOT NULL AUTO_INCREMENT,
    StatusType VARCHAR(45),
    Order_idOrder INT NOT NULL,
    Order_Product_idProduct INT NOT NULL,
    PRIMARY KEY (idStatus_Order),
    FOREIGN KEY (Order_idOrder) REFERENCES Order_Register (idOrder),
    FOREIGN KEY (Order_Product_idProduct) REFERENCES Product (idProduct)
);