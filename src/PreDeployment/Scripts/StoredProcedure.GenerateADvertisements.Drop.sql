PRINT 'Drop Stored Procedure [dbo].[GenerateAdvertisements]'
IF OBJECT_ID(N'[dbo].[GenerateAdvertisements]', N'U') IS NOT NULL

BEGIN
	DROP  PROCEDURE [dbo].[GenerateAdvertisements]
END