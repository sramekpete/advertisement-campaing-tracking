# advertisement-campaign-tracking

## Database

Database can be populated using Visual Studio by deploying SQL Server project in src folder. For more info > [Get started with SQL database projects](https://learn.microsoft.com/en-us/sql/tools/sql-database-projects/get-started?view=sql-server-ver17&pivots=sq1-visual-studio).

*NOTE: By default deployment also imports data. 500 campaigns, random number of advertisements/banners for each campaign and 1mio orders. You can adjust this under src/PostDeployment/Scripts foder.*

Other option is to download and restore [database backup (0.5GB)](https://advertisementcampaign.blob.core.windows.net/alza/db-5m-backup) with 5m orders using [SQL Server Management Studio](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver17).

## Diagram

### SQL Management Studio Diagram
![SQL Management Studio Diagram](https://github.com/sramekpete/advertisement-campaing-tracking/blob/main/diagrams/db-diagram-1.png)

### EF Core Power Tools Diagram
![EF Core Power Tools Diagram](https://github.com/sramekpete/advertisement-campaing-tracking/blob/main/diagrams/db-diagram-2.png)

## Campaign Profitability

Following query can be used to calculate campaign profitability based on the orders placed. It calculates gross and net profit for each campaign based on the price type (click or day) and the total price of the orders associated with the campaign.

[src/queries/b-CampaignProfitability.sql](https://github.com/sramekpete/advertisement-campaing-tracking/blob/main/queries/b-CampaignProfitability.sql)

```sql
WITH CampaignProfits (CampaignId, GrossProfit, NetProfit)
AS
(SELECT
	c.[Id] AS CampaignId,
	CASE
		WHEN p.[PriceTypeId] = 'click'
		THEN (SUM(o.[TotalPrice]) - p.[Price]) * COUNT(o.[TrackingId])
		WHEN p.[PriceTypeId] = 'day'
		THEN (SUM(o.[TotalPrice]) - p.[Price]) * DATEDIFF(DAY, c.[StartDate], c.[EndDate])
		ELSE NULL
	END AS GrossProfit,
	CASE
		WHEN p.[PriceTypeId] = 'click'
		THEN (SUM(o.[TotalProfit]) -  p.[Price]) * COUNT(o.[TrackingId])
		WHEN p.[PriceTypeId] = 'day'
		THEN (SUM(o.[TotalProfit]) - p.[Price]) * DATEDIFF(DAY, c.[StartDate], c.[EndDate])
		ELSE NULL
	END AS NetProfit
FROM [marketing].[Campaign] c
JOIN [marketing].[Advertisement] a ON a.[CampaignId] = c.[Id]
JOIN [marketing].[Placement] p ON p.[Id] = a.[PlacementId]
JOIN [sales].[Order] o ON o.[TrackingId] IS NOT NULL AND  o.[TrackingId] = a.[TrackingId]
GROUP BY c.[Id], c.[StartDate], c.[EndDate], p.[PriceTypeId], p.[Price])

SELECT
	c.[Name],
	cp.[GrossProfit],
	cp.[NetProfit]
FROM [marketing].[Campaign] c
CROSS APPLY
(
	SELECT
		ISNULL(ROUND(SUM([GrossProfit]), 2), 0) AS GrossProfit,
		ISNULL(ROUND(SUM([NetProfit]), 2), 0) AS NetProfit
	FROM  [CampaignProfits]
	WHERE [CampaignId] = c.[Id]
) cp
ORDER BY [NetProfit] DESC, [GrossProfit] DESC
```

## Day Pricing Weekday Profitability

Following query can be used to calculate the profitability of campaigns with day pricing based on the weekday. It calculates the total profit for each campaign on each day of the week.

[src/queries/c-DayPricingWeekdayProfitability.sql](https://github.com/sramekpete/advertisement-campaing-tracking/blob/main/queries/c-DayPricingWeekdayProfitability.sql)

```sql
SELECT
	DATENAME(WEEKDAY, DATEPART(WEEKDAY, f.[OrderDate])) AS [Weekday],
	SUM(f.[NetProfit]) AS NetProfit,
	SUM(f.[GrossProfit]) AS GrossProfit
FROM [report].[GetPricingTypeProfits] ('day') f
GROUP BY DATEPART(WEEKDAY, f.[OrderDate])
ORDER BY 	
	CASE
		WHEN ((DATEPART(WEEKDAY, f.[OrderDate]) % 7))  = 0
			THEN (DATEPART(WEEKDAY, f.[OrderDate]) - 7)
		ELSE DATEPART(WEEKDAY, f.[OrderDate])
	END
```

## Indices

Following indices can be used to improve the performance of the queries:

[src/Indices](https://github.com/sramekpete/advertisement-campaing-tracking/tree/main/src/Indices)

```sql
CREATE UNIQUE NONCLUSTERED INDEX [IX_Marketing_Advertisement_CampaignId_Placement_Id_TrackingId]
ON [marketing].[Advertisement]
(
	CampaignId DESC,
	PlacementId ASC,
	TrackingId ASC
)

CREATE NONCLUSTERED INDEX [IX_Marketing_Campaign_Id_StartDate_EndDate]
ON [marketing].[Campaign]
(
	Id DESC,
	StartDate ASC,
	EndDate ASC
)

CREATE NONCLUSTERED INDEX [IX_Marketing_Placement_Id_PriceTypeId_Include_Price]
ON [marketing].[Placement]
(
	[Id] ASC,
	[PriceTypeId] ASC
)
INCLUDE (Price)

CREATE NONCLUSTERED INDEX [IX_Sales_Order_TrackingId_OrderDate_Include_TotalPrice_ProfitMargin_TotalProfit_Filter_TrackingId_Not_Null]
ON [sales].[Order]
(
	[TrackingId] ASC,
	[OrderDate] ASC
)
INCLUDE
(
	[TotalPrice],
	[ProfitMargin],
	[TotalProfit]
) 
WHERE ([TrackingId] IS NOT NULL)
```

## Additional Constraints

Additional constraints can be found attached to each script responsible for table creation under [src/Tables](https://github.com/sramekpete/advertisement-campaing-tracking/tree/main/src/Tables) folder.

Few applied constraints are:

```sql
CONSTRAINT [CHK_Advertisement_Trimmed_TrackingId_Has_At_Least_3_Chars]
	CHECK (LEN(TRIM([TrackingId])) > 3)

CONSTRAINT [CHK_Campaign_Trimmed_Name_Has_At_Least_3_Chars]
	CHECK (LEN(TRIM([Name])) > 3),
CONSTRAINT [CHK_Campaign_Not_Null_Trimmed_Description_Has_At_Least_3_Chars]
	CHECK ([Description] IS NULL OR LEN(TRIM([Description])) > 3),
CONSTRAINT [CHK_Campaign_StartDate_Less_Than_EndDate]
	CHECK ([StartDate] < [EndDate])

CONSTRAINT [CHK_Placement_Height_And_Width_Are_Between_30_And_1200_Pixels]
	CHECK ([Height] BETWEEN 30 AND 1200 and [Width] BETWEEN 30 AND 1200),
CONSTRAINT [CHK_Placement_Price_Greater_Than_Zero]
	CHECK ([Price] > 0)

CONSTRAINT [CHK_Provider_Url_Is_Valid]
	CHECK ([dbo].[ValidateUrl]([Description]) = 1)
```
