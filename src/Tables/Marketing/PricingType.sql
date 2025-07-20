CREATE TABLE [marketing].[PricingType]
(
	[Id] NVARCHAR(20) NOT NULL,
	[Name] NVARCHAR(25) NOT NULL,
	[Description] NVARCHAR(500) NULL, 
    CONSTRAINT [PK_PricingType] PRIMARY KEY CLUSTERED ([Id] ASC),
	CONSTRAINT [CHK_PricingType_Trimmed_Name_Has_At_Least_3_Chars]
		CHECK (LEN(TRIM([Name])) > 3),
	CONSTRAINT [CHK_PricingType_Not_Null_Trimmed_Description_Has_At_Least_3_Chars]
		CHECK ([Description] IS NULL OR LEN(TRIM([Description])) > 3),
)