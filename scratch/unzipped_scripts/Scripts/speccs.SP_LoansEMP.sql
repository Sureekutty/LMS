
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

