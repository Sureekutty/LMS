IF OBJECT_ID ('speccs.SP_DepositsProcess') IS NOT NULL
	DROP PROCEDURE speccs.SP_DepositsProcess
GO

CREATE  PROCEDURE speccs.SP_DepositsProcess
@Option  		 VARCHAR (20),
@DepositNo       VARCHAR (10),
@Deposittype     VARCHAR(3),
@Depositstatus   VARCHAR(20),
@Remarks         VARCHAR(200),
@MemAccNo        VARCHAR(7),
@CloseDate		 VARCHAR(10),
@adjValue        numeric(10,2),
@refno           VARCHAR(20),
@paymentno	         varchar(15),
@userid          VARCHAR (10),
@Ipaddress       VARCHAR(30) =NULL,
@vouchernonew       varchar(13) output

--@ReceiptNo 		varchar(13) output

AS

--DROP PROC speccs.SP_DepositsProcess
--GRANT Execute ON speccs.SP_DepositsProcess TO speccsgroup

DECLARE @approvalstatus VARCHAR(40)

    
declare @purpose varchar(3)
declare @svalue numeric(10,2)
DECLARE @months INT , @openDate DATE, @svalue2 numeric(10,2)
IF (@Option = 'ASSTUPDATE')  
BEGIN 
UPDATE speccs.Deposits
	SET Status=@Depositstatus,Remarks=@Remarks,UserId=@userid WHERE DepositNo=@DepositNo

	INSERT INTO speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@userid,@DepositNo,@MemAccNo,'Deposit process status updated by assistant',getdate(),@Ipaddress,@Remarks)
	RETURN
END



IF (@Option = 'SCLOSE_INIT')  
BEGIN 

begin transaction

EXEC speccs.SP_getDepositClosingBal @Deposittype,@CloseDate,@DepositNo,@svalue output

UPDATE speccs.Deposits
SET CloseDate=@CloseDate, SettlementAmount=@svalue,
Status=@Depositstatus,
Remarks=@Remarks,
UserId=@userid,
RegTime=GETDATE()
WHERE DepositNo=@DepositNo

    IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='FXD') BEGIN select @purpose='D15' END
    IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='RCD' ) BEGIN select @purpose='D21' END
    IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='MIS') BEGIN select @purpose='D18' END 

-- added by pn on 06/06/2025 told by Rama Rao to generate payments for closing deposit/deposit process 
---Added 14-10-25 for payment gen for both Subscription and Interest  START   
SELECT @openDate=OpenDate FROM speccs.Deposits WHERE DepositNo=@DepositNo
SELECT @months=Datediff(mm,@openDate,@CloseDate)
SELECT @months=@months+1
 IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='RCD' ) BEGIN
 SELECT  @svalue2=(@months*Subscription) from speccs.Deposits where DepositNo=@DepositNo
 END
 ELSE 
 BEGIN
 SELECT @svalue2=Subscription from speccs.Deposits where DepositNo=@DepositNo
 END
	EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@vouchernonew output
	INSERT INTO speccs.Payments
	VALUES(@MemAccNo,@vouchernonew,@CloseDate,@purpose,@svalue2,'CHEQUE','ACTIVE',@DepositNo,@Remarks,@userid,GETDATE())
IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='FXD') BEGIN select @purpose='D16' END
    IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='RCD' ) BEGIN select @purpose='D22' END
    IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='MIS') BEGIN select @purpose='D19' END 

EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@vouchernonew output

	INSERT INTO speccs.Payments
	VALUES(@MemAccNo,@vouchernonew,@CloseDate,@purpose,@svalue-@svalue2,'CHEQUE','ACTIVE',@DepositNo,@Remarks,@userid,GETDATE())
--------Added 14-10-25 for payment gen for both Subscription and Interest  END
INSERT INTO speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
VALUES(@userid,@DepositNo,@MemAccNo,'Deposit - Short close initiated',getdate(),@Ipaddress,@Remarks)
	
commit transaction	
RETURN
END


IF (@Option = 'ADJ_SCLOSE_INIT')  
BEGIN 

begin transaction

     IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='FXD') BEGIN select @purpose='D15' END
    IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='RCD' ) BEGIN select @purpose='D21' END
    IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='MIS') BEGIN select @purpose='D18' END 
    
--added  by pn on 05/05/2025 told by Rama Rao    
DECLARE @adjIntRate FLOAT, @adjMonths INT , @adjOpenDate DATE, @adjPenalityRate FLOAT
SELECT @adjOpenDate=OpenDate,@adjPenalityRate=PenalIntRate FROM speccs.Deposits WHERE DepositNo=@DepositNo
SELECT @adjMonths=Datediff(dd,@adjOpenDate,@CloseDate)

IF(@adjMonths<=182) BEGIN SELECT @adjMonths=5 END
IF(@adjMonths>182 AND @adjMonths<=365) BEGIN SELECT @adjMonths=11 END
IF(@adjMonths>=366 AND @adjMonths<=548) BEGIN SELECT @adjMonths=17 END
IF(@adjMonths>548 AND @adjMonths<=730) BEGIN SELECT @adjMonths=23 END
IF(@adjMonths>730 AND @adjMonths<=912) BEGIN SELECT @adjMonths=29 END
IF(@adjMonths>912 AND @adjMonths<=1095) BEGIN SELECT @adjMonths=35 END
IF(@adjMonths>1095 AND @adjMonths<=1825) BEGIN SELECT @adjMonths=41 END


select @adjIntRate=RateOfInterest+@adjPenalityRate from speccs.Interest where IntCode='FXD' and @adjOpenDate between EffFromDate and EffToDate AND @adjMonths BETWEEN MinMonth AND MaxMonth


select 
@svalue=Subscription+CONVERT(numeric(10,2),(Subscription*@adjIntRate*DATEDIFF(dd,OpenDate,@CloseDate)/36500))
from speccs.Deposits where DepositNo=@DepositNo

-- added by pn on 06/06/2025 told by Rama Rao to generate payments for closing deposit/deposit process 
  ---Added 14-10-25 for payment gen for both Subscription and Interest  START   
SELECT @openDate=OpenDate FROM speccs.Deposits WHERE DepositNo=@DepositNo
SELECT @months=Datediff(mm,@openDate,@CloseDate)
SELECT @months=@months+1
 IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='RCD' ) BEGIN
 SELECT  @svalue2=(@months*Subscription) from speccs.Deposits where DepositNo=@DepositNo
 END
 ELSE 
 BEGIN
 SELECT @svalue2=Subscription from speccs.Deposits where DepositNo=@DepositNo
 END
	EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@vouchernonew output

	INSERT INTO speccs.Payments
	VALUES(@MemAccNo,@vouchernonew,@CloseDate,@purpose,@svalue2,'CHEQUE','ACTIVE',@DepositNo,@Remarks,@userid,GETDATE())
IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='FXD') BEGIN select @purpose='D16' END
    IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='RCD' ) BEGIN select @purpose='D22' END
    IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='MIS') BEGIN select @purpose='D19' END 
EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@vouchernonew output

	INSERT INTO speccs.Payments
	VALUES(@MemAccNo,@vouchernonew,@CloseDate,@purpose,@svalue-@svalue2,'CHEQUE','ACTIVE',@DepositNo,@Remarks,@userid,GETDATE())
--------Added 14-10-25 for payment gen for both Subscription and Interest  END

UPDATE speccs.Deposits
SET SettlementAmount=@svalue-@adjValue,
AdjustedAmount=@adjValue,
AdjustRefNo=@refno,
Status=@Depositstatus,
Remarks=@Remarks,
UserId=@userid,
RegTime=GETDATE()
WHERE DepositNo=@DepositNo




INSERT INTO speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
VALUES(@userid,@DepositNo,@MemAccNo,'Deposit - Short close with loan adjustment initiated',getdate(),@Ipaddress,@Remarks)
	
commit transaction	
RETURN
END


IF (@Option = 'CLOSE_INIT')  
BEGIN 

begin transaction



select @svalue=MaturityAmount
from speccs.Deposits where DepositNo=@DepositNo

UPDATE speccs.Deposits
SET SettlementAmount=@svalue,
Status=@Depositstatus,
Remarks=@Remarks,
UserId=@userid,
RegTime=GETDATE()
WHERE DepositNo=@DepositNo


    IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='FXD') BEGIN select @purpose='D15' END
    IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='RCD' ) BEGIN select @purpose='D21' END
    IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='MIS') BEGIN select @purpose='D18' END 


-- added by pn on 06/06/2025 told by Rama Rao to generate payments for closing deposit/deposit process 
   ---Added 14-10-25 for payment gen for both Subscription and Interest  START   
SELECT @openDate=OpenDate FROM speccs.Deposits WHERE DepositNo=@DepositNo
SELECT @months=Datediff(mm,@openDate,@CloseDate)
SELECT @months=@months+1
 IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='RCD' ) BEGIN

DECLARE @Durat INT 
SELECT @Durat=Duration from speccs.Deposits where DepositNo=@DepositNo
 SELECT  @svalue2=(@Durat*Subscription) from speccs.Deposits where DepositNo=@DepositNo
 END
 ELSE 
 BEGIN
 SELECT @svalue2=Subscription from speccs.Deposits where DepositNo=@DepositNo
 END
	EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@vouchernonew output

	INSERT INTO speccs.Payments
	VALUES(@MemAccNo,@vouchernonew,@CloseDate,@purpose,@svalue2,'CHEQUE','ACTIVE',@DepositNo,@Remarks,@userid,GETDATE())
IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='FXD') BEGIN select @purpose='D16' END
    IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='RCD' ) BEGIN select @purpose='D22' END
    IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='MIS') BEGIN select @purpose='D19' END 
EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@vouchernonew output

	INSERT INTO speccs.Payments
	VALUES(@MemAccNo,@vouchernonew,@CloseDate,@purpose,@svalue-@svalue2,'CHEQUE','ACTIVE',@DepositNo,@Remarks,@userid,GETDATE())
--------Added 14-10-25 for payment gen for both Subscription and Interest  END


INSERT INTO speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
VALUES(@userid,@DepositNo,@MemAccNo,'Deposit - Short close initiated',getdate(),@Ipaddress,@Remarks)
	
commit transaction	
RETURN
END



IF (@Option = 'ADJ_CLOSE_INIT')  
BEGIN 

begin transaction



select @svalue=MaturityAmount
from speccs.Deposits where DepositNo=@DepositNo

UPDATE speccs.Deposits
SET SettlementAmount=@svalue-@adjValue,
AdjustedAmount=@adjValue,
AdjustRefNo=@refno,
Status=@Depositstatus,
Remarks=@Remarks,
UserId=@userid,
RegTime=GETDATE()
WHERE DepositNo=@DepositNo
    IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='FXD') BEGIN select @purpose='D15' END
    IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='RCD' ) BEGIN select @purpose='D21' END
    IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='MIS') BEGIN select @purpose='D18' END 

-- added by pn on 06/06/2025 told by Rama Rao to generate payments for closing deposit/deposit process 
 ---Added 14-10-25 for payment gen for both Subscription and Interest  START   
SELECT @openDate=OpenDate FROM speccs.Deposits WHERE DepositNo=@DepositNo
SELECT @months=Datediff(mm,@openDate,@CloseDate)
SELECT @months=@months+1
 IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='RCD' ) BEGIN
 SELECT  @svalue2=(@months*Subscription) from speccs.Deposits where DepositNo=@DepositNo
 END
 ELSE 
 BEGIN
 SELECT @svalue2=Subscription from speccs.Deposits where DepositNo=@DepositNo
 END
	EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@vouchernonew output

	INSERT INTO speccs.Payments
	VALUES(@MemAccNo,@vouchernonew,@CloseDate,@purpose,@svalue2,'CHEQUE','ACTIVE',@DepositNo,@Remarks,@userid,GETDATE())
IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='FXD') BEGIN select @purpose='D16' END
    IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='RCD' ) BEGIN select @purpose='D22' END
    IF ((select DepositType from speccs.Deposits where DepositNo=@DepositNo)='MIS') BEGIN select @purpose='D19' END 
EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@vouchernonew output

	INSERT INTO speccs.Payments
	VALUES(@MemAccNo,@vouchernonew,@CloseDate,@purpose,@svalue-@svalue2,'CHEQUE','ACTIVE',@DepositNo,@Remarks,@userid,GETDATE())
--------Added 14-10-25 for payment gen for both Subscription and Interest  END

INSERT INTO speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
VALUES(@userid,@DepositNo,@MemAccNo,'Deposit - Short close initiated',getdate(),@Ipaddress,@Remarks)
	
commit transaction	
RETURN
END


    IF (@Depositstatus = 'SCLOSE_INIT')      SELECT @approvalstatus="SCLOSED"
	IF (@Depositstatus = 'ADJ_SCLOSE_INIT') SELECT @approvalstatus="ADJ_SCLOSED"
	IF (@Depositstatus = 'CLOSE_INIT')      SELECT @approvalstatus="CLOSED"
    IF (@Depositstatus = 'ADJ_CLOSE_INIT')  SELECT @approvalstatus="ADJ_CLOSED"


IF (@Option = 'SCLOSE_APPROVE')  
BEGIN 

begin transaction


UPDATE speccs.Deposits
SET Status=@approvalstatus,
Remarks=@Remarks,
UserId=@userid,
RegTime=GETDATE()
WHERE DepositNo=@DepositNo

update speccs.Payments
set Status='ACTIVE',
UserId=@userid,
Remarks=@Remarks,
RegTime=GETDATE()
WHERE PayVoucherNo=@paymentno

INSERT INTO speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
VALUES(@userid,@DepositNo,@MemAccNo,'Deposit - Short close approved',getdate(),@Ipaddress,@Remarks)
	
commit transaction	
RETURN
END


IF (@Option = 'CLOSE_APPROVE')  
BEGIN 

begin transaction


UPDATE speccs.Deposits
SET Status=@approvalstatus,
Remarks=@Remarks,
UserId=@userid,
RegTime=GETDATE()
WHERE DepositNo=@DepositNo

update speccs.Payments
set Status='ACTIVE',
UserId=@userid,
Remarks=@Remarks,
RegTime=GETDATE()
WHERE PayVoucherNo=@paymentno



INSERT INTO speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
VALUES(@userid,@DepositNo,@MemAccNo,'Deposit - Short close approved',getdate(),@Ipaddress,@Remarks)
	
commit transaction	
RETURN
END



IF (@Option = 'ADJ_SCLOSE_APPROVE')  
BEGIN 

begin transaction


UPDATE speccs.Deposits
SET Status=@approvalstatus,
Remarks=@Remarks,
UserId=@userid,
RegTime=GETDATE()
WHERE DepositNo=@DepositNo


update speccs.Payments
set Status='ACTIVE',
UserId=@userid,
Remarks=@Remarks,
RegTime=GETDATE()
where PayVoucherNo=@paymentno

INSERT INTO speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
VALUES(@userid,@DepositNo,@MemAccNo,'Deposit - Short close approved',getdate(),@Ipaddress,@Remarks)
	
commit transaction	
RETURN
END



IF (@Option = 'ADJ_CLOSE_APPROVE')  
BEGIN 

begin transaction


UPDATE speccs.Deposits
SET Status=@approvalstatus,
Remarks=@Remarks,
UserId=@userid,
RegTime=GETDATE()
WHERE DepositNo=@DepositNo


update speccs.Payments
set Status='ACTIVE',
UserId=@userid,
Remarks=@Remarks,
RegTime=GETDATE()
where PayVoucherNo=@paymentno

INSERT INTO speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
VALUES(@userid,@DepositNo,@MemAccNo,'Deposit - Short close approved',getdate(),@Ipaddress,@Remarks)
	
commit transaction	
RETURN
END

--added by pn on 06/05/2025 for mis payments told by Rama Rao
IF (@Option = 'PROCESS')  
BEGIN 

DECLARE @processmonth DATE
SELECT @processmonth= @DepositNo --@CloseDate is coming as from date we want all record

	--mis process start
   IF(@Remarks='1')
	BEGIN
	
	DELETE FROM speccs.MisPayments WHERE Month=@processmonth AND Status='PROCESS'
	
 	SELECT mem.MemAccNo,mem.MemEmpCode,mem.MemName,mem.BankAccNo,dep.DepositNo,dep.OpenDate,round((dep.Subscription*dep.IntRate)/1200,0) AS PaidInterest,
	@processmonth AS Month FROM speccs.Members mem,speccs.Deposits dep
	WHERE mem.MemAccNo=dep.MemAccNo AND dep.DepositType='MIS' AND (convert(DATE,@processmonth)>dep.OpenDate
	AND convert(DATE,@processmonth)<=dep.MaturityDate AND dep.OpenDate<=dateadd(mm,-1,@processmonth)) AND dep.Status='ACTIVE'  
	UNION ALL 
	SELECT mem.MemAccNo,mem.MemEmpCode,mem.MemName,mem.BankAccNo,dep.DepositNo,dep.OpenDate,
	rOUND(convert(NUMERIC(15,2),(dep.Subscription*dep.IntRate*(datediff(dd,dep.OpenDate,dateadd(dd,-1,@processmonth))+1)/(datepart(dd,dateadd(dd,-1,@processmonth))*1200))),0) AS PaidInterest,@processmonth AS Month 
	FROM speccs.Members mem,speccs.Deposits dep  
	WHERE mem.MemAccNo=dep.MemAccNo AND dep.DepositType='MIS' AND dep.Status='ACTIVE' AND (dep.OpenDate>dateadd(mm,-1,@processmonth) and dep.OpenDate<@processmonth)
------------------
IF EXISTS (SELECT * FROM speccs.MisPayments WHERE Month=@processmonth)
BEGIN
------------------------------------------------------
--24-12-2025 Mis Start
	
	--------------------------------
		SELECT mem.MemAccNo,mem.MemEmpCode,mem.MemName,mem.BankAccNo,dep.DepositNo,dep.OpenDate,round((dep.Subscription*dep.IntRate)/1200,0) AS PaidInterest,
	@processmonth AS Month INTO #dumy2 FROM speccs.Members mem,speccs.Deposits dep
	WHERE mem.MemAccNo=dep.MemAccNo AND dep.DepositType='MIS' AND (convert(DATE,@processmonth)>dep.OpenDate
	AND convert(DATE,@processmonth)<=dep.MaturityDate AND dep.OpenDate<=dateadd(mm,-1,@processmonth)) AND dep.Status='ACTIVE' 
	UNION ALL 
	SELECT mem.MemAccNo,mem.MemEmpCode,mem.MemName,mem.BankAccNo,dep.DepositNo,dep.OpenDate,
	rOUND(convert(NUMERIC(15,2),(dep.Subscription*dep.IntRate*(datediff(dd,dep.OpenDate,dateadd(dd,-1,@processmonth))+1)/(datepart(dd,dateadd(dd,-1,@processmonth))*1200))),0) AS PaidInterest,@processmonth AS Month 
	FROM speccs.Members mem,speccs.Deposits dep  
	WHERE mem.MemAccNo=dep.MemAccNo AND dep.DepositType='MIS' AND dep.Status='ACTIVE' AND (dep.OpenDate>dateadd(mm,-1,@processmonth) and dep.OpenDate<@processmonth)
------------------
	INSERT INTO speccs.MisPaymentsdummy
		select #dumy2.DepositNo,@processmonth,'CHEQUE',#dumy2.PaidInterest,'',getdate(),'PROCESS'
  --	SELECT MisNo =#dumy1.DepositNo,Month=@processmonth,ModeOfPayment='CHEQUE', PaidInterest=#dumy1.PaidInterest, UserId=@userid, RegTime= getdate(),Status='PROCESS'
	from #dumy2,speccs.Deposits d
	WHERE #dumy2.DepositNo=d.DepositNo
	
	
	
	
	--------------------------------

----
Declare @MSNO VARCHAR(10)
WHILE EXISTS (SELECT * FROM speccs.MisPaymentsdummy WHERE Month=@processmonth)

BEGIN

  
			    SELECT TOP 1  @MSNO=MisNo FROM speccs.MisPaymentsdummy WHERE Month=@processmonth


				IF EXISTS (SELECT * FROM speccs.MisPayments WHERE MisNo=@MSNO AND Month=@processmonth)
				BEGIN
				
				DELETE FROM speccs.MisPaymentsdummy
				WHERE MisNo = @MSNO AND Month=@processmonth
				END 
				ELSE
				BEGIN 
				
				DELETE FROM speccs.MisPayments
				WHERE MisNo = @MSNO AND Month=@processmonth
				
				END
				
				
END 

	   
Declare @MSNOIn VARCHAR(10)

WHILE EXISTS (SELECT * FROM speccs.MisPaymentsdummy WHERE Month=@processmonth)

BEGIN

  
			    SELECT TOP 1  @MSNOIn=MisNo FROM speccs.MisPaymentsdummy WHERE Month=@processmonth

--INSERT INTO speccs.MisPayments 
			   
 INSERT INTO speccs.MisPayments
	select P.MisNo,@processmonth,'CHEQUE',P.PaidInterest,@userid,getdate(),'PROCESS'
   FROM speccs.MisPaymentsdummy P
	WHERE P.MisNo=@MSNOIn AND P.Month=@processmonth
	
	
	DELETE FROM speccs.MisPaymentsdummy WHERE MisNo= @MSNOIn AND Month=@processmonth
				
				
END 
---
DELETE FROM speccs.MisPaymentsdummy
END 
ELSE 
BEGIN 
	SELECT mem.MemAccNo,mem.MemEmpCode,mem.MemName,mem.BankAccNo,dep.DepositNo,dep.OpenDate,round((dep.Subscription*dep.IntRate)/1200,0) AS PaidInterest,
	@processmonth AS Month INTO #dumy1 FROM speccs.Members mem,speccs.Deposits dep
	WHERE mem.MemAccNo=dep.MemAccNo AND dep.DepositType='MIS' AND (convert(DATE,@processmonth)>dep.OpenDate
	AND convert(DATE,@processmonth)<=dep.MaturityDate AND dep.OpenDate<=dateadd(mm,-1,@processmonth)) AND dep.Status='ACTIVE' 
	UNION ALL 
	SELECT mem.MemAccNo,mem.MemEmpCode,mem.MemName,mem.BankAccNo,dep.DepositNo,dep.OpenDate,
	rOUND(convert(NUMERIC(15,2),(dep.Subscription*dep.IntRate*(datediff(dd,dep.OpenDate,dateadd(dd,-1,@processmonth))+1)/(datepart(dd,dateadd(dd,-1,@processmonth))*1200))),0) AS PaidInterest,@processmonth AS Month 
	FROM speccs.Members mem,speccs.Deposits dep  
	WHERE mem.MemAccNo=dep.MemAccNo AND dep.DepositType='MIS' AND dep.Status='ACTIVE' AND (dep.OpenDate>dateadd(mm,-1,@processmonth) and dep.OpenDate<@processmonth)
------------------
	INSERT INTO speccs.MisPayments
		select #dumy1.DepositNo,@processmonth,'CHEQUE',#dumy1.PaidInterest,'',getdate(),'PROCESS'
  --	SELECT MisNo =#dumy1.DepositNo,Month=@processmonth,ModeOfPayment='CHEQUE', PaidInterest=#dumy1.PaidInterest, UserId=@userid, RegTime= getdate(),Status='PROCESS'
	from #dumy1,speccs.Deposits d
	WHERE #dumy1.DepositNo=d.DepositNo
	
	--DROP TABLE #dumy1
	
END 

------------
	RETURN
	END		--end
   --mis process approval start
	IF(@Remarks='2')
	BEGIN
   --	delete from speccs.MisPayments where Month=@processmonth
	
	SELECT mem.MemAccNo,mem.MemEmpCode,mem.MemName,mem.BankAccNo,dep.DepositNo,dep.OpenDate,round((dep.Subscription*dep.IntRate)/1200,0) AS PaidInterest,
	@processmonth AS Month INTO #dummy FROM speccs.Members mem,speccs.Deposits dep
	WHERE mem.MemAccNo=dep.MemAccNo AND dep.DepositType='MIS' AND (convert(DATE,@processmonth)>dep.OpenDate
	AND convert(DATE,@processmonth)<=dep.MaturityDate AND dep.OpenDate<dateadd(mm,-1,@processmonth)) AND dep.Status='ACTIVE'  
	UNION ALL 
	SELECT mem.MemAccNo,mem.MemEmpCode,mem.MemName,mem.BankAccNo,dep.DepositNo,dep.OpenDate,
	rOUND(convert(NUMERIC(15,2),(dep.Subscription*dep.IntRate*(datediff(dd,dep.OpenDate,dateadd(dd,-1,@processmonth))+1)/(datepart(dd,dateadd(dd,-1,@processmonth))*1200))),0) AS PaidInterest,@processmonth AS Month 
	FROM speccs.Members mem,speccs.Deposits dep  
	WHERE mem.MemAccNo=dep.MemAccNo AND dep.DepositType='MIS' AND dep.Status='ACTIVE' AND (dep.OpenDate>dateadd(mm,-1,@processmonth) and dep.OpenDate<@processmonth)

	
	/* Adaptive Server has expanded all '*' elements in the following statement */ SELECT #dummy.MemAccNo, #dummy.MemEmpCode, #dummy.MemName, #dummy.BankAccNo, #dummy.DepositNo, #dummy.OpenDate, #dummy.PaidInterest, #dummy.Month FROM #dummy
   
---30-12-2025

	--------------------------------------
   IF NOT EXISTS (SELECT * FROM speccs.MisPayments WHERE Month=@processmonth AND Status='PROCESSED')
   BEGIN 
   
	DECLARE @memaccno VARCHAR(17),@Paynonew VARCHAR(50),@IntAmount DECIMAL(15,2),@MisCodeExists VARCHAR(17)
  
  /*
 -- FROM speccs.MisPayments WHERE Month=@processmonth AND Status!='PROCESSED'
  
  ----Temp table and While Loop Only By Payment generation 
  
	SELECT @DepNo=MisNo   FROM speccs.MisPayments WHERE Month=@processmonth
	SELECT @IntAmount= PaidInterest FROM speccs.MisPayments WHERE Month=@processmonth AND MisNo=@DepNo
	SELECT @memaccno=MemAccNo   FROM speccs.Deposits WHERE DepositNo=@DepNo 
 EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@Paynonew output

  INSERT INTO speccs.Payments
  	VALUES(@memaccno,@Paynonew,@processmonth,'D19',@IntAmount,'CHEQUE','ACTIVE',@DepNo,'MIS INTEREST',@userid,GETDATE())

	---Added for contra on 08-12-2025 END
	*/
	--Newly Added On 12-12-2025 -Start
	/* Adaptive Server has expanded all '*' elements in the following statement */ 
	SELECT speccs.MisPayments.MisNo, speccs.MisPayments.Month, speccs.MisPayments.ModeOfPayment, speccs.MisPayments.PaidInterest, speccs.MisPayments.UserId, speccs.MisPayments.RegTime, speccs.MisPayments.Status INTO speccs.MisPaymentsTempNew FROM speccs.MisPayments WHERE Month=@processmonth AND Status IN ('PROCESS')


	WHILE EXISTS (SELECT 1 FROM speccs.MisPaymentsTempNew)
			BEGIN
			
  
			    SELECT TOP 1 @MisCodeExists=MisNo FROM speccs.MisPaymentsTempNew  
			    
			  --  SELECT @DepNo=MisNo   FROM speccs.MisPayments WHERE Month=@processmonth
   				SELECT @IntAmount= PaidInterest FROM speccs.MisPaymentsTempNew WHERE Month=@processmonth AND MisNo=@MisCodeExists
				SELECT @memaccno=MemAccNo FROM speccs.Deposits WHERE DepositNo=@MisCodeExists 
				
 				EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@Paynonew output

  					INSERT INTO speccs.Payments
  					VALUES(@memaccno,@Paynonew,@processmonth,'D19',@IntAmount,'CHEQUE','ACTIVE',@MisCodeExists,'MIS INTEREST',@userid,GETDATE())

   
				    
			    DELETE FROM speccs.MisPaymentsTempNew WHERE MisNo=@MisCodeExists
			
			END 

DROP TABLE speccs.MisPaymentsTempNew
END 

	--Newly Added On 12-12-2025 -End

	------------------------------------------
	



----30-12-2025
UPDATE speccs.MisPayments SET Status='PROCESSED' WHERE Month=@processmonth 

	--INSERT INTO speccs.MisPayments
   --	select #dummy.DepositNo,@processmonth,'CHEQUE',#dummy.PaidInterest,@userid,getdate(),'PROCESSED'
  --	from #dummy,speccs.Deposits d
  --	WHERE #dummy.DepositNo=d.DepositNo

	RETURN
	END	--end
END

/*IF (@Option = 'OFFICEUPDATE')  
BEGIN 

DECLARE @approvalstatus VARCHAR(40)

    IF (@Depositstatus = 'SLOSE-INIT')      SELECT @approvalstatus="SCLOSED"
	IF (@Depositstatus = 'ADJ-SCLOSE-INIT') SELECT @approvalstatus="ADJ-SCLOSED"
	IF (@Depositstatus = 'CLOSE-INIT')      SELECT @approvalstatus="CLOSED"
    IF (@Depositstatus = 'ADJ-CLOSE-INIT')  SELECT @approvalstatus="ADJ-CLOSED"


UPDATE speccs.Deposits
	SET Status=@approvalstatus,Remarks=@Remarks,UserId=@userid WHERE DepositNo=@DepositNo

	INSERT INTO speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@userid,@DepositNo,@MemAccNo,'Deposit process status updated by officer',getdate(),@Ipaddress,@Remarks)
	RETURN
END
*/
RETURN












GO

