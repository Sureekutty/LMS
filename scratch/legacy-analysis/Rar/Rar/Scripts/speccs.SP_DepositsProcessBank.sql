
IF OBJECT_ID ('speccs.SP_DepositsProcessBank') IS NOT NULL
	DROP PROCEDURE speccs.SP_DepositsProcessBank
GO

CREATE  PROCEDURE speccs.SP_DepositsProcessBank
@Option  		 VARCHAR (20),
@processmonth DATE,
@Paynonew VARCHAR(50),
@IntAmount FLOAT,
@MisCodeExists VARCHAR(50),
@Pname VARCHAR(75)



--@ReceiptNo 		varchar(13) output

AS

--DROP PROC speccs.SP_DepositsProcess
--GRANT Execute ON speccs.SP_DepositsProcess TO speccsgroup

DECLARE @approvalstatus VARCHAR(40)

    
declare @purpose varchar(3)
declare @svalue numeric(10,2)
DECLARE @months INT , @openDate DATE, @svalue2 numeric(10,2)


					
    /*	 -------Added Bank Transaction 23-02-2026 START

DECLARE @BankBalance FLOAT ,@BTransactiondate DATE,@BTransNo VARCHAR(50),@BAmount FLOAT,@BrefNo VARCHAR(50),@Purname VARCHAR(75)
SELECT @BTransactiondate=@processmonth
SELECT @BTransNo=@Paynonew
---For receipts+,For payments-

SELECT @BrefNo=@MisCodeExists
SELECT @BAmount= @IntAmount

SELECT @Purname=Description FROM speccs.TransactionType WHERE PayCode='D19' 
SELECT @BankBalance=BankBalance  FROM speccs.BankBalance 
---SELECT @Transdate=Max(TransactionDate) FROM speccs.BankTransactions ORDER BY TransactionDate IN DESC

UPDATE speccs.BankBalance 
SET BankBalance=@BankBalance-@BAmount WHERE BankName='SBI'
INSERT INTO speccs.BankTransactions (ReceiptNo,TransactionDate,Amount,BankName,BankBalance,PurCode,RefNo,RegTime,UserId)
VALUES (@BTransNo,@BTransactiondate,@BAmount,'SBI',@BankBalance-@BAmount,@Purname,@BrefNo,getDate(),'SH15823')

-------Added Bank Transaction 23-02-2026 END */

IF (@Option ='Bank')
BEGIN 
----------------------Bank Transaction 24-02-2026 START
DECLARE @BankBalance FLOAT ,@BTransactiondate DATE,@BTransNo VARCHAR(50),@BAmount FLOAT,@BrefNo VARCHAR(50),@Purname VARCHAR(75)

SELECT @BTransactiondate=@processmonth
SELECT @BTransNo=@Paynonew
---For receipts+,For payments-
SELECT @BAmount=@IntAmount
SELECT @BrefNo=@MisCodeExists
SELECT @Purname=@Pname
--Description FROM speccs.TransactionType WHERE PayCode='D19'
SELECT @BankBalance=BankBalance  FROM speccs.BankBalance 



   DECLARE @BmaxTranDate DATE
    
    SELECT @BmaxTranDate = MAX(TransactionDate) 
    FROM speccs.BankTransactions
    
     IF (@BTransactiondate < @BmaxTranDate)
    BEGIN
    	 SELECT ReceiptNo, TransactionDate, Amount, BankBalance, PurCode, 
            RefNo, RegTime, UserId 
        INTO #tempB9 
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
                
                 WHILE EXISTS (SELECT 1 FROM #tempB9)
       			 BEGIN
                SELECT TOP 1 
                @CurrentReceiptNo       = ReceiptNo,
                @CurrentAmount          = Amount,
                @CurrentPurCode         = PurCode,
                @CurrentRefNo           = RefNo,
                @CurrentBBalance=BankBalance,
                @CurrentTransactionDate = TransactionDate,
                @CurrentRegTime         = RegTime
            	 FROM #tempB9 
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
            DELETE FROM #tempB9 
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










GO

