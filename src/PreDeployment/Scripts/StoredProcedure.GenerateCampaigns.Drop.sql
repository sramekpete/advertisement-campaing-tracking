PRINT 'Drop Stored Procedure [dbo].[GenerateCampaigns]'

IF OBJECT_ID(N'[dbo].[GenerateCampaigns]', N'U') IS NOT NULL

BEGIN
	DROP  PROCEDURE [dbo].[GenerateCampaigns]
END