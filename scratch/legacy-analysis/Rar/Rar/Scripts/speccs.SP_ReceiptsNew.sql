
IF OBJECT_ID ('speccs.SP_ReceiptsNew') IS NOT NULL
	DROP PROCEDURE speccs.SP_ReceiptsNew
GO

CREATE  PROCEDURE speccs.SP_ReceiptsNew
@Option  		VARCHAR (20),
@MemAccNo  		VARCHAR(10)= NULL,
@ReceiptDate	DATETIME= NULL,
@ItemCode		VARCHAR(3)= NULL,
@Amount			DECIMAL(15,2)= NULL,
@ModeOfPayment	VARCHAR(15)= NULL,
@ReferenceNo	VARCHAR(15)= NULL,
@UserId	 		VARCHAR(7)= NULL,
@MonthDate     	VARCHAR(8)= NULL,
@Ipaddress      VARCHAR (30)= NULL,
@Remarks        VARCHAR(150)=NULL,
@ReceiptNo		VARCHAR(14) OUTPUT 

AS

/*

	DROP PROCEDURE  speccs.SP_Receipts
	GRANT ALL ON speccs.SP_Receipts to speccsgroup
	
	DECLARE @ReceiptNo		VARCHAR(13) 
   --	exec speccs.SP_Receipts "SAVE","00020","11/30/2018","L24",3800,"SAL",'LTL1800015',"S000001",@ReceiptNo output 
		exec speccs.SP_Receipts "SAVE","00016","11/20/2018","L26",10000,"CASH",'LTL1800013',"S000001",@ReceiptNo output 
	SELECT @ReceiptNo		
 
 
	DECLARE @Option  VARCHAR (20),@MemAccNo  		VARCHAR(10),@ReceiptDate	DATETIME,@ItemCode		VARCHAR(3),
	@Amount			DECIMAL(15,2),@ModeOfPayment	VARCHAR(15),@ReferenceNo	VARCHAR(15),@UserId	 		VARCHAR(7),@ReceiptNo		VARCHAR(13) 

	SELECT @Option="SAVE",@MemAccNo="00016",@ReceiptDate="11/10/2018",@ItemCode="L26",@Amount=10000,
	@ModeOfPayment="CASH",@ReferenceNo='LTL1800013',@UserId="S000001"

 */
	
	DECLARE @txMonth DATETIME,@ClosingBalance DECIMAL(15,2) ,@Message VARCHAR(255),@Shares INT ,@FromDate DATETIME,@ToDate DATETIME,  @InterestToBePaid INT ,@DepositTypeCode VARCHAR(3)
   		
	SELECT @ClosingBalance=0, @txMonth=MAX(TransactionMonth)	FROM speccs.ProcessMonthTemp12092025 WHERE ProcessFlag='N'
   
	 /*		
	
	CREATE TABLE #TEMP_INTERESTTOBEPAID (  
		LoanAccNo			VARCHAR(13),		
		EffFromDate			DATETIME,	   
		EffToDate			DATETIME,		
		RateOfInterest	    DECIMAL(5,2), 
		LoanSanctionDate	DATETIME,	   	
		FromDate			DATETIME NULL,		
		ToDate				DATETIME NULL,		
		NoOfDays			INT NULL,		
		Interest			DECIMAL(19,2) DEFAULT 0.0,		
		PrincipalOutstanding INT DEFAULT 0	 		
	)
	CREATE TABLE #TEMP_PAIDINCURRMONTH (   	
		LoanAccNo			VARCHAR(13),		
		Month				DATETIME,	   
		TransactionDate		DATETIME,		
		PurposeCode	    	VARCHAR(3), 
		OutstandingAmt 		INT DEFAULT 0,
		PaidPrincipalAmt 	INT DEFAULT 0,
		PaidInterestAmt 	INT DEFAULT 0,
		InterestOvrDue 		INT DEFAULT 0,
		PrincipalOvrDue 	INT DEFAULT 0,
	   	FromDate			DATETIME NULL,		
		ToDate				DATETIME NULL,	
		AccessedFlag		VARCHAR(1) DEFAULT "N"	
	   
	)
  */
	
IF (@Option="SAVE") 
BEGIN
		

BEGIN TRANSACTION
		
	 

EXEC  speccs.SP_AutoNumberNew "RECEIPTNO",NULL ,@ReceiptNo output

INSERT INTO speccs.ReceiptsTemp12092025(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
VALUES (@MemAccNo, @ReceiptNo, @ReceiptDate, @ItemCode, @Amount, @ModeOfPayment,@UserId,getdate(),'SUBMIT',@Remarks,@ReferenceNo)

IF(@@ERROR!=0)
BEGIN
	RAISERROR 99999 "Error while inserting data in Receipts :SP_ReceiptsNew "
	ROLLBACK TRANSACTION
	RETURN
END

/*
else IF (@ItemCode = 'M06')  --SHARE CAPITAL
BEGIN 

	DECLARE @TotalSubscribedShare INT ,@UnitPrice INT 
	
	SELECT @UnitPrice=RuleValue FROM speccs.Rules
	WHERE RuleCode = '104' AND RuleDescription = 'Share Price' 
	
    IF(@@ROWCOUNT =0)
	BEGIN
		RAISERROR 99999 "Unable to fetch share price :SP_Receipts "
   		ROLLBACK TRANSACTION
   		RETURN
	END
	
	SELECT @Shares= round(@Amount/(@UnitPrice*1.0),0)

	SELECT @TotalSubscribedShare=@Shares
	
	UPDATE speccs.MemberAccount
 	SET ShareAmount=ShareAmount+@Amount, UserId=@UserId,RegTime=getdate()
 	WHERE MemAccNo=@MemAccNo
 
	IF EXISTS (SELECT * FROM speccs.Shares WHERE MemAccNo=@MemAccNo AND ToDate=null) 
	BEGIN
		
		SELECT  @TotalSubscribedShare=@TotalSubscribedShare+IssuedShare, @Amount=@Amount+CapitalAmount
		FROM speccs.Shares 
		WHERE MemAccNo=@MemAccNo AND ToDate=NULL
		
		UPDATE speccs.Shares 
		SET ToDate=dateadd(DD,-1,@ReceiptDate),UserId=@UserId,RegTime=getdate()
		WHERE MemAccNo=@MemAccNo AND ToDate=NULL
		
		IF(@@ERROR!=0)
		BEGIN
   			RAISERROR 99999 "Error while updating ToDate in Shares  :SP_Receipts "
   			ROLLBACK TRANSACTION
   			RETURN
		END
		
	END
 		 				
	INSERT INTO speccs.Shares(MemAccNo, FromDate, ToDate, ModeOfPayment, IssuedShare,TotalSubscribedShare,CapitalAmount, ReceiptNo, UserId, RegTime)
	VALUES (@MemAccNo, @ReceiptDate,NULL, @ModeOfPayment, @Shares,@TotalSubscribedShare,@Amount,@ReceiptNo, @UserId,getdate())
	
	IF(@@ERROR!=0)
	BEGIN
   		RAISERROR 99999 "Error while inserting data in Shares :SP_Receipts "
   		ROLLBACK TRANSACTION
   		RETURN
	END
   
	
END --icode M06


ELSE IF (@ItemCode = 'D08' OR @ItemCode = 'M03' OR @ItemCode = 'D20' )  --Thrift  | SERB monthly subscription |Recurrent Deposit
BEGIN

	IF (@ItemCode = 'D08') SELECT @DepositTypeCode="SRB"
	IF (@ItemCode = 'M03') SELECT @DepositTypeCode="THR"
	IF (@ItemCode = 'D20') SELECT @DepositTypeCode="RCD"
   
	IF EXISTS (SELECT * FROM speccs.DepositTransactions WHERE RefNo=@ReferenceNo AND DepositTypeCode=@DepositTypeCode) 
	BEGIN
		
		SELECT  @ClosingBalance=ClosingBalance
		FROM speccs.DepositTransactions
		WHERE RegTime=(SELECT max(RegTime) FROM speccs.DepositTransactions WHERE RefNo=@ReferenceNo AND DepositTypeCode=@DepositTypeCode)
		AND RefNo=@ReferenceNo
		AND DepositTypeCode=@DepositTypeCode
		
		IF(@@ERROR!=0)
		BEGIN
	   		SELECT @Message="Error while fetching closing balance of "+@DepositTypeCode+" from DepositTransactions  :SP_Receipts "
   			RAISERROR 99999 @Message
   			ROLLBACK TRANSACTION
   			RETURN
		END
		
	END
 					
	INSERT INTO speccs.DepositTransactions(MemaccNo,DepositTypeCode,RefNo,  Month, TxnDate, ModeOfPayment, Amount, OpeningBalance,ClosingBalance,ReceiptNo, UserId, RegTime)
	VALUES (@MemAccNo,@DepositTypeCode,@ReferenceNo, @MonthDate, @ReceiptDate, @ModeOfPayment, @Amount, @ClosingBalance,(@ClosingBalance+@Amount),@ReceiptNo, @UserId,getdate())
	
	
	INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@UserId,@MemAccNo,@ReceiptNo,'Receipt Saved',getdate(),@Ipaddress,@Remarks)
	
	
	
	
	IF(@@ERROR!=0)
	BEGIN
   	   	SELECT @Message="Error while inserting "+@DepositTypeCode+" data in DepositTransactions  :SP_Receipts"
   	   	RAISERROR 99999 @Message
   	   	ROLLBACK TRANSACTION
   		RETURN
	END
   

END --icdoe D08/M03/D20

-- icode L26 start 
ELSE IF (@ItemCode = 'L26' OR @ItemCode = 'L31' )
BEGIN

   
 	IF EXISTS (SELECT * FROM speccs.LoanTransactions WHERE LoanAccNo=@ReferenceNo) 
	BEGIN
		
		SELECT  @ClosingBalance=ClosingBal
		FROM speccs.LoanTransactions
		WHERE P_I='P' AND RegTime=(SELECT max(RegTime) FROM speccs.LoanTransactions WHERE LoanAccNo=@ReferenceNo)
		
		IF(@@ERROR!=0)
		BEGIN
	   		SELECT @Message="Error while fetching closing balance of "+@MemAccNo+" from LoanTransactions  :SP_Receipts "
   			RAISERROR 99999 @Message
   			ROLLBACK TRANSACTION
   			RETURN
		END
		
	END	   
 	
 	UPDATE speccs.Loans
 	SET LoanSanctionAmount=LoanSanctionAmount-@Amount,RegTime=@ReceiptDate
 	WHERE LoanAccNo=@ReferenceNo AND LoanStatus='RELEASED'
 	 			
	INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,  Amount, P_I, ReceiptNo, Modeofpay, ClosingBal,RegTime,UserId)
	VALUES (@ReferenceNo,@ReceiptDate,@ItemCode, @Amount, 'P', @ReceiptNo, @ModeOfPayment, (@ClosingBalance-@Amount),getdate(), @UserId)
	
	
	INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@UserId,@MemAccNo,@ReceiptNo,'Receipt Saved',getdate(),@Ipaddress,@Remarks)
	
	
	
	
	IF(@@ERROR!=0)
	BEGIN
   	   	SELECT @Message="Error while inserting "+@MemAccNo+" data in LoanTransactions  :SP_Receipts"
   	   	RAISERROR 99999 @Message
   	   	ROLLBACK TRANSACTION
   		RETURN
	END
   

END    -- icode L26 ends

-- icode M43 start 
ELSE IF (@ItemCode = 'M43' )
BEGIN
	--added by pn on 17/04/2025 
	DECLARE @oldThrift DECIMAL(15,2)
	SELECT @oldThrift=ThriftBalance FROM speccs.MemberAccount WHERE MemAccNo=@MemAccNo
	
	UPDATE speccs.MemberAccount
 	SET ThriftBalance=ThriftBalance+@Amount, UserId=@UserId ,RegTime=getdate()
 	WHERE MemAccNo=@MemAccNo
 	 			
	INSERT INTO speccs.ThriftTransactions(MemAccNo,Month,TransactionDate,ModeOfPayment,Amount,ReceiptNo,UserId,RegTime,ThriftBalance)
	VALUES (@MemAccNo,convert(VARCHAR(8),datepart(mm,@ReceiptDate)),@ReceiptDate,@ModeOfPayment, @Amount, @ReceiptNo, @UserId,getdate(),@oldThrift+@Amount)
	
	
	INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@UserId,@MemAccNo,@ReceiptNo,'Receipt Saved',getdate(),@Ipaddress,@Remarks)	
	
	IF(@@ERROR!=0)
	BEGIN
   	   	SELECT @Message="Error while inserting "+@MemAccNo+" data in ThriftTransactions  :SP_Receipts"
   	   	RAISERROR 99999 @Message
   	   	ROLLBACK TRANSACTION
   		RETURN
	END  

END

-- icode M43 ends
-- icode L25,L27,L30,L32 start
IF(@ItemCode = 'L25' OR @ItemCode ='L30' OR @ItemCode = 'L27' OR @ItemCode ='L32')
BEGIN 
	DECLARE @lastTransDate DATE,@totalInterest INT
	SELECT @lastTransDate=max(TransactionDate) FROM speccs.LoanTransactions WHERE LoanAccNo=@ReferenceNo AND P_I='P'
	
	
	
	INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,  Amount, P_I, ReceiptNo, Modeofpay, ClosingBal,RegTime,UserId)
	VALUES (@ReferenceNo,@ReceiptDate,@ItemCode, @Amount, 'P', @ReceiptNo, @ModeOfPayment, (@ClosingBalance+@Amount),getdate(), @UserId)

END */

-- icode L25,L30 end
COMMIT TRANSACTION
END --option save
	   
	

RETURN








GO

