/****** Object:  Database ist722_hhkhan_ca2_dw    Script Date: 8/11/23 4:56:12 PM ******/
/*
Kimball Group, The Microsoft Data Warehouse Toolkit
Generate a database from the datamodel worksheet, version: 4

You can use this Excel workbook as a data modeling tool during the logical design phase of your project.
As discussed in the book, it is in some ways preferable to a real data modeling tool during the inital design.
We expect you to move away from this spreadsheet and into a real modeling tool during the physical design phase.
The authors provide this macro so that the spreadsheet isn't a dead-end. You can 'import' into your
data modeling tool by generating a database using this script, then reverse-engineering that database into
your tool.

Uncomment the next lines if you want to drop and create the database
*/
/*
DROP DATABASE ist722_hhkhan_ca2_dw
GO
CREATE DATABASE ist722_hhkhan_ca2_dw
GO
ALTER DATABASE ist722_hhkhan_ca2_dw
SET RECOVERY SIMPLE
GO
*/
USE ist722_hhkhan_ca2_dw
;
IF EXISTS (SELECT Name from sys.extended_properties where Name = 'Description')
    EXEC sys.sp_dropextendedproperty @name = 'Description'
EXEC sys.sp_addextendedproperty @name = 'Description', @value = 'Default description - you should change this.'
;





-- Create a schema to hold user views (set schema name on home page of workbook).
-- It would be good to do this only if the schema doesn't exist already.
GO
--CREATE SCHEMA fudgeinc
GO


drop table fudgeinc.FactOrderFulfill



/* Drop table fudgeinc.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgeinc.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgeinc.DimDate 
;

/* Create table fudgeinc.DimDate */
CREATE TABLE fudgeinc.DimDate (
   [DateKey]  int   NOT NULL
,  [Date]  datetime   NULL
,  [FullDateUSA]  nchar(11)   NOT NULL
,  [DayOfWeek]  tinyint   NOT NULL
,  [DayName]  nchar(10)   NOT NULL
,  [DayOfMonth]  tinyint   NOT NULL
,  [DayOfYear]  smallint   NOT NULL
,  [WeekOfYear]  tinyint   NOT NULL
,  [MonthName]  nchar(10)   NOT NULL
,  [MonthOfYear]  tinyint   NOT NULL
,  [Quarter]  tinyint   NOT NULL
,  [QuarterName]  nchar(10)   NOT NULL
,  [Year]  tinyint   NOT NULL
,  [IsAWeekday]  varchar(1)  DEFAULT 'N' NOT NULL
, CONSTRAINT [PK_fudgeinc.DimDate] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;


INSERT INTO fudgeinc.DimDate (DateKey, Date, FullDateUSA, DayOfWeek, DayName, DayOfMonth, DayOfYear, WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsAWeekday)
VALUES (-1, '', 'Unk date', 0, 'Unk day', 0, 0, 0, 'Unk month', 0, 0, 'Unk qtr', 0, '?')
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgeinc].[Date]'))
DROP VIEW [fudgeinc].[Date]
GO
CREATE VIEW [fudgeinc].[Date] AS 
SELECT [DateKey] AS [DateKey]
, [Date] AS [Date]
, [FullDateUSA] AS [FullDateUSA]
, [DayOfWeek] AS [DayOfWeek]
, [DayName] AS [DayName]
, [DayOfMonth] AS [DayOfMonth]
, [DayOfYear] AS [DayOfYear]
, [WeekOfYear] AS [WeekOfYear]
, [MonthName] AS [MonthName]
, [MonthOfYear] AS [MonthOfYear]
, [Quarter] AS [Quarter]
, [QuarterName] AS [QuarterName]
, [Year] AS [Year]
, [IsAWeekday] AS [IsAWeekday]
FROM fudgeinc.DimDate
GO





/* Drop table fudgeinc.DimProduct */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgeinc.DimProduct') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgeinc.DimProduct 
;

/* Create table fudgeinc.DimProduct */
CREATE TABLE fudgeinc.DimProduct (
   [ProductKey]  int IDENTITY  NOT NULL
,  [ProductID]  nvarchar(20)   NOT NULL
,  [ProductName]  nvarchar(200)   NOT NULL
,  [ProductCategory]  nvarchar(20)   NOT NULL
,  [SupplierName]  nvarchar(50)   NULL
,  [Source]  nvarchar(10)   NOT NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_fudgeinc.DimProduct] PRIMARY KEY CLUSTERED 
( [ProductKey] )
) ON [PRIMARY]
;


SET IDENTITY_INSERT fudgeinc.DimProduct ON
;
INSERT INTO fudgeinc.DimProduct (ProductKey, ProductID, ProductName, ProductCategory, SupplierName, Source, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, '-1', 'Unknown', 'Unknown', 'Unknown', 'Unk Source', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT fudgeinc.DimProduct OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgeinc].[Product]'))
DROP VIEW [fudgeinc].[Product]
GO
CREATE VIEW [fudgeinc].[Product] AS 
SELECT [ProductKey] AS [ProductKey]
, [ProductID] AS [ProductID]
, [ProductName] AS [ProductName]
, [ProductCategory] AS [ProductCategory]
, [SupplierName] AS [SupplierName]
, [Source] AS [Source]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM fudgeinc.DimProduct
GO





/* Drop table fudgeinc.DimCustomer */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgeinc.DimCustomer') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgeinc.DimCustomer 
;

/* Create table fudgeinc.DimCustomer */
CREATE TABLE fudgeinc.DimCustomer (
   [CustomerKey]  int IDENTITY  NOT NULL
,  [CustomerID]  int   NOT NULL
,  [CustomerName]  nvarchar(101)   NOT NULL
,  [CustomerEmail]  nvarchar(200)   NOT NULL
,  [CustomerAddress]  nvarchar(1000)  NULL
,  [CustomerPhone]  nvarchar(30)  NULL
,  [CustomerFax]  nvarchar(30)   NULL
,  [CustomerState]  nvarchar(4)   NOT NULL
,  [CustomerCity]  nvarchar(50)   NOT NULL
,  [CustomerPostalCode]  nvarchar(20)   NOT NULL
,  [Source]  nvarchar(10)   NOT NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_fudgeinc.DimCustomer] PRIMARY KEY CLUSTERED 
( [CustomerKey] )
) ON [PRIMARY]
;


SET IDENTITY_INSERT fudgeinc.DimCustomer ON
;
INSERT INTO fudgeinc.DimCustomer (CustomerKey, CustomerID, CustomerName, CustomerEmail, CustomerAddress, CustomerPhone, CustomerFax, CustomerState, CustomerCity, CustomerPostalCode, Source, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'None', 'Unk Source', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT fudgeinc.DimCustomer OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgeinc].[Customer]'))
DROP VIEW [fudgeinc].[Customer]
GO
CREATE VIEW [fudgeinc].[Customer] AS 
SELECT [CustomerKey] AS [CustomerKey]
, [CustomerID] AS [CustomerID]
, [CustomerName] AS [CustomerName]
, [CustomerEmail] AS [CustomerEmail]
, [CustomerAddress] AS [CustomerAddress]
, [CustomerPhone] AS [CustomerPhone]
, [CustomerFax] AS [CustomerFax]
, [CustomerState] AS [CustomerState]
, [CustomerCity] AS [CustomerCity]
, [CustomerPostalCode] AS [CustomerPostalCode]
, [Source] AS [Source]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM fudgeinc.DimCustomer
GO





/* Drop table fudgeinc.DimShipper */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgeinc.DimShipper') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgeinc.DimShipper 
;

/* Create table fudgeinc.DimShipper */
CREATE TABLE fudgeinc.DimShipper (
   [ShipperKey]  int IDENTITY  NOT NULL
,  [ShipperName]  nvarchar(20)   NOT NULL
,  [Source]  nvarchar(10)   NOT NULL
,  [RowIsCurrent]  bit  DEFAULT 1 NOT NULL
,  [RowStartDate]  datetime  DEFAULT '12/31/1899' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_fudgeinc.DimShipper] PRIMARY KEY CLUSTERED 
( [ShipperKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT fudgeinc.DimShipper ON
;
INSERT INTO fudgeinc.DimShipper (ShipperKey, ShipperName, Source, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, 'Unknown', 'Unk Source', 1, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT fudgeinc.DimShipper OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgeinc].[Shipper]'))
DROP VIEW [fudgeinc].[Shipper]
GO
CREATE VIEW [fudgeinc].[Shipper] AS 
SELECT [ShipperKey] AS [ShipperKey]
, [ShipperName] AS [ShipperName]
, [Source] AS [Source]
, [RowIsCurrent] AS [Row Is Current]
, [RowStartDate] AS [Row Start Date]
, [RowEndDate] AS [Row End Date]
, [RowChangeReason] AS [Row Change Reason]
FROM fudgeinc.DimShipper
GO





/* Drop table fudgeinc.FactOrderFulfill */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgeinc.FactOrderFulfill') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgeinc.FactOrderFulfill 
;

/* Create table fudgeinc.FactOrderFulfill */
CREATE TABLE fudgeinc.FactOrderFulfill (
   [ProductKey]  int   NOT NULL
,  [CustomerKey]  int   NOT NULL
,  [ShipperKey]  int   NOT NULL
,  [OrderDateKey]  int   NOT NULL
,  [ShippedDateKey]  int   NOT NULL
,  [OrderID]  int   NOT NULL
,  [OrderToShippedLagInDays]  int   NULL
,  [Source]  nvarchar(10)   NULL
, CONSTRAINT [PK_fudgeinc.FactOrderFulfill] PRIMARY KEY NONCLUSTERED 
( [ProductKey], [CustomerKey], [OrderID] )
) ON [PRIMARY]
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[fudgeinc].[OrderFulfillment]'))
DROP VIEW [fudgeinc].[OrderFulfillment]
GO
CREATE VIEW [fudgeinc].[OrderFulfillment] AS 
SELECT [ProductKey] AS [ProductKey]
, [CustomerKey] AS [CustomerKey]
, [ShipperKey] AS [ShipperKey]
, [OrderDateKey] AS [OrderDateKey]
, [ShippedDateKey] AS [ShippedDateKey]
, [OrderID] AS [OrderID]
, [OrderToShippedLagInDays] AS [OrderToShippedLagInDays]
, [Source] AS [Source]
FROM fudgeinc.FactOrderFulfill
GO

ALTER TABLE fudgeinc.FactOrderFulfill ADD CONSTRAINT
   FK_fudgeinc_FactOrderFulfill_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES fudgeinc.DimProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fudgeinc.FactOrderFulfill ADD CONSTRAINT
   FK_fudgeinc_FactOrderFulfill_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES fudgeinc.DimCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fudgeinc.FactOrderFulfill ADD CONSTRAINT
   FK_fudgeinc_FactOrderFulfill_ShipperKey FOREIGN KEY
   (
   ShipperKey
   ) REFERENCES fudgeinc.DimShipper
   ( ShipperKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fudgeinc.FactOrderFulfill ADD CONSTRAINT
   FK_fudgeinc_FactOrderFulfill_OrderDateKey FOREIGN KEY
   (
   OrderDateKey
   ) REFERENCES fudgeinc.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fudgeinc.FactOrderFulfill ADD CONSTRAINT
   FK_fudgeinc_FactOrderFulfill_ShippedDateKey FOREIGN KEY
   (
   ShippedDateKey
   ) REFERENCES fudgeinc.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 