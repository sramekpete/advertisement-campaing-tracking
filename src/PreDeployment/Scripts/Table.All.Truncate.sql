PRINT 'Truncating all tables in the database'

EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT all'

EXEC sp_MSForEachTable 'SET QUOTED_IDENTIFIER ON; DELETE FROM ?'

EXEC sp_MSForEachTable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all'