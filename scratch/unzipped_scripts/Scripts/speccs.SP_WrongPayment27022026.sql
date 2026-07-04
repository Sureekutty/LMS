
IF OBJECT_ID ('speccs.SP_WrongPayment27022026') IS NOT NULL
	DROP PROCEDURE speccs.SP_WrongPayment27022026
GO

CREATE PROCEDURE speccs.SP_WrongPayment27022026
    @MemAccNo VARCHAR(5),        -- Member account number
    @PayDate DATETIME,           -- Expects MM/DD/YYYY format from controller
    @Amount NUMERIC(15,2),       -- Payment amount
    @ChequeNo VARCHAR(50),       -- Cheque number
    @Remarks VARCHAR(200),       -- Payment remarks
    @UserId VARCHAR(50),         -- User ID from session
    @IpAddress VARCHAR(50)       -- IP address of the client
    
AS
BEGIN
    -- CHANGED: Declare variables for PurposeCode, PaymentNo, and Member check
    DECLARE @PurposeCode VARCHAR(5),
    @PaymentNo	VARCHAR(14) 
    DECLARE @V_MemAccNo VARCHAR(20)

    -- CHANGED: Initialize PurposeCode using SELECT for old Sybase compatibility
    SELECT @PurposeCode = 'P34'  -- Hardcode PurposeCode to M46

    -- CHANGED: Check if member exists and is active in Members21082025
    SELECT @V_MemAccNo = MemAccNo
    FROM speccs.Members
    WHERE MemAccNo = @MemAccNo AND Status = 'ACTIVE'

    -- CHANGED: Proceed with inserts if member is valid
    IF @V_MemAccNo IS NOT NULL 
    BEGIN 
        -- CHANGED: Generate unique PaymentNo using SP_AutoNumber
        EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@PaymentNo output
        
       ---------------------Bank Transaction 24-02-2026 START
DECLARE @BankBalance FLOAT ,@BTransactiondate DATE,@BTransNo VARCHAR(50),@BAmount FLOAT,@BrefNo VARCHAR(50),@Purname VARCHAR(75)

SELECT @BTransactiondate=@PayDate
SELECT @BTransNo=@PaymentNo
---For receipts+,For payments-
SELECT @BAmount=-@Amount
SELECT @BrefNo=@MemAccNo
SELECT @Purname=Description FROM speccs.TransactionType WHERE PayCode='P34'
SELECT @BankBalance=BankBalance  FROM speccs.BankBalance 



    DECLARE @BmaxTranDate DATE
    
    SELECT @BmaxTranDate = MAX(TransactionDate) 
    FROM speccs.BankTransactions
    
     IF (@BTransactiondate < @BmaxTranDate)
    BEGIN
    	 SELECT ReceiptNo, TransactionDate, Amount, BankBalance, PurCode, 
            RefNo, RegTime, UserId 
        INTO #tempB13 
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
                
             
                 WHILE EXISTS (SELECT 1 FROM #tempB13)
       			 BEGIN
                SELECT TOP 1 
                @CurrentReceiptNo       = ReceiptNo,
                @CurrentAmount          = Amount,
                @CurrentPurCode         = PurCode,
                @CurrentRefNo           = RefNo,
                @CurrentBBalance=BankBalance,
                @CurrentTransactionDate = TransactionDate,
                @CurrentRegTime         = RegTime
            	 FROM #tempB13 
           		 ORDER BY TransactionDate ASC, RegTime ASC
                
               /* IF (LEFT(@CurrentReceiptNo,1) = 'R')
                BEGIN SELECT  @CurrentBalance = - @CurrentAmount
                END
            	ELSE
            	BEGIN
                SELECT  @CurrentBalance = @CurrentAmount
            	END */
            	
            	
            UPDATE speccs.BankTransactions
            SET BankBalance =@CurrentBBalance + @BAmount
            WHERE ReceiptNo = @CurrentReceiptNo
            
        -- RefNo = @CurrentRefNo 
                
            -- Remove processed row from temp table
            DELETE FROM #tempB13 
            WHERE RefNo = @CurrentRefNo 
              AND ReceiptNo = @CurrentReceiptNo
              
          DROP TABLE #tempB13
              
             
              
              
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




        -- CHANGED: Insert payment details into Payments21082025 with PayDate as DATETIME
        INSERT INTO speccs.Payments 
            (MemAccNo, PayVoucherNo, VoucherDate, PurposeCode, Amount, ModeOfPayment, Status, RefNo, Remarks, UserId, RegTime)
        VALUES 
            (@V_MemAccNo, @PaymentNo, @PayDate, @PurposeCode, @Amount, 'CHEQUE', 'ACTIVE', @ChequeNo, @Remarks, @UserId, GETDATE())
  INSERT INTO speccs.WrongPayment
            (MemAccNo, PurposeCode, PayDate, Amount, ChequeNo, Remarks, PaymentNo)
        VALUES
            (@V_MemAccNo, @PurposeCode, CONVERT(VARCHAR(10), @PayDate, 103), @Amount, @ChequeNo, @Remarks, @PaymentNo)
        -- CHANGED: Insert into speccs.WrongPayment, converting PayDate to VARCHAR(10) as DD/MM/YYYY
  /*       -------Added Bank Transaction 23-02-2026 START

DECLARE @BankBalance FLOAT ,@BTransactiondate DATE,@BTransNo VARCHAR(50),@BAmount FLOAT,@BrefNo VARCHAR(50),@Purname VARCHAR(75)
SELECT @BTransactiondate=@PayDate
SELECT @BTransNo=@PaymentNo
---For receipts+,For payments-

SELECT @BrefNo=@V_MemAccNo
SELECT @BAmount= @Amount

SELECT @Purname=Description FROM speccs.TransactionType WHERE PayCode=@PurposeCode 
SELECT @BankBalance=BankBalance  FROM speccs.BankBalance 
---SELECT @Transdate=Max(TransactionDate) FROM speccs.BankTransactions ORDER BY TransactionDate IN DESC

UPDATE speccs.BankBalance 
SET BankBalance=@BankBalance-@BAmount WHERE BankName='SBI'
INSERT INTO speccs.BankTransactions (ReceiptNo,TransactionDate,Amount,BankName,BankBalance,PurCode,RefNo,RegTime,UserId)
VALUES (@BTransNo,@BTransactiondate,@BAmount,'SBI',@BankBalance-@BAmount,@Purname,@BrefNo,getDate(),'SH15823')

-------Added Bank Transaction 23-02-2026 END    */


        
      
    END
END






GO

