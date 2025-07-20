CREATE UNIQUE NONCLUSTERED INDEX [IX_Marketing_Advertisement_CampaignId_Placement_Id_TrackingId]
ON [marketing].[Advertisement]
(
	CampaignId DESC,
	PlacementId ASC,
	TrackingId ASC
)
	