CREATE PROCEDURE [marketing].[GenerateAdvertisements]
AS

CREATE TABLE #temp
(
	[TrackingId] NVARCHAR(50) NOT NULL, 
	[CampaignId] BIGINT NOT NULL,
	[PlacementId] SMALLINT NOT NULL,
);

DECLARE @CampaignCount AS INT
DECLARE @CampaignId AS BIGINT = 1

DECLARE @PlacementCount AS INT
DECLARE @PlacementId AS SMALLINT

DECLARE @TargetCount AS INT
DECLARE @CurrentCount AS INT = 0

SELECT
	@CampaignCount = COUNT(Id)
FROM [marketing].[Campaign]

SELECT
	@PlacementCount = COUNT(Id)
FROM [marketing].[Placement]

WHILE(@CampaignId < @CampaignCount + 1)
BEGIN

	SET @TargetCount = [dbo].GetRandom(@PlacementCount, RAND(CHECKSUM(NEWID())))

	WHILE(@CurrentCount < @TargetCount)
	BEGIN
		SET @PlacementId = CONVERT(SMALLINT, [dbo].GetRandom(@PlacementCount - 1, RAND(CHECKSUM(NEWID())))) + 1

		IF (SELECT COUNT(*) FROM #temp WHERE [CampaignId] = @CampaignId AND [PlacementId] = @PlacementId) > 0
		BEGIN
			CONTINUE;
		END

		INSERT INTO #temp
		VALUES (
			LOWER(REPLACE(CONVERT(NVARCHAR(50), NEWID()), '-', '')),
			@CampaignId,
			@PlacementId
		)

		SET @CurrentCount += 1
	END

	SET @CurrentCount = 0
	SET @CampaignId += 1
END

INSERT INTO [marketing].[Advertisement] (
	[TrackingId],
	[CampaignId],
	[PlacementId]
)
SELECT
	[TrackingId],
	[CampaignId],
	[PlacementId]
FROM #temp

DROP TABLE #temp

RETURN 0
