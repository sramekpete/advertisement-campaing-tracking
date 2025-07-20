CREATE TABLE [marketing].[Placement]
(
	[Id] SMALLINT NOT NULL IDENTITY(1,1), 
	[Name] NVARCHAR(25) NOT NULL,
	[Description] NVARCHAR(500) NULL, 
	[Height] SMALLINT NOT NULL, 
    [Width] SMALLINT NOT NULL,
	[Price] SMALLMONEY NOT NULL,
	[PriceTypeId] NVARCHAR(20) NOT NULL, 
	[ProviderId] TINYINT NOT NULL,
    CONSTRAINT [PK_Placement] PRIMARY KEY CLUSTERED (Id),
	CONSTRAINT [FK_Provider_Placement] FOREIGN KEY (ProviderId)
        REFERENCES [marketing].[Provider](Id)
		ON UPDATE NO ACTION
		ON DELETE NO ACTION,
	CONSTRAINT [FK_PriceType_Placement] FOREIGN KEY (PriceTypeId)
        REFERENCES [marketing].[PricingType](Id)
		ON UPDATE CASCADE
		ON DELETE NO ACTION,
	CONSTRAINT [CHK_Placement_Trimmed_Name_Has_At_Least_3_Chars]
		CHECK (LEN(TRIM([Name])) > 3),
	CONSTRAINT [CHK_Placement_Not_Null_Trimmed_Description_Has_At_Least_3_Chars]
		CHECK ([Description] IS NULL OR LEN(TRIM([Description])) > 3),
	CONSTRAINT [CHK_Placement_Height_And_Width_Are_Between_30_And_1200_Pixels]
		CHECK ([Height] BETWEEN 30 AND 1200 and [Width] BETWEEN 30 AND 1200),
	CONSTRAINT [CHK_Placement_Price_Greater_Than_Zero]
		CHECK ([Price] > 0)
)