CREATE TABLE [sales].[Order]
(
	[Id] BIGINT NOT NULL IDENTITY(1, 1),
	[OrderDate] DATE NOT NULL,
	[TrackingId] NVARCHAR(50) NULL,
	[TotalPrice] MONEY NOT NULL,
	[ProfitMargin] DECIMAL(5,2) NOT NULL,
	[TotalProfit] AS CONVERT(MONEY, CONVERT(DECIMAL(19,2), [TotalPrice]) * ([ProfitMargin] / 100)) PERSISTED
    CONSTRAINT [PK_Order]
		PRIMARY KEY ([Id] DESC)
	CONSTRAINT [CHK_Order_OrderDate_Less_Than_Tomorrow]
		CHECK (DATEDIFF(DAY, [OrderDate], GETDATE()) > -1)
	CONSTRAINT [CHK_Order_TotalPrice_Greater_Than_Zero]
		CHECK ([TotalPrice] > 0)
	CONSTRAINT [CHK_Order_ProfitMargin_Greater_Than_Zero]
		CHECK ([ProfitMargin] > 0)
)