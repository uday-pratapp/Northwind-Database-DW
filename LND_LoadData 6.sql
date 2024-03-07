
CREATE PROCEDURE 
LND_LoadData AS BEGIN 

-------------------------------------------------------- Insert for Categories------------------------------------------------------------------------------------------------------------------------

SET 
  IDENTITY_INSERT NW_LANDING.LND_Categories ON INSERT INTO NW_LANDING.LND_Categories(
    CategoryID, CategoryName, Description, 
    Picture, SourceName, LoadTime
  ) 
SELECT 
  CategoryID, 
  CategoryName, 
  Description, 
  Picture, 
  'Categories', 
  GETDATE() 
FROM 
  dbo.Categories;
SET 
  IDENTITY_INSERT NW_LANDING.LND_Categories OFF;

------------------------------------------------------------------ Insert for CustomerCustomerDemo--------------------------------------------------------------------------------------------------------

INSERT INTO NW_LANDING.LND_CustomerCustomerDemo (
  CustomerID, CustomerTypeID, SourceName, 
  LoadTime
) 
SELECT 
  CustomerID, 
  CustomerTypeID, 
  'CustomerCustomerDemo', 
  GETDATE() 
FROM 
  dbo.CustomerCustomerDemo;

------------------------------------------------------------------ Insert for CustomerDemographics--------------------------------------------------------------------------------------------------------

INSERT INTO NW_LANDING.LND_CustomerDemographics (
  CustomerTypeID, CustomerDesc, SourceName, 
  LoadTime
) 
SELECT 
  CustomerTypeID, 
  CustomerDesc, 
  'CustomerDemographics', 
  GETDATE() 
FROM 
  dbo.CustomerDemographics;

------------------------------------------------------------------ Insert for Customers------------------------------------------------------------------------------------------------------------------------

INSERT INTO NW_LANDING.LND_Customers(
  CustomerID, CompanyName, ContactName, 
  ContactTitle, Address, City, Region, 
  PostalCode, Country, Phone, Fax, SourceName, 
  LoadTime
) 
SELECT 
  CustomerID, 
  CompanyName, 
  ContactName, 
  ContactTitle, 
  Address, 
  City, 
  Region, 
  PostalCode, 
  Country, 
  Phone, 
  Fax, 
  'Customers', 
  GETDATE() 
FROM 
  dbo.Customers;

--------------------------------------------------------------------- Insert for Employees------------------------------------------------------------------------------------------------------------------------

SET 
  IDENTITY_INSERT NW_LANDING.LND_Employees ON INSERT INTO NW_LANDING.LND_Employees (
    Address, BirthDate, City, Country, 
    EmployeeID, Extension, FirstName, 
    HireDate, HomePhone, LastName, Notes, 
    Photo, PhotoPath, PostalCode, Region, 
    ReportsTo, Title, TitleOfCourtesy, 
    SourceName, LoadTime
  ) 
SELECT 
  Address, 
  BirthDate, 
  City, 
  Country, 
  EmployeeID, 
  Extension, 
  FirstName, 
  HireDate, 
  HomePhone, 
  LastName, 
  Notes, 
  Photo, 
  PhotoPath, 
  PostalCode, 
  Region, 
  ReportsTo, 
  Title, 
  TitleOfCourtesy, 
  'Employees', 
  GETDATE() 
FROM 
  dbo.Employees;
SET 
  IDENTITY_INSERT NW_LANDING.LND_Employees OFF;

------------------------------------------------------------------ Insert for EmployeeTerritories----------------------------------------------------------------------------------------------------------------

INSERT INTO NW_LANDING.LND_EmployeeTerritories (
  EmployeeID, TerritoryID, SourceName, 
  LoadTime
) 
SELECT 
  EmployeeID, 
  TerritoryID, 
  'EmployeeTerritories', 
  GETDATE() 
FROM 
  dbo.EmployeeTerritories;
-- Insert for Order Details
INSERT INTO NW_LANDING.[LND_Order Details] (
  Discount, OrderID, ProductID, Quantity, 
  UnitPrice, SourceName, LoadTime
) 
SELECT 
  Discount, 
  OrderID, 
  ProductID, 
  Quantity, 
  UnitPrice, 
  'Order Details', 
  GETDATE() 
FROM 
  dbo.[Order Details];

----------------------------------------------------------------------- Insert for Orders------------------------------------------------------------------------------------------------------------------------

SET 
  IDENTITY_INSERT NW_LANDING.LND_Orders ON INSERT INTO NW_LANDING.LND_Orders(
    OrderID, CustomerID, employeeId, OrderDate, 
    RequiredDate, ShippedDate, ShipVia, 
    Freight, shipName, shipAddress, shipCity, 
    shipRegion, shipPostalCode, shipCountry, 
    SourceName, LoadTime
  ) 
SELECT 
  OrderID, 
  CustomerID, 
  employeeId, 
  OrderDate, 
  RequiredDate, 
  ShippedDate, 
  ShipVia, 
  Freight, 
  shipName, 
  shipAddress, 
  shipCity, 
  shipRegion, 
  shipPostalCode, 
  shipCountry, 
  'Orders', 
  GETDATE() 
FROM 
  dbo.Orders;
SET 
  IDENTITY_INSERT NW_LANDING.LND_Orders OFF;

-------------------------------------------------------------------------- Insert for Products----------------------------------------------------------------------------------------------------------------

SET 
  IDENTITY_INSERT NW_LANDING.LND_Products ON INSERT INTO NW_LANDING.LND_Products(
    ProductID, ProductName, SupplierID, 
    CategoryID, QuantityPerUnit, UnitPrice, 
    UnitsInStock, UnitsOnOrder, ReorderLevel, 
    Discontinued, SourceName, LoadTime
  ) 
SELECT 
  ProductID, 
  ProductName, 
  SupplierID, 
  CategoryID, 
  QuantityPerUnit, 
  UnitPrice, 
  UnitsInStock, 
  UnitsOnOrder, 
  ReorderLevel, 
  Discontinued, 
  'Products', 
  GETDATE() 
FROM 
  dbo.Products;
SET 
  IDENTITY_INSERT NW_LANDING.LND_Products OFF;

---------------------------------------------------------------------------------- Insert for Region----------------------------------------------------------------------------------------------------------------

INSERT INTO NW_LANDING.LND_Region (
  RegionID, RegionDescription, SourceName, 
  LoadTime
) 
SELECT 
  RegionID, 
  RegionDescription, 
  'Region', 
  GETDATE() 
FROM 
  dbo.Region;

---------------------------------------------------------------------------------- Insert for Shippers-------------------------------------------------------------------------------------------------------------------

SET 
  IDENTITY_INSERT NW_LANDING.LND_Shippers ON INSERT INTO NW_LANDING.LND_Shippers(
    ShipperID, CompanyName, Phone, SourceName, 
    LoadTime
  ) 
SELECT 
  ShipperID, 
  CompanyName, 
  Phone, 
  'Shippers', 
  GETDATE() 
FROM 
  dbo.Shippers;
SET 
  IDENTITY_INSERT NW_LANDING.LND_Shippers OFF;

------------------------------------------------------------------------------------ Insert for Suppliers--------------------------------------------------------------------------------------------------------

SET 
  IDENTITY_INSERT NW_LANDING.LND_Suppliers ON INSERT INTO NW_LANDING.LND_Suppliers(
    SupplierID, CompanyName, ContactName, 
    ContactTitle, Address, City, Region, 
    PostalCode, Country, Phone, Fax, HomePage, 
    SourceName, LoadTime
  ) 
SELECT 
  SupplierID, 
  CompanyName, 
  ContactName, 
  ContactTitle, 
  Address, 
  City, 
  Region, 
  PostalCode, 
  Country, 
  Phone, 
  Fax, 
  HomePage, 
  'Suppliers', 
  GETDATE() 
FROM 
  dbo.Suppliers;
SET 
  IDENTITY_INSERT NW_LANDING.LND_Suppliers OFF;

-------------------------------------------------------------------------- Insert for Territories----------------------------------------------------------------------------------------------------------------

INSERT INTO NW_LANDING.LND_Territories (
  TerritoryID, TerritoryDescription, 
  RegionID, SourceName, LoadTime
) 
SELECT 
  TerritoryID, 
  TerritoryDescription, 
  RegionID, 
  'Territories', 
  GETDATE() 
FROM 
  dbo.Territories;
END;


-------------------------------------------------------------------------------Execute Procedure----------------------------------------------------------------------------------------------------------------
EXEC LND_LoadData;

----------------------------------------------------------------------------------Delete Procedure----------------------------------------------------------------------------------------------------------------
DROP PROCEDURE LND_LoadData;


--------------------------------------------------------------------------------------View Tables -----------------------------------------------------------------------------------------------------------------------
SELECT * FROM NW_LANDING.LND_Categories;
SELECT * FROM NW_LANDING.LND_CustomerCustomerDemo;
SELECT * FROM NW_LANDING.LND_CustomerDemographics;
SELECT * FROM NW_LANDING.LND_Customers;
SELECT * FROM NW_LANDING.LND_Employees;
SELECT * FROM NW_LANDING.LND_EmployeeTerritories;
SELECT * FROM NW_LANDING.[LND_Order Details];
SELECT * FROM NW_LANDING.LND_Orders;
SELECT * FROM NW_LANDING.LND_Products;
SELECT * FROM NW_LANDING.LND_Region;
SELECT * FROM NW_LANDING.LND_Shippers;
SELECT * FROM NW_LANDING.LND_Suppliers;
SELECT * FROM NW_LANDING.LND_Territories;


--------------------------------------------------------------------------DELETING ALL THE TABLES AND DATA------------------------------------------------------------------------------------------------------------

DROP TABLE NW_LANDING.LND_Categories;
DROP TABLE NW_LANDING.LND_CustomerCustomerDemo;
DROP TABLE NW_LANDING.LND_CustomerDemographics;
DROP TABLE NW_LANDING.LND_Customers;
DROP TABLE NW_LANDING.LND_Employees;
DROP TABLE NW_LANDING.LND_EmployeeTerritories;
DROP TABLE NW_LANDING.[LND_Order Details];
DROP TABLE NW_LANDING.LND_Orders;
DROP TABLE NW_LANDING.LND_Products;
DROP TABLE NW_LANDING.LND_Region;
DROP TABLE NW_LANDING.LND_Shippers;
DROP TABLE NW_LANDING.LND_Suppliers;
DROP TABLE NW_LANDING.LND_Territories;



UPDATE NW_LANDING.LND_Customers SET ContactName = 'John' 
WHERE CustomerID= 'ALFKI';

UPDATE NW_LANDING.LND_Employees SET FirstName = 'Test 2' 
WHERE EmployeeID= '1';