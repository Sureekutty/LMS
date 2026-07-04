IF OBJECT_ID ('speccs.SP_LoanDetails') IS NOT NULL
	DROP PROCEDURE speccs.SP_LoanDetails
GO

CREATE  PROCEDURE speccs.SP_LoanDetails 
@Option  	VARCHAR (20),
@MemAccNo VARCHAR(15),
@EmpCode VARCHAR(7) = NULL,
@Loantype  	VARCHAR (7),
@Status VARCHAR(10),
@Sanctiondate VARCHAR(14),
@Remarks VARCHAR(150),
@Ipaddress VARCHAR(30) =NULL,
@AccountNumber VARCHAR(30),
@ChequeNumber VARCHAR(30)
 
 

AS




/*
	DROP PROCEDURE  speccs.SP_LoanDetails
	
	GRANT ALL ON speccs.SP_LoanDetails to speccsgroup
*/


  /* 	IF (@Status="SANCTION") 
	BEGIN
	
	SELECT MemAccNo,LoanSanctionAmount,NoOfInstallments FROM speccs.Loans  WHERE LoanStatus='SANCTION'
	END
*/

		IF(@Option = 'LOANSOCIETYMEM')
	BEGIN 
	
	
		IF(@MemAccNo = '')
		BEGIN 
		/* Adaptive Server has expanded all '*' elements in the following statement */
		 SELECT mem.MemAccNo, mem.MemEmpCode, mem.MemName, mem.PanNo, mem.AadharNo, mem.MailId,
		  mem.Designation, mem.Division, mem.Phone, mem.OffPhone, mem.BankAccNo, 
		  mem.IfscCode, mem.BankName, mem.BankAddress, mem.BankPlace, mem.BasicPay, mem.MemDate,
		   mem.Dob, mem.RetiredDate, mem.Status, mem.CareOf, mem.ClosedDate, mem.Remarks, mem.UserId, mem.RegTime,
		 memloan.LoanAccNo,memloan.LoanType,memloan.LoanPurpose,memloan.NoOfInstallments,memloan.MonthlyInstallments,memloan.Thriftdudamt,memloan.ChequeAmount,memloan.Releaseddate,
		     memloan.LoanStatus,memloan.FundId,memloan.LoanSanctionAmount,memloan.InterestMethod,memloan.InterestRate,memloan.LoanSanctionDate,memloan.Loanappdate,memloan.DisbursedOnDate,
		     memloan.Surety1,memloan.Surety2,memloan.Surety3,memloan.UserId,memloan.RegTime,memAccount.ThriftSubscriptionAmount,
		     memAccount.ThriftBalance,memAccount.ShareAmount,memAccount.NoOfShares
			FROM speccs.Members mem
			LEFT JOIN speccs.Loans memloan
			ON mem.MemAccNo = memloan.MemAccNo
			LEFT JOIN speccs.MemberAccount memAccount
			ON mem.MemAccNo = memAccount.MemAccNo
			WHERE memloan.LoanStatus =@Status
			
		END
	  /*ELSE
		BEGIN 
   
		 SELECT mem.MemAccNo, mem.MemEmpCode, mem.MemName, mem.PanNo, mem.AadharNo, mem.MailId,
		  mem.Designation, mem.Division, mem.Phone, mem.OffPhone, mem.BankAccNo, mem.IfscCode, 
		  mem.BankName, mem.BankAddress, mem.BankPlace, mem.BasicPay, mem.MemDate, mem.Dob,
		   mem.RetiredDate, mem.Status, mem.CareOf, mem.ClosedDate, mem.Remarks, mem.UserId,
		    mem.RegTime, nom.MemAccNo, nom.NomName, nom.NomDOB, nom.Relationship, nom.Gender, 
		    nom.Address, nom.Status, nom.UserId, nom.RegTime, memAccount.MemAccNo, memAccount.MembershipFee,
		     memAccount.ThriftSubscriptionAmount, memAccount.ThriftBalance, memAccount.ShareAmount,
		      memAccount.NoOfShares, memAccount.WelfareFund, memAccount.SERBS, memAccount.Insurance_Loan,
		       memAccount.Insurance_Thrift, memAccount.UserId, memAccount.RegTime         
			FROM speccs.Members mem
	   		LEFT JOIN speccs.Nominee nom
			ON mem.MemAccNo = nom.MemAccNo
			LEFT JOIN speccs.MemberAccount memAccount
			ON mem.MemAccNo = memAccount.MemAccNo
			WHERE mem.Status = @Status AND mem.MemAccNo =@MemAccNo
			
		END
		*/
	END
	

   	IF (@Option="STATUSUPDATE") 
	BEGIN
	
	UPDATE speccs.Loanstatus SET LoanStatus=@Status,UserId=@EmpCode,RegTime=getdate() WHERE LoanAccNo=@MemAccNo 
	END

	IF(@Option = 'LOANVIEW')
	BEGIN 
	
		/* Adaptive Server has expanded all '*' elements in the following statement */
		 SELECT  DISTINCT mem.MemAccNo, mem.MemEmpCode, mem.MemName,mem.BankName,mem.BankAccNo,
		 memloan.LoanAccNo,memloan.LoanType,memloan.LoanPurpose,memloan.NoOfInstallments,memloan.MonthlyInstallments,memloan.Thriftdudamt,memloan.ChequeAmount,
		     memloan.LoanStatus,memloan.FundId,memloan.LoanSanctionAmount,memloan.InterestMethod,memloan.InterestRate,
		     convert(CHAR(10),memloan.LoanSanctionDate,103) AS LoanSanctionDate ,
		    convert(CHAR(10),memloan.Loanrejecteddate,103) AS Loanrejecteddate  ,
		     convert(CHAR(10),memloan.Loanappdate,103) AS Loanappdate  ,
		     convert(CHAR(10),memloan.Releaseddate,103) AS Releaseddate,
		    memloan.Surety1,memloan.Surety2,memloan.Surety3,memloan.UserId,memloan.RegTime,memAccount.ThriftSubscriptionAmount,  memloan.DisbursedOnDate,
		     memAccount.ThriftSubscriptionAmount,
		     memAccount.ThriftBalance,memAccount.ShareAmount,memAccount.NoOfShares
			FROM speccs.Members mem
			LEFT JOIN speccs.Loanstatus memloan
			ON mem.MemAccNo = memloan.MemAccNo
			LEFT JOIN speccs.MemberAccount memAccount
			ON mem.MemAccNo = memAccount.MemAccNo
			WHERE  memloan.LoanStatus='FRESH' ORDER BY Loanappdate DESC
			
		END
	IF(@Option = 'LOANVIEWSANCTION')
	BEGIN 
	
		/* Adaptive Server has expanded all '*' elements in the following statement */
	    SELECT  DISTINCT mem.MemAccNo, mem.MemEmpCode, mem.MemName,mem.BankName,mem.BankAccNo,
		 memloan.LoanAccNo,memloan.LoanType,memloan.LoanPurpose,memloan.NoOfInstallments,memloan.MonthlyInstallments,memloan.Thriftdudamt,memloan.ChequeAmount,
		     memloan.LoanStatus,memloan.FundId,memloan.LoanSanctionAmount,memloan.InterestMethod,memloan.InterestRate,
		     convert(CHAR(10),memloan.LoanSanctionDate,103) AS LoanSanctionDate ,
		    convert(CHAR(10),memloan.Loanrejecteddate,103) AS Loanrejecteddate  ,
		     convert(CHAR(10),memloan.Loanappdate,103) AS Loanappdate  ,
		     convert(CHAR(10),memloan.Releaseddate,103) AS Releaseddate,
		     memloan.Surety1,memloan.Surety2,memloan.Surety3,memloan.UserId,memloan.RegTime,memAccount.ThriftSubscriptionAmount, memloan.DisbursedOnDate,
		     memAccount.ThriftSubscriptionAmount,
		     memAccount.ThriftBalance,memAccount.ShareAmount,memAccount.NoOfShares
			FROM speccs.Members mem
			LEFT JOIN speccs.Loanstatus memloan
			ON mem.MemAccNo = memloan.MemAccNo
			LEFT JOIN speccs.MemberAccount memAccount
			ON mem.MemAccNo = memAccount.MemAccNo
			WHERE  memloan.LoanStatus IN ('SANCTION') ORDER BY LoanSanctionDate DESC
			
		END
		IF(@Option = 'LOANVIEWRELINIT')
	BEGIN 
	
		/* Adaptive Server has expanded all '*' elements in the following statement */
	    SELECT  DISTINCT mem.MemAccNo, mem.MemEmpCode, mem.MemName,mem.BankName,mem.BankAccNo,
		 memloan.LoanAccNo,memloan.LoanType,memloan.LoanPurpose,memloan.NoOfInstallments,memloan.MonthlyInstallments,memloan.Thriftdudamt,memloan.ChequeAmount,
		     memloan.LoanStatus,memloan.FundId,memloan.LoanSanctionAmount,memloan.InterestMethod,memloan.InterestRate,
		     convert(CHAR(10),memloan.LoanSanctionDate,103) AS LoanSanctionDate ,
		    convert(CHAR(10),memloan.Loanrejecteddate,103) AS Loanrejecteddate  ,
		     convert(CHAR(10),memloan.Loanappdate,103) AS Loanappdate  ,
		     convert(CHAR(10),memloan.Releaseddate,103) AS Releaseddate,
		     memloan.Surety1,memloan.Surety2,memloan.Surety3,memloan.UserId,memloan.RegTime,memAccount.ThriftSubscriptionAmount, memloan.DisbursedOnDate,
		     memAccount.ThriftSubscriptionAmount,
		     memAccount.ThriftBalance,memAccount.ShareAmount,memAccount.NoOfShares
			FROM speccs.Members mem
			LEFT JOIN speccs.Loanstatus memloan
			ON mem.MemAccNo = memloan.MemAccNo
			LEFT JOIN speccs.MemberAccount memAccount
			ON mem.MemAccNo = memAccount.MemAccNo
			WHERE  memloan.LoanStatus IN ('RELINITE') ORDER BY Loanappdate DESC
			
		END
	IF(@Option = 'LOANVIEWREJECTED')
	BEGIN 
	
		/* Adaptive Server has expanded all '*' elements in the following statement */
		 SELECT DISTINCT mem.MemAccNo, mem.MemEmpCode, mem.MemName,mem.BankName,mem.BankAccNo,
		 memloan.LoanAccNo,memloan.LoanType,memloan.LoanPurpose,memloan.NoOfInstallments,memloan.MonthlyInstallments,memloan.Thriftdudamt,memloan.ChequeAmount,
		     memloan.LoanStatus,memloan.FundId,memloan.LoanSanctionAmount,memloan.InterestMethod,memloan.InterestRate,
		     convert(CHAR(10),memloan.LoanSanctionDate,103) AS LoanSanctionDate ,
		    convert(CHAR(10),memloan.Loanrejecteddate,103) AS Loanrejecteddate  ,
		     convert(CHAR(10),memloan.Loanappdate,103) AS Loanappdate  ,
		     convert(CHAR(10),memloan.Releaseddate,103) AS Releaseddate,
		     memloan.Surety1,memloan.Surety2,memloan.Surety3,memloan.UserId,memloan.RegTime,memAccount.ThriftSubscriptionAmount, memloan.DisbursedOnDate,
		     memAccount.ThriftSubscriptionAmount,
		     memAccount.ThriftBalance,memAccount.ShareAmount,memAccount.NoOfShares
			FROM speccs.Members mem
			LEFT JOIN speccs.Loanstatus memloan
			ON mem.MemAccNo = memloan.MemAccNo
			LEFT JOIN speccs.MemberAccount memAccount
			ON mem.MemAccNo = memAccount.MemAccNo
		
			WHERE  memloan.LoanStatus='REJECT' ORDER BY Loanrejecteddate DESC
			
		END
			IF(@Option = 'LOANVIEWRELEASED')
	BEGIN 
	
		/* Adaptive Server has expanded all '*' elements in the following statement */
		 SELECT DISTINCT mem.MemAccNo, mem.MemEmpCode, mem.MemName,mem.BankName,mem.BankAccNo,
		 memloan.LoanAccNo,memloan.LoanType,memloan.LoanPurpose,memloan.NoOfInstallments,memloan.MonthlyInstallments,memloan.Thriftdudamt,memloan.ChequeAmount,
		     memloan.LoanStatus,memloan.FundId,memloan.LoanSanctionAmount,memloan.InterestMethod,memloan.InterestRate,
		   convert(CHAR(10),memloan.Loanrejecteddate,103) AS Loanrejecteddate ,
		     convert(CHAR(10),memloan.LoanSanctionDate,103) AS LoanSanctionDate ,
		      convert(CHAR(10),memloan.Loanappdate,103) AS Loanappdate ,
		      convert(CHAR(10),memloan.Releaseddate,103) AS Releaseddate,
		     memloan.Surety1,memloan.Surety2,memloan.Surety3,memloan.UserId,memloan.RegTime,memAccount.ThriftSubscriptionAmount,
		     memAccount.ThriftBalance,memAccount.ShareAmount,memAccount.NoOfShares
			FROM speccs.Members mem
			LEFT JOIN speccs.Loanstatus memloan
			ON mem.MemAccNo = memloan.MemAccNo
			LEFT JOIN speccs.MemberAccount memAccount
			ON mem.MemAccNo = memAccount.MemAccNo
			WHERE  memloan.LoanStatus='RELEASED' ORDER BY Releaseddate DESC
			
		END
		/* 21-08-2025 Added Settled If Block -->Start */
		IF(@Option = 'LOANVIEWSETTLED')
	BEGIN 
	
		/* Adaptive Server has expanded all '*' elements in the following statement */
		 SELECT DISTINCT mem.MemAccNo, mem.MemEmpCode, mem.MemName,mem.BankName,mem.BankAccNo,
		 memloan.LoanAccNo,memloan.LoanType,memloan.LoanPurpose,memloan.NoOfInstallments,memloan.MonthlyInstallments,memloan.Thriftdudamt,memloan.ChequeAmount,
		     memloan.LoanStatus,memloan.FundId,memloan.LoanSanctionAmount,memloan.InterestMethod,memloan.InterestRate,
		   convert(CHAR(10),memloan.Loanrejecteddate,103) AS Loanrejecteddate ,
		     convert(CHAR(10),memloan.LoanSanctionDate,103) AS LoanSanctionDate ,
		      convert(CHAR(10),memloan.Loanappdate,103) AS Loanappdate ,
		      convert(CHAR(10),memloan.Releaseddate,103) AS Releaseddate,
		     memloan.Surety1,memloan.Surety2,memloan.Surety3,memloan.UserId,memloan.RegTime,memAccount.ThriftSubscriptionAmount,
		     memAccount.ThriftBalance,memAccount.ShareAmount,memAccount.NoOfShares
			FROM speccs.Members mem
			LEFT JOIN speccs.Loanstatus memloan
			ON mem.MemAccNo = memloan.MemAccNo
			LEFT JOIN speccs.MemberAccount memAccount
			ON mem.MemAccNo = memAccount.MemAccNo
			WHERE  memloan.LoanStatus='SETTLED' ORDER BY Releaseddate DESC
			
		END
		
		/* 21-08-2025 Added Settled If Block -->End */
	IF (@Option="SANCTION") 
	BEGIN
	
	UPDATE speccs.Loanstatus SET LoanStatus=@Status,Remarks=@Remarks ,LoanSanctionDate=getdate(),UserId=@EmpCode,RegTime=getdate() WHERE LoanAccNo=@MemAccNo
	
	INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@EmpCode,@Loantype,@MemAccNo,'user sanctioned',getdate(),@Ipaddress,@Remarks)
	
	
	END

	IF (@Option="REJECT") 
	BEGIN
	-- @ChequeNumber comin as memAccNo and @Loantype is coming as empcode
	UPDATE speccs.Loanstatus SET LoanStatus=@Status,Remarks=@Remarks , Loanrejecteddate=getdate(),UserId=@EmpCode,RegTime=getdate() WHERE LoanAccNo=@MemAccNo
	--added by pn on 23/05/2025 for thrift receipt rejection told by Rama Rao
		--thrift receipt rejection once loan will get reject
		IF EXISTS(SELECT * FROM speccs.Receipts WHERE MemAccNO=@ChequeNumber AND PurposeCode='M45' AND Status='SUBMIT')
	    BEGIN
	   		UPDATE speccs.Receipts
	   		SET Status='CANCEL'
	   		WHERE MemAccNO=@ChequeNumber AND PurposeCode='M45' AND Status='SUBMIT'   		
   	    END
	-- end
	
	
	INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@EmpCode,@Loantype,@MemAccNo,'user Rejected',getdate(),@Ipaddress,@Remarks)
	
	END

	IF (@Option="RELINIT") 
	BEGIN
	
	UPDATE speccs.Loanstatus SET LoanStatus=@Status, Recoverydate=@Sanctiondate,UserId=@EmpCode,RegTime=getdate(),Remarks=@Remarks WHERE LoanAccNo=@MemAccNo
	
	INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@EmpCode,@Loantype,@MemAccNo,'user Loan Release Initiate',getdate(),@Ipaddress,@Remarks)
	
	END

IF (@Option="RELEASE") 
	BEGIN
	UPDATE speccs.Loans SET LoanStatus=@Status, Releaseddate=@Sanctiondate,UserId=@EmpCode,RegTime=getdate(),Remarks=@Remarks WHERE LoanAccNo=@MemAccNo
	UPDATE speccs.Loanstatus SET LoanStatus=@Status, Releaseddate=@Sanctiondate,UserId=@EmpCode,RegTime=getdate(),Remarks=@Remarks WHERE LoanAccNo=@MemAccNo



 --added by pn on 25/07/2024 for generating payment voucher of loans told by Madhav Reddy sir	
	DECLARE @vouchernonew VARCHAR(14)
	DECLARE @Amount NUMERIC(20,2) ,@cbl NUMERIC(20,2)
	SELECT @Amount=LoanSanctionAmount FROM speccs.Loanstatus WHERE LoanAccNo=@MemAccNo
 --loan cbl start
 	
	DECLARE @memaccno VARCHAR(10),@tranDate DATETIME
	SELECT @memaccno=MemAccNo FROM speccs.Loans WHERE LoanAccNo=@MemAccNo
	SELECT @tranDate=max(TransactionDate) FROM speccs.LoanTransactions WHERE LoanAccNo=@MemAccNo
 
 --loan cbl end
   
 --added by pn on 22/11/2024 to store in loanTransacions told by Madhav Reddy Sir
 DECLARE @purCode VARCHAR(5)
 IF(substring(@MemAccNo,1,3)='LTL') BEGIN SELECT @purCode='L23' END 
  IF(substring(@MemAccNo,1,3)='EXL') BEGIN SELECT @purCode='L28' END 
 IF(substring(@MemAccNo,1,3)='FDL') BEGIN SELECT @purCode='L33' END 

-- added by pn on 06/06/2025 told by Rama Rao to generate payments for loan disbursement  --added the same before FDL

-- EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@vouchernonew output

 --  	INSERT INTO speccs.Payments
 --  VALUES(@memaccno,@vouchernonew,@Sanctiondate,@purCode,@Amount,'CHEQUE','ACTIVE',@MemAccNo,'Loan Disburs Payment',@EmpCode,GETDATE())

 	DECLARE @ReceiptNo VARCHAR(14)
   --	exec SP_Receipts 'SAVE',@memaccno,@Sanctiondate,@purCode,@Amount,'BANK',@MemAccNo,@EmpCode,@Sanctiondate,@Ipaddress,'Loan Disbursement',@ReceiptNo output
   --Thrift deduction against loan and receipt start
   
     DECLARE @Thriftdudamt NUMERIC(15,2),@thrftAmnt NUMERIC(15,2),@receiptNo VARCHAR(14)
 	SELECT @Thriftdudamt=0
   IF EXISTS(SELECT * FROM speccs.Receipts WHERE MemAccNO=@memaccno AND PurposeCode='M45' AND Status='SUBMIT')
   BEGIN
   SELECT @receiptNo=ReceiptNo,@Thriftdudamt=Amount FROM speccs.Receipts WHERE MemAccNO=@memaccno AND PurposeCode='M45' AND Status='SUBMIT'
   
   		UPDATE speccs.Receipts
   		SET Status='ACTIVE'
   		WHERE MemAccNO=@memaccno AND PurposeCode='M45' AND Status='SUBMIT'
   	   
   		UPDATE speccs.MemberAccount 
		SET ThriftBalance=ThriftBalance+@Thriftdudamt
		WHERE MemAccNo=@memaccno
		
		
	----Added on 13-11-2025 for thrift as payment transcaction -START
	DECLARE @vouchernonew1 VARCHAR(14)
	EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@vouchernonew1 output
  INSERT INTO speccs.Payments
  	VALUES(@memaccno,@vouchernonew1,@Sanctiondate,'M45',@Thriftdudamt,'Thrift Against loan','ACTIVE',@receiptNo,'Thrift from loan Payment',@EmpCode,GETDATE())
	---- 13-11-2025 for thrift as payment transcaction -END
	
	
		SELECT @thrftAmnt=ThriftBalance FROM speccs.MemberAccount WHERE MemAccNo=@memaccno
		INSERT INTO speccs.ThriftTransactions
		(MemAccNo,Month,TransactionDate,ModeOfPayment,Amount,ReceiptNo,UserId,RegTime,ThriftBalance)
		VALUES  (@memaccno,convert(VARCHAR(8),datepart(mm,@Sanctiondate)),@Sanctiondate,'Loan Disburse',@Thriftdudamt, @receiptNo,@EmpCode,getdate(),@thrftAmnt)
		
   		
   END
   
   --end
   
  ----Removed on 14-10-25 START
  EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNo output
  -- INSERT INTO speccs.Receipts(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
  -- VALUES (@memaccno, @ReceiptNo, @Sanctiondate, @purCode, @Amount, 'Loan Disb',@EmpCode,getdate(),'ACTIVE','',@MemAccNo)
----Remove 14-10-25 END


	--changed by pn on 23/06/2025 told by Rama Rao
	--IF(@purCode='LTL' OR @purCode='EXL')
	IF((substring(@MemAccNo,1,3)='LTL') OR (substring(@MemAccNo,1,3)='EXL'))
	BEGIN 
	---Added for contra on 08-12-2025 START
	 DECLARE @Contraamount NUMERIC(20,2)
	   EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNo output
	   
	   IF ((SELECT LoanSanctionAmount  FROM speccs.Loans WHERE LoanAccNo=@MemAccNo)=(SELECT LoanSanctionAmount  FROM speccs.Loanstatus WHERE LoanAccNo=@MemAccNo))
	   BEGIN 
	   
	   SELECT @Contraamount=0
	   
	   END 
	   ELSE 
	   BEGIN 

	SELECT @Contraamount=LoanSanctionAmount  FROM speccs.Loans WHERE LoanAccNo=@MemAccNo
		
	INSERT INTO speccs.Receipts(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
   VALUES (@memaccno, @ReceiptNo, @Sanctiondate, 'L42', @Contraamount, 'Loan Disb contra',@EmpCode,getdate(),'ACTIVE','',@MemAccNo)

  EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@vouchernonew output

  INSERT INTO speccs.Payments
  	VALUES(@memaccno,@vouchernonew,@Sanctiondate,'L42',@Contraamount,'CHEQUE','ACTIVE',@MemAccNo,'Loan Disburs contra',@EmpCode,GETDATE())

	END 
	
   
	---Added for contra on 08-12-2025 END
	
	
	  EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNo output

	SELECT @Amount=LoanSanctionAmount FROM speccs.Loanstatus WHERE LoanAccNo=@MemAccNo AND LoanType IN ('LTL','EXL') 
   
   -------21/08/2025 start
   DECLARE @Amount1 NUMERIC(20,2)
       --Newlyadded on 17/10/2025
       
    IF EXISTS (SELECT * FROM speccs.LoanTransactions WHERE LoanAccNo=@MemAccNo AND P_I='P' )
    BEGIN 
    SELECT @Amount1=LoanSanctionAmount FROM speccs.Loans WHERE LoanAccNo=@MemAccNo
   /*SELECT @Amount1= ClosingBal FROM speccs.LoanTransactions WHERE LoanAccNo=@MemAccNo AND P_I='P' ORDER BY TransactionDate ASC */
/* Newly Added 12-11-2025 Transaction Date Duplication Isuue resolved -Start*/

/*DECLARE @TranCountdate DATE,@Count NUMERIC,@ClosingBalance NUMERIC(15,2)
	
		SELECT  TOP 1 @TranCountdate= TransactionDate
    		FROM speccs.LoanTransactions
    		WHERE LoanAccNo=@MemAccNo AND P_I='P' ORDER BY TransactionDate DESC 
    	   
			
			SELECT  @Count=Count(*) 
    		FROM speccs.LoanTransactions
    		WHERE LoanAccNo=@MemAccNo AND P_I='P' AND convert(DATE,TransactionDate)=@TranCountdate ORDER BY TransactionDate DESC 
    		IF @Count>1
    		BEGIN
    		
    		SELECT TOP 1 @Amount1=ClosingBal FROM speccs.LoanTransactions
    		 	WHERE LoanAccNo=@MemAccNo AND P_I='P' AND convert(DATE,TransactionDate)=@TranCountdate ORDER BY RegTime  DESC 
    		  END 
    		  ELSE 
    		  BEGIN
    		  
    		  		SELECT TOP 1 @Amount1=ClosingBal FROM speccs.LoanTransactions WHERE LoanAccNo=@MemAccNo AND P_I='P' ORDER BY TransactionDate DESC
    		  END */


 /*Newly Added 12-11-2025 Transaction Date Duplication Isuue resolved -End*/

   END 
   ELSE 
   BEGIN 
   
   SELECT @Amount1=0
   
   END 
   
/* 
   IF (@Amount1 >=0)
   BEGIN
   SELECT @Amount1=@Amount1
   END
   ELSE IF (@Amount1=NULL )
   BEGIN 
   SELECT @Amount1=0
   END
   ELSE
   BEGIN
   SELECT @Amount1=0
   END
   
  */ 
   
    SELECT @Amount1=@Amount-@Amount1
     INSERT INTO speccs.LoanTransactions 
	VALUES (@MemAccNo,@Sanctiondate,@purCode,@Amount1,'P',@ReceiptNo,'Loan Disb',convert(INT,@Amount),getdate(),@EmpCode)
-----Added on 14-10-25 START

  EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@vouchernonew output

  INSERT INTO speccs.Payments
  	VALUES(@memaccno,@vouchernonew,@Sanctiondate,@purCode,@Amount1-@Thriftdudamt,'CHEQUE','ACTIVE',@MemAccNo,'Loan Disburs Payment',@EmpCode,GETDATE())


------Added on 14-10-25 END

/*
-------Added Bank Transaction 23-02-2026 START

DECLARE @BankBalance FLOAT ,@BTransactiondate DATE,@BTransNo VARCHAR(50),@BAmount FLOAT,@BrefNo VARCHAR(50),@Purname VARCHAR(75)
SELECT @BTransactiondate=@Sanctiondate
SELECT @BTransNo=@vouchernonew
---For receipts+,For payments-

SELECT @BrefNo=@MemAccNo
SELECT @BAmount= @Amount1-@Thriftdudamt

SELECT @Purname=Description FROM speccs.TransactionType WHERE PayCode=@purCode 
SELECT @BankBalance=BankBalance  FROM speccs.BankBalance 
---SELECT @Transdate=Max(TransactionDate) FROM speccs.BankTransactions ORDER BY TransactionDate IN DESC

UPDATE speccs.BankBalance 
SET BankBalance=@BankBalance-@BAmount WHERE BankName='SBI'
INSERT INTO speccs.BankTransactions (ReceiptNo,TransactionDate,Amount,BankName,BankBalance,PurCode,RefNo,RegTime,UserId)
VALUES (@BTransNo,@BTransactiondate,@BAmount,'SBI',@BankBalance-@BAmount,@Purname,@BrefNo,getDate(),'SH15823')

-------Added Bank Transaction 23-02-2026 END  */

----------------------Bank Transaction 24-02-2026 START
DECLARE @BankBalance FLOAT ,@BTransactiondate DATE,@BTransNo VARCHAR(50),@BAmount FLOAT,@BrefNo VARCHAR(50),@Purname VARCHAR(75)

SELECT @BTransactiondate=@Sanctiondate
SELECT @BTransNo=@vouchernonew
---For receipts+,For payments-
SELECT @BAmount=-(@Amount1-@Thriftdudamt)
SELECT @BrefNo=@MemAccNo
SELECT @Purname=Description FROM speccs.TransactionType WHERE PayCode=@purCode
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




DECLARE @MonInst INT 

SELECT @MonInst=MonthlyInstallments FROM speccs.Loanstatus WHERE LoanAccNo=@MemAccNo



        	UPDATE speccs.Loans
		SET LoanSanctionAmount = @Amount
		WHERE LoanAccNo = @MemAccNo AND LoanStatus='RELEASED'
		
		
		UPDATE speccs.Loans
		SET MonthlyInstallments=@MonInst
		WHERE LoanAccNo = @MemAccNo AND LoanStatus='RELEASED'
		
		
	  	UPDATE speccs.Loans 
		SET l.LoanStatus=t.LoanStatus,l.Surety1=t.Surety1,l.Surety2=t.Surety2,l.Surety3=t.Surety3,l.NoOfInstallments=t.NoOfInstallments,l.MonthlyInstallments=t.MonthlyInstallments,l.InterestRate=t.InterestRate,l.Releaseddate=t.Releaseddate,l.ChequeAmount=t.ChequeAmount
	 	FROM speccs.Loanstatus t,speccs.Loans l
		WHERE t.LoanAccNo=l.LoanAccNo AND t.LoanAccNo=@MemAccNo AND l.LoanStatus='RELEASED'
		
		
    END 
    
    
     EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNo output

 	
   IF(substring(@MemAccNo,1,3)='FDL')
	BEGIN 
  --		SELECT @Amount=convert(FLOAT,(ChequeAmount+Thriftdudamt)) FROM speccs.Loans WHERE LoanAccNo=@MemAccNo AND LoanType IN ('FDL') 

		SELECT @Amount=LoanSanctionAmount  FROM speccs.Loans WHERE LoanAccNo=@MemAccNo 

   INSERT INTO speccs.LoanTransactions 
	VALUES (@MemAccNo,@Sanctiondate,@purCode,@Amount,'P',@ReceiptNo,'Loan Disb',convert(INT,@Amount),getdate(),@EmpCode)
 	END
 	------------21/08/2025 Ended
   --added for missed receipt loan transactions start
		IF(@Sanctiondate<@tranDate)
		BEGIN 
		
			/* Adaptive Server has expanded all '*' elements in the following statement */ SELECT speccs.LoanTransactions.LoanAccNo, speccs.LoanTransactions.TransactionDate, speccs.LoanTransactions.PayCode, speccs.LoanTransactions.Amount, speccs.LoanTransactions.P_I, speccs.LoanTransactions.ReceiptNo, speccs.LoanTransactions.Modeofpay, speccs.LoanTransactions.ClosingBal, speccs.LoanTransactions.RegTime, speccs.LoanTransactions.UserId INTO #tempData7 FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)>@Sanctiondate AND LoanAccNo=@MemAccNo
			DECLARE @LoanAccNo VARCHAR(10), @Receiptno VARCHAR(14)
			
			WHILE EXISTS (SELECT 1 FROM #tempData7)
			BEGIN
			
			    SELECT TOP 1 @LoanAccNo = LoanAccNo,@Receiptno=ReceiptNo FROM #tempData7
			    
					UPDATE speccs.LoanTransactions
				   SET ClosingBal=@Amount-Amount
				   WHERE LoanAccNo=@LoanAccNo AND ReceiptNo=@Receiptno
				    
				    SELECT @Amount=ClosingBal FROM speccs.LoanTransactions WHERE LoanAccNo=@LoanAccNo AND ReceiptNo=@Receiptno 
			    DELETE FROM #tempData7 WHERE LoanAccNo=@LoanAccNo AND ReceiptNo=@Receiptno
			END
			
			-----Added 26-08-2025 start
			SELECT @Amount=LoanSanctionAmount  FROM speccs.Loanstatus WHERE LoanAccNo=@LoanAccNo
			----26-08-2025 end
			
	  	UPDATE speccs.Loans
		SET LoanSanctionAmount = @Amount
		WHERE LoanAccNo = @MemAccNo AND LoanStatus='RELEASED' 
	END	--end of missed receipts transactions 
	
   ----------------------------------------------------------------	

 IF(substring(@MemAccNo,1,3)='FDL')
	BEGIN 
	 ---Added Payments for FDL on 20-11-2025 -Start
		DECLARE @vouchernonew2 VARCHAR(14)
		
 	EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@vouchernonew2 output

	DECLARE @MemNo1 VARCHAR(17)
	
   ---	SELECT @MemNo1=MemAccNo FROM speccs.Members WHERE MemEmpCode=@EmpCode


	SELECT @MemNo1=MemAccNo FROM speccs.Loans WHERE LoanAccNo=@MemAccNo

  INSERT INTO speccs.Payments
  	VALUES(@MemNo1,@vouchernonew2,@Sanctiondate,'L33',@Amount,'CHEQUE','ACTIVE',@MemAccNo,'FD Loan Disburs Payment','SH15823',GETDATE())
 
 ---Added Payments for FDL on 20-11-2025 -End
 
 -------Added Bank Transaction 23-02-2026 START

--DECLARE @BankBalance FLOAT ,@BTransactiondate DATE,@BTransNo VARCHAR(50),@BAmount FLOAT,@BrefNo VARCHAR(50),@Purname VARCHAR(75)
SELECT @BTransactiondate=@Sanctiondate
SELECT @BTransNo=@vouchernonew2
---For receipts+,For payments-

SELECT @BrefNo=@MemAccNo
SELECT @BAmount= @Amount

SELECT @Purname=Description FROM speccs.TransactionType WHERE PayCode='L33' 
SELECT @BankBalance=BankBalance  FROM speccs.BankBalance 
---SELECT @Transdate=Max(TransactionDate) FROM speccs.BankTransactions ORDER BY TransactionDate IN DESC

UPDATE speccs.BankBalance 
SET BankBalance=@BankBalance-@BAmount WHERE BankName='SBI'
INSERT INTO speccs.BankTransactions (ReceiptNo,TransactionDate,Amount,BankName,BankBalance,PurCode,RefNo,RegTime,UserId)
VALUES (@BTransNo,@BTransactiondate,@BAmount,'SBI',@BankBalance-@BAmount,@Purname,@BrefNo,getDate(),'SH15823')

-------Added Bank Transaction 23-02-2026 END
 
 
 
 	END 
 	
 	----------------------------------------------------------
	INSERT INTO speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@EmpCode,@Loantype,@MemAccNo,'user Loan Released',getdate(),@Ipaddress,@Remarks)
	
	END
	

IF(@Option="PRVLOAN")
BEGIN

IF EXISTS (SELECT * FROM speccs.Loanstatus WHERE MemAccNo = @MemAccNo AND LoanType=@Loantype)

SELECT L.LoanAccNo,L.LoanSanctionAmount,L.LoanSanctionDate,L.LoanStatus  FROM speccs.Loanstatus L WHERE L.MemAccNo=@MemAccNo  AND L.LoanType=@Loantype AND L.LoanStatus='RELEASED'
ELSE
BEGIN
SELECT L.LoanAccNo,L.LoanSanctionAmount,L.LoanSanctionDate,L.LoanStatus  FROM speccs.Loanstatus L WHERE L.MemAccNo=@MemAccNo  
END

END



IF(@Option="PRVLOANCHECK")
BEGIN

IF EXISTS (SELECT * FROM speccs.Loanstatus WHERE MemAccNo = @MemAccNo AND LoanType=@Loantype AND LoanStatus IN('FRESH','SANCTION','RELEASED','SETTLED','RELINITE'))

SELECT L.LoanAccNo,(SELECT LoanSanctionAmount FROM speccs.Loans WHERE MemAccNo = @MemAccNo AND LoanType=@Loantype ) AS LoanSanctionAmount,L.LoanSanctionDate,L.LoanStatus  FROM speccs.Loanstatus L WHERE L.MemAccNo=@MemAccNo AND L.LoanType=@Loantype AND L.LoanStatus IN('FRESH','SANCTION','RELEASED','SETTLED','RELINITE') AND L.FundId=@EmpCode ORDER BY L.RegTime asc 
ELSE
BEGIN
SELECT L.LoanAccNo,(SELECT LoanSanctionAmount FROM speccs.Loans WHERE MemAccNo = @MemAccNo AND LoanType=@Loantype) AS LoanSanctionAmount,L.LoanSanctionDate,L.LoanStatus  FROM speccs.Loanstatus L WHERE L.MemAccNo=@MemAccNo AND L.LoanType=@Loantype
END
END































































GO

