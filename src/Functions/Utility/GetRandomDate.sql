CREATE FUNCTION [dbo].[GetRandomDate]
(
	@MinDate DATE,
	@MaxDate DATE,
	@Random FLOAT
)
RETURNS DATE
AS
BEGIN
	
	DECLARE @DateRange AS INT;
    DECLARE @Result as DATE

	SELECT @DateRange = DATEDIFF(DAY, @MinDate, @MaxDate) - 1

	SET @Result = CONVERT(DATE, DATEADD(DAY, @Random * @DateRange, @MinDate))

	Return @Result;

END
