IF OBJECT_ID ('speccs.SP_MonthlyRecoveryProcess') IS NOT NULL
	DROP PROCEDURE speccs.SP_MonthlyRecoveryProcess
GO

CREATE PROCEDURE SP_MonthlyRecoveryProcess
@option        VARCHAR(15),
@month         VARCHAR(10),
@Purposecode       VARCHAR(6),
@Memcode        VARCHAR(7),
@Refid          VARCHAR(15), 
@ProcessDate    DATETIME,
@Empcode        VARCHAR(7),
@Salcode        INT , 
@Recoveryamount  FLOAT= NULL,
@Recoveredamount FLOAT= NULL,
@RecoveredDate  DATETIME, 
@Regstatus      VARCHAR(10),
@UserId        VARCHAR(7)
AS

/*
	DROP PROCEDURE  speccs.SP_MonthlyRecoveyProcess
	
	GRANT ALL ON speccs.SP_MonthlyRecoveyProcess to speccsgroup
*/



	IF (@option="SAVE") 
  
	BEGIN
			   --10/07/2025 Processdate changed--	
	INSERT INTO speccs.MonthlyProcess(Month ,Memcode ,Purposecode,Refid,Processdate,Empcode ,Salcode,Recoveryamount,
	Recoveredamount,RecoveredDate,Regstatus,UserId,RegTime )
	VALUES (@month,@Memcode,@Purposecode,@Refid,@ProcessDate,@Empcode,@Salcode,@Recoveryamount,0,@RecoveredDate,
	@Regstatus,@UserId, getdate())
		 	
		   
   	IF(@@ERROR!=0)
			BEGIN
				RAISERROR 99999 "Error while saving in Monthlysaladvise :SP_MonthlyRecoveyProcess "
				ROLLBACK TRANSACTION
				RETURN
	END
	  RETURN
	END
	

	IF (@option="GRIDDATA") 
  
	BEGIN
  
	                	
   SELECT A.Memcode,B.MemName,A.Refid,A.Empcode,A.Salcode,A.Recoveredamount  FROM  speccs.MonthlyProcess A,speccs.Members B
   WHERE A.Memcode=B.MemAccNo 	 	
		   
  RETURN
	END
	
	
	IF (@option="PROCESSDATA") 
  
	BEGIN
  
  INSERT INTO speccs.MonthlyProcess(Month ,Memcode ,Purposecode,Refid,Processdate,Empcode ,Salcode,Recoveryamount,
	Recoveredamount,RecoveredDate,Regstatus,UserId,RegTime )
	VALUES (@month,@Memcode,@Purposecode,@Refid,getdate(),@Empcode,@Salcode,@Recoveryamount,0,getdate(),
	@Regstatus,@UserId, getdate())
	                	
 	    --10/07/2025 CHANGED 0 TO Recoveryamount--
  RETURN
	END
	
	
		

	IF (@option="PURPOSECODE") 
  
	BEGIN
  
  SELECT PayCode,Description FROM speccs.TransactionType WHERE PayCode IN ('L24','L25','L29','L30','L34','L35','M03','D20')
  
    /* SELECT 'PY1-LTL-LOAN AMOUNT RECOVERY' AS PURPOSE
     UNION 
     SELECT 'PY2-LTL-LOAN INTEREST RECOVERY' AS PURPOSE
     UNION
     SELECT 'PY3-FDL-FD LOAN AMOUNT RECOVERY' AS PURPOSE
     UNION
     SELECT 'PY4-FDL-FD LOAN INTEREST RECOVERY' AS PURPOSE
     UNION
     SELECT 'PY5-EXL-EXPRESS LOAN AMOUNT RECOVERY' AS PURPOSE
     UNION
     SELECT 'PY6-EXL-EXPRESS LOAN INTEREST RECOVERY' AS PURPOSE
     UNION
     SELECT 'PY7-THR-THRIFT AMOUNT RECOVERY' AS PURPOSE
     UNION
	 SELECT 'PY8-RCD-RECURRENTDEPOSIT AMOUNT RECOVERY' AS PURPOSE	 	
		   
  */
  RETURN
	END
	
	
 








GO

