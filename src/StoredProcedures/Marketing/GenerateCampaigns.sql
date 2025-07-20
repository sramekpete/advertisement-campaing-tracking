CREATE PROCEDURE [marketing].[GenerateCampaigns]
	@TargetCount int
AS

CREATE TABLE #temp
(
	[Name] NVARCHAR(50) NOT NULL, 
	[Description] NVARCHAR(500) NULL,
    [StartDate] DATE NULL, 
    [EndDate] DATE NULL,
);

DECLARE @CurrentCount AS INT = 0
DECLARE @StartDate DATE
DECLARE @EndDate DATE

WHILE(@CurrentCount < @TargetCount)
BEGIN

	SET @StartDate = [dbo].[GetRandomDate](DATEADD(YEAR, -3, GETDATE()), DATEADD(MONTH, 1, GETDATE()), RAND(CHECKSUM(NEWID())))
	SET @EndDate = [dbo].[GetRandomDate](DATEADD(MONTH, 1, @StartDate), DATEADD(MONTH, 3, @StartDate), RAND(CHECKSUM(NEWID())));

	INSERT INTO #temp
	VALUES (
		'Campaign ' + TRIM(STR(@CurrentCount)),
		'Campaign description ' + TRIM(STR(@CurrentCount)), 
		@StartDate,
		@EndDate
	)

	SET @CurrentCount += 1
END

INSERT INTO [marketing].[Campaign] (
	[Name],
	[Description],
	[StartDate],
	[EndDate]
)
SELECT
	[Name],
	[Description],
	[StartDate],
	[EndDate]
FROM #temp
ORDER BY [StartDate] ASC

DROP TABLE #temp

RETURN 0
