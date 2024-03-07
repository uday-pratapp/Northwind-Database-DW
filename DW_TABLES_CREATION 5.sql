
------------------------------------------------------------Schema for staging--------------------------------------------------------------------------------------------------------------
CREATE SCHEMA NW_DW;

--------------------------------------------------------------Creating Tables for DATA WAREHOUSE------------------------------------------------------------------------------------------ 
CREATE PROCEDURE DW_CreateTables 
AS
BEGIN
-------------------------------------------------------------------Dimension Tables-----------------------------------------------------------------------------------------------------------------

CREATE TABLE NW_DW.Calender_DIM(
  CalendarKey INT NOT NULL PRIMARY KEY IDENTITY, 
  FullDate DATETIME, 
  DayOfWeek VARCHAR(15), 
  DayType VARCHAR(20), 
  DayOfMonth INTEGER, 
  Month VARCHAR(10), 
  Quarter VARCHAR(5), 
  Year INT
);
CREATE TABLE NW_DW.Customer_DIM (
  CustomerKey INT NOT NULL PRIMARY KEY, 
  CustomerID VARCHAR(10), 
  CompanyName VARCHAR(40), 
  ContactName VARCHAR(30), 
  ContactTitle VARCHAR(30), 
  CustAddress VARCHAR(60), 
  City VARCHAR(20), 
  Region VARCHAR(20), 
  PostalCode VARCHAR(20), 
  Country VARCHAR(15), 
  Phone VARCHAR(20), 
  LoadTime DATETIME, 
  EndTime DATETIME, 
  CurrentFlag CHAR(3)
);
CREATE TABLE NW_DW.Employee_DIM(
  EmployeeKey INT NOT NULL PRIMARY KEY, 
  EmployeeID VARCHAR(5), 
  LastName VARCHAR(20), 
  FirstName VARCHAR(10), 
  BirthDate DATETIME, 
  HireDate DATETIME, 
  Region VARCHAR(20), 
  Country varchar(20), 
  LoadTime DATETIME, 
  EndTime DATETIME, 
  CurrentFlag CHAR(3)
);
CREATE TABLE NW_DW.Categories_DIM(
  CategoriesKey INT PRIMARY KEY NOT NULL, 
  CategoryID INT, 
  CategoryName VARCHAR(50), 
  CatDescription NTEXT, 
  LoadTime DATETIME, 
  EndTime DATETIME, 
  CurrentFlag CHAR(3)
);
CREATE TABLE NW_DW.Product_DIM(
  ProductKey INT PRIMARY KEY NOT NULL IDENTITY, 
  ProductID VARCHAR(5), 
  ProductName VARCHAR(100), 
  UnitPrice MONEY, 
  Discontinued INT, 
  LoadTime DATETIME, 
  EndTime DATETIME, 
  CurrentFlag CHAR(3)
);
CREATE TABLE NW_DW.Supplier_DIM(
  SupplierKey INT NOT NULL PRIMARY KEY, 
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
  LoadTime DATETIME, 
  EndTime DATETIME, 
  CurrentFlag CHAR(3)
);
------------------------------------------------------------------------Fact Tables-------------------------------------------------------------------------------------------------------------------

Create table NW_DW.CustomerEmployee_Fact(
  CustomerKey INT REFERENCES NW_DW.Customer_DIM(CustomerKey), 
  EmployeeKey INT REFERENCES NW_DW.Employee_DIM(EmployeeKey), 
  CalendarKey INT REFERENCES NW_DW.Calender_DIM(CalendarKey), 
  OrderID VARCHAR(20), 
  Sales INT
);
CREATE TABLE NW_DW.ProductInStock_Fact (
  CalendarKey INT REFERENCES NW_DW.Calender_DIM(CalendarKey), 
  ProductKey INT REFERENCES NW_DW.Product_DIM(ProductKey), 
  CategoriesKey INT REFERENCES NW_DW.Categories_DIM(CategoriesKey), 
  Supplierkey INT REFERENCES NW_DW.Supplier_DIM(Supplierkey), 
  UnitsInStock INT, 
  UnitsOnOrder INT, 
  ReorderLevel INT, 
  TotalQuantity INT, 
  OrderID VARCHAR(20)
);

END

------------------------------------------------------------------------Execute Procedure for creating tables in DW--------------------------------------------------------------------------------------------------------------

EXEC DW_CreateTables;

---------------------------------------------------------------------------------------Drop procedure---------------------------------------------------------------------------------------------------------

DROP PROCEDURE DW_CreateTables;

----------------------------------------------------------------------------- View all tables in DW---------------------------------------------------------------------------------------------------------
SELECT * FROM NW_DW.Calender_DIM;
SELECT * FROM NW_DW.Customer_DIM;
SELECT * FROM NW_DW.Employee_DIM;
SELECT * FROM NW_DW.Categories_DIM;
SELECT * FROM NW_DW.Product_DIM;
SELECT * FROM NW_DW.Supplier_DIM;
SELECT * FROM NW_DW.CustomerEmployee_Fact;
SELECT * FROM NW_DW.ProductInStock_Fact;

------------------------------------------------------------------------ DROP ALL TABLES in DW------------------------------------------------------------------------------------------------------------------------
DROP TABLE NW_DW.Calender_DIM;
DROP TABLE NW_DW.Customer_DIM;
DROP TABLE NW_DW.Employee_DIM;
DROP TABLE NW_DW.Categories_DIM;
DROP TABLE NW_DW.Product_DIM;
DROP TABLE NW_DW.Supplier_DIM;
DROP TABLE NW_DW.CustomerEmployee_Fact;
DROP TABLE NW_DW.ProductInStock_Fact;
