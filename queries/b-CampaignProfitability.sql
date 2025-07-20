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