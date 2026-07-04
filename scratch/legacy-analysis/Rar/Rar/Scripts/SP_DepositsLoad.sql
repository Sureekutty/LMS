IF OBJECT_ID ('speccs.SP_DepositsLoad') IS NOT NULL
	DROP PROCEDURE speccs.SP_DepositsLoad
GO

CREATE  PROCEDURE speccs.SP_DepositsLoad
@Option  		VARCHAR (20)

AS

/*
	DROP PROCEDURE  speccs.SP_DepositsLoad
	
	GRANT ALL ON speccs.SP_DepositsLoad
*/
   	IF (@Option='deposit') 
	BEGIN
			   SELECT 	DepositTypeCode,DepositTypeDescription,RegTime,UserId
			   FROM speccs.DepositTypes WHERE DepositTypeCode NOT IN('SRB')
			   RETURN
	END


IF (@Option='depositstatus') 
	BEGIN
               SELECT  'FRESH' AS STATUS
			   UNION
			   SELECT  'ACTIVE' AS STATUS
			   UNION
			   SELECT  'EXPIRING' AS STATUS
			   UNION
			   SELECT 'UNDER PROCESS'  AS STATUS
			   UNION
			   SELECT 'CLOSED'  AS STATUS
			   UNION
			   SELECT 'REJECTED' AS STATUS
			   RETURN
	END
	
	IF (@Option='ASSTPROREQ') 
	BEGIN
               SELECT  'SCLOSE_INIT&Process Short Closing' AS ASSTREQ
			   UNION
			   SELECT  'ADJ_SCLOSE_INIT&Process Short Closing with Loan Adjustment' AS ASSTREQ
			   UNION
			   SELECT  'CLOSE_INIT&Process Closing' AS ASSTREQ
			   UNION
			   SELECT  'ADJ_CLOSE_INIT&Process Closing with Loan Adjustment'  AS ASSTREQ
			   RETURN
	END







GO

