IF OBJECT_ID ('speccs.SP_MemberSettlement') IS NOT NULL
	DROP PROCEDURE speccs.SP_MemberSettlement
GO

CREATE PROCEDURE speccs.SP_MemberSettlement
@option VARCHAR(12),
@memaccno VARCHAR(10),
@settlementDate VARCHAR(10),
@remarks VARCHAR(100),
@userID VARCHAR(10),
@settlementAmount INT,
@receiptPayNo VARCHAR(14) output

as
/*
drop proc speccs.SP_MemberSettlement
	GRANT ALL ON speccs.SP_MemberSettlement to speccsgroup
*/

IF(@option='PROCESS')
BEGIN 
DECLARE @purposecode VARCHAR(4)
-- if deposits available start
IF(len(@remarks)>1)
BEGIN 
DECLARE @start INT, @end INT, @len INT, @depNo VARCHAR(100)

    SET @remarks = @remarks + ','  -- add trailing comma to simplify logic
    SET @start = 1
    SET @len = LEN(@remarks)

    WHILE @start < @len
    BEGIN
        SET @end = CHARINDEX(',', @remarks, @start)
        IF @end = 0
            SET @end = @len + 1

        SET @depNo = LTRIM(RTRIM(SUBSTRING(@remarks, @start, @end - @start)))

        IF @depNo <> ''
        IF(substring(@depNo,1,2)='FD') BEGIN  SELECT @purposecode='D15' END
       	IF(substring(@depNo,1,2)='RD') BEGIN  SELECT @purposecode='D21' END
        EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@receiptPayNo output
	    DECLARE @depositBal NUMERIC(15,2)
		SELECT @depositBal = SettlementAmount FROM speccs.Deposits WHERE DepositNo=@depNo
		INSERT INTO speccs.Payments
		VALUES(@memaccno,@receiptPayNo,@settlementDate,@purposecode,@depositBal,'CHEQUE','ACTIVE',@depNo,"Deposits Settlement",@userID,GETDATE())
		-----------
		----------------------Bank Transaction 24-02-2026 START
DECLARE @BankBalance FLOAT ,@BTransactiondate DATE,@BTransNo VARCHAR(50),@BAmount FLOAT,@BrefNo VARCHAR(50),@Purname VARCHAR(75)

SELECT @BTransactiondate=@settlementDate
SELECT @BTransNo=@receiptPayNo
---For receipts+,For payments-
SELECT @BAmount=-@depositBal
SELECT @BrefNo=@depNo
SELECT @Purname=Description FROM speccs.TransactionType WHERE PayCode=@purposecode
SELECT @BankBalance=BankBalance  FROM speccs.BankBalance 



    DECLARE @BmaxTranDate DATE
    
    SELECT @BmaxTranDate = MAX(TransactionDate) 
    FROM speccs.BankTransactions
    
     IF (@BTransactiondate < @BmaxTranDate)
    BEGIN
    	 SELECT ReceiptNo, TransactionDate, Amount, BankBalance, PurCode, 
            RefNo, RegTime, UserId 
        INTO #tempB14
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
                
                 WHILE EXISTS (SELECT 1 FROM #tempB14)
       			 BEGIN
                SELECT TOP 1 
                @CurrentReceiptNo       = ReceiptNo,
                @CurrentAmount          = Amount,
                @CurrentPurCode         = PurCode,
                @CurrentRefNo           = RefNo,
                @CurrentBBalance=BankBalance,
                @CurrentTransactionDate = TransactionDate,
                @CurrentRegTime         = RegTime
            	 FROM #tempB14 
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
            DELETE FROM #tempB14 
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


		
		
		IF(substring(@depNo,1,2)='FD') BEGIN  SELECT @purposecode='D16' END
       	IF(substring(@depNo,1,2)='RD') BEGIN  SELECT @purposecode='D22' END
		EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@receiptPayNo output
		SELECT @depositBal = (SettlementAmount-Subscription) FROM speccs.Deposits WHERE DepositNo=@depNo
		INSERT INTO speccs.Payments
		VALUES(@memaccno,@receiptPayNo,@settlementDate,'D15',@depositBal,'CHEQUE','ACTIVE',@depNo,"Deposits Interest Settlement",@userID,GETDATE())

		-----------
		-----------
		----------------------Bank Transaction 24-02-2026 START
--DECLARE @BankBalance FLOAT ,@BTransactiondate DATE,@BTransNo VARCHAR(50),@BAmount FLOAT,@BrefNo VARCHAR(50),@Purname VARCHAR(75)

SELECT @BTransactiondate=@settlementDate
SELECT @BTransNo=@receiptPayNo
---For receipts+,For payments-
SELECT @BAmount=-@depositBal
SELECT @BrefNo=@depNo
SELECT @Purname=Description FROM speccs.TransactionType WHERE PayCode='D15'
SELECT @BankBalance=BankBalance  FROM speccs.BankBalance 



   -- DECLARE @BmaxTranDate DATE
    
    SELECT @BmaxTranDate = MAX(TransactionDate) 
    FROM speccs.BankTransactions
    
     IF (@BTransactiondate < @BmaxTranDate)
    BEGIN
    	 SELECT ReceiptNo, TransactionDate, Amount, BankBalance, PurCode, 
            RefNo, RegTime, UserId 
        INTO #tempB15
        FROM speccs.BankTransactions 
        WHERE CONVERT(DATE, TransactionDate) > @BTransactiondate
        
     --    DECLARE @Bankbalnce1 FLOAT,@BAmt FLOAT,@BNo VARCHAR(14)
     
     
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

     /*         
       DECLARE @CurrentReceiptNo VARCHAR(14), 
                @CurrentAmount DECIMAL(18,2), 
                @CurrentPurCode VARCHAR(10), 
                @CurrentRefNo VARCHAR(10),
                @CurrentBBalance FLOAT, 
                @CurrentTransactionDate DATE, 
                @CurrentRegTime DATETIME */
                
                 WHILE EXISTS (SELECT 1 FROM #tempB15)
       			 BEGIN
                SELECT TOP 1 
                @CurrentReceiptNo       = ReceiptNo,
                @CurrentAmount          = Amount,
                @CurrentPurCode         = PurCode,
                @CurrentRefNo           = RefNo,
                @CurrentBBalance=BankBalance,
                @CurrentTransactionDate = TransactionDate,
                @CurrentRegTime         = RegTime
            	 FROM #tempB15
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
            DELETE FROM #tempB15 
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


		
            UPDATE speccs.Deposits
			SET CloseDate=@settlementDate, Status='CLOSED',RegTime=getdate()
			WHERE DepositNo=@depNo
        SET @start = @end + 1
    END

   

END	 --deposit status update end



DECLARE @deposits DECIMAL(15,2)
SELECT @deposits=0 
SELECT @deposits=convert(DECIMAL(15,2),(ThriftBalance + ShareAmount)) FROM speccs.MemberAccount WHERE MemAccNo=@memaccno

SELECT @deposits=@deposits+ (CASE WHEN sum(dep.SettlementAmount)=NULL THEN 0 ELSE sum(dep.SettlementAmount) END)  FROM speccs.Deposits dep WHERE  dep.MemAccNo=@memaccno AND dep.Status='CLOSE_INIT'

SELECT @deposits=convert(DECIMAL(15,2),@deposits)
	
 /*	IF(@deposits > @liabilities)
	BEGIN	
		SELECT @settlementAmount = (@deposits-@liabilities),@purposecode='M05'	*/
	   --	EXEC speccs.SP_Payments  'SAVE',@memaccno,@settlementDate,@purposecode,@settlementAmount,"CHEQUE",@memaccno,@userID,"Settlement",@receiptPayNo output 
	SET @deposits=CASE WHEN @deposits=NULL THEN 0 ELSE @deposits END

  	EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@receiptPayNo output

	INSERT INTO speccs.Payments
	VALUES(@memaccno,@receiptPayNo,@settlementDate,'M05',(CASE WHEN @deposits=NULL THEN 0 ELSE @deposits END),'CHEQUE','ACTIVE',@memaccno,"Member Settlement",@userID,GETDATE())
-------


	EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@receiptPayNo output
	DECLARE @thriftBal DECIMAL(15,2)
	SELECT @thriftBal=0
	SELECT @thriftBal = ThriftBalance FROM speccs.MemberAccount WHERE MemAccNo=@memaccno
	INSERT INTO speccs.Payments
	VALUES(@memaccno,@receiptPayNo,@settlementDate,'M09',(CASE WHEN @thriftBal=NULL THEN 0 ELSE @thriftBal END),'CHEQUE','ACTIVE',@memaccno,"Thrift Settlement",@userID,GETDATE())
  -----
  		----------------------Bank Transaction 24-02-2026 START
--DECLARE @BankBalance FLOAT ,@BTransactiondate DATE,@BTransNo VARCHAR(50),@BAmount FLOAT,@BrefNo VARCHAR(50),@Purname VARCHAR(75)

SELECT @BTransactiondate=@settlementDate
SELECT @BTransNo=@receiptPayNo
---For receipts+,For payments-
SELECT @BAmount=-(CASE WHEN @thriftBal=NULL THEN 0 ELSE @thriftBal END)
SELECT @BrefNo=@memaccno
SELECT @Purname=Description FROM speccs.TransactionType WHERE PayCode='M09'
SELECT @BankBalance=BankBalance  FROM speccs.BankBalance 



   -- DECLARE @BmaxTranDate DATE
    
    SELECT @BmaxTranDate = MAX(TransactionDate) 
    FROM speccs.BankTransactions
    
     IF (@BTransactiondate < @BmaxTranDate)
    BEGIN
    	 SELECT ReceiptNo, TransactionDate, Amount, BankBalance, PurCode, 
            RefNo, RegTime, UserId 
        INTO #tempB16
        FROM speccs.BankTransactions 
        WHERE CONVERT(DATE, TransactionDate) > @BTransactiondate
        
     --    DECLARE @Bankbalnce1 FLOAT,@BAmt FLOAT,@BNo VARCHAR(14)
     
     
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

     /*         
       DECLARE @CurrentReceiptNo VARCHAR(14), 
                @CurrentAmount DECIMAL(18,2), 
                @CurrentPurCode VARCHAR(10), 
                @CurrentRefNo VARCHAR(10),
                @CurrentBBalance FLOAT, 
                @CurrentTransactionDate DATE, 
                @CurrentRegTime DATETIME */
                
                 WHILE EXISTS (SELECT 1 FROM #tempB16)
       			 BEGIN
                SELECT TOP 1 
                @CurrentReceiptNo       = ReceiptNo,
                @CurrentAmount          = Amount,
                @CurrentPurCode         = PurCode,
                @CurrentRefNo           = RefNo,
                @CurrentBBalance=BankBalance,
                @CurrentTransactionDate = TransactionDate,
                @CurrentRegTime         = RegTime
            	 FROM #tempB16
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
            DELETE FROM #tempB16
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

 	
    EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@receiptPayNo output
    DECLARE @shareBal DECIMAL(15,2)
    SELECT @shareBal=0
	SELECT @shareBal = ShareAmount FROM speccs.MemberAccount WHERE MemAccNo=@memaccno
	INSERT INTO speccs.Payments
	VALUES(@memaccno,@receiptPayNo,@settlementDate,'M10',(CASE WHEN @shareBal=NULL THEN 0 ELSE @shareBal END),'CHEQUE','ACTIVE',@memaccno,"Share Capital Settlement",@userID,GETDATE())
	--------------------------------------------------------------------
  
	  		----------------------Bank Transaction 24-02-2026 START
--DECLARE @BankBalance FLOAT ,@BTransactiondate DATE,@BTransNo VARCHAR(50),@BAmount FLOAT,@BrefNo VARCHAR(50),@Purname VARCHAR(75)

SELECT @BTransactiondate=@settlementDate
SELECT @BTransNo=@receiptPayNo
---For receipts+,For payments-
SELECT @BAmount=-(CASE WHEN @shareBal=NULL THEN 0 ELSE @shareBal END)
SELECT @BrefNo=@memaccno
SELECT @Purname=Description FROM speccs.TransactionType WHERE PayCode='M10'
SELECT @BankBalance=BankBalance  FROM speccs.BankBalance 



   -- DECLARE @BmaxTranDate DATE
    
    SELECT @BmaxTranDate = MAX(TransactionDate) 
    FROM speccs.BankTransactions
    
     IF (@BTransactiondate < @BmaxTranDate)
    BEGIN
    	 SELECT ReceiptNo, TransactionDate, Amount, BankBalance, PurCode, 
            RefNo, RegTime, UserId 
        INTO #tempB17
        FROM speccs.BankTransactions 
        WHERE CONVERT(DATE, TransactionDate) > @BTransactiondate
        
     --    DECLARE @Bankbalnce1 FLOAT,@BAmt FLOAT,@BNo VARCHAR(14)
     
     
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

     /*         
       DECLARE @CurrentReceiptNo VARCHAR(14), 
                @CurrentAmount DECIMAL(18,2), 
                @CurrentPurCode VARCHAR(10), 
                @CurrentRefNo VARCHAR(10),
                @CurrentBBalance FLOAT, 
                @CurrentTransactionDate DATE, 
                @CurrentRegTime DATETIME */
                
                 WHILE EXISTS (SELECT 1 FROM #tempB17)
       			 BEGIN
                SELECT TOP 1 
                @CurrentReceiptNo       = ReceiptNo,
                @CurrentAmount          = Amount,
                @CurrentPurCode         = PurCode,
                @CurrentRefNo           = RefNo,
                @CurrentBBalance=BankBalance,
                @CurrentTransactionDate = TransactionDate,
                @CurrentRegTime         = RegTime
            	 FROM #tempB17
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
            DELETE FROM #tempB17
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

	EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@receiptPayNo output

	DECLARE @rimsAmt FLOAT 
	 SELECT @rimsAmt=0
	
	SELECT @rimsAmt=CASE WHEN (Datediff(YY,m.MemDate ,@settlementDate))>10 THEN  (CASE WHEN ((Datediff(YY,m.MemDate ,@settlementDate)) * 450) <= 15000 THEN ((Datediff(YY,m.MemDate ,@settlementDate)) * 450) ELSE 15000 END) ELSE 0 END 
     FROM speccs.MemberAccount mem,speccs.Members m
     WHERE m.MemAccNo=mem.MemAccNo AND mem.MemAccNo=@memaccno AND m.Status='ACTIVE'

    
  
   
   
	INSERT INTO speccs.Payments
	VALUES(@memaccno,@receiptPayNo,@settlementDate,'M13',(CASE WHEN @rimsAmt=NULL THEN 0 ELSE @rimsAmt END),'CHEQUE','ACTIVE',@memaccno,"REMBS Amount Settlement",@userID,GETDATE())

 
	  		----------------------Bank Transaction 24-02-2026 START
--DECLARE @BankBalance FLOAT ,@BTransactiondate DATE,@BTransNo VARCHAR(50),@BAmount FLOAT,@BrefNo VARCHAR(50),@Purname VARCHAR(75)

SELECT @BTransactiondate=@settlementDate
SELECT @BTransNo=@receiptPayNo
---For receipts+,For payments-
SELECT @BAmount=-(CASE WHEN @rimsAmt=NULL THEN 0 ELSE @rimsAmt END)
SELECT @BrefNo=@memaccno
SELECT @Purname=Description FROM speccs.TransactionType WHERE PayCode='M13'
SELECT @BankBalance=BankBalance  FROM speccs.BankBalance 



   -- DECLARE @BmaxTranDate DATE
    
    SELECT @BmaxTranDate = MAX(TransactionDate) 
    FROM speccs.BankTransactions
    
     IF (@BTransactiondate < @BmaxTranDate)
    BEGIN
    	 SELECT ReceiptNo, TransactionDate, Amount, BankBalance, PurCode, 
            RefNo, RegTime, UserId 
        INTO #tempB18
        FROM speccs.BankTransactions 
        WHERE CONVERT(DATE, TransactionDate) > @BTransactiondate
        
     --    DECLARE @Bankbalnce1 FLOAT,@BAmt FLOAT,@BNo VARCHAR(14)
     
     
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

     /*         
       DECLARE @CurrentReceiptNo VARCHAR(14), 
                @CurrentAmount DECIMAL(18,2), 
                @CurrentPurCode VARCHAR(10), 
                @CurrentRefNo VARCHAR(10),
                @CurrentBBalance FLOAT, 
                @CurrentTransactionDate DATE, 
                @CurrentRegTime DATETIME */
                
                 WHILE EXISTS (SELECT 1 FROM #tempB18)
       			 BEGIN
                SELECT TOP 1 
                @CurrentReceiptNo       = ReceiptNo,
                @CurrentAmount          = Amount,
                @CurrentPurCode         = PurCode,
                @CurrentRefNo           = RefNo,
                @CurrentBBalance=BankBalance,
                @CurrentTransactionDate = TransactionDate,
                @CurrentRegTime         = RegTime
            	 FROM #tempB18
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
            DELETE FROM #tempB18
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
	--------------------------------------------------------------------
  /*	
	--updating member status
		UPDATE speccs.Members
		SET Status = 'SETTLED', UserId = @userID, Remarks = 'Account closed'
		WHERE MemAccNo = @memaccno
	
	--updating loan status
		UPDATE speccs.Loans
		SET LoanStatus = 'SETTLED',UserId = @userID,ClosedOnDate = @settlementDate, Remarks = 'Account closed'
		WHERE MemAccNo = @memaccno

	END 
	ELSE IF( @liabilities > @deposits )
	BEGIN		*/
	---------------------------------------------------------------------------------------------------------------------------------------
	--BOTH LTL & EXL -START
	
DECLARE @liabilities NUMERIC(15,2) ,@liabilities1 NUMERIC(15,2), @days INT,@lastDate INT 
SELECT @liabilities=0,@liabilities1=0,@days=0,@lastDate=0
SELECT @days=datepart(dd,@settlementDate)-1
SELECT @lastDate=datepart(dd,dateadd(dd,-datepart(dd,@settlementDate),dateadd(mm,1,@settlementDate)))
SELECT @liabilities=convert(NUMERIC(15,2),LoanSanctionAmount+((LoanSanctionAmount*InterestRate*@days)/(@lastDate*1200))) FROM speccs.Loans WHERE MemAccNo=@memaccno AND LoanStatus='RELEASED' AND LoanType='LTL'
SELECT @liabilities1 =convert(NUMERIC(15,2),LoanSanctionAmount+((LoanSanctionAmount*InterestRate*@days)/(@lastDate*1200))) FROM speccs.Loans WHERE MemAccNo=@memaccno AND LoanStatus='RELEASED' AND LoanType='EXL'
SELECT @liabilities=@liabilities+@liabilities1
		--BOTH LTL & EXL -END
-----------------------------------------------------------------------------------------------------------------------------------------------	
	--LTL ALONE -START
	   IF EXISTS	(SELECT LoanAccNo FROM speccs.Loans WHERE MemAccNo=@memaccno AND LoanStatus='RELEASED' AND LoanType='LTL')
BEGIN
	
	DECLARE @LoanAppNo VARCHAR(12)
	SELECT @LoanAppNo = LoanAccNo FROM speccs.Loans WHERE MemAccNo=@memaccno AND LoanStatus='RELEASED' AND LoanType='LTL'
	SELECT @settlementAmount=0

		SELECT @settlementAmount = ((CASE WHEN @liabilities =NULL THEN 0 ELSE @liabilities  END)-(CASE WHEN @deposits=NULL THEN 0 ELSE @deposits END)),@purposecode='M08'
	   --	EXEC speccs.SP_Receipts  'SAVE',@memaccno,@settlementDate,@purposecode,@settlementAmount,"CHEQUE",@memaccno,@userID,'','',"Account Settlement",@receiptPayNo output		
	
	EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@receiptPayNo output
   INSERT INTO speccs.Receipts(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
   VALUES (@memaccno, @receiptPayNo, @settlementDate, 'M08', CASE WHEN @liabilities =NULL THEN 0 ELSE @liabilities  END, 'SETTLED',@userID,getdate(),'ACTIVE','Account Settled',@LoanAppNo)
	
	
	--LTL Receipt settlement
	DECLARE @loanSanAmnt NUMERIC(15,2)
	SELECT @loanSanAmnt=LoanSanctionAmount  FROM speccs.Loans WHERE MemAccNo=@memaccno AND LoanStatus='RELEASED' AND LoanType='LTL'
		SELECT @loanSanAmnt=CASE WHEN @loanSanAmnt =NULL THEN 0 ELSE @loanSanAmnt  END
	EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@receiptPayNo output
    INSERT INTO speccs.Receipts(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
    VALUES (@memaccno, @receiptPayNo, @settlementDate, 'L26', @loanSanAmnt, 'SETTLED',@userID,getdate(),'ACTIVE','Account Settled',@LoanAppNo)
	-------------------
		----------------------Bank Transaction 24-02-2026 START
--DECLARE @BankBalance FLOAT ,@BTransactiondate DATE,@BTransNo VARCHAR(50),@BAmount FLOAT,@BrefNo VARCHAR(50),@Purname VARCHAR(75)

SELECT @BTransactiondate=@settlementDate
SELECT @BTransNo=@receiptPayNo
---For receipts+,For payments-
SELECT @BAmount=@loanSanAmnt
SELECT @BrefNo=@LoanAppNo
SELECT @Purname=Description FROM speccs.TransactionType WHERE PayCode='L26'
SELECT @BankBalance=BankBalance  FROM speccs.BankBalance 



   -- DECLARE @BmaxTranDate DATE
    
    SELECT @BmaxTranDate = MAX(TransactionDate) 
    FROM speccs.BankTransactions
    
     IF (@BTransactiondate < @BmaxTranDate)
    BEGIN
    	 SELECT ReceiptNo, TransactionDate, Amount, BankBalance, PurCode, 
            RefNo, RegTime, UserId 
        INTO #tempB19
        FROM speccs.BankTransactions 
        WHERE CONVERT(DATE, TransactionDate) > @BTransactiondate
        
     --    DECLARE @Bankbalnce1 FLOAT,@BAmt FLOAT,@BNo VARCHAR(14)
     
     
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

     /*         
       DECLARE @CurrentReceiptNo VARCHAR(14), 
                @CurrentAmount DECIMAL(18,2), 
                @CurrentPurCode VARCHAR(10), 
                @CurrentRefNo VARCHAR(10),
                @CurrentBBalance FLOAT, 
                @CurrentTransactionDate DATE, 
                @CurrentRegTime DATETIME */
                
                 WHILE EXISTS (SELECT 1 FROM #tempB19)
       			 BEGIN
                SELECT TOP 1 
                @CurrentReceiptNo       = ReceiptNo,
                @CurrentAmount          = Amount,
                @CurrentPurCode         = PurCode,
                @CurrentRefNo           = RefNo,
                @CurrentBBalance=BankBalance,
                @CurrentTransactionDate = TransactionDate,
                @CurrentRegTime         = RegTime
            	 FROM #tempB19
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
            DELETE FROM #tempB19
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
	
	-----------------
	
	INSERT INTO speccs.LoanTransactions 
	VALUES (@LoanAppNo,@settlementDate,'L26',@loanSanAmnt,'P',@receiptPayNo,'Loan Sett',0,getdate(),@userID)
	   
	   SELECT @loanSanAmnt=convert(NUMERIC(15,2),((LoanSanctionAmount*InterestRate*@days)/(@lastDate*1200))) FROM speccs.Loans WHERE MemAccNo=@memaccno AND LoanStatus='RELEASED' AND LoanType='LTL'
	EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@receiptPayNo output
    INSERT INTO speccs.Receipts(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
    VALUES (@memaccno, @receiptPayNo, @settlementDate, 'L27', @loanSanAmnt, 'SETTLED',@userID,getdate(),'ACTIVE','Account Settled',@LoanAppNo)
	--------------
		----------------------Bank Transaction 24-02-2026 START
--DECLARE @BankBalance FLOAT ,@BTransactiondate DATE,@BTransNo VARCHAR(50),@BAmount FLOAT,@BrefNo VARCHAR(50),@Purname VARCHAR(75)

SELECT @BTransactiondate=@settlementDate
SELECT @BTransNo=@receiptPayNo
---For receipts+,For payments-
SELECT @BAmount=@loanSanAmnt
SELECT @BrefNo=@LoanAppNo
SELECT @Purname=Description FROM speccs.TransactionType WHERE PayCode='L27'
SELECT @BankBalance=BankBalance  FROM speccs.BankBalance 



   -- DECLARE @BmaxTranDate DATE
    
    SELECT @BmaxTranDate = MAX(TransactionDate) 
    FROM speccs.BankTransactions
    
     IF (@BTransactiondate < @BmaxTranDate)
    BEGIN
    	 SELECT ReceiptNo, TransactionDate, Amount, BankBalance, PurCode, 
            RefNo, RegTime, UserId 
        INTO #tempB20
        FROM speccs.BankTransactions 
        WHERE CONVERT(DATE, TransactionDate) > @BTransactiondate
        
     --    DECLARE @Bankbalnce1 FLOAT,@BAmt FLOAT,@BNo VARCHAR(14)
     
     
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

     /*         
       DECLARE @CurrentReceiptNo VARCHAR(14), 
                @CurrentAmount DECIMAL(18,2), 
                @CurrentPurCode VARCHAR(10), 
                @CurrentRefNo VARCHAR(10),
                @CurrentBBalance FLOAT, 
                @CurrentTransactionDate DATE, 
                @CurrentRegTime DATETIME */
                
                 WHILE EXISTS (SELECT 1 FROM #tempB20)
       			 BEGIN
                SELECT TOP 1 
                @CurrentReceiptNo       = ReceiptNo,
                @CurrentAmount          = Amount,
                @CurrentPurCode         = PurCode,
                @CurrentRefNo           = RefNo,
                @CurrentBBalance=BankBalance,
                @CurrentTransactionDate = TransactionDate,
                @CurrentRegTime         = RegTime
            	 FROM #tempB20
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
            DELETE FROM #tempB20
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
	
	
	---------------
	INSERT INTO speccs.LoanTransactions 
	VALUES (@LoanAppNo,@settlementDate,'L27',@loanSanAmnt,'I',@receiptPayNo,'Loan Sett',0,getdate(),@userID)
	--ltl end
	END
	
		--LTL ALONE -END
--------------------------------------------------------------------------------------------------------------------------------------------	
	--EXL ALONE -START
	   IF EXISTS	(SELECT  LoanAccNo FROM speccs.Loans WHERE MemAccNo=@memaccno AND LoanStatus='RELEASED' AND LoanType='EXL')
BEGIN
	--EXL Receipt Settelement
	SELECT @loanSanAmnt=0 
		SELECT @LoanAppNo = LoanAccNo FROM speccs.Loans WHERE MemAccNo=@memaccno AND LoanStatus='RELEASED' AND LoanType='EXL'

	SELECT @loanSanAmnt=LoanSanctionAmount  FROM speccs.Loans WHERE MemAccNo=@memaccno AND LoanStatus='RELEASED' AND LoanType='EXL'
	SELECT @loanSanAmnt=CASE WHEN @loanSanAmnt =NULL THEN 0 ELSE @loanSanAmnt  END
	EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@receiptPayNo output
    INSERT INTO speccs.Receipts(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
    VALUES (@memaccno, @receiptPayNo, @settlementDate, 'L31', @loanSanAmnt, 'SETTLED',@userID,getdate(),'ACTIVE','Account Settled',@LoanAppNo)
	---------------------
	
		----------------------Bank Transaction 24-02-2026 START
--DECLARE @BankBalance FLOAT ,@BTransactiondate DATE,@BTransNo VARCHAR(50),@BAmount FLOAT,@BrefNo VARCHAR(50),@Purname VARCHAR(75)

SELECT @BTransactiondate=@settlementDate
SELECT @BTransNo=@receiptPayNo
---For receipts+,For payments-
SELECT @BAmount=@loanSanAmnt
SELECT @BrefNo=@LoanAppNo
SELECT @Purname=Description FROM speccs.TransactionType WHERE PayCode='L31'
SELECT @BankBalance=BankBalance  FROM speccs.BankBalance 



   -- DECLARE @BmaxTranDate DATE
    
    SELECT @BmaxTranDate = MAX(TransactionDate) 
    FROM speccs.BankTransactions
    
     IF (@BTransactiondate < @BmaxTranDate)
    BEGIN
    	 SELECT ReceiptNo, TransactionDate, Amount, BankBalance, PurCode, 
            RefNo, RegTime, UserId 
        INTO #tempB21
        FROM speccs.BankTransactions 
        WHERE CONVERT(DATE, TransactionDate) > @BTransactiondate
        
     --    DECLARE @Bankbalnce1 FLOAT,@BAmt FLOAT,@BNo VARCHAR(14)
     
     
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

     /*         
       DECLARE @CurrentReceiptNo VARCHAR(14), 
                @CurrentAmount DECIMAL(18,2), 
                @CurrentPurCode VARCHAR(10), 
                @CurrentRefNo VARCHAR(10),
                @CurrentBBalance FLOAT, 
                @CurrentTransactionDate DATE, 
                @CurrentRegTime DATETIME */
                
                 WHILE EXISTS (SELECT 1 FROM #tempB21)
       			 BEGIN
                SELECT TOP 1 
                @CurrentReceiptNo       = ReceiptNo,
                @CurrentAmount          = Amount,
                @CurrentPurCode         = PurCode,
                @CurrentRefNo           = RefNo,
                @CurrentBBalance=BankBalance,
                @CurrentTransactionDate = TransactionDate,
                @CurrentRegTime         = RegTime
            	 FROM #tempB21
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
            DELETE FROM #tempB21
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
	
	
	-------------------
	
	
	INSERT INTO speccs.LoanTransactions 
	VALUES (@LoanAppNo,@settlementDate,'L31',CASE WHEN @loanSanAmnt =NULL THEN 0 ELSE @loanSanAmnt  END,'P',@receiptPayNo,'Loan Sett',0,getdate(),@userID)
	   
	   SELECT @loanSanAmnt=convert(NUMERIC(15,2),((LoanSanctionAmount*InterestRate*@days)/(@lastDate*1200)))  FROM speccs.Loans WHERE MemAccNo=@memaccno AND LoanStatus='RELEASED' AND LoanType='EXL'
	EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@receiptPayNo output
    INSERT INTO speccs.Receipts(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
    VALUES (@memaccno, @receiptPayNo, @settlementDate, 'L32', @loanSanAmnt, 'SETTLED',@userID,getdate(),'ACTIVE','Account Settled',@LoanAppNo)
	--------------------
		----------------------Bank Transaction 24-02-2026 START
--DECLARE @BankBalance FLOAT ,@BTransactiondate DATE,@BTransNo VARCHAR(50),@BAmount FLOAT,@BrefNo VARCHAR(50),@Purname VARCHAR(75)

SELECT @BTransactiondate=@settlementDate
SELECT @BTransNo=@receiptPayNo
---For receipts+,For payments-
SELECT @BAmount=@loanSanAmnt
SELECT @BrefNo=@LoanAppNo
SELECT @Purname=Description FROM speccs.TransactionType WHERE PayCode='L32'
SELECT @BankBalance=BankBalance  FROM speccs.BankBalance 



   -- DECLARE @BmaxTranDate DATE
    
    SELECT @BmaxTranDate = MAX(TransactionDate) 
    FROM speccs.BankTransactions
    
     IF (@BTransactiondate < @BmaxTranDate)
    BEGIN
    	 SELECT ReceiptNo, TransactionDate, Amount, BankBalance, PurCode, 
            RefNo, RegTime, UserId 
        INTO #tempB22
        FROM speccs.BankTransactions 
        WHERE CONVERT(DATE, TransactionDate) > @BTransactiondate
        
     --    DECLARE @Bankbalnce1 FLOAT,@BAmt FLOAT,@BNo VARCHAR(14)
     
     
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

     /*         
       DECLARE @CurrentReceiptNo VARCHAR(14), 
                @CurrentAmount DECIMAL(18,2), 
                @CurrentPurCode VARCHAR(10), 
                @CurrentRefNo VARCHAR(10),
                @CurrentBBalance FLOAT, 
                @CurrentTransactionDate DATE, 
                @CurrentRegTime DATETIME */
                
                 WHILE EXISTS (SELECT 1 FROM #tempB22)
       			 BEGIN
                SELECT TOP 1 
                @CurrentReceiptNo       = ReceiptNo,
                @CurrentAmount          = Amount,
                @CurrentPurCode         = PurCode,
                @CurrentRefNo           = RefNo,
                @CurrentBBalance=BankBalance,
                @CurrentTransactionDate = TransactionDate,
                @CurrentRegTime         = RegTime
            	 FROM #tempB22
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
            DELETE FROM #tempB22
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
	
	
	-------------------
	INSERT INTO speccs.LoanTransactions 
	VALUES (@LoanAppNo,@settlementDate,'L32',@loanSanAmnt,'I',@receiptPayNo,'Loan Sett',0,getdate(),@userID)
	--EXL end
	END
	--EXL ALONE -END
---------------------------------------------------------------------------------------------------------------------------------------
   --updating member status
	UPDATE speccs.Members
	SET Status = 'SETTLED',ClosedDate=@settlementDate, UserId = @userID, Remarks = 'Account closed'
	WHERE MemAccNo = @memaccno
	
	--updating loan status
	UPDATE speccs.Loans
	SET LoanSanctionAmount=0, LoanStatus = 'SETTLED',UserId = @userID,ClosedOnDate = @settlementDate, Remarks = 'Account closed'
	WHERE MemAccNo = @memaccno
--deposit status update start

 /*	
	--updating member status
		UPDATE speccs.Members
		SET Status = 'SETTLED', UserId = @userID, Remarks = 'Account closed'
		WHERE MemAccNo = @memaccno

	--updating loan status
		UPDATE speccs.Loans
		SET LoanStatus = 'SETTLED',UserId = @userID,ClosedOnDate = @settlementDate, Remarks = 'Account closed'
		WHERE MemAccNo = @memaccno

	
		 INSERT INTO speccs.LoanTransactions 
		VALUES (@LoanAppNo,@settlementDate,@purposecode,@liabilities,'P',@receiptPayNo,'CHEQUE',0,getdate(),@userID) 
	END  */
	--SELECT @receiptPayNo AS receiptPayNo

RETURN 
END


GO

