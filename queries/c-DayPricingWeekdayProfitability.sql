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