
-----------------------------------------------------Creating Schema for landing----------------------------------
CREATE SCHEMA NW_LANDING;

--------------------------------------------------------------------Creating Tables for Landing Layer------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE LND_CreateTables 
AS
BEGIN
SELECT * INTO NW_LANDING.LND_Categories
FROM dbo.Categories
    WHERE 1 = 2;

SELECT * INTO NW_LANDING.LND_CustomerCustomerDemo
FROM dbo.CustomerCustomerDemo
    WHERE 1 = 2;

SELECT * INTO NW_LANDING.LND_CustomerDemographics
FROM dbo.CustomerDemographics
    WHERE 1 = 2;

SELECT * INTO NW_LANDING.LND_Customers
FROM dbo.Customers
    WHERE 1 = 2;

SELECT * INTO NW_LANDING.LND_Employees
FROM dbo.Employees
    WHERE 1 = 2;

SELECT * INTO NW_LANDING.LND_EmployeeTerritories
FROM dbo.EmployeeTerritories
    WHERE 1 = 2;

SELECT * INTO NW_LANDING.[LND_Order Details]
FROM dbo.[Order Details]
    WHERE 1 = 2;

SELECT * INTO NW_LANDING.LND_Orders
FROM dbo.Orders
    WHERE 1 = 2;

SELECT * INTO NW_LANDING.LND_Products
FROM dbo.Products
    WHERE 1 = 2;

SELECT * INTO NW_LANDING.LND_Region
FROM dbo.Region
    WHERE 1 = 2;

SELECT * INTO NW_LANDING.LND_Shippers
FROM dbo.Shippers
    WHERE 1 = 2;

SELECT * INTO NW_LANDING.LND_Suppliers
FROM dbo.Suppliers
    WHERE 1 = 2;

SELECT * INTO NW_LANDING.LND_Territories
FROM dbo.Territories
    WHERE 1 = 2;

----------------------------------------------------------------------------Adding two columns----------------------------------------------------------------------------------------------------------------

ALTER TABLE NW_LANDING.LND_Categories
ADD SourceName VARCHAR(25),        
LoadTime DATETIME;

ALTER TABLE NW_LANDING.LND_CustomerCustomerDemo
ADD SourceName VARCHAR(25),       
LoadTime DATETIME;

ALTER TABLE NW_LANDING.LND_CustomerDemographics
ADD SourceName VARCHAR(25),       
LoadTime DATETIME;

ALTER TABLE NW_LANDING.LND_Customers
ADD SourceName VARCHAR(25),       
LoadTime DATETIME;

ALTER TABLE NW_LANDING.LND_Employees
ADD SourceName VARCHAR(25),        
LoadTime DATETIME;

ALTER TABLE NW_LANDING.LND_EmployeeTerritories
ADD SourceName VARCHAR(25),    
LoadTime DATETIME;

ALTER TABLE NW_LANDING.[LND_Order Details]
ADD SourceName VARCHAR(25),   
LoadTime DATETIME;

ALTER TABLE NW_LANDING.LND_Orders
ADD SourceName VARCHAR(25),  
LoadTime DATETIME;

ALTER TABLE NW_LANDING.LND_Products
ADD SourceName VARCHAR(25),  
LoadTime DATETIME;

ALTER TABLE NW_LANDING.LND_Region
ADD SourceName VARCHAR(25),  
LoadTime DATETIME;

ALTER TABLE NW_LANDING.LND_Shippers
ADD SourceName VARCHAR(25),     
LoadTime DATETIME;

ALTER TABLE NW_LANDING.LND_Suppliers
ADD SourceName VARCHAR(25),    
LoadTime DATETIME;

ALTER TABLE NW_LANDING.LND_Territories
ADD SourceName VARCHAR(25),
LoadTime DATETIME;

END 

--------------------------------------------------------------Execute Procedure fOR Creating the tables------------------------------------------------------------------------------------------------------------------------

EXEC LND_CreateTables;

-----------------------------------------------------------------------------Drop Procedure -------------------------------------------------------------------------------------------------------------------------------------

DROP PROCEDURE LND_CreateTables;

-----------------------------------------------------------------------------View ALL tables-------------------------------------------------------------------------------------------------------------------------------------- 

SELECT *
    FROM NW_LANDING.LND_Categories;
SELECT *
    FROM NW_LANDING.LND_CustomerCustomerDemo;
SELECT *
    FROM NW_LANDING.LND_CustomerDemographics;
SELECT *
    FROM NW_LANDING.LND_Customers;
SELECT *
    FROM NW_LANDING.LND_Employees;
SELECT *
    FROM NW_LANDING.LND_EmployeeTerritories;
SELECT *
    FROM NW_LANDING.[LND_Order Details];
SELECT *
    FROM NW_LANDING.LND_Orders;
SELECT *
    FROM NW_LANDING.LND_Products;
SELECT *
    FROM NW_LANDING.LND_Region;
SELECT *
    FROM NW_LANDING.LND_Shippers;
SELECT *
    FROM NW_LANDING.LND_Suppliers;
SELECT *
    FROM NW_LANDING.LND_Territories;