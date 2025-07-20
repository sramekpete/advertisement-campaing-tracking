CREATE TABLE [marketing].[Campaign]
(
	[Id] BIGINT NOT NULL IDENTITY (1,1),
	[Name] NVARCHAR(50) NOT NULL, 
	[Description] NVARCHAR(500) NULL,
    [StartDate] DATE NULL, 
    [EndDate] DATE NULL,
	[Cancelled] BIT NOT NULL DEFAULT 0,
	[State] AS (
		CASE
			WHEN [Cancelled] = 1
				THEN 'Cancelled'
			WHEN DATEDIFF(DAY, GETDATE(), [StartDate]) > 7
				THEN 'Planned'
			WHEN DATEDIFF(DAY, GETDATE(), [StartDate]) BETWEEN 7 AND 1
				THEN 'Upcoming'
			WHEN GETDATE() BETWEEN ISNULL([StartDate], GETDATE()) AND ISNULL([EndDate], GETDATE())
				THEN 'Ongoing'
			ELSE 'Concluded'
		END
	)
    CONSTRAINT [PK_Campaign] PRIMARY KEY (Id DESC),
	CONSTRAINT [CHK_Campaign_Trimmed_Name_Has_At_Least_3_Chars]
		CHECK (LEN(TRIM([Name])) > 3),
	CONSTRAINT [CHK_Campaign_Not_Null_Trimmed_Description_Has_At_Least_3_Chars]
		CHECK ([Description] IS NULL OR LEN(TRIM([Description])) > 3),
	CONSTRAINT [CHK_Campaign_StartDate_Less_Than_EndDate]
		CHECK ([StartDate] < [EndDate]),
)