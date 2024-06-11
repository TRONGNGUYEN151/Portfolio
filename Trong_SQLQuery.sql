use Trong_Portfolio
/* Xóa các dòng trống trong bảng Customer */
Select * 
From Customer
Where CustomerKey is null

Delete 
From Customer
Where CustomerKey is null
 
 /* Tổng hợp số lượng sản phẩm bán được theo phân loại phụ */
Select PrS.ProductSubcategoryKey,Prs.SubcategoryName, Sum(OrderQuantity) as total_sales
From (
select OrderQuantity, Pr.ProductKey, ProductSubcategoryKey
From Sales2022 as Sa right join Product as Pr	
On Sa.ProductKey = Pr.ProductKey) as ne inner Join ProductSubcategories as PrS
on ne.ProductSubcategoryKey = PrS.ProductSubcategoryKey
Group By PrS.ProductSubcategoryKey, Prs.SubcategoryName
Order By Prs.ProductSubcategoryKey


/* Tổng hợp số lượng đơn hàng và sản phẩm bán được theo phân loại và khu vực */
Select Ter.SalesTerritoryKey,Ter.Region, Ter.Country,Ter.Continent,
Sum(OrderQuantity) as Total_Quantity,
Count(Distinct(OrderNumber)) as Total_Order
From
(Select * From Sales2020
Union all
Select * From Sales2021
Union all
Select * From Sales2022 ) Sales Right Join Territory Ter
On
Sales.TerritoryKey = Ter.SalesTerritoryKey
Group By Ter.SalesTerritoryKey,Ter.Region, Ter.Country,Ter.Continent
Order By Total_Order DESC

/* Tổng hợp số lượng đơn hàng và sản phẩm bán được theo các thứ trong tuần */
SELECT Dow,
	Count(Distinct(OrderNumber)) Total_Order,
	Sum(OrderQuantity) Total_Quantity
from (
Select *, CASE DATEPART(WEEKDAY,OrderDate)
    WHEN 1 THEN 'SUNDAY' 
    WHEN 2 THEN 'MONDAY' 
    WHEN 3 THEN 'TUESDAY' 
    WHEN 4 THEN 'WEDNESDAY' 
    WHEN 5 THEN 'THURSDAY' 
    WHEN 6 THEN 'FRIDAY' 
    WHEN 7 THEN 'SATURDAY'
	END as DoW
	From Sales2022
) Dayofweek
Group By Dow

/* Tổng hợp doanh thu theo từng khu vực và đặt KPIs cho năm tiếp theo */
Select T.Country,
Sum(Revenue) as Total_Revenue_2022,
(Sum(Revenue)*1.1) as KPIs
From 
(
Select S.OrderDate, S.ProductKey, S.TerritoryKey, S.OrderQuantity, P.ProductPrice,
(S.OrderQuantity*P.ProductPrice) as Revenue
From Sales2022 S Left join Product P
On S.ProductKey = P.ProductKey
) N Right Join Territory T
On N.TerritoryKey = T.SalesTerritoryKey
Group By T.Country
Order By Total_Revenue_2022