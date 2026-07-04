
IF OBJECT_ID ('speccs.SP_Ledger') IS NOT NULL
	DROP PROCEDURE speccs.SP_Ledger
GO

CREATE PROCEDURE speccs.SP_Ledger
@EmpCode VARCHAR(7) ,
@Fromdate VARCHAR(14),
@Todate VARCHAR(14),
--@Option  	VARCHAR (20),
@Loantype  	VARCHAR (7)

/*
GRANT ALL ON speccs.SP_getReferenceDetails TO speccs
DROP PROC SP_getReferenceDetails
speccs.SP_getReferenceDetails '00002','D20'
*/


AS 


BEGIN 
DECLARE @MEMCODE VARCHAR(10),@LoanNum VARCHAR(12)



	IF (@Loantype="%") 
	BEGIN
	  SELECT @MEMCODE=MemAccNo FROM speccs.Members WHERE MemEmpCode=@EmpCode  
	RETURN
	END	


	ELSE IF (@Loantype="LTL Loan") 
	BEGIN
	   SELECT @MEMCODE=MemAccNo FROM speccs.Members WHERE MemEmpCode=@EmpCode
	      SELECT @LoanNum= LoanAccNo FROM speccs.Loans WHERE MemAccNo=@MEMCODE AND LoanType='LTL'
	   

 SELECT TxnId AS SNo,TransactionDate AS Date,Amount AS Amount ,P_I AS PayCode,ClosingBal AS Balance,TransactionDate AS RegTime  FROM speccs.LoanTransactions WHERE LoanAccNo=@LoanNum AND TransactionDate BETWEEN @Fromdate AND @Todate 
	END	



END

GO


