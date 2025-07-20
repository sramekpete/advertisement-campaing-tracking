PRINT 'Inserting pricing type records...';
INSERT INTO [marketing].[PricingType] ([Id], [Name])
VALUES
	('click', 'Cena za proklik'),
	('day', 'Cena za den')