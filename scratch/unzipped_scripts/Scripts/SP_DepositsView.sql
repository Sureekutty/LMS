IF OBJECT_ID ('speccs.SP_DepositsView') IS NOT NULL
	DROP PROCEDURE speccs.SP_DepositsView
GO

CREATE  PROCEDURE speccs.SP_DepositsView
@Option  		VARCHAR (20),
@Memaccno        VARCHAR (10),
@userid        VARCHAR (10),
@Option3        VARCHAR (20),
@Remarks       VARCHAR(250),
@Ipaddress VARCHAR(30) =NULL

--@ReceiptNo 		varchar(13) output

AS

--DROP PROC speccs.SP_DepositsView
--GRANT Execute ON speccs.SP_DepositsView TO speccsgroup



IF (@Option = 'FRESH')  
BEGIN 
   
SELECT B.MemAccNo,B.MemName,B.Designation,B.Division,B.MemEmpCode,B.AadharNo,B.MailId,B.Phone,B.BankAccNo,
B.IfscCode,B.BankName,B.BasicPay,B.Dob,B.Status ,A.DepositType,convert(CHAR(10),A.OpenDate,103) AS OpenDate,A.Duration,A.IntRate,
A.Subscription,A.MaturityAmount,A.Remarks,A.DepositNo,convert(CHAR(10),A.MaturityDate,103) AS CloseDate,A.Status AS depositstatus
from speccs.Members B   LEFT JOIN speccs.Deposits A
			ON A.MemAccNo = B.MemAccNo WHERE A.Status='REQUEST'

RETURN
END
----ACTIVE----------

IF (@Option = 'ACTIVE')  
BEGIN 
   
SELECT B.MemAccNo,B.MemName,B.Designation,B.Division,B.MemEmpCode,B.AadharNo,B.MailId,B.Phone,B.BankAccNo,
B.IfscCode,B.BankName,B.BasicPay,B.Dob,B.Status ,A.DepositType,convert(CHAR(10),A.OpenDate,103) AS OpenDate,A.Duration,A.IntRate,
A.Subscription,A.MaturityAmount,A.Remarks,A.DepositNo,convert(CHAR(10),A.MaturityDate,103) AS CloseDate,A.Status AS depositstatus
from speccs.Members B   LEFT JOIN speccs.Deposits A
			ON A.MemAccNo = B.MemAccNo WHERE A.Status ='ACTIVE'
	RETURN
END
------COMPLETED--------

IF (@Option = 'REJECTED')  
BEGIN 
   
SELECT B.MemAccNo,B.MemName,B.Designation,B.Division,B.MemEmpCode,B.AadharNo,B.MailId,B.Phone,B.BankAccNo,
B.IfscCode,B.BankName,B.BasicPay,B.Dob,B.Status, A.DepositType,convert(CHAR(10),A.OpenDate,103) AS OpenDate,A.Duration,A.IntRate,
A.Subscription,A.MaturityAmount,A.Remarks,A.DepositNo,convert(CHAR(10),A.CloseDate,103) AS CloseDate,A.Status AS depositstatus
from speccs.Members B  LEFT JOIN speccs.Deposits A
			ON A.MemAccNo = B.MemAccNo WHERE A.Status='REJECTED'
	RETURN
END
------EXPIRING--------

IF (@Option = 'EXPIRING')  
BEGIN 
   DECLARE @DATE DATE
   
   SELECT @DATE=DATEADD(DD,30,getdate())
      
SELECT B.MemAccNo,B.MemName,B.Designation,B.Division,B.MemEmpCode,B.AadharNo,B.MailId,B.Phone,B.BankAccNo,
B.IfscCode,B.BankName,B.BasicPay,B.Dob,B.Status, A.DepositType,convert(CHAR(10),A.OpenDate,103) AS OpenDate,A.Duration,A.IntRate,
A.Subscription,A.MaturityAmount,A.Remarks,A.DepositNo,convert(CHAR(10),A.CloseDate,103) AS CloseDate,A.Status AS depositstatus
from speccs.Members B  LEFT JOIN speccs.Deposits A
			ON A.MemAccNo = B.MemAccNo WHERE A.Status='ACTIVE' AND A.MaturityDate<@DATE
	RETURN
END


IF (@Option = 'UNDER PROCESS')  
BEGIN 


   
   
SELECT B.MemAccNo,B.MemName,B.Designation,B.Division,B.MemEmpCode,B.AadharNo,B.MailId,B.Phone,B.BankAccNo,
B.IfscCode,B.BankName,B.BasicPay,B.Dob,B.Status, A.DepositType,convert(CHAR(10),A.OpenDate,103) AS OpenDate,A.Duration,A.IntRate,
A.Subscription,A.MaturityAmount,A.Remarks,A.DepositNo,convert(CHAR(10),A.CloseDate,103) AS CloseDate,A.Status,
 CASE WHEN A.Status='SCLOSE_INIT' THEN 'Short Closing Processed' 
WHEN A.Status='ADJ_SCLOSE_INIT' THEN 'Short Closing with Loan Adjustment Processed'
WHEN A.Status='CLOSE_INIT' THEN 'Closing Processed'
WHEN A.Status='ADJ_CLOSE_INIT' THEN 'Closing with Loan Adjustment Processed'
ELSE 'NULL' END  AS depositstatus
from speccs.Members B LEFT JOIN speccs.Deposits A
			ON A.MemAccNo = B.MemAccNo WHERE A.Status IN('SCLOSE_INIT','ADJ_SCLOSE_INIT','CLOSE_INIT','ADJ_CLOSE_INIT')
	RETURN
END

IF (@Option = 'CLOSED')  
BEGIN 
   
SELECT B.MemAccNo,B.MemName,B.Designation,B.Division,B.MemEmpCode,B.AadharNo,B.MailId,B.Phone,B.BankAccNo,
B.IfscCode,B.BankName,B.BasicPay,B.Dob,B.Status, A.DepositType,convert(CHAR(10),A.OpenDate,103) AS OpenDate,A.Duration,A.IntRate,
A.Subscription,A.MaturityAmount,A.Remarks,A.DepositNo,convert(CHAR(10),A.CloseDate,103) AS CloseDate,A.Status,
 CASE WHEN A.Status='SCLOSED' THEN 'Short Closed' 
WHEN A.Status='ADJ_SCLOSED' THEN 'Short Closed with Loan Adjustment'
WHEN A.Status='CLOSED' THEN 'Closed'
WHEN A.Status='ADJ_CLOSED' THEN 'Closed with Loan Adjustment'
ELSE 'NULL' END  AS depositstatus
from speccs.Members B  LEFT JOIN speccs.Deposits A
			ON A.MemAccNo = B.MemAccNo WHERE A.Status IN('SCLOSED','ADJ_SCLOSED','CLOSED','ADJ_CLOSED')
	RETURN
END



IF (@Option = 'REJECT')  
BEGIN 
   
UPDATE speccs.Deposits
	SET Status='REJECTED' ,RegTime=getdate(),UserId=@userid,Remarks=@Remarks WHERE DepositNo=@Memaccno

	INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@userid,@Option3,@Memaccno,'Deposit Rejected',getdate(),@Ipaddress,@Remarks)
	RETURN
END

IF (@Option = 'APPROVE')  
BEGIN 

UPDATE speccs.Deposits
	SET Status='ACTIVE' ,RegTime=getdate(),UserId=@userid ,Remarks=@Remarks WHERE DepositNo=@Memaccno
	-----Added on 14-10-2025 for Receipt gen START
	DECLARE @ReceiptNo varchar(13),@Date1 DATE,@purpose varchar(3),@priBal NUMERIC(15,2),@purpose2 varchar(3)
	 IF ((select DepositType from speccs.Deposits where DepositNo=@Memaccno)='RCD' ) 
	 BEGIN
	  SELECT @Date1=OpenDate FROM speccs.Deposits WHERE DepositNo=@Memaccno
	 END
	 ELSE 
	 BEGIN
	 
	  IF ((select DepositType from speccs.Deposits where DepositNo=@Memaccno)='FXD') BEGIN select @purpose='D14' END
    IF ((select DepositType from speccs.Deposits where DepositNo=@Memaccno)='MIS') BEGIN select @purpose='D17' END 
    SELECT @Date1=OpenDate FROM speccs.Deposits WHERE DepositNo=@Memaccno
    SELECT @purpose2=DepositType FROM speccs.Deposits WHERE DepositNo=@Memaccno
    SELECT @priBal=Subscription FROM speccs.Deposits WHERE DepositNo=@Memaccno
	  EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNo output
	  
	  DECLARE @MemDepNo VARCHAR(15)--RThis is Member Account No Added on 08/12/2025 
	  SELECT @MemDepNo= MemAccNo FROM speccs.Deposits WHERE DepositNo=@Memaccno
   INSERT INTO speccs.Receipts(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
   VALUES (@MemDepNo, @ReceiptNo, @Date1, @purpose, @priBal, @purpose2,'',getdate(),'ACTIVE',@Ipaddress,@Memaccno)
   
   

----------------------Bank Transaction 24-02-2026 START
DECLARE @BankBalance FLOAT ,@BTransactiondate DATE,@BTransNo VARCHAR(50),@BAmount FLOAT,@BrefNo VARCHAR(50),@Purname VARCHAR(75)

SELECT @BTransactiondate=@Date1
SELECT @BTransNo=@ReceiptNo
---For receipts+,For payments-
SELECT @BAmount=@priBal
SELECT @BrefNo=@Memaccno
SELECT @Purname=Description FROM speccs.TransactionType WHERE PayCode=@purpose
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


	 END
	 	-----Added on 14-10-2025 for Receipt gen END
	
	
		INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@userid,@Option3,@Memaccno,'Deposit Sanctioned updated',getdate(),@Ipaddress,@Remarks)
	RETURN
END


 IF (@Option='LOANPROCESSINFO') 
	BEGIN
SELECT L.LoanAccNo,L.LoanSanctionAmount,L.LoanStatus
FROM speccs.Loans L WHERE L.MemAccNo=@Memaccno AND L.LoanStatus='RELEASED'


RETURN
END

--changed by pn on 06/06/2025 to get payment number for approval
 IF (@Option='PAYMENTNUMBER') 
	BEGIN
SELECT B.MemAccNo,B.PayVoucherNo,B.Status FROM speccs.Payments B 
 WHERE B.MemAccNo=@Memaccno AND B.RefNo=@Option3 AND B.Status='DRAFT'

RETURN
END


RETURN



GO

