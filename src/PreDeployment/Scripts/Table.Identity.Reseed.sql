PRINT 'Reseeding identity columns in tables...'

IF OBJECT_ID(N'[marketing].[Placement]', N'U') IS NOT NULL
    DBCC CHECKIDENT ('[marketing].[Placement]', RESEED, 0)

IF OBJECT_ID(N'[marketing].[Provider]', N'U') IS NOT NULL
    DBCC CHECKIDENT ('[marketing].[Provider]', RESEED, 0)

IF OBJECT_ID(N'[marketing].[Campaign]', N'U') IS NOT NULL
    DBCC CHECKIDENT ('[marketing].[Campaign]', RESEED, 0)

IF OBJECT_ID(N'[sales].[Order]', N'U') IS NOT NULL
    DBCC CHECKIDENT ('[sales].[Order]', RESEED, 0)