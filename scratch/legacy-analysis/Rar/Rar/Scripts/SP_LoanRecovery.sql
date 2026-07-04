IF OBJECT_ID ('speccs.SP_LoanRecovery') IS NOT NULL
	DROP PROCEDURE speccs.SP_LoanRecovery
GO

CREATE  PROCEDURE speccs.SP_LoanRecovery


@Option  		    VARCHAR (20),
@LoanAccno          VARCHAR (15) =NULL,
@Loantype           VARCHAR (5) =NULL,
@opendate           VARCHAR (15) =NULL,
@loaninterest       FLOAT,
@noofinstallments 	INT,
@loansancamt  		VARCHAR (20)=NULL,
@loansanctiondate  VARCHAR (20)=NULL,
@noofinstallpaid    VARCHAR (20)=NULL,
@principalbal       INT,
@interestrate      VARCHAR (20)=NULL,
@modeOfPay         VARCHAR (10)=NULL,
@principalamt       FLOAT,
@interestamt        FLOAT,
@prereceiptno       VARCHAR(15)=NULL,
@userid             VARCHAR(10)=NULL,
@memaccno           VARCHAR(10)=NULL,
@Ipaddress          VARCHAR(30)=NULL,
@ClosingBal       INT,
@ApplNoNew			VARCHAR(20) output


AS

/*
	DROP PROCEDURE  speccs.SP_LoanRecovery
	
	GRANT ALL ON speccs.SP_LOANRECOVERY to speccsgroup
*/
	IF (@Option="SANCTION") 
	BEGIN
		SELECT B.MemEmpCode,B.MemName,B.MemAccNo,A.LoanAccNo FROM speccs.Loans A,speccs.Members B 
		WHERE A.MemAccNo=B.MemAccNo AND A.LoanStatus NOT IN('FRESH','REJECT') 
		RETURN
	   END
	   
	   	IF (@Option="PRIAMOUNTDETAILS") 
     	BEGIN
 
	   SELECT  SUM(Amount) AS PriAmount FROM speccs.LoanTransactions WHERE LoanAccNo=@LoanAccno AND P_I='P'
	   RETURN
     	END
	  
	   
	   
	IF (@Option="INTSANCDETAILS") 
	BEGIN
	SELECT tr.Amount AS intamount  FROM speccs.LoanTransactions tr WHERE tr.LoanAccNo=@LoanAccno AND tr.P_I='I'
	   RETURN
	END
	
	IF (@Option="SANCDETAILS") 
	BEGIN
	SELECT A.NoOfInstallments,convert(CHAR(10),A.LoanSanctionDate,103) AS LoanSanctionDate,
	A.LoanSanctionAmount,A.InterestRate,convert(CHAR(10),A.Loanappdate,103)AS Loanappdate,
	A.MonthlyInstallments,A.LoanType,tr.Amount,tr.Modeofpay,tr.ReceiptNo,tr.P_I FROM speccs.Loans A
	LEFT JOIN speccs.LoanTransactions tr
	ON A.LoanAccNo=tr.LoanAccNo
	 WHERE A.LoanAccNo=@LoanAccno
	   RETURN
	END
	
	IF (@Option="SAVE") 
	BEGIN
	DECLARE @Exlpripaycode VARCHAR(10),@Exlintpaycode VARCHAR(10),@Ltlpripaycode VARCHAR(10),@Ltlintpaycode VARCHAR(10),@Fdlpripaycode VARCHAR(10),@Fdlintpaycode VARCHAR(10)
	
	SELECT @Exlpripaycode='L29',@Exlintpaycode='L30',@Ltlpripaycode='L24',@Ltlintpaycode='L25',@Fdlpripaycode='L34',@Fdlintpaycode='L35'
	
	EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ApplNoNew output
			  
   IF(@Loantype='EXL')	
   BEGIN 
INSERT INTO speccs.Receipts(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
VALUES (@memaccno, @ApplNoNew, getdate(), @Loantype, @principalbal, @modeOfPay,@userid,getdate(),'ACTIVE','',@LoanAccno)
			  
INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,Amount,P_I,ReceiptNo,Modeofpay,RegTime,UserId)
VALUES (@LoanAccno,getdate(),@Exlpripaycode,@principalamt,'P',@ApplNoNew,@modeOfPay,getdate(),@userid) 
			  
INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,Amount,P_I,ReceiptNo,Modeofpay,RegTime,UserId)
VALUES (@LoanAccno,getdate(),@Exlintpaycode,CONVERT(INT,@interestamt),'I',@ApplNoNew,@modeOfPay,getdate(),@userid)	   

INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@userid,@memaccno,@ApplNoNew,'EXL Loan Recovery Data Saved ',getdate(),@Ipaddress,'')

RETURN
END
		  
ELSE IF(@Loantype='LTL')
    BEGIN

INSERT INTO speccs.Receipts(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
VALUES (@memaccno, @ApplNoNew, getdate(), @Loantype, @principalbal, @modeOfPay,@userid,getdate(),'ACTIVE','',@LoanAccno)
			  
INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,Amount,P_I,ReceiptNo,Modeofpay,ClosingBal,RegTime,UserId)
VALUES (@LoanAccno,getdate(),@Ltlpripaycode,@principalamt,'P',@ApplNoNew,@modeOfPay,@ClosingBal,getdate(),@userid) 
  			  
  INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,Amount,P_I,ReceiptNo,Modeofpay,ClosingBal,RegTime,UserId)
  VALUES (@LoanAccno,getdate(),@Ltlintpaycode,CONVERT(INT,@interestamt),'I',@ApplNoNew,@modeOfPay,@ClosingBal,getdate(),@userid) 

INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@userid,@memaccno,@ApplNoNew,'LTL Loan Recovery Data Saved ',getdate(),@Ipaddress,'')
	   
RETURN
END
ELSE IF(@Loantype='FDL')
    BEGIN

INSERT INTO speccs.Receipts(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
VALUES (@memaccno, @ApplNoNew, getdate(), @Loantype, @principalbal, @modeOfPay,@userid,getdate(),'ACTIVE','',@LoanAccno)
			  
INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,Amount,P_I,ReceiptNo,Modeofpay,RegTime,UserId)
VALUES (@LoanAccno,getdate(),@Fdlpripaycode,@principalamt,'P',@ApplNoNew,@modeOfPay,getdate(),@userid) 
			  
INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,Amount,P_I,ReceiptNo,Modeofpay,RegTime,UserId)
VALUES (@LoanAccno,getdate(),@Fdlintpaycode,CONVERT(INT,@interestamt),'I',@ApplNoNew,@modeOfPay,getdate(),@userid)	   

INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@userid,@memaccno,@ApplNoNew,'FDL Loan Recovery Data Saved ',getdate(),@Ipaddress,'')

RETURN
END

	
				
	   RETURN
	END
	
	

IF (@Option="UPDATE") 
	BEGIN
	
	
UPDATE  speccs.Receipts SET MemAccNO=@memaccno, ReceiptDate=getdate(),
 PurposeCode=@Loantype, Amount=@principalbal, ModeOfPayment=@modeOfPay,UserId=@userid,RegTime=getdate(),
 Status='ACTIVE',Remarks='',RefNo=@LoanAccno WHERE ReceiptNo=@prereceiptno
	
UPDATE speccs.LoanTransactions SET TransactionDate=getdate(),Amount=@principalamt,
Modeofpay=@modeOfPay,RegTime=getdate(),UserId=@userid
WHERE ReceiptNo=@prereceiptno AND P_I='P'

UPDATE speccs.LoanTransactions SET TransactionDate=getdate(),Amount=CONVERT(INT,@interestamt),
Modeofpay=@modeOfPay,RegTime=getdate(),UserId=@userid
WHERE ReceiptNo=@prereceiptno AND P_I='I'

	INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@userid,@memaccno,@prereceiptno,'Loan Recovery Data Updated ',getdate(),@Ipaddress,'')
				
	   RETURN
	END
	
	IF (@Option="LOANTYPE") 
	BEGIN
	SELECT LoanTypeCode,LoanTypeDescription FROM speccs.LoanTypes
  
	   RETURN
	END







GO

