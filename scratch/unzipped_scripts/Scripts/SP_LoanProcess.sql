IF OBJECT_ID ('speccs.SP_LoanProcess') IS NOT NULL
	DROP PROCEDURE speccs.SP_LoanProcess
GO

CREATE PROCEDURE speccs.SP_LoanProcess

@Option  VARCHAR(20) ,
@LoanAppNo VARCHAR(12),
@NoOfInst INT,
@MemAccNo VARCHAR(10),
@UserId		varchar(7),
@Ipaddress  varchar(30),
@ReceiptNo varchar(13) output,
@priBal NUMERIC(15,2),
@intAmount NUMERIC(15,2),
@date VARCHAR(10)

AS
--DROP PROC speccs.SP_LoanProcess
--GRANT ALL ON speccs.SP_LoanProcess to speccsgroup

IF(@Option='LOANPROCESS')
BEGIN 
SELECT LoanAccNo FROM speccs.Loans where MemAccNo=@MemAccNo and LoanStatus='RELEASED' AND LoanAccNo IN (SELECT LoanAccNo  
FROM speccs.LoanTransactions)
RETURN
END

if not exists(select * from speccs.Loans where LoanAccNo=@LoanAppNo and LoanStatus='RELEASED' AND MemAccNo=@MemAccNo)
begin
	RAISERROR 99999 "This is not an Fresh loan"
RETURN
end

declare @cdate  DATE
select @cdate=getdate()


declare @processmonth date
EXEC  speccs.SP_ProcessMonth @cdate,@processmonth output

IF(@Option='update')
BEGIN 

begin transaction

UPDATE speccs.Loans
SET NoOfInstallments = @NoOfInst
WHERE LoanAccNo = @LoanAppNo AND MemAccNo=@MemAccNo

 INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@UserId,@MemAccNo,@LoanAppNo,'loanprocess change user installements',getdate(),@Ipaddress,'')
	
IF(@@ERROR!=0)
BEGIN
	RAISERROR 99999 "Error while updating data in loans :SP_Deposits"
	ROLLBACK TRANSACTION
	RETURN
END

commit transaction
RETURN
END 
--added by pn on 16/05/2025 for monthly Installment amount told by Rama Rao
IF(@Option='UpdateMonInstAmnt')
BEGIN 

begin transaction

UPDATE speccs.Loans
SET MonthlyInstallments = @NoOfInst
WHERE LoanAccNo = @LoanAppNo AND MemAccNo=@MemAccNo

 INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@UserId,@MemAccNo,@LoanAppNo,'loanprocess change user installements',getdate(),@Ipaddress,'')
	
IF(@@ERROR!=0)
BEGIN
	RAISERROR 99999 "Error while updating data in loans :SP_Deposits"
	ROLLBACK TRANSACTION
	RETURN
END

commit transaction
RETURN
END 
--changed by pn on 03/06/2025 told by Rama Rao
IF(@Option='settle')
BEGIN

declare @purposecode varchar(3) 

begin transaction

--principal settlement
--declare @prin numeric(13,2)
--select @prin=Amount  from speccs.LoanTransactions WHERE LoanAccNo=@LoanAppNo AND P_I='P'

if(@LoanAppNo like 'LTL%')
begin select @purposecode='L24' end

if(@LoanAppNo like 'EXL%')
begin select @purposecode='L29' end

if(@LoanAppNo like 'FDL%')
begin select @purposecode='L34' end




--declare @intr numeric(13,2)
--select @intr=Amount  from speccs.LoanTransactions WHERE LoanAccNo=@LoanAppNo AND P_I='I'

declare @totAmount numeric (13,2)
select @totAmount=@priBal+@intAmount

 EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNo output
   INSERT INTO speccs.Receipts(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
   VALUES (@MemAccNo, @ReceiptNo, @date, @purposecode, @priBal, 'Loan Settled',@UserId,getdate(),'ACTIVE',@Ipaddress,@LoanAppNo)


--exec SP_Receipts 'SAVE',@MemAccNo,@date,@purposecode,@totAmount,'SETTLE',@LoanAppNo,@UserId,'',@Ipaddress,'Loan settlement record',@ReceiptNo output

INSERT INTO speccs.LoanTransactions 
VALUES (@LoanAppNo,@date,@purposecode,@priBal,'P',@ReceiptNo,'SETTLE',0,getdate(),@UserId)


IF(@@ERROR!=0)
BEGIN
	RAISERROR 99999 "Error while inserting data in loans[1] :SP_Deposits"
	ROLLBACK TRANSACTION
	RETURN
END

--interest codes
if(@LoanAppNo like 'LTL%')
begin select @purposecode='L25' end

if(@LoanAppNo like 'EXL%')
begin select @purposecode='L30' end

if(@LoanAppNo like 'FDL%')
begin select @purposecode='L35' END


EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNo output
   INSERT INTO speccs.Receipts(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
   VALUES (@MemAccNo, @ReceiptNo, @date, @purposecode, @intAmount, 'Loan Settled',@UserId,getdate(),'ACTIVE',@Ipaddress,@LoanAppNo)

--exec SP_Receipts 'SAVE',@MemAccNo,@date,@purposecode,@intAmount,'SETTLE',@LoanAppNo,@UserId,'',@Ipaddress,'Loan settlement record',@ReceiptNo output

INSERT INTO speccs.LoanTransactions 
VALUES (@LoanAppNo,@date,@purposecode,@intAmount,'I',@ReceiptNo,'SETTLE',0,getdate(),@UserId)

IF(@@ERROR!=0)
BEGIN
	RAISERROR 99999 "Error while inserting data in loans[1] :SP_Deposits"
	ROLLBACK TRANSACTION
	RETURN
END

UPDATE speccs.Loans
SET LoanSanctionAmount=0, LoanStatus = 'SETTLED',UserId=@UserId,RegTime=getdate(),Remarks='SETTLED',ClosedOnDate=@date
WHERE LoanAccNo = @LoanAppNo AND MemAccNo=@MemAccNo

/*
update LoanAccount 
set PrincipalCB=0,InterestCB=0,RegTime=getdate(),Remarks='SETTLED',UserId=@UserId
WHERE LoanAppNo = @LoanAppNo

IF(@@ERROR!=0)
BEGIN
	RAISERROR 99999 "Error while updating data in loans :SP_Deposits"
	ROLLBACK TRANSACTION
	RETURN
END
*/
commit transaction

END 
RETURN









GO

