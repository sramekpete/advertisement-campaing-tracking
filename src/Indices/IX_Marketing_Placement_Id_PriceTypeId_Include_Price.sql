CREATE NONCLUSTERED INDEX [IX_Marketing_Placement_Id_PriceTypeId_Include_Price]
ON [marketing].[Placement]
(
	[Id] ASC,
	[PriceTypeId] ASC
)
INCLUDE (Price)
