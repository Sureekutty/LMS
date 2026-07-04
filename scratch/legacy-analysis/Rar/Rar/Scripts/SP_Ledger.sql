IF OBJECT_ID ('speccs.SP_Ledger') IS NOT NULL
	DROP PROCEDURE speccs.SP_Ledger
GO

CREATE PROCEDURE speccs.SP_Ledger
    @MemEmpCode  		VARCHAR(10),
    @FromDate     VARCHAR(15) ,   -- MM/dd/yyyy
    @ToDate       VARCHAR(15),   -- MM/dd/yyyy
    @LedgerType   VARCHAR (50)    -- ALL / LTL / EXL / FD / RD
AS
BEGIN


   	DECLARE @MEMCODE VARCHAR(17),@LoanNum VARCHAR(12)
    IF @LedgerType = 'ALL'
    BEGIN
       	  SELECT @MEMCODE=MemAccNo FROM speccs.Members WHERE MemEmpCode=@MemEmpCode  

    END
    ELSE IF (@LedgerType IN  ("LTL","EXL","FDL"))
    BEGIN
        	  -- SELECT @MEMCODE=MemAccNo FROM speccs.Members WHERE MemEmpCode=@MemEmpCode
	      SELECT @LoanNum= LoanAccNo FROM speccs.Loans WHERE MemAccNo=@MemEmpCode AND LoanType=@LedgerType
	   
--CONVERT(VARCHAR(10), TransactionDate, 103) AS Date
--convert(CHAR(10),r.ReceiptDate,103)
--CONVERT(DATE, getDate(), 101)
 SELECT Modeofpay AS Modeofpay,CONVERT(VARCHAR(10), TransactionDate, 103) AS Date,Amount AS Amount ,P_I AS PayCode,ClosingBal AS Balance,CONVERT(VARCHAR(10), RegTime, 103) AS RegTime  FROM speccs.LoanTransactions WHERE LoanAccNo=@LoanNum AND TransactionDate BETWEEN @FromDate AND @ToDate 
ORDER BY TransactionDate


    END
    
    ELSE IF (@LedgerType IN  ("THRIFT"))
    BEGIN
        	  -- SELECT @MEMCODE=MemAccNo FROM speccs.Members WHERE MemEmpCode=@MemEmpCode
	   
--CONVERT(VARCHAR(10), TransactionDate, 103) AS Date
--convert(CHAR(10),r.ReceiptDate,103)
--CONVERT(DATE, getDate(), 101)
 SELECT ModeOfPayment AS Modeofpay,CONVERT(VARCHAR(10), TransactionDate, 103) AS Date,Amount AS Amount ,ReceiptNo AS PayCode,ThriftBalance AS Balance,CONVERT(VARCHAR(10), RegTime, 103) AS RegTime  FROM speccs.ThriftTransactions WHERE MemAccNo=@MemEmpCode AND TransactionDate BETWEEN @FromDate AND @ToDate 
ORDER BY TransactionDate


    END
    ELSE IF (@LedgerType IN  ("FD"))
    BEGIN
        	  -- SELECT @MEMCODE=MemAccNo FROM speccs.Members WHERE MemEmpCode=@MemEmpCode
	   
--CONVERT(VARCHAR(10), TransactionDate, 103) AS Date
--convert(CHAR(10),r.ReceiptDate,103)
--CONVERT(DATE, getDate(), 101)
 SELECT DepositType AS Modeofpay,CONVERT(VARCHAR(10), OpenDate, 103) AS Date,Subscription AS Amount ,DepositNo AS PayCode,MaturityAmount AS Balance,CONVERT(VARCHAR(10), RegTime, 103) AS RegTime  FROM speccs.Deposits WHERE MemAccNo=@MemEmpCode AND DepositType='FXD' AND OpenDate BETWEEN @FromDate AND @ToDate 
ORDER BY OpenDate


    END
     ELSE IF (@LedgerType IN  ("RD"))
    BEGIN
        	  -- SELECT @MEMCODE=MemAccNo FROM speccs.Members WHERE MemEmpCode=@MemEmpCode
	   
--CONVERT(VARCHAR(10), TransactionDate, 103) AS Date
--convert(CHAR(10),r.ReceiptDate,103)
--CONVERT(DATE, getDate(), 101)
 SELECT DepositType AS Modeofpay,CONVERT(VARCHAR(10), OpenDate, 103) AS Date,Subscription AS Amount ,DepositNo AS PayCode,MaturityAmount AS Balance,CONVERT(VARCHAR(10), RegTime, 103) AS RegTime  FROM speccs.Deposits WHERE MemAccNo=@MemEmpCode AND DepositType='RCD' AND OpenDate BETWEEN @FromDate AND @ToDate 
ORDER BY OpenDate


    END
    
    
    
 
   
END

GO

