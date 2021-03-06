SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE FUNCTION [dbo].[udf_ValidateNHSNumber] (@NHSnumber VARCHAR(10)) RETURNS INTEGER

/*

Test
=====
SELECT [dbo].[udf_ValidateNHSNumber] ('4507355696a') 


*/



AS

BEGIN

-- Declare / Set Variables
DECLARE @ReturnValue AS INTEGER
DECLARE @Modulus AS INTEGER

SET @ReturnValue = 0


-- Check 1 - Numeric Value
IF ISNUMERIC(@NHSnumber) = 0 SET @ReturnValue = 1

-- Check 2 - LEN of 10
IF LEN(@NHSnumber) != 10 SET @ReturnValue = 2

-- Check 2 - Not All 0
IF @NHSnumber = '0000000000' SET @ReturnValue = 3

-- Check 4 - Check Digit (Modulus 11)
IF @ReturnValue = 0

	BEGIN

		DECLARE @A AS INTEGER
		DECLARE @B AS INTEGER
		DECLARE @C AS INTEGER
		DECLARE @D AS INTEGER
		DECLARE @E AS INTEGER
		DECLARE @F AS INTEGER
		DECLARE @G AS INTEGER
		DECLARE @H AS INTEGER
		DECLARE @I AS INTEGER
		DECLARE @J AS INTEGER

		SET @A = SUBSTRING(@NHSnumber, 1, 1)
		SET @B = SUBSTRING(@NHSnumber, 2, 1)
		SET @C = SUBSTRING(@NHSnumber, 3, 1)
		SET @D = SUBSTRING(@NHSnumber, 4, 1)
		SET @E = SUBSTRING(@NHSnumber, 5, 1)
		SET @F = SUBSTRING(@NHSnumber, 6, 1)
		SET @G = SUBSTRING(@NHSnumber, 7, 1)
		SET @H = SUBSTRING(@NHSnumber, 8, 1)
		SET @I = SUBSTRING(@NHSnumber, 9, 1)
		SET @J = SUBSTRING(@NHSnumber, 10, 1)

		IF  @A=@B AND @B=@C AND @C=@D AND @D=@E AND @E=@F AND @F=@G AND @G=@H AND @H=@I AND @I=@J
			SET @ReturnValue = 5
		ELSE
		BEGIN
			SET @Modulus = ((@A * 10) + (@B * 9) + (@C * 8) + (@D * 7) + (@E * 6) + (@F * 5) + (@G * 4) + (@H * 3) + (@I * 2))
			SET @Modulus = 11 - (@Modulus % 11)

			IF @Modulus != CASE WHEN @J = 0 THEN 11 ELSE @J END SET @ReturnValue = 4
		END
	
	END

-- Generate Return Value, 0 Indicates Valid NHS Number
RETURN @ReturnValue

END


GO
