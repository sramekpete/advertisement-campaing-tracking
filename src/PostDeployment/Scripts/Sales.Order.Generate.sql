PRINT 'Generating orders...'

WHILE((SELECT COUNT(*) FROM [sales].[Order]) < 1000000)
BEGIN
	PRINT 'Generating 100000 batch...'

	EXEC [sales].[GenerateOrders] @TargetCount = 100000
END
