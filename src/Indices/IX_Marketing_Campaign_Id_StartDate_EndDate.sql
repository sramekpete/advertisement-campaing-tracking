CREATE NONCLUSTERED INDEX [IX_Marketing_Campaign_Id_StartDate_EndDate]
ON [marketing].[Campaign]
(
	Id DESC,
	StartDate ASC,
	EndDate ASC
)
