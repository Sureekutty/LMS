IF OBJECT_ID ('speccs.SP_LoansEMP') IS NOT NULL
	DROP PROCEDURE speccs.SP_LoansEMP
GO

CREATE  PROCEDURE speccs.SP_LoansEMP



@Option  	   		VARCHAR (20),
@MemAccNo    		VARCHAR(7)= NULL, 
@Loanaccno 	   		VARCHAR(8)= NULL, 
@loantype 			VARCHAR(4)= NULL,
@loanpurpose 		VARCHAR(50)= NULL,
@Noofinstall 		INT= NULL,
@Monthlyinstall 	INT= NULL,
@Thriftdudamt 		INT= NULL,
@ChequeAmount       INT = NULL,
@Fundid     		VARCHAR(12)= NULL,
@loansancamt        INT=NULL,
@loansancdate 		VARCHAR(10)= NULL,
@Interestrate       NUMERIC(13,2)=NULL, --change by pn on 229/01/2023
@userid	 			VARCHAR(7)= NULL,
@Remarks            VARCHAR(200)=NULL,
@Ipaddress          VARCHAR(30)= NULL,
@LoanNoNew			VARCHAR(7) =null output

AS

/*
	DROP PROCEDURE  speccs.SP_Loans
	
	GRANT ALL ON speccs.SP_Loans to speccsgroup
*/
	IF (@Option="SAVE") 
	BEGIN
		DECLARE @ltlLoanNo VARCHAR(12)
		DECLARE @surety1 VARCHAR(12)
		DECLARE @surety2 VARCHAR(12)
		DECLARE @surety3 VARCHAR(12)
		
		SELECT  @surety1=Surety1,@surety2=Surety2,@surety3=Surety3 FROM Loanstatus WHERE LoanAccNo=@Loanaccno
	IF(@loantype="EXL")
	BEGIN
	
   
	
		IF EXISTS ( SELECT * FROM speccs.Loanstatus WHERE MemAccNo=@MemAccNo AND (LoanStatus='RELEASED' OR LoanStatus='REJECT') AND LoanType='EXL' )
		BEGIN 
		
		
		
		SELECT TOP 1 @ltlLoanNo=LoanAccNo FROM speccs.Loanstatus WHERE MemAccNo=@MemAccNo AND (LoanStatus='RELEASED' OR LoanStatus='REJECT') AND LoanType='EXL' ORDER BY RegTime DESC
		UPDATE  speccs.Loanstatus SET MemAccNo=@MemAccNo,LoanAccNo=@ltlLoanNo,LoanType=@loantype,LoanPurpose=@loanpurpose,NoOfInstallments=@Noofinstall,
		MonthlyInstallments=@Monthlyinstall,Thriftdudamt=@Thriftdudamt,ChequeAmount=@ChequeAmount,LoanStatus='FRESH',FundId=@Fundid,
		LoanSanctionAmount=@loansancamt,InterestRate=@Interestrate,
		Loanappdate=@loansancdate,Remarks=@Remarks,UserId=@userid,RegTime=GETDATE() WHERE LoanAccNo=@ltlLoanNo AND 
		(LoanStatus='RELEASED' OR LoanStatus='REJECT')

	
		--EXEC speccs.SP_Surety  'SAVE',@MemAccNo,@LoanNoNew,0,@surety1,@surety2,@surety3,'Y',null,@userid

		INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
		VALUES(@userid,@LoanNoNew,@MemAccNo,'user Loan Saved',getdate(),@Ipaddress,@Remarks)
	   
	RETURN
	END	--end	
	
		EXEC  speccs.SP_AutoNumber 'EXL',NULL ,@LoanNoNew output
		
		
	
				--EXEC  speccs.SP_AutoNumber 'LOANAPPNO',NULL ,@LoanNoNew output
INSERT INTO speccs.Loanstatus(MemAccNo,LoanAccNo,LoanType,LoanPurpose,NoOfInstallments,MonthlyInstallments,Thriftdudamt,ChequeAmount,LoanStatus,FundId,LoanSanctionAmount,InterestRate,Surety1,Surety2,Surety3,Loanappdate,Remarks,UserId,RegTime)
VALUES (@MemAccNo,@LoanNoNew,@loantype,@loanpurpose,@Noofinstall,@Monthlyinstall,@Thriftdudamt,@ChequeAmount,'FRESH',@Fundid,@loansancamt,@Interestrate,@surety1,@surety2,@surety3,@loansancdate,@Remarks,@userid,getdate())

INSERT INTO speccs.Loans(MemAccNo,LoanAccNo,LoanType,LoanPurpose,NoOfInstallments,MonthlyInstallments,Thriftdudamt,ChequeAmount,LoanStatus,FundId,LoanSanctionAmount,InterestRate,Surety1,Surety2,Surety3,Loanappdate,Remarks,UserId,RegTime)
VALUES (@MemAccNo,@LoanNoNew,@loantype,@loanpurpose,@Noofinstall,@Monthlyinstall,@Thriftdudamt,@ChequeAmount,'FRESH',@Fundid,@loansancamt,@Interestrate,@surety1,@surety2,@surety3,@loansancdate,@Remarks,@userid,getdate())

INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@userid,@LoanNoNew,@MemAccNo,'user Loan Saved',getdate(),@Ipaddress,@Remarks)
	

END
ELSE IF(@loantype="LTL")
 BEGIN
 		DECLARE @receiptPayNo VARCHAR(14)
--added by pn on 14/05/2025 told by Rama rao to validate if already loan account is there and no settlement rule for previous account
	
	IF EXISTS ( SELECT * FROM speccs.Loanstatus WHERE MemAccNo=@MemAccNo AND (LoanStatus='RELEASED' OR LoanStatus='REJECT') AND LoanType='LTL' )
	BEGIN 
		
		SELECT TOP 1 @ltlLoanNo=LoanAccNo FROM speccs.Loanstatus WHERE MemAccNo=@MemAccNo AND (LoanStatus='RELEASED' OR LoanStatus='REJECT') AND LoanType='LTL' ORDER BY RegTime DESC
		
		UPDATE  speccs.Loanstatus SET LoanType=@loantype,LoanPurpose=@loanpurpose,NoOfInstallments=@Noofinstall,
		MonthlyInstallments=@Monthlyinstall,Thriftdudamt=@Thriftdudamt,ChequeAmount=@ChequeAmount,LoanStatus='FRESH',FundId=@Fundid,
		LoanSanctionAmount=@loansancamt,InterestRate=@Interestrate,
		Loanappdate=@loansancdate,Remarks=@Remarks,UserId=@userid,RegTime=GETDATE() WHERE LoanAccNo=@ltlLoanNo AND 
		(LoanStatus='RELEASED' OR LoanStatus='REJECT')
	--for thrift if deducted
	DECLARE @thrftAmnt NUMERIC(15,2)
	IF(@Thriftdudamt>0)
		begin
	  
		EXEC speccs.SP_Receipts  'SAVE',@MemAccNo,@loansancdate,"M45",@Thriftdudamt,"Thrift For Loan",@MemAccNo,@userid,null,'SUBMIT',@Remarks,@receiptPayNo output
		/*
		UPDATE speccs.MemberAccount 
		SET ThriftBalance=ThriftBalance+@Thriftdudamt
		WHERE MemAccNo=@MemAccNo
	
	
		SELECT @thrftAmnt=ThriftBalance FROM speccs.MemberAccount WHERE MemAccNo=@MemAccNo
		INSERT INTO speccs.ThriftTransactions
		(MemAccNo,Month,TransactionDate,ModeOfPayment,Amount,ReceiptNo,UserId,RegTime,ThriftBalance)
		VALUES  (@MemAccNo,convert(VARCHAR(8),datepart(mm,@loansancdate)),@loansancdate,'Loan Disburse',@Thriftdudamt, @receiptPayNo,@userid,getdate(),@thrftAmnt)
		*/
		END		-- thrift end
		
		EXEC speccs.SP_Surety  'SAVE',@MemAccNo,@LoanNoNew,0,@surety1,@surety2,@surety3,'Y',null,@userid

		INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
		VALUES(@userid,@LoanNoNew,@MemAccNo,'user Loan Saved',getdate(),@Ipaddress,@Remarks)
		
	RETURN
	END	--end
	
 	
		EXEC  speccs.SP_AutoNumber 'LTL',NULL ,@LoanNoNew output
		--EXEC  speccs.SP_AutoNumber 'LOANAPPNO',NULL ,@LoanNoNew output
		INSERT INTO speccs.Loans(MemAccNo,LoanAccNo,LoanType,LoanPurpose,NoOfInstallments,MonthlyInstallments,Thriftdudamt,ChequeAmount,LoanStatus,FundId,LoanSanctionAmount,InterestRate,LoanSanctionDate,Surety1,Surety2,Surety3,Loanappdate,Remarks,UserId,RegTime)
	    VALUES (@MemAccNo,@LoanNoNew,@loantype,@loanpurpose,@Noofinstall,@Monthlyinstall,@Thriftdudamt,@ChequeAmount,'FRESH',@Fundid,@loansancamt,@Interestrate,getdate(),@surety1,@surety2,@surety3,@loansancdate,@Remarks,@userid,getdate())
	
  		INSERT INTO speccs.Loanstatus(MemAccNo,LoanAccNo,LoanType,LoanPurpose,NoOfInstallments,MonthlyInstallments,Thriftdudamt,ChequeAmount,LoanStatus,FundId,LoanSanctionAmount,InterestRate,LoanSanctionDate,Surety1,Surety2,Surety3,Loanappdate,Remarks,UserId,RegTime)
	    VALUES (@MemAccNo,@LoanNoNew,@loantype,@loanpurpose,@Noofinstall,@Monthlyinstall,@Thriftdudamt,@ChequeAmount,'FRESH',@Fundid,@loansancamt,@Interestrate,getdate(),@surety1,@surety2,@surety3,@loansancdate,@Remarks,@userid,getdate())
	
		--for thrift if deducted added by pn on 15/07/2024 
		IF(@Thriftdudamt>0)
		begin
		EXEC speccs.SP_Receipts  'SAVE',@MemAccNo,@loansancdate,"M45",@Thriftdudamt,"Thrift For Loan",@MemAccNo,@userid,null,'SUBMIT',@Remarks,@receiptPayNo output
	   /*	
		UPDATE speccs.MemberAccount 
		SET ThriftBalance=ThriftBalance+@Thriftdudamt
		WHERE MemAccNo=@MemAccNo
			
		SELECT @thrftAmnt=ThriftBalance FROM speccs.MemberAccount WHERE MemAccNo=@MemAccNo
		INSERT INTO speccs.ThriftTransactions
		(MemAccNo,Month,TransactionDate,ModeOfPayment,Amount,ReceiptNo,UserId,RegTime,ThriftBalance)
		VALUES  (@MemAccNo,convert(VARCHAR(8),datepart(mm,@loansancdate)),@loansancdate,'Loan Disburse',@Thriftdudamt, @receiptPayNo,@userid,getdate(),@thrftAmnt)
		*/
		END		--thrift end
		--added by pn on 10/09/2024 for surety table
		EXEC speccs.SP_Surety  'SAVE',@MemAccNo,@LoanNoNew,0,@surety1,@surety2,@surety3,'Y',null,@userid
		
		INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	    VALUES(@userid,@LoanNoNew,@MemAccNo,'user Loan Saved',getdate(),@Ipaddress,@Remarks)
 END
ELSE IF(@loantype="FDL")
			BEGIN
		EXEC  speccs.SP_AutoNumber 'FDL',NULL ,@LoanNoNew output
		
		
	
				--EXEC  speccs.SP_AutoNumber 'LOANAPPNO',NULL ,@LoanNoNew output
INSERT INTO speccs.Loanstatus(MemAccNo,LoanAccNo,LoanType,LoanPurpose,NoOfInstallments,MonthlyInstallments,Thriftdudamt,ChequeAmount,LoanStatus,FundId,LoanSanctionAmount,InterestRate,Surety1,Surety2,Surety3,Loanappdate,Remarks,UserId,RegTime)
VALUES (@MemAccNo,@LoanNoNew,@loantype,@loanpurpose,@Noofinstall,@Monthlyinstall,@Thriftdudamt,@ChequeAmount,'FRESH',@Fundid,@loansancamt,@Interestrate,@surety1,@surety2,@surety3,@loansancdate,@Remarks,@userid,getdate())

INSERT INTO speccs.Loans(MemAccNo,LoanAccNo,LoanType,LoanPurpose,NoOfInstallments,MonthlyInstallments,Thriftdudamt,ChequeAmount,LoanStatus,FundId,LoanSanctionAmount,InterestRate,Surety1,Surety2,Surety3,Loanappdate,Remarks,UserId,RegTime)
VALUES (@MemAccNo,@LoanNoNew,@loantype,@loanpurpose,@Noofinstall,@Monthlyinstall,@Thriftdudamt,@ChequeAmount,'FRESH',@Fundid,@loansancamt,@Interestrate,@surety1,@surety2,@surety3,@loansancdate,@Remarks,@userid,getdate())
END

	INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@userid,@LoanNoNew,@MemAccNo,'user Loan Saved',getdate(),@Ipaddress,@Remarks)




   	IF(@@ERROR!=0)
			BEGIN
				RAISERROR 99999 "Error while saving in Appln :SP_Loans "
				ROLLBACK TRANSACTION
				RETURN
	END
	 
	END --if (option=new) 
   	
	
   	IF (@Option="UPDATE") 
	BEGIN
	
	IF(@loantype="EXL")
	BEGIN
		
UPDATE  speccs.Loanstatus SET MemAccNo=@MemAccNo,LoanAccNo=@Loanaccno,LoanType=@loantype,LoanPurpose=@loanpurpose,NoOfInstallments=@Noofinstall,

MonthlyInstallments=@Monthlyinstall,Thriftdudamt=@Thriftdudamt,ChequeAmount=@ChequeAmount,LoanStatus='FRESH',FundId=@Fundid,
LoanSanctionAmount=@loansancamt,InterestRate=@Interestrate,
Loanappdate=@loansancdate,Remarks=@Remarks,UserId=@userid,RegTime=GETDATE() WHERE LoanAccNo=@Loanaccno

UPDATE  speccs.Loans SET MemAccNo=@MemAccNo,LoanAccNo=@Loanaccno,LoanType=@loantype,LoanPurpose=@loanpurpose,NoOfInstallments=@Noofinstall,

MonthlyInstallments=@Monthlyinstall,Thriftdudamt=@Thriftdudamt,ChequeAmount=@ChequeAmount,FundId=@Fundid,
InterestRate=@Interestrate,
Loanappdate=@loansancdate,Remarks=@Remarks,UserId=@userid,RegTime=GETDATE() WHERE LoanAccNo=@Loanaccno

INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@userid,@Loanaccno,@MemAccNo,'user Loan Updated',getdate(),@Ipaddress,@Remarks)

END
ELSE IF(@loantype="LTL")
			BEGIN
UPDATE  speccs.Loanstatus SET MemAccNo=@MemAccNo,LoanAccNo=@Loanaccno,LoanType=@loantype,LoanPurpose=@loanpurpose,NoOfInstallments=@Noofinstall,
MonthlyInstallments=@Monthlyinstall,Thriftdudamt=@Thriftdudamt,ChequeAmount=@ChequeAmount,LoanStatus='FRESH',FundId=@Fundid,
LoanSanctionAmount=@loansancamt,InterestRate=@Interestrate,
Loanappdate=@loansancdate,Remarks=@Remarks,UserId=@userid,RegTime=GETDATE() WHERE LoanAccNo=@Loanaccno	


UPDATE  speccs.Loans SET MemAccNo=@MemAccNo,LoanAccNo=@Loanaccno,LoanType=@loantype,LoanPurpose=@loanpurpose,NoOfInstallments=@Noofinstall,
MonthlyInstallments=@Monthlyinstall,Thriftdudamt=@Thriftdudamt,ChequeAmount=@ChequeAmount,FundId=@Fundid,
InterestRate=@Interestrate,
Loanappdate=@loansancdate,Remarks=@Remarks,UserId=@userid,RegTime=GETDATE() WHERE LoanAccNo=@Loanaccno	



INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@userid,@Loanaccno,@MemAccNo,'user Loan Updated',getdate(),@Ipaddress,@Remarks)
END
ELSE IF(@loantype="FDL")
			BEGIN
	UPDATE  speccs.Loanstatus SET MemAccNo=@MemAccNo,LoanAccNo=@Loanaccno,LoanType=@loantype,LoanPurpose=@loanpurpose,NoOfInstallments=@Noofinstall,
MonthlyInstallments=@Monthlyinstall,Thriftdudamt=@Thriftdudamt,ChequeAmount=@ChequeAmount,LoanStatus='FRESH',FundId=@Fundid,
LoanSanctionAmount=@loansancamt,InterestRate=@Interestrate,
Loanappdate=@loansancdate,Remarks=@Remarks,UserId=@userid,RegTime=GETDATE() WHERE LoanAccNo=@Loanaccno

	UPDATE  speccs.Loans SET MemAccNo=@MemAccNo,LoanAccNo=@Loanaccno,LoanType=@loantype,LoanPurpose=@loanpurpose,NoOfInstallments=@Noofinstall,
MonthlyInstallments=@Monthlyinstall,Thriftdudamt=@Thriftdudamt,ChequeAmount=@ChequeAmount,FundId=@Fundid,
InterestRate=@Interestrate,
Loanappdate=@loansancdate,Remarks=@Remarks,UserId=@userid,RegTime=GETDATE() WHERE LoanAccNo=@Loanaccno


END

	


INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@userid,@Loanaccno,@MemAccNo,'user Loan Updated',getdate(),@Ipaddress,@Remarks)



   	IF(@@ERROR!=0)
			BEGIN
				RAISERROR 99999 "Error while updating in Appln :SP_Loans "
				ROLLBACK TRANSACTION
				RETURN
	END
	 
	END


	IF (@Option="GETLOANINFO") 
	BEGIN
	SELECT L.MemAccNo,L.LoanAccNo,L.LoanType,L.LoanPurpose,L.NoOfInstallments,
	L.MonthlyInstallments,L.Thriftdudamt,L.FundId,L.LoanSanctionAmount,L.InterestMethod,
	L.InterestRate,L.LoanSanctionDate,L.Surety1,L.Surety2,L.Surety3,L.Loanappdate,
	L.Loanrejecteddate,M.BasicPay,A.NoOfShares,A.ShareAmount,A.ThriftBalance, L.Remarks FROM speccs.Loanstatus L 
	LEFT JOIN speccs.Members M ON L.MemAccNo=M.MemAccNo  
	LEFT JOIN speccs.MemberAccount A ON A.MemAccNo=M.MemAccNo  WHERE L.LoanAccNo=@Loanaccno
	RETURN
	END


	IF (@Option="GETLTLINFO") 
	BEGIN
	SELECT MemAccNo FROM speccs.Members WHERE MemEmpCode=@MemAccNo
	/* Adaptive Server has expanded all '*' elements in the following statement */ SELECT speccs.LoanTransactions.LoanAccNo, speccs.LoanTransactions.TransactionDate, speccs.LoanTransactions.PayCode, speccs.LoanTransactions.Amount, speccs.LoanTransactions.P_I, speccs.LoanTransactions.ReceiptNo, speccs.LoanTransactions.Modeofpay, speccs.LoanTransactions.ClosingBal, speccs.LoanTransactions.RegTime, speccs.LoanTransactions.UserId FROM speccs.LoanTransactions WHERE LoanAccNo IN (SELECT LoanAccNo FROM speccs.Loanstatus WHERE MemAccNo=MemAccNo)
	RETURN
	END



























GO

