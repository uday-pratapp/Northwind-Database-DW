------------------------------------------------------------Schema for staging--------------------------------------------------------------------------------------------------------------

CREATE SCHEMA NW_STAGING;

--------------------------------------------------------------Creating Tables for Staging Layer----------------------------------------------------------------------------------------------------

CREATE PROCEDURE STG_CreateTables
AS
BEGIN 
CREATE TABLE NW_STAGING.STG_Customers (
  CustomerID char(5), 
  CompanyName varchar(40), 
  ContactName varchar(30), 
  ContactTitle varchar(30), 
  CustAddress varchar(60), 
  City varchar(15), 
  Region varchar(15), 
  PostalCode varchar(10), 
  Country varchar(15), 
  Phone varchar(24), 
  SourceName VARCHAR(25), 
  LoadTime DATETIME
);
CREATE TABLE NW_STAGING.STG_Employees(
  EmployeeID char(5), 
  LastName varchar(20), 
  FirstName varchar(10), 
  BirthDate Datetime, 
  HireDate Datetime, 
  Region varchar(15), 
  Country varchar(15), 
  SourceName VARCHAR(25), 
  LoadTime DATETIME
);
CREATE TABLE NW_STAGING.STG_Categories(
  CategoryID INT, 
  CategoryName VARCHAR(50), 
  CatDescription NTEXT, 
  SourceName VARCHAR(25), 
  LoadTime DATETIME
);
CREATE TABLE NW_STAGING.STG_Products(
  ProductID INT, 
  SupplierID INT, 
  CategoryID INT, 
  ProductName VARCHAR(100), 
  UnitPrice MONEY, 
  UnitsInStock SMALLINT, 
  UnitsOnOrder SMALLINT, 
  ReOrderLevel SMALLINT, 
  Discontinued INT, 
  SourceName VARCHAR(25), 
  LoadTime DATETIME
);
CREATE TABLE NW_STAGING.STG_Suppliers(
  SupplierID INT, 
  CompanyName VARCHAR(50), 
  ContactName VARCHAR(50), 
  ContactTitle VARCHAR(50), 
  SupplierAddress VARCHAR(50), 
  City VARCHAR(50), 
  Region VARCHAR(50), 
  PostalCode VARCHAR(50), 
  Country VARCHAR(50), 
  Phone VARCHAR(50), 
  SourceName VARCHAR(25), 
  LoadTime DATETIME
);
CREATE TABLE NW_STAGING.[STG_Order Details](
  OrderID INT, 
  ProductID INT, 
  UnitPrice MONEY, 
  Quantity INT, 
  Discount INT, 
  SourceName VARCHAR(25), 
  LoadTime DATETIME
);
CREATE TABLE NW_STAGING.STG_Orders(
  OrderID INT, 
  CustomerID VARCHAR(20), 
  EmployeeID INT, 
  OrderDate DATETIME, 
  SourceName VARCHAR(25), 
  LoadTime DATETIME
);
END 

-------------------------------------------------- Execute Procedure for creating Staging Layer Tables-------------------------------------------------------------------------------------------------------

EXEC STG_CreateTables

----------------------------------------------------------------------------------Drop Procedure--------------------------------------------------------------------------------------------------------------

DROP PROCEDURE STG_CreateTables;

----------------------------------------------------------------------------------View Staging Layer Tables----------------------------------------------------------------------------------------------------
SELECT * FROM NW_STAGING.STG_Customers;
SELECT * FROM NW_STAGING.STG_Employees;
SELECT * FROM NW_STAGING.STG_Categories;
SELECT * FROM NW_STAGING.STG_Products;
SELECT * FROM NW_STAGING.STG_Suppliers;
SELECT * FROM NW_STAGING.[STG_Order Details];
SELECT * FROM NW_STAGING.STG_Orders;


----------------------------------------------------------------------------------Drop tables --------------------------------------------------------------------------------------------------------------
DROP TABLE NW_STAGING.STG_Customers;
DROP TABLE NW_STAGING.STG_Employees;
DROP TABLE NW_STAGING.STG_Categories;
DROP TABLE NW_STAGING.STG_Products;
DROP TABLE NW_STAGING.STG_Suppliers;
DROP TABLE NW_STAGING.[STG_Order Details];
DROP TABLE NW_STAGING.STG_Orders;