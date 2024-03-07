------------------------------------------------------------ Populating Fact Tables------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE DW_FactLoad 
AS
BEGIN 

TRUNCATE TABLE NW_DW.ProductInStock_Fact;
INSERT INTO NW_DW.ProductInStock_Fact (
  CalendarKey, ProductKey, CategoriesKey, 
  SupplierKey, UnitsInStock, UnitsOnOrder, 
  ReorderLevel, TotalQuantity, OrderID
) 
SELECT 
  cd.CalendarKey, 
  pd.ProductKey, 
  c.CategoriesKey, 
  s.SupplierKey, 
  p.UnitsInStock, 
  p.UnitsOnOrder, 
  p.ReorderLevel, 
  sum(od.Quantity) as TotalQuantity, 
  o.OrderID 
FROM 
  NW_STAGING.[STG_Order Details] od 
  JOIN NW_STAGING.[STG_Products] p ON p.ProductID = od.ProductID 
  JOIN NW_STAGING.STG_Orders o ON o.OrderID = od.OrderID 
  JOIN NW_DW.[Categories_DIM] c ON p.CategoryID = c.CategoryID 
  JOIN NW_DW.Supplier_DIM s ON p.SupplierID = s.SupplierID 
  JOIN NW_DW.[Calender_DIM] cd ON o.OrderDate = cd.FullDate 
  JOIN NW_DW.[Product_DIM] pd ON od.ProductID = pd.ProductID 
GROUP BY 
  cd.CalendarKey, 
  pd.ProductKey, 
  c.CategoriesKey, 
  s.SupplierKey, 
  p.UnitsInStock, 
  p.UnitsOnOrder, 
  p.ReorderLevel, 
  o.OrderID;
TRUNCATE TABLE NW_DW.CustomerEmployee_Fact;
INSERT INTO NW_DW.CustomerEmployee_Fact (
  CustomerKey, EmployeeKey, CalendarKey, 
  OrderID, Sales
) 
SELECT 
  c.CustomerKey, 
  e.EmployeeKey, 
  cd.CalendarKey, 
  o.OrderID, 
  SUM(od.UnitPrice * od.Quantity) as Sales 
FROM 
  NW_STAGING.[STG_Order Details] od 
  JOIN NW_STAGING.STG_Orders o ON o.OrderID = od.OrderID 
  JOIN NW_DW.[Calender_DIM] cd ON o.OrderDate = cd.FullDate 
  JOIN NW_DW.Customer_DIM c ON o.CustomerID = c.CustomerID 
  JOIN NW_DW.Employee_DIM e ON o.EmployeeID = e.EmployeeID 
GROUP BY 
  c.CustomerKey, 
  e.EmployeeKey, 
  cd.CalendarKey, 
  o.OrderID;
END

--------------------------------------------------------------Execute Procedure------------------------------------------------------------------------------------------------------------------------
EXEC DW_FactLoad;


--------------------------------------------------------------------------drop procedure ------------------------------------------------------------------------------------------------------------------------
DROP PROCEDURE DW_FactLoad;

--------------------------------------------------------------------------view tables------------------------------------------------------------------------------------------------------------------------
SELECT * FROM NW_DW.CustomerEmployee_Fact;
SELECT * FROM NW_DW.ProductInStock_Fact;