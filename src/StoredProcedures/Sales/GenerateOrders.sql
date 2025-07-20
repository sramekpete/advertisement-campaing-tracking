CREATE PROCEDURE [sales].[GenerateOrders]
	@TargetCount int
AS

CREATE TABLE #temp
(
	[OrderDate] DATE NOT NULL,
	[TrackingId] NVARCHAR(50) NULL,
	[TotalPrice] MONEY NOT NULL,
	[ProfitMargin] DECIMAL(5,2) NOT NULL,
);

DECLARE @TrackingId NVARCHAR(50)
DECLARE @StartDate DATE
DECLARE @EndDate DATE
DECLARE @RowNumber INT
DECLARE @AdvertisementCount AS INT
DECLARE @CurrentCount AS INT = 0

SELECT
	@AdvertisementCount = COUNT(TrackingId)
FROM [marketing].[Advertisement]


WHILE(@CurrentCount < @TargetCount)
BEGIN
	SET @RowNumber = CONVERT(INT, [dbo].GetRandom(@AdvertisementCount, RAND(CHECKSUM(NEWID()))))

	IF CONVERT(INT, [dbo].GetRandom(@AdvertisementCount, RAND(CHECKSUM(NEWID())))) % 4 = 0
	BEGIN
		WITH Advertisement (TrackingId, StartDate, EndDate, RowNumber)
		AS
		(
			SELECT
				TrackingId,
				CASE
					WHEN DATEDIFF(DAY, c.[StartDate], GETDATE()) < 0
						THEN DATEADD(YEAR, -2, GETDATE())
					ELSE c.[StartDate]
				END AS STartDate,
				CASE
					WHEN DATEDIFF(DAY, c.[EndDate], GETDATE()) < 0
						THEN GETDATE()
					ELSE c.[EndDate]
				END AS EndDate,
				ROW_NUMBER() OVER (ORDER BY [TrackingId] ASC)
			FROM [marketing].[Advertisement] a
			JOIN [marketing].[Campaign] c ON c.[Id] = a.[CampaignId]
		)

		SELECT TOP 1
			@TrackingId = [TrackingId],
			@StartDate = [StartDate],
			@EndDate = [EndDate]
		FROM Advertisement
		WHERE @RowNumber = RowNumber
	END

	--PRINT 'StartDate: ' + ISNULL(CONVERT(NVARCHAR(10), @StartDate, 120), 'NULL') + ', EndDate: ' + ISNULL(CONVERT(NVARCHAR(10), @EndDate, 120), 'NULL')

	INSERT INTO #temp
	VALUES (
		[dbo].[GetRandomDate](ISNULL(@StartDate, DATEADD(YEAR, -2, GETDATE())), ISNULL(@EndDate, GETDATE()), RAND(CHECKSUM(NEWID()))),
		@TrackingId,
		ROUND(ABS([dbo].[GetRandom](100000, RAND(CHECKSUM(NEWID())))), 0) + 1,
		ROUND(ABS([dbo].[GetRandom](30, RAND(CHECKSUM(NEWID())))), 2) + 1
	)

	SET @CurrentCount += 1
	SET @TrackingId = NULL
	SET @StartDate = NULL
	SET @EndDate = NULL
END

INSERT INTO [sales].[Order] (
	[OrderDate],
	[TrackingId],
	[TotalPrice],
	[ProfitMargin]
)
SELECT
	[OrderDate],
	[TrackingId],
	[TotalPrice],
	[ProfitMargin]
FROM #temp
ORDER BY [OrderDate] ASC

DROP TABLE #temp

RETURN 0
