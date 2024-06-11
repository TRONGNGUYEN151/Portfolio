use Trong_Portfolio
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
