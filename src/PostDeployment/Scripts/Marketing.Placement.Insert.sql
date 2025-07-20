PRINT 'Inserting placements...'

INSERT INTO [marketing].[Placement] ([Name], [Description], [Height], [Width], [Price], [PriceTypeId], [ProviderId])
VALUES
	('Sklik Leaderboard', NULL, 728, 100, 1200, 'day', 1),
	('Heuraka Leaderboard', NULL, 728, 90, 10, 'click', 2),
	('Penize.cz Leaderboard', NULL, 728, 90, 650, 'day', 3),

	('Sklik Banner', NULL, 468, 60, 2.5, 'click', 1),
	('Heuraka Banner', NULL, 500, 100, 1.5, 'click', 2),
	('Penize.cz Banner', NULL, 468, 70, 350, 'day', 3),

	('Sklik Skyscrapper', NULL, 125, 550, 2.5, 'click', 1),
	('Heuraka Skyscrapper', NULL, 120, 660, 1.5, 'click', 2),
	('Penize.cz Skyscrapper', NULL, 120, 500, 350, 'day', 3),

	('Sklik Square', NULL, 250, 250, 2.5, 'click', 1),
	('Heuraka Square', NULL, 250, 250, 450, 'day', 2),
	('Penize.cz Square', NULL, 250, 250, 1, 'click', 3)
