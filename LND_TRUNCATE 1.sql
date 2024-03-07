CREATE PROCEDURE LND_TRUNCATE 
AS
BEGIN 
DECLARE @TableName nvarchar(500);
DECLARE @SchemaName nvarchar(50);

SET 
  @SchemaName = 'NW_LANDING';
DECLARE cur CURSOR FOR 
SELECT 
  table_name 
FROM 
  INFORMATION_SCHEMA.TABLES 
WHERE 
  table_schema = @SchemaName 
  AND TABLE_TYPE = 'BASE TABLE';
OPEN cur;
FETCH NEXT 
FROM 
  cur INTO @TableName;
WHILE @@FETCH_STATUS = 0 BEGIN EXEC(
  'TRUNCATE TABLE [' + @SchemaName + '].[' + @TableName + ']'
);
FETCH NEXT 
FROM 
  cur INTO @TableName;
END;
CLOSE cur;
DEALLOCATE cur;
END
