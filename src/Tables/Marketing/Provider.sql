CREATE TABLE [marketing].[Provider]
(
	[Id] TINYINT NOT NULL IDENTITY(1,1),
    [Name] NVARCHAR(25) NOT NULL,
    [Description] NVARCHAR(500) NULL, 
    [Url] NVARCHAR(75) NOT NULL, 
    CONSTRAINT [PK_Provider] PRIMARY KEY CLUSTERED ([Id]),
	CONSTRAINT [CHK_Provider_Trimmed_Name_Has_At_Least_3_Chars]
		CHECK (LEN(TRIM([Name])) > 3),
	CONSTRAINT [CHK_Provider_Not_Null_Trimmed_Description_Has_At_Least_3_Chars]
		CHECK ([Description] IS NULL OR LEN(TRIM([Description])) > 3),
	CONSTRAINT [CHK_Provider_Url_Is_Valid]
		CHECK ([dbo].[ValidateUrl]([Description]) = 1)
)