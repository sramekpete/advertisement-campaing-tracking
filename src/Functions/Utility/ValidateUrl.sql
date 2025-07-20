CREATE FUNCTION [dbo].[ValidateUrl]
(
	@Url NVARCHAR(2048)
)
RETURNS BIT
AS
BEGIN

-- For the sake of having at least minimal validation
IF CHARINDEX('https://', @Url) = 0 OR CHARINDEX('http://', @Url) = 0
BEGIN
	RETURN 1;
END

RETURN 0;

END