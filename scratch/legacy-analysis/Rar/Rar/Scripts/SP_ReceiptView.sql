IF OBJECT_ID ('speccs.SP_ReceiptView') IS NOT NULL
	DROP PROCEDURE speccs.SP_ReceiptView
GO

CREATE  PROCEDURE speccs.SP_ReceiptView
@Option  		VARCHAR (20),
@Receiptno        VARCHAR (14),
@userid        VARCHAR (10),
@Option3        VARCHAR (20),
@Remarks        VARCHAR(200)=NULL,
@Ipaddress      VARCHAR (30)=NULL
--@Receiptno 		varchar(13) output

AS

--DROP PROC speccs.SP_ReceiptView
--GRANT ALL ON speccs.SP_ReceiptView to speccsgroup



IF (@Option = 'SUBMIT')  
BEGIN 
   
SELECT B.MemAccNo,B.MemName,B.Designation,B.Division,B.MemEmpCode,B.AadharNo,B.MailId,B.Phone,B.BankAccNo,B.BasicPay,
A.ReceiptNo,convert(CHAR(10),A.ReceiptDate,103) AS ReceiptDate,A.PurposeCode,A.Amount,A.ModeOfPayment
from speccs.Members B  LEFT JOIN  speccs.Receipts A  ON A.MemAccNO = B.MemAccNo  WHERE A.Status='SUBMIT'
 



END
----ACTIVE----------

IF (@Option = 'GETACTIVE')  
BEGIN 
 --changed by pn on 10/06/2025 told by Rama Rao to fetch data between some time period  
SELECT B.MemAccNo,B.MemName,B.Designation,B.Division,B.MemEmpCode,B.AadharNo,B.MailId,B.Phone,B.BankAccNo,B.BasicPay,
A.ReceiptNo,convert(CHAR(10),A.ReceiptDate,103) AS ReceiptDate,A.PurposeCode,A.Amount,A.ModeOfPayment
from speccs.Members B  LEFT JOIN  speccs.Receipts A  ON A.MemAccNO = B.MemAccNo  WHERE A.Status='ACTIVE' AND A.ReceiptDate BETWEEN @Remarks AND @Ipaddress
	



		 	



END
------COMPLETED--------
/*
IF (@Option = 'CANCEL')  
BEGIN 
   
SELECT B.MemAccNo,B.MemName,B.Designation,B.Division,B.MemEmpCode,B.AadharNo,B.MailId,B.Phone,B.BankAccNo,B.BasicPay,
A.ReceiptNo,convert(CHAR(10),A.ReceiptDate,103) AS ReceiptDate,A.PurposeCode,A.Amount,A.ModeOfPayment
from speccs.Members B  LEFT JOIN  speccs.Receipts A  ON A.MemAccNO = B.MemAccNo  WHERE A.Status='CANCEL'


		 	

	
END

IF (@Option = 'CANCEL')  
BEGIN 
   
UPDATE speccs.Receipts 	SET Status='CANCEL' ,RegTime=getdate(),UserId=@userid,Remarks=@Remarks WHERE ReceiptNo=@Receiptno
	INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@userid,@Option3,@Receiptno,'user Receipt Rejected',getdate(),@Ipaddress,@Remarks)
RETURN
END 
*/
IF (@Option = 'CANCEL')  
BEGIN 

------------------

IF EXISTS( SELECT  * FROM speccs.LoanTransactions l WHERE l.ReceiptNo=@Receiptno)
BEGIN 

IF EXISTS( SELECT  * FROM speccs.LoanTransactions l WHERE l.ReceiptNo=@Receiptno AND l.P_I='P')
BEGIN


DECLARE @AmountL      NUMERIC(15,2)
DECLARE @TransDateL   DATETIME
DECLARE @P_IL         CHAR(1)
DECLARE @LoanAccNoL   VARCHAR(14)

/* Step 1: Take Amount, Date, P_I and LoanAccNo into variables */

SELECT @AmountL    = Amount,
       @TransDateL = TransactionDate,
       @P_IL       = P_I,
       @LoanAccNoL = LoanAccNo
FROM speccs.LoanTransactions
WHERE ReceiptNo = @Receiptno   

/* Step 2: Delete the record */

DELETE FROM speccs.LoanTransactions
WHERE ReceiptNo = @Receiptno  
 
/* Step 3: Add back the deleted Amount to ClosingBal of ALL transactions
          from the deleted transaction date till TODAY */
          
	UPDATE speccs.LoanTransactions
	SET ClosingBal = ClosingBal +
                 CASE WHEN @P_IL = 'P' THEN @AmountL ELSE 0 END   
	WHERE LoanAccNo = @LoanAccNoL AND P_I='P'
  	AND TransactionDate > @TransDateL
  	AND TransactionDate <= GETDATE()
  
  	UPDATE speccs.Loans
  	SET LoanSanctionAmount=LoanSanctionAmount+@AmountL
  	WHERE LoanAccNo = @LoanAccNoL

  

 	DELETE FROM speccs.Receipts
	WHERE ReceiptNo= @Receiptno  


END 

-----'P'End 
ELSE 
BEGIN 

DELETE FROM speccs.LoanTransactions
WHERE ReceiptNo = @Receiptno  

DELETE FROM speccs.Receipts
	WHERE ReceiptNo= @Receiptno 

END --'I' End 

END 
ELSE 
BEGIN 
----------------------

IF EXISTS( SELECT  * FROM speccs.ThriftTransactions l WHERE l.ReceiptNo=@Receiptno)
BEGIN



------------------Thrift --Start -----------------

DECLARE @AmountT      NUMERIC(15,2)
DECLARE @TransDateT   DATETIME
DECLARE @LoanAccNoT   VARCHAR(14)

/* Step 1: Take Amount, Date, P_I and LoanAccNo into variables */

SELECT @AmountT    = Amount,
       @TransDateT = TransactionDate,
       @LoanAccNoT = MemAccNo
FROM speccs.ThriftTransactions
WHERE ReceiptNo = @Receiptno   

/* Step 2: Delete the record */

DELETE FROM speccs.ThriftTransactions
WHERE ReceiptNo = @Receiptno  

/* Step 3: Add back the deleted Amount to ClosingBal of ALL transactions
          from the deleted transaction date till TODAY */
          
	UPDATE speccs.ThriftTransactions
	SET ThriftBalance=ThriftBalance-@AmountT    
	WHERE MemAccNo= @LoanAccNoT
  	AND TransactionDate > @TransDateT
  	AND TransactionDate <= GETDATE()
  	
  	
  	UPDATE speccs.MemberAccount
  	SET ThriftBalance=ThriftBalance-@AmountT
  	WHERE MemAccNo= @LoanAccNoT
  
 	DELETE FROM speccs.Receipts
	WHERE ReceiptNo= @Receiptno 
	
------------------Thrift End -----------------


END 
ELSE --Share Capital Receipt Deletion Start
BEGIN
 
	DECLARE @PCode VARCHAR(17),@MANo VARCHAR(17),@RecSC DECIMAL(15,2) 
	
	SELECT @PCode=PurposeCode FROM speccs.Receipts WHERE ReceiptNo=@Receiptno
   
	SELECT @RecSC=Amount FROM speccs.Receipts WHERE ReceiptNo=@Receiptno
   
	SELECT @MANo=MemAccNO FROM speccs.Receipts WHERE ReceiptNo=@Receiptno

	IF (@PCode='M06')
	BEGIN 
	
	UPDATE speccs.MemberAccount SET ShareAmount=ShareAmount-@RecSC,RegTime=getdate() 
   	WHERE MemAccNo=@MANo
	
	DELETE FROM speccs.Receipts
	WHERE ReceiptNo= @Receiptno 
	
	
	
	END --Share Capital Receipt Deletion End 
	
	

END 
END 




------------------

RETURN
END 


IF (@Option = 'ACTIVE')  
BEGIN 
   
UPDATE speccs.Receipts SET Status='ACTIVE' ,RegTime=getdate(),UserId=@userid,Remarks=@Remarks   WHERE ReceiptNo=@Receiptno
--added by pn on 16/05/2025 told by Kannan sir and Rama Rao
DECLARE @ModeOfPayment	VARCHAR(15),@ClosingBalance NUMERIC(15,2),@purposecode VARCHAR(5), @Message VARCHAR(255),@Amount NUMERIC(15,2),@MemAccNo VARCHAR(10),@RefNo VARCHAR(10),@receiptDate DATE
DECLARE @txMonth DATETIME, @FromDate DATETIME,@ToDate DATETIME,  @InterestToBePaid INT ,@DepositTypeCode VARCHAR(3)


SELECT @MemAccNo=MemAccNO,@ModeOfPayment=ModeOfPayment,@purposecode=PurposeCode,@receiptDate=ReceiptDate,@Amount=Amount,@RefNo=RefNo FROM speccs.Receipts WHERE ReceiptNo=@Receiptno
------------------------------------------------------------
-- icode L36,L37 start


IF (@purposecode NOT IN ('I06','I07'))
BEGIN 
/*
DECLARE @BankBalance FLOAT ,@BTransactiondate DATE,@BTransNo VARCHAR(50),@BAmount FLOAT,@BrefNo VARCHAR(50),@Purname VARCHAR(75)
SELECT @BTransactiondate=@receiptDate
SELECT @BTransNo=@Receiptno
---For receipts+,For payments-
SELECT @BAmount=@Amount
SELECT @BrefNo=@RefNo
SELECT @Purname=Description FROM speccs.TransactionType WHERE PayCode=@purposecode 
SELECT @BankBalance=BankBalance  FROM speccs.BankBalance 
---SELECT @Transdate=Max(TransactionDate) FROM speccs.BankTransactions ORDER BY TransactionDate IN DESC

UPDATE speccs.BankBalance 
SET BankBalance=@BankBalance+@BAmount WHERE BankName='SBI'
INSERT INTO speccs.BankTransactions (ReceiptNo,TransactionDate,Amount,BankName,BankBalance,PurCode,RefNo,RegTime,UserId)
VALUES (@BTransNo,@BTransactiondate,@BAmount,'SBI',@BankBalance+@BAmount,@Purname,@BrefNo,getDate(),'SH15823') */


----------------------Bank Transaction 24-02-2026 START
DECLARE @BankBalance FLOAT ,@BTransactiondate DATE,@BTransNo VARCHAR(50),@BAmount FLOAT,@BrefNo VARCHAR(50),@Purname VARCHAR(75)

SELECT @BTransactiondate=@receiptDate
SELECT @BTransNo=@Receiptno
---For receipts+,For payments-
SELECT @BAmount=@Amount
SELECT @BrefNo=@RefNo
SELECT @Purname=Description FROM speccs.TransactionType WHERE PayCode=@purposecode
SELECT @BankBalance=BankBalance  FROM speccs.BankBalance 



    DECLARE @BmaxTranDate DATE
    
    SELECT @BmaxTranDate = MAX(TransactionDate) 
    FROM speccs.BankTransactions
    
     IF (@BTransactiondate < @BmaxTranDate)
    BEGIN
    	 SELECT ReceiptNo, TransactionDate, Amount, BankBalance, PurCode, 
            RefNo, RegTime, UserId 
        INTO #tempB1 
        FROM speccs.BankTransactions 
        WHERE CONVERT(DATE, TransactionDate) > @BTransactiondate
        
         DECLARE @Bankbalnce1 FLOAT,@BAmt FLOAT,@BNo VARCHAR(14)
     
     
             SELECT TOP 1 @Bankbalnce1= BankBalance FROM speccs.BankTransactions WHERE TransactionDate>@BTransactiondate  ORDER BY TransactionDate ASC, RegTime ASC
             SELECT  TOP 1 @BAmt= Amount FROM  speccs.BankTransactions WHERE TransactionDate>@BTransactiondate  ORDER BY TransactionDate ASC, RegTime ASC
             SELECT  TOP 1 @BNo= ReceiptNo from speccs.BankTransactions WHERE TransactionDate>@BTransactiondate  ORDER BY TransactionDate ASC, RegTime ASC

     /*   IF (LEFT(@BNo,1) = 'P')
                BEGIN SELECT  @Bankbalnce1 = @Bankbalnce1+ @BAmt
                END
            	ELSE
            	BEGIN
                SELECT  @Bankbalnce1 = @Bankbalnce1-@BAmt
            	END */
            	SELECT  @Bankbalnce1 = @Bankbalnce1- @BAmt
       
              UPDATE speccs.BankBalance 
				SET BankBalance=@BankBalance+@BAmount WHERE BankName='SBI'
				INSERT INTO speccs.BankTransactions (ReceiptNo,TransactionDate,Amount,BankName,BankBalance,PurCode,RefNo,RegTime,UserId)
			VALUES (@BTransNo,@BTransactiondate,@BAmount,'SBI',@Bankbalnce1+@BAmount,@Purname,@BrefNo,getDate(),'SH15823')

              
       DECLARE @CurrentReceiptNo VARCHAR(14), 
                @CurrentAmount DECIMAL(18,2), 
                @CurrentPurCode VARCHAR(10), 
                @CurrentRefNo VARCHAR(10),
                @CurrentBBalance FLOAT, 
                @CurrentTransactionDate DATE, 
                @CurrentRegTime DATETIME 
                
                 WHILE EXISTS (SELECT 1 FROM #tempB1)
       			 BEGIN
                SELECT TOP 1 
                @CurrentReceiptNo       = ReceiptNo,
                @CurrentAmount          = Amount,
                @CurrentPurCode         = PurCode,
                @CurrentRefNo           = RefNo,
                @CurrentBBalance=BankBalance,
                @CurrentTransactionDate = TransactionDate,
                @CurrentRegTime         = RegTime
            	 FROM #tempB1 
           		 ORDER BY TransactionDate ASC, RegTime ASC
                
               /* IF (LEFT(@CurrentReceiptNo,1) = 'R')
                BEGIN SELECT  @CurrentBalance = - @CurrentAmount
                END
            	ELSE
            	BEGIN
                SELECT  @CurrentBalance = @CurrentAmount
            	END */
            	
            	
            UPDATE speccs.BankTransactions
            SET BankBalance =BankBalance + @BAmount
            WHERE RefNo = @CurrentRefNo 
              AND ReceiptNo = @CurrentReceiptNo
            
           
            -- Remove processed row from temp table
            DELETE FROM #tempB1 
            WHERE RefNo = @CurrentRefNo 
              AND ReceiptNo = @CurrentReceiptNo
              
          
              
             
              
              
    END
    
    END
    ELSE
    BEGIN
    SELECT @BankBalance=BankBalance  FROM speccs.BankBalance 
---SELECT @Transdate=Max(TransactionDate) FROM speccs.BankTransactions ORDER BY TransactionDate IN DESC

UPDATE speccs.BankBalance 
SET BankBalance=@BankBalance+@BAmount WHERE BankName='SBI'
INSERT INTO speccs.BankTransactions (ReceiptNo,TransactionDate,Amount,BankName,BankBalance,PurCode,RefNo,RegTime,UserId)
VALUES (@BTransNo,@BTransactiondate,@BAmount,'SBI',@BankBalance+@BAmount,@Purname,@BrefNo,getDate(),'SH15823')

---------------
    
    
    
    END
----------------------Bank Transaction 24-02-2026 END





END 

 

DECLARE @ClosingBalance1 NUMERIC(15,2),@Amount1 FLOAT,@ReceiptNoS VARCHAR(14),@sur1 VARCHAR(10),@LSur1 VARCHAR(10) 
IF (@purposecode = 'L36')
BEGIN

SELECT @ClosingBalance1=LoanSanctionAmount FROM speccs.Loans WHERE LoanAccNo=@RefNo

 UPDATE speccs.Loans
 	SET LoanSanctionAmount=@ClosingBalance1-@Amount,RegTime=getdate()
 	WHERE LoanAccNo=@RefNo AND LoanStatus='RELEASED'
 	 			
	INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,  Amount, P_I, ReceiptNo, Modeofpay, ClosingBal,RegTime,UserId)
	VALUES (@RefNo,@receiptDate,'L24', @Amount, 'P', @Receiptno, 'Surety pay P', (@ClosingBalance1-@Amount),getdate(), @userid)
	
	SELECT @Amount1=@Amount/3
	SELECT @sur1=Surety1 FROM speccs.Loanstatus WHERE MemAccNo =@MemAccNo
	SELECT @LSur1=LoanAccNo FROM speccs.Loans WHERE MemAccNo=@sur1 AND LoanType='LTL' AND LoanStatus='RELEASED'
	EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNoS output
	INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,  Amount, P_I, ReceiptNo, Modeofpay, ClosingBal,RegTime,UserId)
	VALUES (@LSur1,@receiptDate,'L36', @Amount1, 'Sur P', @ReceiptNoS, 'Surety pay', 0,getdate(), @userid)

	SELECT @sur1=Surety2   FROM speccs.Loanstatus WHERE MemAccNo =@MemAccNo
	SELECT @LSur1=LoanAccNo FROM speccs.Loans WHERE MemAccNo=@sur1 AND LoanType='LTL' AND LoanStatus='RELEASED'
	EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNoS output
	INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,  Amount, P_I, ReceiptNo, Modeofpay, ClosingBal,RegTime,UserId)
	VALUES (@LSur1,@receiptDate,'L36', @Amount1, 'Sur P', @ReceiptNoS, 'Surety pay', 0,getdate(), @userid)

	SELECT @sur1=Surety3   FROM speccs.Loanstatus WHERE MemAccNo =@MemAccNo
	SELECT @LSur1=LoanAccNo FROM speccs.Loans WHERE MemAccNo=@sur1 AND LoanType='LTL' AND LoanStatus='RELEASED'
	EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNoS output
	INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,  Amount, P_I, ReceiptNo, Modeofpay, ClosingBal,RegTime,UserId)
	VALUES (@LSur1,@receiptDate,'L36', @Amount1, 'Sur P', @ReceiptNoS, 'Surety pay', 0,getdate(), @userid)


END



IF (@purposecode = 'L37')
BEGIN

SELECT @ClosingBalance1=LoanSanctionAmount FROM speccs.Loans WHERE LoanAccNo=@RefNo

 /*UPDATE speccs.Loans
 	SET LoanSanctionAmount=@ClosingBalance1-@Amount,RegTime=getdate()
 	WHERE LoanAccNo=@RefNo AND LoanStatus='RELEASED'*/
 	 			
	INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,  Amount, P_I, ReceiptNo, Modeofpay, ClosingBal,RegTime,UserId)
	VALUES (@RefNo,@receiptDate,'L25', @Amount, 'I', @Receiptno, 'Surety pay Int', 0,getdate(), @userid)
	
	SELECT @Amount1=@Amount/3
	SELECT @sur1=Surety1 FROM speccs.Loanstatus WHERE MemAccNo =@MemAccNo
	SELECT @LSur1=LoanAccNo FROM speccs.Loans WHERE MemAccNo=@sur1 AND LoanType='LTL' AND LoanStatus='RELEASED'
	EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNoS output
	INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,  Amount, P_I, ReceiptNo, Modeofpay, ClosingBal,RegTime,UserId)
	VALUES (@LSur1,@receiptDate,'L37', @Amount1, 'Sur I', @ReceiptNoS, 'Surety pay', 0,getdate(), @userid)

	SELECT @sur1=Surety2   FROM speccs.Loanstatus WHERE MemAccNo =@MemAccNo
	SELECT @LSur1=LoanAccNo FROM speccs.Loans WHERE MemAccNo=@sur1 AND LoanType='LTL' AND LoanStatus='RELEASED'
	EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNoS output
	INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,  Amount, P_I, ReceiptNo, Modeofpay, ClosingBal,RegTime,UserId)
	VALUES (@LSur1,@receiptDate,'L37', @Amount1, 'Sur I', @ReceiptNoS, 'Surety pay', 0,getdate(), @userid)

	SELECT @sur1=Surety3   FROM speccs.Loanstatus WHERE MemAccNo =@MemAccNo
	SELECT @LSur1=LoanAccNo FROM speccs.Loans WHERE MemAccNo=@sur1 AND LoanType='LTL' AND LoanStatus='RELEASED'
	EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNoS output
	INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,  Amount, P_I, ReceiptNo, Modeofpay, ClosingBal,RegTime,UserId)
	VALUES (@LSur1,@receiptDate,'L37', @Amount1, 'Sur I', @ReceiptNoS, 'Surety pay', 0,getdate(), @userid)


END



IF (@purposecode = 'L66')
BEGIN

SELECT @ClosingBalance1=LoanSanctionAmount FROM speccs.Loans WHERE LoanAccNo=@RefNo

 UPDATE speccs.Loans
 	SET LoanSanctionAmount=@ClosingBalance1-@Amount,RegTime=getdate()
 	WHERE LoanAccNo=@RefNo AND LoanStatus='RELEASED'
 	 			
	INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,  Amount, P_I, ReceiptNo, Modeofpay, ClosingBal,RegTime,UserId)
	VALUES (@RefNo,@receiptDate,'L26', @Amount, 'P', @Receiptno, 'Surety payP', (@ClosingBalance1-@Amount),getdate(), @userid)
	
	SELECT @Amount1=@Amount
	SELECT @sur1=Surety1 FROM speccs.Loanstatus WHERE MemAccNo =@MemAccNo
	SELECT @LSur1=LoanAccNo FROM speccs.Loans WHERE MemAccNo=@sur1 AND LoanType='EXL' AND LoanStatus='RELEASED'
	EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNoS output
	INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,  Amount, P_I, ReceiptNo, Modeofpay, ClosingBal,RegTime,UserId)
	VALUES (@LSur1,@receiptDate,'L66', @Amount1, 'Sur P', @ReceiptNoS, 'Surety pay', 0,getdate(), @userid)

   


END


IF (@purposecode = 'L67')
BEGIN

SELECT @ClosingBalance1=LoanSanctionAmount FROM speccs.Loans WHERE LoanAccNo=@RefNo

 /*UPDATE speccs.Loans
 	SET LoanSanctionAmount=@ClosingBalance1-@Amount,RegTime=getdate()
 	WHERE LoanAccNo=@RefNo AND LoanStatus='RELEASED'*/
 	 			
	INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,  Amount, P_I, ReceiptNo, Modeofpay, ClosingBal,RegTime,UserId)
	VALUES (@RefNo,@receiptDate,'L27', @Amount, 'I', @Receiptno, 'Surety pay Int', 0,getdate(), @userid)
	
	SELECT @Amount1=@Amount
	SELECT @sur1=Surety1 FROM speccs.Loanstatus WHERE MemAccNo =@MemAccNo AND LoanType='EXL'
	SELECT @LSur1=LoanAccNo FROM speccs.Loans WHERE MemAccNo=@sur1 AND LoanType='EXL' AND LoanStatus='RELEASED'
	EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNoS output
	INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,  Amount, P_I, ReceiptNo, Modeofpay, ClosingBal,RegTime,UserId)
	VALUES (@LSur1,@receiptDate,'L67', @Amount1, 'Sur I', @ReceiptNoS, 'Surety pay', 0,getdate(), @userid)

	


END



-------------------------------------------------------------

--------------Newly Added on 20/02/2026-For insurance-------------------------


IF (@purposecode = 'I06')
BEGIN

SELECT @ClosingBalance1=LoanSanctionAmount FROM speccs.Loans WHERE LoanAccNo=@RefNo

 UPDATE speccs.Loans
 	SET LoanSanctionAmount=@ClosingBalance1-@Amount,RegTime=getdate()
 	WHERE LoanAccNo=@RefNo AND LoanStatus='RELEASED'
 	 			
	INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,  Amount, P_I, ReceiptNo, Modeofpay, ClosingBal,RegTime,UserId)
	VALUES (@RefNo,@receiptDate,'L24', @Amount, 'P', @Receiptno, 'Insurance', (@ClosingBalance1-@Amount),getdate(), @userid)
	
	DECLARE @PayNo VARCHAR(50)
   	EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@PayNo output

INSERT INTO speccs.Payments(MemAccNo, PayVoucherNo, VoucherDate, PurposeCode, Amount, ModeOfPayment,Status,RefNo,Remarks,UserId,RegTime)
VALUES (@MemAccNo, @PayNo, @receiptDate, 'I06', @Amount, 'Insurance','ACTIVE',@RefNo,'',@userid,getdate())


END


IF (@purposecode = 'I07')
BEGIN

DECLARE @TBalAmt NUMERIC(15,2)
SELECT  @TBalAmt=ThriftBalance 
		FROM speccs.MemberAccount
		WHERE MemAccNo=@MemAccNo 
		
		INSERT INTO speccs.ThriftTransactions(MemAccNo,Month,TransactionDate,ModeOfPayment,Amount,ReceiptNo,UserId,RegTime,ThriftBalance)
	VALUES (@MemAccNo,convert(VARCHAR(8),datepart(mm,@receiptDate)),@receiptDate,'Thrift-Insurance', @Amount, @Receiptno, @userid,getdate(),@TBalAmt+@Amount)
 	
 	
 		UPDATE speccs.MemberAccount
 	SET ThriftBalance=ThriftBalance+@Amount, UserId=@userid ,RegTime=getdate()
 	WHERE MemAccNo=@MemAccNo
	
  
   	EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@PayNo output

INSERT INTO speccs.Payments(MemAccNo, PayVoucherNo, VoucherDate, PurposeCode, Amount, ModeOfPayment,Status,RefNo,Remarks,UserId,RegTime)
VALUES (@MemAccNo, @PayNo, @receiptDate, 'I07', @Amount, 'Thrift-Insurance','ACTIVE',@RefNo,'',@userid,getdate())


END


---------------------------


IF (@purposecode = 'M06')  --SHARE CAPITAL
BEGIN 

	DECLARE @TotalSubscribedShare INT ,@UnitPrice INT,@Shares INT 
	
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
 	SET ShareAmount=ShareAmount+@Amount, UserId=@userid,RegTime=getdate()
 	WHERE MemAccNo=@MemAccNo
 
	IF EXISTS (SELECT * FROM speccs.Shares WHERE MemAccNo=@MemAccNo AND ToDate=null) 
	BEGIN
		
		SELECT  @TotalSubscribedShare=@TotalSubscribedShare+IssuedShare, @Amount=@Amount+CapitalAmount
		FROM speccs.Shares 
		WHERE MemAccNo=@MemAccNo AND ToDate=NULL
		
		UPDATE speccs.Shares 
		SET ToDate=dateadd(DD,-1,@receiptDate),UserId=@userid,RegTime=getdate()
		WHERE MemAccNo=@MemAccNo AND ToDate=NULL
		
		IF(@@ERROR!=0)
		BEGIN
   			RAISERROR 99999 "Error while updating ToDate in Shares  :SP_Receipts "
   			ROLLBACK TRANSACTION
   			RETURN
		END
		
	END
 		 				
	INSERT INTO speccs.Shares(MemAccNo, FromDate, ToDate, ModeOfPayment, IssuedShare,TotalSubscribedShare,CapitalAmount, ReceiptNo, UserId, RegTime)
	VALUES (@MemAccNo, @receiptDate,NULL, @ModeOfPayment, @Shares,@TotalSubscribedShare,@Amount,@Receiptno, @userid,getdate())
	
	IF(@@ERROR!=0)
	BEGIN
   		RAISERROR 99999 "Error while inserting data in Shares :SP_Receipts "
   		ROLLBACK TRANSACTION
   		RETURN
	END
   
	
END --icode M06

-- icode L26 start 
IF (@purposecode = 'L26' OR @purposecode = 'L31' OR @purposecode = 'L24' OR @purposecode = 'L29' OR @purposecode = 'L34')
BEGIN

   
 	IF EXISTS (SELECT * FROM speccs.LoanTransactions WHERE LoanAccNo=@RefNo) 
	BEGIN
		DECLARE @maxTranDate DATE 
		SELECT @maxTranDate=max(TransactionDate) FROM speccs.LoanTransactions WHERE LoanAccNo=@RefNo
		--added for missed receipt transactions start
		IF(@receiptDate<@maxTranDate)
		BEGIN 
		
			/* Adaptive Server has expanded all '*' elements in the following statement */ 
			SELECT speccs.LoanTransactions.LoanAccNo, speccs.LoanTransactions.TransactionDate, speccs.LoanTransactions.PayCode, speccs.LoanTransactions.Amount, speccs.LoanTransactions.P_I, speccs.LoanTransactions.ReceiptNo, speccs.LoanTransactions.Modeofpay, speccs.LoanTransactions.ClosingBal, speccs.LoanTransactions.RegTime, speccs.LoanTransactions.UserId INTO #tempData7 FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)>@receiptDate AND LoanAccNo=@RefNo AND P_I='P'
			DECLARE @LoanAccNo VARCHAR(10), @ReceiptNo VARCHAR(14)
			
			WHILE EXISTS (SELECT 1 FROM #tempData7)
			BEGIN
			
			    SELECT TOP 1 @LoanAccNo = LoanAccNo,@ReceiptNo=ReceiptNo FROM #tempData7
			    
					UPDATE speccs.LoanTransactions
				   SET ClosingBal=ClosingBal-@Amount
				   WHERE LoanAccNo=@LoanAccNo AND ReceiptNo=@ReceiptNo AND P_I='P'
				    
			    DELETE FROM #tempData7 WHERE LoanAccNo=@LoanAccNo AND ReceiptNo=@ReceiptNo
			END
		/*SELECT TOP 1 @ClosingBalance=ClosingBal FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)<@receiptDate AND LoanAccNo=@RefNo AND PayCode IN('L23','L24','L26') AND P_I='P' ORDER BY TransactionDate desc
	Newly added on 12-11-2025 for Transaction date Duplication -Start*/
	
		DECLARE @TranCountdate DATE,@Count NUMERIC
	
		SELECT  TOP 1 @TranCountdate= TransactionDate
    		FROM speccs.LoanTransactions
    		WHERE convert(DATE,TransactionDate)<@receiptDate AND LoanAccNo=@RefNo 
    		AND PayCode IN('L23','L24','L26') AND P_I='P' ORDER BY TransactionDate desc
		SELECT @TranCountdate
		
			SELECT  @Count=Count(*) 
    		FROM speccs.LoanTransactions
    		WHERE convert(DATE,TransactionDate)=@TranCountdate AND LoanAccNo=@RefNo 
    		AND PayCode IN('L23','L24','L26') AND P_I='P' ORDER BY TransactionDate DESC
    		IF @Count>1
    		BEGIN
    		
    		SELECT TOP 1 @ClosingBalance=ClosingBal FROM speccs.LoanTransactions
    		 WHERE convert(DATE,TransactionDate)=@TranCountdate AND LoanAccNo=@RefNo
    		  AND PayCode IN('L23','L24','L26') AND P_I='P' ORDER BY RegTime DESC
    		  END 
    		  ELSE 
    		  BEGIN
    		  
    		  		SELECT TOP 1 @ClosingBalance=ClosingBal FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)<@receiptDate 
    		  		AND LoanAccNo=@RefNo  AND PayCode IN('L23','L24','L26') AND P_I='P' ORDER BY TransactionDate DESC,RegTime DESC,ReceiptNo DESC 

    		  END 
    		  
    		  
    		  UPDATE speccs.Loans
 	SET LoanSanctionAmount=LoanSanctionAmount-@Amount,RegTime=getdate()
 	WHERE LoanAccNo=@RefNo AND LoanStatus='RELEASED'
 	 			
	INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,  Amount, P_I, ReceiptNo, Modeofpay, ClosingBal,RegTime,UserId)
	VALUES (@RefNo,@receiptDate,@purposecode, @Amount, 'P', @Receiptno, @ModeOfPayment, (@ClosingBalance-@Amount),getdate(), @userid)
	
	
	
	
   /*Newly added on 12-11-2025 for Transaction date Duplication -End */
	
	
	
	
	END	--end of missed receipts transactions 
	ELSE
	BEGIN 
	SELECT  @ClosingBalance=0
		SELECT  @ClosingBalance=LoanSanctionAmount FROM speccs.Loans WHERE LoanAccNo=@RefNo	
	
   
 	 			
	INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,  Amount, P_I, ReceiptNo, Modeofpay, ClosingBal,RegTime,UserId)
	VALUES (@RefNo,@receiptDate,@purposecode, @Amount, 'P', @Receiptno, @ModeOfPayment, (@ClosingBalance-@Amount),getdate(), @userid)
	
		UPDATE speccs.Loans
 	SET LoanSanctionAmount=@ClosingBalance-@Amount,RegTime=getdate()
 	WHERE LoanAccNo=@RefNo AND LoanStatus='RELEASED'
	
	END --end else part
	   
 	
 	
	
	INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@userid,@MemAccNo,@Receiptno,'Loan Transactions Receipts',getdate(),@Ipaddress,@Remarks)
	END	
	IF(@@ERROR!=0)
	BEGIN
   	   	SELECT @Message="Error while inserting "+@MemAccNo+" data in LoanTransactions  :SP_Receipts"
   	   	RAISERROR 99999 @Message
   	   	ROLLBACK TRANSACTION
   		RETURN
	END
   

END    -- icode L26 ends
IF (@purposecode = 'M43' OR @purposecode = 'M03' )
BEGIN
	--added by pn on 17/04/2025 
	DECLARE @oldThrift DECIMAL(15,2)
	SELECT @oldThrift=ThriftBalance FROM speccs.MemberAccount WHERE MemAccNo=@MemAccNo
   	
	
 	-----Added for Missed Transacions 27-11-2025 -Start
 	
 	DECLARE @maxTranDate1 DATE 
		SELECT @maxTranDate1=max(TransactionDate) FROM speccs.ThriftTransactions WHERE MemAccNo=@MemAccNo
IF(@receiptDate<@maxTranDate1)
		BEGIN 
		
			/* Adaptive Server has expanded all '*' elements in the following statement */ 
			/* Adaptive Server has expanded all '*' elements in the following statement */ SELECT t.MemAccNo, t.Month, t.TransactionDate, t.ModeOfPayment, t.Amount, t.ReceiptNo, t.UserId, t.RegTime, t.ThriftBalance INTO #tempData8 FROM speccs.ThriftTransactions t WHERE convert(DATE,t.TransactionDate)>@receiptDate AND t.MemAccNo=@MemAccNo
			DECLARE @ReceiptNo1 VARCHAR(14)
			
			WHILE EXISTS (SELECT 1 FROM #tempData8)
			BEGIN
			
			    SELECT TOP 1 @MemAccNo=MemAccNo,@ReceiptNo1=ReceiptNo FROM #tempData8
			    
				   UPDATE speccs.ThriftTransactions
				   SET ThriftBalance=ThriftBalance+@Amount
				   WHERE MemAccNo=@MemAccNo AND ReceiptNo=@ReceiptNo1
				    
			    DELETE FROM #tempData8 WHERE MemAccNo=@MemAccNo AND ReceiptNo=@ReceiptNo1
			END
		/*SELECT TOP 1 @ClosingBalance=ClosingBal FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)<@receiptDate AND LoanAccNo=@RefNo AND PayCode IN('L23','L24','L26') AND P_I='P' ORDER BY TransactionDate desc
	Newly added on 12-11-2025 for Transaction date Duplication -Start*/
	
		DECLARE @TranCountdate1 DATE,@Count1 NUMERIC,@ThriftBalance NUMERIC(15,2) 
	
		SELECT  TOP 1 @TranCountdate1= TransactionDate
    		FROM speccs.ThriftTransactions
    		WHERE convert(DATE,TransactionDate)<=@receiptDate AND MemAccNo=@MemAccNo
    		ORDER BY TransactionDate DESC
    		
		SELECT @TranCountdate1
		
			SELECT  @Count1=Count(*) 
    		FROM speccs.ThriftTransactions
    		WHERE convert(DATE,TransactionDate)=@TranCountdate1 AND MemAccNo=@MemAccNo
    	  	ORDER BY TransactionDate DESC
    	  	
    		IF @Count1>1
    		BEGIN
    		
    		SELECT TOP 1 @ThriftBalance =ThriftBalance FROM speccs.ThriftTransactions
    		 WHERE convert(DATE,TransactionDate)=@TranCountdate1 AND MemAccNo=@MemAccNo
    		 ORDER BY RegTime DESC
    		  END 
    		  ELSE 
    		  BEGIN
    		  
    		  		SELECT TOP 1 @ThriftBalance=ThriftBalance FROM speccs.ThriftTransactions WHERE convert(DATE,TransactionDate)<@receiptDate 
    		  		AND MemAccNo=@MemAccNo ORDER BY TransactionDate desc

    		  END 
	
	
	   

	INSERT INTO speccs.ThriftTransactions(MemAccNo,Month,TransactionDate,ModeOfPayment,Amount,ReceiptNo,UserId,RegTime,ThriftBalance)
	VALUES (@MemAccNo,convert(VARCHAR(8),datepart(mm,@receiptDate)),@receiptDate,@ModeOfPayment, @Amount, @Receiptno, @userid,getdate(),@ThriftBalance+@Amount)
 	
	
   /*Newly added on 12-11-2025 for Transaction date Duplication -End */
	
	
	   
	
	END
		------Added for Missed Transacions 27-11-2025 -END 	
	ELSE
	BEGIN 
		SELECT  @ThriftBalance=ThriftBalance 
		FROM speccs.MemberAccount
		WHERE MemAccNo=@MemAccNo 
		
		INSERT INTO speccs.ThriftTransactions(MemAccNo,Month,TransactionDate,ModeOfPayment,Amount,ReceiptNo,UserId,RegTime,ThriftBalance)
	VALUES (@MemAccNo,convert(VARCHAR(8),datepart(mm,@receiptDate)),@receiptDate,@ModeOfPayment, @Amount, @Receiptno, @userid,getdate(),@ThriftBalance+@Amount)
	
	END --end else part

 				
	
	UPDATE speccs.MemberAccount
 	SET ThriftBalance=ThriftBalance+@Amount, UserId=@userid ,RegTime=getdate()
 	WHERE MemAccNo=@MemAccNo
	
	INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@userid,@MemAccNo,@Receiptno,'Receipt Saved',getdate(),@Ipaddress,@Remarks)	
	
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
IF(@purposecode = 'L25' OR @purposecode ='L30' OR @purposecode = 'L27' OR @purposecode ='L32' OR @purposecode ='L35')
BEGIN 
	DECLARE @lastTransDate DATE,@totalInterest INT
	SELECT @lastTransDate=max(TransactionDate) FROM speccs.LoanTransactions WHERE LoanAccNo=@RefNo AND P_I='P'
	
	
	
	INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,  Amount, P_I, ReceiptNo, Modeofpay, ClosingBal,RegTime,UserId)
	VALUES (@RefNo,@receiptDate,@purposecode, @Amount, 'I', @Receiptno, @ModeOfPayment, 0,getdate(), @userid)

END 

-- icode L25,L30 end

	INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@userid,@Option3,@Receiptno,'user Receipt Approved',getdate(),@Ipaddress,@Remarks)
	RETURN
END

IF (@Option = 'DEPOSITDETAILS')  
BEGIN 
   
SELECT DepositTypeCode,Month,Amount,OpeningBalance,ClosingBalance   FROM speccs.DepositTransactions   WHERE ReceiptNo=@Receiptno
	
END


RETURN













GO

