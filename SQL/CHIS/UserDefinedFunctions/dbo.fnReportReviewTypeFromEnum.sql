SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE FUNCTION [dbo].[fnReportReviewTypeFromEnum] (@ReviewType int)
RETURNS varchar(20)
AS BEGIN
	IF (@ReviewType = 0) RETURN 'Health Review'
	ELSE
	BEGIN
		IF (@ReviewType = 1) RETURN 'Screening Test'
	END
	RETURN '<unknown>'
END
GO
