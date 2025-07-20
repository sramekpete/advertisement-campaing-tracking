CREATE TABLE [marketing].[Advertisement]
(
	[CampaignId] BIGINT NOT NULL, 
    [PlacementId] SMALLINT NOT NULL,
	[TrackingId] NVARCHAR(50) NOT NULL UNIQUE, 
	CONSTRAINT [FK_Advertisement_Campaign] FOREIGN KEY ([CampaignId])
		REFERENCES [marketing].[Campaign]([Id])
			ON UPDATE NO ACTION
			ON DELETE NO ACTION,
	CONSTRAINT [FK_Advertisement_Placement] FOREIGN KEY ([PlacementId])
		REFERENCES [marketing].[Placement]([Id])
			ON UPDATE NO ACTION
			ON DELETE NO ACTION,
	CONSTRAINT [CHK_Advertisement_Trimmed_TrackingId_Has_At_Least_3_Chars]
		CHECK (LEN(TRIM([TrackingId])) > 3),
)
