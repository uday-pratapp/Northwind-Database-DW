CREATE PROCEDURE DW_LoadData 
AS 
BEGIN 
------------------------------------------------------------------------Merge  CUSTOMER DIM------------------------------------------------------------------------------------------------------------------------------------------------
MERGE INTO NW_DW.Customer_DIM AS Target USING NW_STAGING.STG_Customers AS Source ON Target.CustomerID = Source.CustomerID 
AND Target.CurrentFlag = 'Y' WHEN MATCHED 
AND (
  Target.CompanyName != Source.CompanyName 
  OR Target.ContactName != Source.ContactName 
  OR Target.ContactTitle != Source.ContactTitle 
  OR Target.CustAddress != Source.CustAddress 
  OR Target.City != Source.City 
  OR Target.Region != Source.Region 
  OR Target.PostalCode != Source.PostalCode 
  OR Target.Country != Source.Country 
  OR Target.Phone != Source.Phone
) THEN 
UPDATE 
SET 
  Target.EndTime = GETDATE(), 
  Target.CurrentFlag = 'N' WHEN NOT MATCHED BY Target THEN INSERT (
    CustomerKey, CustomerID, CompanyName, 
    ContactName, ContactTitle, CustAddress, 
    City, Region, PostalCode, Country, 
    Phone, LoadTime, EndTime, CurrentFlag
  ) 
VALUES 
  (
    HASHBYTES(
      'MD5', 
      CONCAT(
        Source.CustomerID, 
        ISNULL(Source.CompanyName, ''), 
        ISNULL(Source.ContactName, ''), 
        ISNULL(Source.ContactTitle, ''), 
        ISNULL(Source.CustAddress, ''), 
        ISNULL(Source.City, ''), 
        ISNULL(Source.Region, ''), 
        ISNULL(Source.PostalCode, ''), 
        ISNULL(Source.Country, ''), 
        ISNULL(Source.Phone, '')
      )
    ), 
    Source.CustomerID, 
    Source.CompanyName, 
    Source.ContactName, 
    Source.ContactTitle, 
    Source.CustAddress, 
    Source.City, 
    Source.Region, 
    Source.PostalCode, 
    Source.Country, 
    Source.Phone, 
    GETDATE(), 
    NULL, 
    'Y'
  );
--Insert updated records as new ones with CurrentFlag = 'Y' and EndTime = NULL
INSERT INTO NW_DW.Customer_DIM (
  CustomerKey, CustomerID, CompanyName, 
  ContactName, ContactTitle, CustAddress, 
  City, Region, PostalCode, Country, 
  Phone, LoadTime, EndTime, CurrentFlag
) 
SELECT 
  HASHBYTES(
    'MD5', 
    CONCAT(
      Source.CustomerID, 
      ISNULL(Source.CompanyName, ''), 
      ISNULL(Source.ContactName, ''), 
      ISNULL(Source.ContactTitle, ''), 
      ISNULL(Source.CustAddress, ''), 
      ISNULL(Source.City, ''), 
      ISNULL(Source.Region, ''), 
      ISNULL(Source.PostalCode, ''), 
      ISNULL(Source.Country, ''), 
      ISNULL(Source.Phone, '')
    )
  ), 
  Source.CustomerID, 
  Source.CompanyName, 
  Source.ContactName, 
  Source.ContactTitle, 
  Source.CustAddress, 
  Source.City, 
  Source.Region, 
  Source.PostalCode, 
  Source.Country, 
  Source.Phone, 
  GETDATE(), 
  NULL, 
  'Y' 
FROM 
  NW_STAGING.STG_Customers AS Source 
  JOIN NW_DW.Customer_DIM AS Target ON Target.CustomerID = Source.CustomerID 
WHERE 
  Target.CurrentFlag = 'N';

--------------------------------------------------------------------------Merge for Employee------------------------------------------------------------------------------------------------------------------------

MERGE INTO NW_DW.Employee_DIM AS Target USING NW_STAGING.STG_Employees AS Source ON Target.EmployeeID = Source.EmployeeID 
AND Target.CurrentFlag = 'Y' WHEN MATCHED 
AND (
  Target.LastName != Source.LastName 
  OR Target.FirstName != Source.FirstName 
  OR Target.BirthDate != Source.BirthDate 
  OR Target.HireDate != Source.HireDate 
  OR Target.Region != Source.Region 
  OR Target.Country != Source.Country
) THEN 
UPDATE 
SET 
  Target.EndTime = GETDATE(), 
  Target.CurrentFlag = 'N' WHEN NOT MATCHED BY Target THEN INSERT (
    EmployeeKey, EmployeeID, LastName, 
    FirstName, BirthDate, HireDate, Region, 
    Country, LoadTime, EndTime, CurrentFlag
  ) 
VALUES 
  (
    HASHBYTES(
      'SHA2_256', 
      CONCAT(
        Source.EmployeeID, 
        ISNULL(Source.LastName, ''), 
        ISNULL(Source.FirstName, ''), 
        ISNULL(
          CONVERT(VARCHAR, Source.BirthDate, 120), 
          ''
        ), 
        ISNULL(
          CONVERT(VARCHAR, Source.HireDate, 120), 
          ''
        ), 
        ISNULL(Source.Region, ''), 
        ISNULL(Source.Country, '')
      )
    ), 
    Source.EmployeeID, 
    Source.LastName, 
    Source.FirstName, 
    Source.BirthDate, 
    Source.HireDate, 
    Source.Region, 
    Source.Country, 
    GETDATE(), 
    NULL, 
    'Y'
  );
--Insert updated records as new ones with CurrentFlag = 'Y' and EndTime = NULL
INSERT INTO NW_DW.Employee_DIM (
  EmployeeKey, EmployeeID, LastName, 
  FirstName, BirthDate, HireDate, Region, 
  Country, LoadTime, EndTime, CurrentFlag
) 
SELECT 
  HASHBYTES(
    'SHA2_256', 
    CONCAT(
      Source.EmployeeID, 
      ISNULL(Source.LastName, ''), 
      ISNULL(Source.FirstName, ''), 
      ISNULL(
        CONVERT(VARCHAR, Source.BirthDate, 120), 
        ''
      ), 
      ISNULL(
        CONVERT(VARCHAR, Source.HireDate, 120), 
        ''
      ), 
      ISNULL(Source.Region, ''), 
      ISNULL(Source.Country, '')
    )
  ), 
  Source.EmployeeID, 
  Source.LastName, 
  Source.FirstName, 
  Source.BirthDate, 
  Source.HireDate, 
  Source.Region, 
  Source.Country, 
  GETDATE(), 
  NULL, 
  'Y' 
FROM 
  NW_STAGING.STG_Employees AS Source 
  JOIN NW_DW.Employee_DIM AS Target ON Target.EmployeeID = Source.EmployeeID 
WHERE 
  Target.CurrentFlag = 'N';

--------------------------------------------------------------------------Merge for Calender------------------------------------------------------------------------------------------------

MERGE INTO NW_DW.Calender_DIM AS Target USING (
  SELECT 
    DISTINCT OrderDate 
  FROM 
    NW_STAGING.STG_Orders
) AS Source ON Target.FullDate = Source.OrderDate WHEN NOT MATCHED BY Target THEN INSERT (
  FullDate, DayOfWeek, DayType, DayOfMonth, 
  Month, Quarter, Year
) 
VALUES 
  (
    Source.OrderDate, 
    DATENAME(WEEKDAY, Source.OrderDate), 
    CASE WHEN DATEPART(WEEKDAY, Source.OrderDate) IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END, 
    --assuming 1 = Sunday, 7 = Saturday
    DATEPART(DAY, Source.OrderDate), 
    DATENAME(MONTH, Source.OrderDate), 
    'Q' + DATENAME(QUARTER, Source.OrderDate), 
    YEAR(Source.OrderDate)
  ) WHEN MATCHED THEN 
UPDATE 
SET 
  Target.DayOfWeek = DATENAME(WEEKDAY, Source.OrderDate), 
  Target.DayType = (
    CASE WHEN DATEPART(WEEKDAY, Source.OrderDate) IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END
  ), 
  Target.DayOfMonth = DATEPART(DAY, Source.OrderDate), 
  Target.Month = DATENAME(MONTH, Source.OrderDate), 
  Target.Quarter = 'Q' + DATENAME(QUARTER, Source.OrderDate), 
  Target.Year = YEAR(Source.OrderDate);

--------------------------------------------------------------------------Categories_Dim------------------------------------------------------------------------------------------------------------------------

MERGE INTO NW_DW.Categories_DIM AS Target USING NW_STAGING.STG_Categories AS Source ON Target.CategoryID = Source.CategoryID 
AND Target.CurrentFlag = 'Y' WHEN MATCHED 
AND (
  Target.CategoryName != Source.CategoryName
) THEN 
UPDATE 
SET 
  Target.EndTime = GETDATE(), 
  Target.CurrentFlag = 'N' WHEN NOT MATCHED BY Target THEN INSERT (
    CategoriesKey, CategoryID, CategoryName, 
    CatDescription, LoadTime, EndTime, 
    CurrentFlag
  ) 
VALUES 
  (
    HASHBYTES(
      'MD5', 
      CONCAT(
        Source.CategoryID, 
        ISNULL(Source.CategoryName, ''), 
        ISNULL(Source.CatDescription, '')
      )
    ), 
    Source.CategoryID, 
    Source.CategoryName, 
    Source.CatDescription, 
    GETDATE(), 
    NULL, 
    'Y'
  );
-- Insert updated rows as new ones with CurrentFlag = 'Y' and EndTime = NULL
INSERT INTO NW_DW.Categories_DIM (
  CategoriesKey, CategoryID, CategoryName, 
  CatDescription, LoadTime, EndTime, 
  CurrentFlag
) 
SELECT 
  HASHBYTES(
    'MD5', 
    CONCAT(
      Source.CategoryID, 
      ISNULL(Source.CategoryName, ''), 
      ISNULL(Source.CatDescription, '')
    )
  ), 
  Source.CategoryID, 
  Source.CategoryName, 
  Source.CatDescription, 
  GETDATE(), 
  NULL, 
  'Y' 
FROM 
  NW_STAGING.STG_Categories AS Source 
  JOIN NW_DW.Categories_DIM AS Target ON Target.CategoryID = Source.CategoryID 
WHERE 
  Target.CurrentFlag = 'N';

--------------------------------------------------------------------------Merge for Products-------------------------------------------------------------------------------------------------------------------------------------------------------------------

MERGE INTO NW_DW.Product_DIM AS Target USING NW_STAGING.STG_Products AS Source ON Target.ProductID = Source.ProductID 
AND Target.CurrentFlag = 'Y' WHEN MATCHED 
AND (
  Target.ProductName != Source.ProductName 
  OR Target.UnitPrice != Source.UnitPrice 
  OR Target.Discontinued != Source.Discontinued
) THEN 
UPDATE 
SET 
  Target.EndTime = GETDATE(), 
  Target.CurrentFlag = 'N' WHEN NOT MATCHED BY Target THEN INSERT (
    ProductID, ProductName, UnitPrice, 
    Discontinued, LoadTime, EndTime, 
    CurrentFlag
  ) 
VALUES 
  (
    Source.ProductID, 
    Source.ProductName, 
    Source.UnitPrice, 
    Source.Discontinued, 
    GETDATE(), 
    NULL, 
    'Y'
  );
-- Insert updated rows as new ones with CurrentFlag = 'Y' and EndTime = NULL
INSERT INTO NW_DW.Product_DIM (
  ProductID, ProductName, UnitPrice, 
  Discontinued, LoadTime, EndTime, 
  CurrentFlag
) 
SELECT 
  Source.ProductID, 
  Source.ProductName, 
  Source.UnitPrice, 
  Source.Discontinued, 
  GETDATE(), 
  NULL, 
  'Y' 
FROM 
  NW_STAGING.STG_Products AS Source 
  JOIN NW_DW.Product_DIM AS Target ON Target.ProductID = Source.ProductID 
WHERE 
  Target.CurrentFlag = 'N';

--------------------------------------------------------------------------Merge for Supplier------------------------------------------------------------------------------------------------------------------------

MERGE INTO NW_DW.Supplier_DIM AS Target USING NW_STAGING.STG_Suppliers AS Source ON Target.SupplierID = Source.SupplierID 
AND Target.CurrentFlag = 'Y' WHEN MATCHED 
AND (
  Target.CompanyName != Source.CompanyName 
  OR Target.ContactName != Source.ContactName 
  OR Target.ContactTitle != Source.ContactTitle 
  OR Target.SupplierAddress != Source.SupplierAddress 
  OR Target.City != Source.City 
  OR Target.Region != Source.Region 
  OR Target.PostalCode != Source.PostalCode 
  OR Target.Country != Source.Country 
  OR Target.Phone != Source.Phone
) THEN 
UPDATE 
SET 
  Target.EndTime = GETDATE(), 
  Target.CurrentFlag = 'N' WHEN NOT MATCHED BY Target THEN INSERT (
    SupplierKey, SupplierID, CompanyName, 
    ContactName, ContactTitle, SupplierAddress, 
    City, Region, PostalCode, Country, 
    Phone, LoadTime, EndTime, CurrentFlag
  ) 
VALUES 
  (
    HASHBYTES(
      'MD5', 
      CONCAT(
        Source.SupplierID, 
        ISNULL(Source.CompanyName, ''), 
        ISNULL(Source.ContactName, ''), 
        ISNULL(Source.ContactTitle, ''), 
        ISNULL(Source.SupplierAddress, ''), 
        ISNULL(Source.City, ''), 
        ISNULL(Source.Region, ''), 
        ISNULL(Source.PostalCode, ''), 
        ISNULL(Source.Country, ''), 
        ISNULL(Source.Phone, '')
      )
    ), 
    Source.SupplierID, 
    Source.CompanyName, 
    Source.ContactName, 
    Source.ContactTitle, 
    Source.SupplierAddress, 
    Source.City, 
    Source.Region, 
    Source.PostalCode, 
    Source.Country, 
    Source.Phone, 
    GETDATE(), 
    NULL, 
    'Y'
  );
-- Insert updated rows as new ones with CurrentFlag = 'Y' and EndTime = NULL
INSERT INTO NW_DW.Supplier_DIM (
  SupplierKey, SupplierID, CompanyName, 
  ContactName, ContactTitle, SupplierAddress, 
  City, Region, PostalCode, Country, 
  Phone, LoadTime, EndTime, CurrentFlag
) 
SELECT 
  HASHBYTES(
    'MD5', 
    CONCAT(
      Source.SupplierID, 
      ISNULL(Source.CompanyName, ''), 
      ISNULL(Source.ContactName, ''), 
      ISNULL(Source.ContactTitle, ''), 
      ISNULL(Source.SupplierAddress, ''), 
      ISNULL(Source.City, ''), 
      ISNULL(Source.Region, ''), 
      ISNULL(Source.PostalCode, ''), 
      ISNULL(Source.Country, ''), 
      ISNULL(Source.Phone, '')
    )
  ), 
  Source.SupplierID, 
  Source.CompanyName, 
  Source.ContactName, 
  Source.ContactTitle, 
  Source.SupplierAddress, 
  Source.City, 
  Source.Region, 
  Source.PostalCode, 
  Source.Country, 
  Source.Phone, 
  GETDATE(), 
  NULL, 
  'Y' 
FROM 
  NW_STAGING.STG_Suppliers AS Source 
  JOIN NW_DW.Supplier_DIM AS Target ON Target.SupplierID = Source.SupplierID 
WHERE 
  Target.CurrentFlag = 'N';
EXEC DW_FactLoad;
EXEC LND_TRUNCATE;
END

--------------------------------------------------------------------------Execute Procedure for loading data in DW------------------------------------------------------------------------------------------------
EXEC DW_LoadData;


--------------------------------------------------------------------------------------------------Drop procedure------------------------------------------------------------------------------------------------
DROP PROCEDURE DW_LoadData;

-------------------------------------------------------------------------------------------------- View all tables in DW------------------------------------------------------------------------------------------------
SELECT * FROM NW_DW.Calender_DIM;
SELECT * FROM NW_DW.Customer_DIM;
SELECT * FROM NW_DW.Employee_DIM;
SELECT * FROM NW_DW.Categories_DIM;
SELECT * FROM NW_DW.Product_DIM;
SELECT * FROM NW_DW.Supplier_DIM;
SELECT * FROM NW_DW.CustomerEmployee_Fact;
SELECT * FROM NW_DW.ProductInStock_Fact;

-------------------------------------------------------------------------------------------------- DROP ALL TABLES in DW------------------------------------------------------------------------
DROP TABLE NW_DW.Calender_DIM;
DROP TABLE NW_DW.Customer_DIM;
DROP TABLE NW_DW.Employee_DIM;
DROP TABLE NW_DW.Categories_DIM;
DROP TABLE NW_DW.Product_DIM;
DROP TABLE NW_DW.Supplier_DIM;
--------------------------------------------------------------------------------------------------Execute this first------------------------------------------------------------------------------------------------------------------------
DROP TABLE NW_DW.CustomerEmployee_Fact;
DROP TABLE NW_DW.ProductInStock_Fact;
