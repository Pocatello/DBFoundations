--*************************************************************************--
-- Title: Assignment06_Jlevenson
-- Author: Joshua Levenson
-- Desc: This file demonstrates how to use Views
-- Change Log: When,Who,What
-- 2021-22-02 Created File
 2021-22-02 7:40 pm Joshua Levenson answered question 1 and 2
 9:00 pm Joshua Levenson answered questions 4 
 2021-23-02 
 12:00 pm Joshua Levenson answered question 5 
 4 pm Joshua Levenson answered question 6
 6-7:30 PM Joshua Levenson answered question 7 and 8
 8 PM Joshua Levenson answered question 9
 2021-24-02 
 2:15 pm Joshua Levenson answered question number 10


--**************************************************************************-
Begin Try 
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment06DB_Jlevenson')
	 Begin 
	  Alter Database [Assignment06DB_Jlevenson] set Single_user With Rollback Immediate;
	  Drop Database Assignment06DB_Jlevenson;
	 End
	Create Database Assignment06DB_Jlevenson;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment06DB_Jlevenson;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [mOney] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Order By 1, 2
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From Categories;
go
Select * From Products;
go
Select * From Employees;
go
Select * From Inventories;
go

/********************************* Questions and Answers *********************************/
'NOTES------------------------------------------------------------------------------------ 
 1) You can use any name you like for you views, but be descriptive and consistent
 2) You can use your working code from assignment 5 for much of this assignment
 3) You must use the BASIC views for each table after they are created in Question 1
------------------------------------------------------------------------------------------'

-- Question 1 (5 pts): How can you create BACIC views to show data from each table in the database.
-- NOTES: 1) Do not use a *, list out each column!
--        2) Create one view per table!
--		  3) Use SchemaBinding to protect the views from being orphaned!



Create View vCategories 
With SchemaBinding
 AS
  Select CategoryID, CategoryName 
   From dbo.Categories;

Go

Create View vProducts
With SchemaBinding
As 
Select ProductName, UnitPrice
From dbo.Products

Go 

Create View Vemployees 
With Schemabinding 
As
Select EmployeeFirstName, EmployeeLastName, EmployeeID
From dbo.Employees

Go 

Create View vInventories
With Schemabinding 
As
Select EmployeeID, InventoryID, InventoryDate, Count, ProductID
From dbo.Inventories

Go 



-- Question 2 (5 pts): How can you set permissions, so that the public group CANNOT select data 
-- from each table, but can select data from each view?
Deny Select On Products to Public;
Grant Select On vProducts to Public;

Deny Select On Employees to Public;
Grant Select On vEmployees to Public;

Deny Select On  Inventories to Public;
Grant Select On vInventories to Public;

Deny Select On  Categories to Public;
Grant Select On vCategories to Public;


-- Question 3 (10 pts): How can you create a view to show a list of Category and Product names, 
-- and the price of each product?
-- Order the result by the Category and Product!
Select * From [dbo].[vCategories]

--------------------
/* Go 

Join Northwind.dbo.Products
On Categories.CategoryID = Products.CategoryID
 Order By Category ProductName */ ---1st attempt




Create View vProductPrice 
as 
Select Top 10000000000 
ProductName, UnitPrice, CategoryName
From dbo.Products Join dbo.Categories
on  Products.CategoryID = Categories.CategoryID


Select * From vProductPrice


Select * From vProductPrice
Select * From Categories;
go
Select * From Products;
go
Select * From Employees;
go
Select * From Inventories;
go



-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,UnitPrice
-- Beverages,Chai,18.00
-- Beverages,Chang,19.00
-- Beverages,Chartreuse verte,18.00


-- Question 4 (10 pts): How can you create a view to show a list of Product names 
-- and Inventory Counts on each Inventory Date?
-- Order the results by the Product, Date, and Count!
Create View VProductInventory
as 
Select Top 10000000000 
ProductName, Count, InventoryDate
From dbo.Products Join dbo.Inventories
On  Products.ProductID = Inventories.ProductID
Order by ProductName, InventoryDate, Count 


Select * From VProductInventory
go


Select * From Products;

go
Select * From Inventories;
go





-- Here is an example of some rows selected from the view:
--ProductName,InventoryDate,Count
--Alice Mutton,2017-01-01,15
--Alice Mutton,2017-02-01,78
--Alice Mutton,2017-03-01,83


-- Question 5 (10 pts): How can you create a view to show a list of Inventory Dates 
-- and the Employee that took the count?
-- Order the results by the Date and return only one row per date!
/* Create View Vstockdate_by_employee
as 
Select Top 10000000 
InventoryDate, EmployeeFirstName, EmployeeLastName
From dbo.Inventories Join dbo.Employees
On Inventories.EmployeeID = Employees.EmployeeID */  -- First Try


ALTER View Vstockdate_by_employee
as 
Select Distinct Top 10000000 
InventoryDate, concat(EmployeeFirstName, EmployeeLastName) as EmployeeName 
From dbo.Inventories Join dbo.Employees
On Inventories.EmployeeID = Employees.EmployeeID ---Try with "Concat"
Order By InventoryDate



Select * From Vstockdate_by_employee


Select * From Inventories;
Select * From Employees;

-- Here is an example of some rows selected from the view:
-- InventoryDate,EmployeeName
-- 2017-01-01,Steven Buchanan
-- 2017-02-01,Robert King
-- 2017-03-01,Anne Dodsworth


-- Question 6 (10 pts): How can you create a view show a list of Categories, Products, 
-- and the Inventory Date and Count of each product?
-- Order the results by the Category, Product, Date, and Count!
*/ Create View VInventoryReport 
as 
Select Top 1000000000 
CategoryName, ProductName, InventoryDate, Count 
From dbo.Categories Inner Join dbo.Products
On  Categories.CategoryID = Products.CategoryID
From dbo.Products Inner Join dbo.Inventories
On Product.ProductID = Inventories.ProductID */ ---1st attempt. I needed to ommit the second from statement.
------
Create View VInventoriesByProductsByCategories
as 
Select Top 10000000000 

CategoryName, ProductName
From dbo.Categories Join dbo.products
On  Categories.CategoryID = Products.CategoryID

Go 

Alter View VInventoriesByProductsByCategories
As
Select Top 10000000000 
CategoryName, ProductName, InventoryDate, Count 
From dbo.Categories Join dbo.Products
On Categories.CategoryID = Products.CategoryID
Join dbo.Inventories
On Inventories.ProductID = Products.ProductID 

Go 

Select * From VInventoriesByProductsByCategories
Go 






Select * From Categories; 
Select * From Products;

Select * From Inventories;
Select * From Employees;



-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count
-- Beverages,Chai,2017-01-01,72
-- Beverages,Chai,2017-02-01,52
-- Beverages,Chai,2017-03-01,54


-- Question 7 (10 pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the EMPLOYEE who took the count?
-- Order the results by the Inventory Date, Category, Product and Employee!

Create View vInventoriesByEmployeesByDates

As
Select Top 10000000000 
CategoryName, ProductName, InventoryDate, Count, concat(EmployeeFirstName, EmployeeLastName) as EmployeeName 
From dbo.Categories Join dbo.Products
On Categories.CategoryID = Products.CategoryID 
Join dbo.Inventories
On Inventories.ProductID = Products.ProductID 
Join dbo.Employees
On Inventories.EmployeeID = Employees.EmployeeID



ALTER View vInventoriesByEmployeesByDates

As
Select Top 10000000000 
CategoryName, ProductName, InventoryDate, Count, concat(EmployeeFirstName, EmployeeLastName) as EmployeeName 
From dbo.Categories Join dbo.Products
On Categories.CategoryID = Products.CategoryID 
Join dbo.Inventories
On Inventories.ProductID = Products.ProductID 
Join dbo.Employees
On Inventories.EmployeeID = Employees.EmployeeID

----------




Select * From vInventoriesByEmployeesByDates


ALTER View vInventoriesByEmployeesByDates

As
Select Top 10000000000 
CategoryName, ProductName, InventoryDate, Count, concat(EmployeeFirstName, EmployeeLastName) as EmployeeName 
From dbo.Categories Join dbo.Products
On Categories.CategoryID = Products.CategoryID
Join dbo.Inventories
On Inventories.ProductID = Products.ProductID 
Join dbo.Employees
On Inventories.EmployeeID = Employees.EmployeeID
Order By InventoryDate, CategoryName, ProductName, EmployeeName 





Select * From vInventoriesByEmployeesByDates




Select * From Categories; 
Select * From Products;

Select * From Inventories;
Select * From Employees;


-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count,EmployeeName
-- Beverages,Chai,2017-01-01,72,Steven Buchanan
-- Beverages,Chang,2017-01-01,46,Steven Buchanan
-- Beverages,Chartreuse verte,2017-01-01,61,Steven Buchanan


-- Question 8 (10 pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the Employee who took the count
-- for the Products 'Chai' and 'Chang'? 

Create View vInventoriesByProductsEmployeesDates

As
Select Top 100000000
CategoryName, ProductName, InventoryDate, Count, concat(EmployeeFirstName, EmployeeLastName) as EmployeeName 
From dbo.Categories Join dbo.Products
On Categories.CategoryID = Products.CategoryID
Join dbo.Inventories
On Inventories.ProductID = Products.ProductID 
Join dbo.Employees
On Inventories.EmployeeID = Employees.EmployeeID

Go 
Alter View vInventoriesByProductsEmployeesDates

As
Select Top 1000000000
CategoryName, ProductName, InventoryDate, Count, concat(EmployeeFirstName, EmployeeLastName) as EmployeeName 
From dbo.Categories Join dbo.Products
On Categories.CategoryID = Products.CategoryID
Join dbo.Inventories
On Inventories.ProductID = Products.ProductID 
Join dbo.Employees
On Inventories.EmployeeID = Employees.EmployeeID
Where Products.ProductName in (Select ProductName From Products where ProductName in ('chai', 'chang')) --I watched the review of Assignment 5 and answered this fairly quickly!




Select * From vInventoriesByProductsEmployeesDates

--join between select statements--  
-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count,EmployeeName
-- Beverages,Chai,2017-01-01,72,Steven Buchanan
-- Beverages,Chang,2017-01-01,46,Steven Buchanan
-- Beverages,Chai,2017-02-01,52,Robert King


-- Question 9 (10 pts): How can you create a view to show a list of Employees and the Manager who manages them?
-- Order the results by the Manager's name!

/*

Create View VEmployeeManagerChart
Select Top 100000 
Mgr.EmployeeFirstName as ManagerFirstName
E.EmployeeFirstName + ' ' + E.EmployeeLastName as EmployeeName 
From Employees as M
Inner Join Employees as E
On M.EmployeeID = E.ManagerID */ --- Error message I need to work on the aliases.  

--------





Create View  VEmployeeManagerChart
WITH SCHEMABINDING
AS
Select Mgr.EmployeeFirstName + ' ' + Mgr.EmployeeLastName as [ManagerName], Emp.EmployeeFirstName + ' ' + Emp.EmployeeLastName as [EmployeeName]
From dbo.Employees as Mgr 
Inner Join dbo.Employees as Emp 
On Mgr.EmployeeID = Emp.ManagerID;
go 


Select * From VEmployeeManagerChart

Select * From Employees;




-- Here is an example of some rows selected from the view:
-- Manager,Employee
-- Andrew Fuller,Andrew Fuller
-- Andrew Fuller,Janet Leverling
-- Andrew Fuller,Laura Callahan


-- Question 10 (10 pts): How can you create one view to show all the data from all four 
-- BASIC Views?

-- Here is an example of some rows selected from the view:
-- CategoryID,CategoryName,ProductID,ProductName,UnitPrice,InventoryID,InventoryDate,Count,EmployeeID,Employee,Manager
-- 1,Beverages,1,Chai,18.00,1,2017-01-01,72,5,Steven Buchanan,Andrew Fuller
-- 1,Beverages,1,Chai,18.00,78,2017-02-01,52,7,Robert King,Steven Buchanan
-- 1,Beverages,1,Chai,18.00,155,2017-03-01,54,9,Anne Dodsworth,Steven Buchanan

Create View vInventoriesByProductsByCategoriesByEmployees
As 
Select Top 100000
Categories.CategoryID, Categories.CategoryName, Products.ProductName, Products.UnitPrice, Inventories.InventoryID, Inventories.Count
From dbo.Categories 
Inner Join dbo.Products 
On Categories.CategoryID = Products.CategoryID
Inner Join dbo.Inventories 
On Products.ProductID = Inventories.ProductID
Inner Join dbo.Employees
On Inventories.EmployeeID = Employees.EmployeeID;  --with manager ids not names

go


Select * From vInventoriesByProductsByCategoriesByEmployees


Alter View vInventoriesByProductsByCategoriesByEmployees
As 
Select Top 100000
Categories.CategoryID, Categories.CategoryName, Products.ProductName, Products.UnitPrice, Inventories.InventoryID, Inventories.Count,
Mgr.EmployeeFirstName + ' ' + Mgr.EmployeeLastName as [ManagerName], Emp.EmployeeFirstName + ' ' + Emp.EmployeeLastName as [EmployeeName]
From dbo.Categories 
Inner Join dbo.Products 
On Categories.CategoryID = Products.CategoryID
Inner Join dbo.Inventories 
On Products.ProductID = Inventories.ProductID
Inner Join dbo.Employees 
On Inventories.EmployeeID = Employees.EmployeeID
Inner Join VEmployeeManagerChart as managers
On Mgr.EmployeeID = Emp.ManagerID; -- tried to add manager names to no avail
go 




-- Test your Views (NOTE: You must change the names to match yours as needed!)
Select * From [dbo].[vCategories]
Select * From [dbo].[vProducts]
Select * From vProductPrice 
Select * From VProductInventory
Select * From Vstockdate_by_employee
Select * From VInventoriesByProductsByCategories
Select * From vInventoriesByEmployeesByDates
Select * From vInventoriesByProductsEmployeesDates
Select * From VEmployeeManagerChart
Select * From vInventoriesByProductsByCategoriesByEmployees
/***************************************************************************************/