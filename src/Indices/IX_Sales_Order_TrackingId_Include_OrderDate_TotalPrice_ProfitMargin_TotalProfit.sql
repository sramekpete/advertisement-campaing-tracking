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