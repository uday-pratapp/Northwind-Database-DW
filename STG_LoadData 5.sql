CREATE PROCEDURE STG_LoadData
AS
BEGIN 
------------------------------------------------------------------------ Merge for Customers------------------------------------------------------------------------------------------------------------------------
MERGE NW_STAGING.STG_Customers AS target USING (
  SELECT 
    CustomerID, 
    CompanyName, 
    ContactName, 
    ContactTitle, 
    Address AS CustAddress, 
    City, 
    Region, 
    PostalCode, 
    Country, 
    Phone 
  FROM 
    NW_LANDING.LND_Customers
) AS source ON (
  target.CustomerID = source.CustomerID
) WHEN MATCHED 
AND (
  source.CustomerID <> target.CustomerID 
  or source.CompanyName <> target.CompanyName 
  or source.ContactName <> target.ContactName 
  or source.ContactTitle <> target.ContactTitle 
  or source.CustAddress <> target.CustAddress 
  or source.City <> target.City 
  or source.Region <> target.Region 
  or source.PostalCode <> target.PostalCode 
  or source.Country <> target.Country 
  or source.Phone <> target.Phone
) THEN 
UPDATE 
SET 
  target.CompanyName = source.CompanyName, 
  target.ContactName = source.ContactName, 
  target.ContactTitle = source.ContactTitle, 
  target.CustAddress = source.CustAddress, 
  target.City = source.City, 
  target.Region = source.Region, 
  target.PostalCode = source.PostalCode, 
  target.Country = source.Country, 
  target.Phone = source.Phone, 
  target.LoadTime = GETDATE() WHEN NOT MATCHED THEN INSERT (
    CustomerID, CompanyName, ContactName, 
    ContactTitle, CustAddress, City, 
    Region, PostalCode, Country, Phone, 
    SourceName, LoadTime
  ) 
VALUES 
  (
    source.CustomerID, 
    source.CompanyName, 
    source.ContactName, 
    source.ContactTitle, 
    source.CustAddress, 
    source.City, 
    source.Region, 
    source.PostalCode, 
    source.Country, 
    source.Phone, 
    'LND_Customers', 
    GETDATE()
  ) WHEN NOT MATCHED BY SOURCE THEN DELETE;

----------------------------------------------------------------------------Merge for Employees------------------------------------------------------------------------------------------------------------------------
MERGE NW_STAGING.STG_Employees AS target USING (
  SELECT 
    EmployeeID, 
    LastName, 
    FirstName, 
    BirthDate, 
    HireDate, 
    Region, 
    Country 
  FROM 
    NW_LANDING.LND_Employees
) AS source ON (
  target.EmployeeID = source.EmployeeID
) WHEN MATCHED 
AND (
  source.EmployeeID <> target.EmployeeID 
  or source.LastName <> target.LastName 
  or source.FirstName <> target.FirstName 
  or source.BirthDate <> target.Birthdate 
  or source.HireDate <> target.HireDate 
  or source.Region <> target.Region 
  or source.Country <> target.Country
) THEN 
UPDATE 
SET 
  target.LastName = source.LastName, 
  target.FirstName = source.FirstName, 
  target.BirthDate = source.BirthDate, 
  target.HireDate = source.HireDate, 
  target.Region = source.Region, 
  target.Country = source.Country, 
  target.LoadTime = GETDATE() WHEN NOT MATCHED THEN INSERT (
    EmployeeID, LastName, FirstName, BirthDate, 
    HireDate, Region, Country, SourceName, 
    LoadTime
  ) 
VALUES 
  (
    source.EmployeeID, 
    source.LastName, 
    source.FirstName, 
    source.BirthDate, 
    source.HireDate, 
    source.Region, 
    source.Country, 
    'LND_Employees', 
    GETDATE()
  ) WHEN NOT MATCHED BY SOURCE THEN DELETE;

----------------------------------------------------------------------------- Merge for Categories------------------------------------------------------------------------------------------------------------
MERGE NW_STAGING.STG_Categories AS target USING (
  SELECT 
    CategoryID, 
    CategoryName, 
    Description AS CatDescription 
  FROM 
    NW_LANDING.LND_Categories
) AS source ON (
  target.CategoryID = source.CategoryID
) WHEN MATCHED 
AND (
  source.CategoryID <> target.CategoryID 
  or source.CategoryName <> target.CategoryName
) THEN 
UPDATE 
SET 
  target.CategoryName = source.CategoryName, 
  target.CatDescription = source.CatDescription, 
  target.LoadTime = GETDATE() WHEN NOT MATCHED THEN INSERT (
    CategoryID, CategoryName, CatDescription, 
    SourceName, LoadTime
  ) 
VALUES 
  (
    source.CategoryID, 
    source.CategoryName, 
    source.CatDescription, 
    'LND_Categories', 
    GETDATE()
  ) WHEN NOT MATCHED BY SOURCE THEN DELETE;

-------------------------------------------------------------- Merge for Products------------------------------------------------------------------------------------------------------------
MERGE NW_STAGING.STG_Products AS target USING (
  SELECT 
    ProductID, 
    ProductName, 
    SupplierID, 
    CategoryID, 
    UnitPrice, 
    UnitsInStock, 
    UnitsOnOrder, 
    ReOrderLevel, 
    Discontinued 
  FROM 
    NW_LANDING.LND_Products
) AS source ON (
  target.ProductID = source.ProductID
) WHEN MATCHED 
AND(
  source.ProductName != target.ProductName 
  OR source.UnitPrice != target.UnitPrice 
  OR source.UnitsInStock != target.UnitsInStock 
  OR source.UnitsOnOrder != target.UnitsOnOrder 
  OR source.ReOrderLevel != target.ReOrderLevel 
  OR source.Discontinued != target.Discontinued
) THEN 
UPDATE 
SET 
  target.ProductName = source.ProductName, 
  target.UnitPrice = source.UnitPrice, 
  target.UnitsInStock = source.UnitsInStock, 
  target.UnitsOnOrder = Source.UnitsOnOrder, 
  target.ReOrderLevel = source.ReOrderLevel, 
  target.Discontinued = source.Discontinued, 
  target.LoadTime = GETDATE() WHEN NOT MATCHED THEN INSERT (
    ProductID, ProductName, SupplierID, 
    CategoryID, UnitPrice, UnitsInStock, 
    UnitsOnOrder, ReOrderLevel, Discontinued, 
    SourceName, LoadTime
  ) 
VALUES 
  (
    source.ProductID, 
    source.ProductName, 
    source.SupplierID, 
    source.CategoryID, 
    source.UnitPrice, 
    source.UnitsInStock, 
    source.UnitsOnOrder, 
    source.ReOrderLevel, 
    source.Discontinued, 
    'LND_Products', 
    GETDATE()
  ) WHEN NOT MATCHED BY SOURCE THEN DELETE;

-------------------------------------------------------------------------- Merge for Suppliers------------------------------------------------------------------------------------------------
MERGE NW_STAGING.STG_Suppliers AS target USING (
  SELECT 
    SupplierID, 
    CompanyName, 
    ContactName, 
    ContactTitle, 
    Address AS SupplierAddress, 
    City, 
    Region, 
    PostalCode, 
    Country, 
    Phone 
  FROM 
    NW_LANDING.LND_Suppliers
) AS source ON (
  target.SupplierID = source.SupplierID
) WHEN MATCHED 
AND (
  target.CompanyName != source.CompanyName 
  OR target.ContactName != source.ContactName 
  OR target.ContactTitle != source.ContactTitle 
  OR target.SupplierAddress != source.SupplierAddress 
  OR target.City != source.City 
  OR target.Region != source.Region 
  OR target.PostalCode != source.PostalCode 
  OR target.Country != source.Country 
  OR target.Phone != source.Phone
) THEN 
UPDATE 
SET 
  target.CompanyName = source.CompanyName, 
  target.ContactName = source.ContactName, 
  target.ContactTitle = source.ContactTitle, 
  target.SupplierAddress = source.SupplierAddress, 
  target.City = source.City, 
  target.Region = source.Region, 
  target.PostalCode = source.PostalCode, 
  target.Country = source.Country, 
  target.Phone = source.Phone, 
  target.LoadTime = GETDATE() WHEN NOT MATCHED THEN INSERT (
    SupplierID, CompanyName, ContactName, 
    ContactTitle, SupplierAddress, City, 
    Region, PostalCode, Country, Phone, 
    SourceName, LoadTime
  ) 
VALUES 
  (
    source.SupplierID, 
    source.CompanyName, 
    source.ContactName, 
    source.ContactTitle, 
    source.SupplierAddress, 
    source.City, 
    source.Region, 
    source.PostalCode, 
    source.Country, 
    source.Phone, 
    'LND_Suppliers', 
    GETDATE()
  ) WHEN NOT MATCHED BY SOURCE THEN DELETE;

-------------------------------------------------------------- Merge for Order Details------------------------------------------------------------------------------------------------------------
MERGE NW_STAGING.[STG_Order Details] AS target USING (
  SELECT 
    OrderID, 
    ProductID, 
    UnitPrice, 
    Quantity, 
    Discount 
  FROM 
    NW_LANDING.[LND_Order Details]
) AS source ON (
  target.OrderID = source.OrderID 
  AND target.ProductID = source.ProductID
) WHEN MATCHED 
AND (
  target.UnitPrice != source.UnitPrice 
  OR target.Quantity != source.Quantity 
  OR target.Discount != source.Discount
) THEN 
UPDATE 
SET 
  target.UnitPrice = source.UnitPrice, 
  target.Quantity = source.Quantity, 
  target.Discount = source.Discount, 
  target.LoadTime = GETDATE() WHEN NOT MATCHED THEN INSERT (
    OrderID, ProductID, UnitPrice, Quantity, 
    Discount, SourceName, LoadTime
  ) 
VALUES 
  (
    source.OrderID, 
    source.ProductID, 
    source.UnitPrice, 
    source.Quantity, 
    source.Discount, 
    'LND_Order Details', 
    GETDATE()
  ) WHEN NOT MATCHED BY SOURCE THEN DELETE;

-------------------------------------------------------------------------- Merge for Orders------------------------------------------------------------------------------------------------------------------------
MERGE NW_STAGING.STG_Orders AS target USING (
  SELECT 
    OrderID, 
    CustomerID, 
    EmployeeID, 
    OrderDate 
  FROM 
    NW_LANDING.LND_Orders
) AS source ON (target.OrderID = source.OrderID) WHEN MATCHED 
AND (
  target.CustomerID != source.CustomerID 
  OR target.EmployeeID != source.EmployeeID 
  OR target.OrderDate != source.OrderDate
) THEN 
UPDATE 
SET 
  target.CustomerID = source.CustomerID, 
  target.EmployeeID = source.EmployeeID, 
  target.OrderDate = source.OrderDate, 
  target.LoadTime = GETDATE() WHEN NOT MATCHED THEN INSERT (
    OrderID, CustomerID, EmployeeID, OrderDate, 
    SourceName, LoadTime
  ) 
VALUES 
  (
    source.OrderID, 
    source.CustomerID, 
    source.EmployeeID, 
    source.OrderDate, 
    'LND_Order', 
    GETDATE()
  ) WHEN NOT MATCHED BY SOURCE THEN DELETE;
END



-------------------------------------------------------------- Execute Procedure for merge from LANDING TO STAGING------------------------------------------------------------------------------------------------
EXEC STG_LoadData;

--------------------------------------------------------------------------Drop Procedure------------------------------------------------------------------------------------------------------------------------
DROP PROCEDURE STG_LoadData;

--------------------------------------------------------------View Staging Layer Tables------------------------------------------------------------------------------------------------------------------------
SELECT * FROM NW_STAGING.STG_Customers;
SELECT * FROM NW_STAGING.STG_Employees;
SELECT * FROM NW_STAGING.STG_Categories;
SELECT * FROM NW_STAGING.STG_Products;
SELECT * FROM NW_STAGING.STG_Suppliers;
SELECT * FROM NW_STAGING.[STG_Order Details];
SELECT * FROM NW_STAGING.STG_Orders;

--------------------------------------------------------------------------Drop tables ------------------------------------------------------------------------------------------------------------
DROP TABLE NW_STAGING.STG_Customers;
DROP TABLE NW_STAGING.STG_Employees;
DROP TABLE NW_STAGING.STG_Categories;
DROP TABLE NW_STAGING.STG_Products;
DROP TABLE NW_STAGING.STG_Suppliers;
DROP TABLE NW_STAGING.[STG_Order Details];
DROP TABLE NW_STAGING.STG_Orders;