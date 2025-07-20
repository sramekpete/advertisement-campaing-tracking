CREATE VIEW [report].[AdvertisementOverview]
AS
SELECT
	c.[Name] 'Campaign',
	c.[StartDate],
	c.[EndDate],
	a.[TrackingId],
	p.[PriceTypeId] 'PriceType',
	p.[Price] 'Price'
FROM [marketing].[Campaign] c
JOIN [marketing].[Advertisement] a ON a.[CampaignId] = c.[Id]
JOIN [marketing].[Placement] p ON p.[Id] = a.[PlacementId]