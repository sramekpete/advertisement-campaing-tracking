CREATE FUNCTION [report].[GetPricingTypeProfits]
(
	@PricingType NVARCHAR(20)
)
RETURNS @Profitability TABLE
(
	OrderDate DATE,
	GrossProfit MONEY,
	NetProfit MONEY
)
AS
BEGIN
	INSERT @Profitability
	SELECT
		o.[OrderDate],
		ROUND(SUM(o.[TotalPrice]), 2) AS GrossProfit,
		ROUND(SUM(o.[TotalProfit]), 2) AS NetProfit
	FROM [marketing].[Advertisement] a
	JOIN [marketing].[Placement] p ON p.[Id] = a.[PlacementId]
	JOIN [sales].[Order] o ON o.[TrackingId] IS NOT NULL AND  o.[TrackingId] = a.[TrackingId]
	WHERE p.[PriceTypeId] = @PricingType
	GROUP BY o.[OrderDate]
	ORDER BY o.[OrderDate] ASC

	RETURN
END
