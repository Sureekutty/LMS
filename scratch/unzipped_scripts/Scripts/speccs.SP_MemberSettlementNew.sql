IF OBJECT_ID ('speccs.SP_MemberSettlementNew') IS NOT NULL
	DROP PROCEDURE speccs.SP_MemberSettlementNew
GO

CREATE PROCEDURE speccs.SP_MemberSettlementNew
@option VARCHAR(12),
@memaccno VARCHAR(10),
@settlementDate VARCHAR(10),
@remarks VARCHAR(100),
@userID VARCHAR(10),
@settlementAmount INT,
@receiptPayNo VARCHAR(14) output

as
/*
drop proc speccs.SP_MemberSettlement
	GRANT ALL ON speccs.SP_MemberSettlement to speccsgroup
*/

IF(@option='PROCESS')
BEGIN 
DECLARE @purposecode VARCHAR(4)
-- if deposits available start
IF(len(@remarks)>1)
BEGIN 
DECLARE @start INT, @end INT, @len INT, @depNo VARCHAR(100)

    SET @remarks = @remarks + ','  -- add trailing comma to simplify logic
    SET @start = 1
    SET @len = LEN(@remarks)

    WHILE @start < @len
    BEGIN
        SET @end = CHARINDEX(',', @remarks, @start)
        IF @end = 0
            SET @end = @len + 1

        SET @depNo = LTRIM(RTRIM(SUBSTRING(@remarks, @start, @end - @start)))

        IF @depNo <> ''
        IF(substring(@depNo,1,2)='FD') BEGIN  SELECT @purposecode='D15' END
       	IF(substring(@depNo,1,2)='RD') BEGIN  SELECT @purposecode='D21' END
       	
       	
        EXEC  speccs.SP_AutoNumberNew "PAYMENTNO",NULL ,@receiptPayNo output
	    DECLARE @depositBal NUMERIC(15,2)
		SELECT @depositBal = SettlementAmount FROM speccs.DepositsTemp12092025 WHERE DepositNo=@depNo--
		INSERT INTO speccs.PaymentsTemp12092025--
		VALUES(@memaccno,@receiptPayNo,@settlementDate,@purposecode,@depositBal,'CHEQUE','ACTIVE',@depNo,"Deposits Settlement",@userID,GETDATE())
		
		IF(substring(@depNo,1,2)='FD') BEGIN  SELECT @purposecode='D16' END
       	IF(substring(@depNo,1,2)='RD') BEGIN  SELECT @purposecode='D22' END
       	
       	
		EXEC  speccs.SP_AutoNumberNew "PAYMENTNO",NULL ,@receiptPayNo output
		SELECT @depositBal = (SettlementAmount-Subscription) FROM speccs.DepositsTemp12092025 WHERE DepositNo=@depNo
		INSERT INTO speccs.PaymentsTemp12092025
		VALUES(@memaccno,@receiptPayNo,@settlementDate,'D15',@depositBal,'CHEQUE','ACTIVE',@depNo,"Deposits Interest Settlement",@userID,GETDATE())

            UPDATE speccs.DepositsTemp12092025
			SET CloseDate=@settlementDate, Status='CLOSED',RegTime=getdate()
			WHERE DepositNo=@depNo
        SET @start = @end + 1
    END

   

END	 --deposit status update end



DECLARE @deposits DECIMAL(15,2)
SELECT @deposits=0 
SELECT @deposits=convert(DECIMAL(15,2),(ThriftBalance + ShareAmount)) FROM speccs.MemberAccountTemp12092025 WHERE MemAccNo=@memaccno

SELECT @deposits=@deposits+ (CASE WHEN sum(dep.SettlementAmount)=NULL THEN 0 ELSE sum(dep.SettlementAmount) END)  FROM speccs.DepositsTemp12092025 dep WHERE  dep.MemAccNo=@memaccno AND dep.Status='CLOSE_INIT'

SELECT @deposits=convert(DECIMAL(15,2),@deposits)
	
 /*	IF(@deposits > @liabilities)
	BEGIN	
		SELECT @settlementAmount = (@deposits-@liabilities),@purposecode='M05'	*/
	   --	EXEC speccs.SP_Payments  'SAVE',@memaccno,@settlementDate,@purposecode,@settlementAmount,"CHEQUE",@memaccno,@userID,"Settlement",@receiptPayNo output 
	SET @deposits=CASE WHEN @deposits=NULL THEN 0 ELSE @deposits END

  	EXEC  speccs.SP_AutoNumberNew "PAYMENTNO",NULL ,@receiptPayNo output

	INSERT INTO speccs.PaymentsTemp12092025
	VALUES(@memaccno,@receiptPayNo,@settlementDate,'M05',(CASE WHEN @deposits=NULL THEN 0 ELSE @deposits END),'CHEQUE','ACTIVE',@memaccno,"Member Settlement",@userID,GETDATE())

	EXEC  speccs.SP_AutoNumberNew "PAYMENTNO",NULL ,@receiptPayNo output
	DECLARE @thriftBal DECIMAL(15,2)
	SELECT @thriftBal=0
	SELECT @thriftBal = ThriftBalance FROM speccs.MemberAccountTemp12092025 WHERE MemAccNo=@memaccno
	INSERT INTO speccs.PaymentsTemp12092025
	VALUES(@memaccno,@receiptPayNo,@settlementDate,'M09',(CASE WHEN @thriftBal=NULL THEN 0 ELSE @thriftBal END),'CHEQUE','ACTIVE',@memaccno,"Thrift Settlement",@userID,GETDATE())
  
 	
    EXEC  speccs.SP_AutoNumberNew "PAYMENTNO",NULL ,@receiptPayNo output
    DECLARE @shareBal DECIMAL(15,2)
    SELECT @shareBal=0
	SELECT @shareBal = ShareAmount FROM speccs.MemberAccountTemp12092025 WHERE MemAccNo=@memaccno
	INSERT INTO speccs.PaymentsTemp12092025
	VALUES(@memaccno,@receiptPayNo,@settlementDate,'M10',(CASE WHEN @shareBal=NULL THEN 0 ELSE @shareBal END),'CHEQUE','ACTIVE',@memaccno,"Share Capital Settlement",@userID,GETDATE())

  /*	
	--updating member status
		UPDATE speccs.Members
		SET Status = 'SETTLED', UserId = @userID, Remarks = 'Account closed'
		WHERE MemAccNo = @memaccno
	
	--updating loan status
		UPDATE speccs.Loans
		SET LoanStatus = 'SETTLED',UserId = @userID,ClosedOnDate = @settlementDate, Remarks = 'Account closed'
		WHERE MemAccNo = @memaccno

	END 
	ELSE IF( @liabilities > @deposits )
	BEGIN		*/
	
	
DECLARE @liabilities NUMERIC(15,2) ,@liabilities1 NUMERIC(15,2), @days INT,@lastDate INT 
SELECT @liabilities=0,@liabilities1=0,@days=0,@lastDate=0
SELECT @days=datepart(dd,@settlementDate)-1
SELECT @lastDate=datepart(dd,dateadd(dd,-datepart(dd,@settlementDate),dateadd(mm,1,@settlementDate)))
SELECT @liabilities=convert(NUMERIC(15,2),LoanSanctionAmount+((LoanSanctionAmount*InterestRate*@days)/(@lastDate*1200))) FROM speccs.LoansTemp12092025 WHERE MemAccNo=@memaccno AND LoanStatus='RELEASED' AND LoanType='LTL'
SELECT @liabilities1 =convert(NUMERIC(15,2),LoanSanctionAmount+((LoanSanctionAmount*InterestRate*@days)/(@lastDate*1200))) FROM speccs.LoansTemp12092025 WHERE MemAccNo=@memaccno AND LoanStatus='RELEASED' AND LoanType='EXL'
SELECT @liabilities=@liabilities+@liabilities1
	
	
	
	DECLARE @LoanAppNo VARCHAR(12)
	SELECT @LoanAppNo = LoanAccNo FROM speccs.LoansTemp12092025 WHERE MemAccNo=@memaccno AND LoanStatus='RELEASED' AND LoanType='LTL'

		SELECT @settlementAmount = (@liabilities-@deposits),@purposecode='M08'
	   --	EXEC speccs.SP_Receipts  'SAVE',@memaccno,@settlementDate,@purposecode,@settlementAmount,"CHEQUE",@memaccno,@userID,'','',"Account Settlement",@receiptPayNo output		
	
	EXEC  speccs.SP_AutoNumberNew "RECEIPTNO",NULL ,@receiptPayNo output
   INSERT INTO speccs.ReceiptsTemp12092025(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
   VALUES (@memaccno, @receiptPayNo, @settlementDate, 'M08', @liabilities, 'SETTLED',@userID,getdate(),'ACTIVE','Account Settled',@LoanAppNo)
	
	--LTL Receipt settlement
	DECLARE @loanSanAmnt NUMERIC(15,2)
	SELECT @loanSanAmnt=LoanSanctionAmount  FROM speccs.LoansTemp12092025 WHERE MemAccNo=@memaccno AND LoanStatus='RELEASED' AND LoanType='LTL'
	EXEC  speccs.SP_AutoNumberNew "RECEIPTNO",NULL ,@receiptPayNo output
    INSERT INTO speccs.ReceiptsTemp12092025(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
    VALUES (@memaccno, @receiptPayNo, @settlementDate, 'L26', @loanSanAmnt, 'SETTLED',@userID,getdate(),'ACTIVE','Account Settled',@LoanAppNo)
	
	INSERT INTO speccs.LoanTransactionsTemp12092025 
	VALUES (@LoanAppNo,@settlementDate,'L26',@loanSanAmnt,'P',@receiptPayNo,'Loan Sett',0,getdate(),@userID)
	   
	   SELECT @loanSanAmnt=convert(NUMERIC(15,2),((LoanSanctionAmount*InterestRate*@days)/(@lastDate*1200))) FROM speccs.LoansTemp12092025 WHERE MemAccNo=@memaccno AND LoanStatus='RELEASED' AND LoanType='LTL'
	EXEC  speccs.SP_AutoNumberNew "RECEIPTNO",NULL ,@receiptPayNo output
    INSERT INTO speccs.ReceiptsTemp12092025(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
    VALUES (@memaccno, @receiptPayNo, @settlementDate, 'L27', @loanSanAmnt, 'SETTLED',@userID,getdate(),'ACTIVE','Account Settled',@LoanAppNo)
	
	INSERT INTO speccs.LoanTransactionsTemp12092025 
	VALUES (@LoanAppNo,@settlementDate,'L27',@loanSanAmnt,'I',@receiptPayNo,'Loan Sett',0,getdate(),@userID)
	--ltl end
	--EXL Receipt Settelement
	SELECT @loanSanAmnt=0 
		SELECT @LoanAppNo = LoanAccNo FROM speccs.LoansTemp12092025 WHERE MemAccNo=@memaccno AND LoanStatus='RELEASED' AND LoanType='EXL'

	SELECT @loanSanAmnt=LoanSanctionAmount  FROM speccs.LoansTemp12092025 WHERE MemAccNo=@memaccno AND LoanStatus='RELEASED' AND LoanType='EXL'
	EXEC  speccs.SP_AutoNumberNew "RECEIPTNO",NULL ,@receiptPayNo output
    INSERT INTO speccs.ReceiptsTemp12092025(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
    VALUES (@memaccno, @receiptPayNo, @settlementDate, 'L31', @loanSanAmnt, 'SETTLED',@userID,getdate(),'ACTIVE','Account Settled',@LoanAppNo)
	
	INSERT INTO speccs.LoanTransactionsTemp12092025 
	VALUES (@LoanAppNo,@settlementDate,'L31',@loanSanAmnt,'P',@receiptPayNo,'Loan Sett',0,getdate(),@userID)
	   
	   SELECT @loanSanAmnt=convert(NUMERIC(15,2),((LoanSanctionAmount*InterestRate*@days)/(@lastDate*1200)))  FROM speccs.LoansTemp12092025 WHERE MemAccNo=@memaccno AND LoanStatus='RELEASED' AND LoanType='EXL'
	EXEC  speccs.SP_AutoNumberNew "RECEIPTNO",NULL ,@receiptPayNo output
    INSERT INTO speccs.ReceiptsTemp12092025(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
    VALUES (@memaccno, @receiptPayNo, @settlementDate, 'L32', @loanSanAmnt, 'SETTLED',@userID,getdate(),'ACTIVE','Account Settled',@LoanAppNo)
	
	INSERT INTO speccs.LoanTransactionsTemp12092025 
	VALUES (@LoanAppNo,@settlementDate,'L32',@loanSanAmnt,'I',@receiptPayNo,'Loan Sett',0,getdate(),@userID)
	--EXL end

   --updating member status
	UPDATE speccs.MembersTemp12092025
	SET Status = 'SETTLED',ClosedDate=@settlementDate, UserId = @userID, Remarks = 'Account closed'
	WHERE MemAccNo = @memaccno
	
	--updating loan status
	UPDATE speccs.LoansTemp12092025
	SET LoanSanctionAmount=0, LoanStatus = 'SETTLED',UserId = @userID,ClosedOnDate = @settlementDate, Remarks = 'Account closed'
	WHERE MemAccNo = @memaccno
--deposit status update start

 /*	
	--updating member status
		UPDATE speccs.Members
		SET Status = 'SETTLED', UserId = @userID, Remarks = 'Account closed'
		WHERE MemAccNo = @memaccno

	--updating loan status
		UPDATE speccs.Loans
		SET LoanStatus = 'SETTLED',UserId = @userID,ClosedOnDate = @settlementDate, Remarks = 'Account closed'
		WHERE MemAccNo = @memaccno

	
		 INSERT INTO speccs.LoanTransactions 
		VALUES (@LoanAppNo,@settlementDate,@purposecode,@liabilities,'P',@receiptPayNo,'CHEQUE',0,getdate(),@userID) 
	END  */
	--SELECT @receiptPayNo AS receiptPayNo

RETURN 
END
GO

