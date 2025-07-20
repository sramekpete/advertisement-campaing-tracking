CREATE VIEW [report].[CampaignProfitability]
AS
WITH CampaignProfits (CampaignId, GrossProfit, NetProfit)
AS
(SELECT
	c.[Id] AS CampaignId,
	CASE
		WHEN p.[PriceTypeId] = 'click'
		THEN ROUND(SUM(o.[TotalPrice]) - CONVERT(MONEY, p.[Price]) * COUNT(o.[TrackingId]), 2)
		WHEN p.[PriceTypeId] = 'day'
		THEN ROUND(SUM(o.[TotalPrice]) - CONVERT(MONEY, p.[Price]) * DATEDIFF(DAY, c.[StartDate], c.[EndDate]), 2)
		ELSE NULL
	END AS GrossProfit,
	CASE
		WHEN p.[PriceTypeId] = 'click'
		THEN ROUND(SUM(o.[TotalProfit]) - CONVERT(MONEY, p.[Price]) * COUNT(o.[TrackingId]), 2)
		WHEN p.[PriceTypeId] = 'day'
		THEN ROUND(SUM(o.[TotalProfit]) - CONVERT(MONEY, p.[Price]) * DATEDIFF(DAY, c.[StartDate], c.[EndDate]), 2)
		ELSE NULL
	END AS NetProfit
FROM [marketing].[Campaign] c
JOIN [marketing].[Advertisement] a ON a.[CampaignId] = c.[Id]
JOIN [marketing].[Placement] p ON p.[Id] = a.[PlacementId]
JOIN [sales].[Order] o ON o.[TrackingId] IS NOT NULL AND o.[OrderDate] BETWEEN c.[StartDate] AND c.[EndDate] AND  o.[TrackingId] = a.[TrackingId]
GROUP BY c.[Id], c.[StartDate], c.[EndDate], p.[PriceTypeId], p.[Price])

SELECT
	c.[Name],
	SUM(p.GrossProfit) AS GrossProfit,
	SUM(p.NetProfit) AS NetProfit
FROM [marketing].[Campaign] c
JOIN CampaignProfits p ON p.[CampaignId] = c.[Id]
GROUP BY c.[Name]
