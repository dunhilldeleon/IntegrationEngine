SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE dbo.uspMPI_Update_SentTracker_Demographics 
(
@NHSno VARCHAR(10)
)
AS

UPDATE dbo.tblOH_MPI
SET [Sent]		= 1,
	[Sent_Dttm] = GETDATE()
WHERE NHS_Number = @NHSno


GO
