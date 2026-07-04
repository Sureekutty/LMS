IF OBJECT_ID ('speccs.sp_ThriftAdj') IS NOT NULL
	DROP PROCEDURE speccs.sp_ThriftAdj
GO

CREATE PROCEDURE speccs.sp_ThriftAdj
	@EmpCode  VARCHAR(15),
    @UploadDate  DATETIME,
    @Amount      DECIMAL(15,2),
    @ThriftType  INT
AS
BEGIN--1
    --BEGIN TRANSACTION
    --------------------------Thrift 2-------------------------------------
      -------------999999999999999-------12/08/2025
     DECLARE @countadj INT,@codeadj VARCHAR(50),@Amountadj1 DECIMAL(15,2),@RefNumberadj1 VARCHAR(5),
     @Adddate DATETIME,
    		 @YYYY INT,
    		 @ThriftMinBal DECIMAL(15,2),
   			 @ThriftMaxBal DECIMAL(15,2),
    		 @ThriftAmtMin DECIMAL(15,2),
    		 @ThriftAmtMax DECIMAL(15,2),
    		 @ReceiptNumberT1 VARCHAR(15),
    		@ReceiptNumberT2 VARCHAR(15),
    		@Message VARCHAR(255)
    		------------------------------------------------------------------------------------------------
    		DECLARE @EmpCodeExists INT
    		
    		  -- Check if EmpCode exists in the table
    		SELECT @EmpCodeExists = COUNT(*)
    		FROM speccs.ThriftInterestUploading06temp
    		WHERE EmpCode = @EmpCode
-----------Start 0 ------------
    	IF @EmpCodeExists = 0
    	BEGIN
        -- If EmpCode does not exist, insert new record
        		   
       				INSERT INTO speccs.ThriftInterestUploading06temp2 (EmpCode, UploadDate, RegDate, Amount, ThriftType)
       				VALUES (@EmpCode, @UploadDate, GETDATE(), @Amount, @ThriftType)
    	END
    	ELSE
    	BEGIN
       		 -- If EmpCode exists, check if UploadDate matches an existing record
        		IF EXISTS (
            		SELECT 1 
            		FROM speccs.ThriftInterestUploading06temp2
            		WHERE EmpCode = @EmpCode AND UploadDate = @UploadDate
        			)
        		BEGIN
            		-- Update Amount and ThriftType for the matching record
              
            	
               
            	
            	UPDATE speccs.ThriftInterestUploading06temp2
            	SET Amount = @Amount,
                ThriftType = @ThriftType,
                RegDate = GETDATE() -- Update RegDate on modification
            	WHERE EmpCode = @EmpCode AND UploadDate = @UploadDate
       
        		END
        		ELSE
        		BEGIN
           		 -- If UploadDate differs, insert new record for the same EmpCode
              
            	
            	INSERT INTO speccs.ThriftInterestUploading06temp2 (EmpCode, UploadDate, RegDate, Amount, ThriftType)
            	VALUES (@EmpCode, @UploadDate, GETDATE(), @Amount, @ThriftType)
        		END
    	END
    
    		
    		
    		
    		
    		
    		
    		
    		--------------------------------------------------------------------------------------------------------
		SELECT @countadj=count(*) FROM speccs.ThriftInterestUploading06temp2 WHERE ThriftType=2 OR ThriftType=3 OR ThriftType=1  
		SELECT @countadj
		
		SELECT @YYYY = DATEPART(YY, GETDATE())
    		SELECT @Adddate = CAST('04/01/' + CAST(@YYYY AS VARCHAR(4)) AS DATETIME)

	
		   -- CHANGE: Changed from 'WHILE @countadj >0' to 'WHILE EXISTS' to match ThriftType3 loop style
		   -- WHY: Ensures loop continues only if records exist, preventing potential infinite loops if count doesn't decrement correctly
		   -- PURPOSE: Processes all records dynamically, exiting when no more records match the condition
		   WHILE EXISTS (SELECT 1 FROM speccs.ThriftInterestUploading06temp2 WHERE ThriftType=2 OR ThriftType=3 OR ThriftType=1)
	  BEGIN--2
	  
	   -- CHANGE: Added SET ROWCOUNT 1 for selecting the first EmpCode, similar to ThriftType3
	   -- WHY: Limits selection to one record at a time for processing
	   -- PURPOSE: Fetches the next record in each iteration, mimicking ThriftType3's row-by-row processing
	   SET ROWCOUNT 1
		SELECT @codeadj=EmpCode, @Amountadj1=Amount 
		FROM speccs.ThriftInterestUploading06temp2 
		WHERE ThriftType=2 OR ThriftType=3 OR ThriftType=1
		ORDER BY EmpCode
		SET ROWCOUNT 0
		
		-- CHANGE: Removed separate SELECT for @Amountadj1
		-- WHY: Combined into one SELECT with EmpCode to ensure values from the same record
		-- PURPOSE: Prevents mismatches between EmpCode and Amount
		
		SELECT @RefNumberadj1= MemAccNo FROM speccs.Members m WHERE MemEmpCode=@codeadj AND m.Status='ACTIVE'
		
		-- CHANGE: Added IF validation for @RefNumberadj1, similar to ThriftType3
		-- WHY: Prevents NULL issues if no active member
		-- PURPOSE: Skips invalid records, ensuring no errors during adjustment
		
		IF @RefNumberadj1 IS NULL
		BEGIN--3
		    SELECT @Message = 'No active member found for EmpCode: ' + ISNULL(@codeadj, 'NULL')
		    RAISERROR 99999 @Message
		    DELETE FROM speccs.ThriftInterestUploading06temp2 WHERE EmpCode=@codeadj
		    SELECT @countadj=@countadj-1
		END--4
		ELSE
		BEGIN--4
     		SELECT speccs.ThriftTransactions06082025temp.MemAccNo,speccs.ThriftTransactions06082025temp.Month, speccs.ThriftTransactions06082025temp.TransactionDate, speccs.ThriftTransactions06082025temp.ModeOfPayment, speccs.ThriftTransactions06082025temp.Amount, 
			speccs.ThriftTransactions06082025temp.ReceiptNo, speccs.ThriftTransactions06082025temp.UserId,  speccs.ThriftTransactions06082025temp.RegTime,speccs.ThriftTransactions06082025temp.ThriftBalance INTO #tempData81 FROM speccs.ThriftTransactions06082025temp WHERE MemAccNo=@RefNumberadj1 AND TransactionDate>@Adddate AND TransactionDate<=@UploadDate
    
       		   
    		DECLARE @MAccNo1 VARCHAR(10), @RecNum1 VARCHAR(14)
     		
     		
     		WHILE EXISTS (SELECT 1 FROM #tempData81)
			BEGIN--5
			
			    SET ROWCOUNT 1  -- CHANGE: Added SET ROWCOUNT 1 for inner loop selection, to match ThriftType3 style
			    -- WHY: Limits to one row for consistent processing
			    -- PURPOSE: Ensures inner loop processes one transaction at a time
			    SELECT @MAccNo1 = MemAccNo,@RecNum1=ReceiptNo FROM #tempData81
			    SET ROWCOUNT 0
			    
					UPDATE speccs.ThriftTransactions06082025temp
				   	SET ThriftBalance=ThriftBalance+@Amountadj1
				   	WHERE MemAccNo=@MAccNo1 AND ReceiptNo=@RecNum1
				    
			    DELETE FROM #tempData81 WHERE MemAccNo=@MAccNo1 AND ReceiptNo=@RecNum1
				    
			END--3

			  
			     		SET ROWCOUNT 1  -- CHANGE: Added SET ROWCOUNT 1 for balance selection, to match ThriftType3
			     		-- WHY: Ensures only one row is selected for max balance
			     		-- PURPOSE: Prevents multiple rows from affecting variables
			     		SELECT @ThriftMaxBal=Max(ThriftBalance)  FROM speccs.ThriftTransactions06082025temp WHERE MemAccNo=@RefNumberadj1 AND TransactionDate<=@UploadDate  ORDER BY TransactionDate DESC 
			     		SET ROWCOUNT 0
  			---   SELECT TOP 1 @ThriftAmtMax=Amount  FROM speccs.ThriftTransactions WHERE MemAccNo=@RefNumber1 AND TransactionDate BETWEEN @Adddate AND @UploadDate ORDER BY RegTime DESC 

     		SET ROWCOUNT 1  -- CHANGE: Added SET ROWCOUNT 1 for min balance selection, to match ThriftType3
     		-- WHY: Ensures only one row is selected for min balance
     		-- PURPOSE: Consistent with ThriftType3's approach for single-row queries
     		SELECT @ThriftMinBal=ThriftBalance  FROM speccs.ThriftTransactions06082025temp WHERE MemAccNo=@RefNumberadj1 AND TransactionDate<=@Adddate  ORDER BY TransactionDate DESC 
     		SET ROWCOUNT 0
      	   ---	SELECT TOP 1 @ThriftAmtMin=Amount  FROM speccs.ThriftTransactions WHERE MemAccNo=@RefNumber1 AND TransactionDate BETWEEN @Adddate AND @UploadDate ORDER BY RegTime ASC 

						
		   		EXEC speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNumberT1 output
	
		   	
		   		INSERT INTO speccs.ThriftTransactions06082025temp(MemAccNo,Month,TransactionDate,ModeOfPayment,Amount,ReceiptNo,UserId,RegTime,ThriftBalance)
				VALUES (@RefNumberadj1,convert(VARCHAR(8),datepart(mm,@Adddate)),@Adddate,'Thrift Int ADj', @Amountadj1, @ReceiptNumberT1, 'SH15823',getdate(),@ThriftMinBal+@Amountadj1)
				
			    
       			EXEC speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNumberT2 output
      	   		INSERT INTO speccs.ThriftTransactions06082025temp(MemAccNo,Month,TransactionDate,ModeOfPayment,Amount,ReceiptNo,UserId,RegTime,ThriftBalance)
				VALUES (@RefNumberadj1,convert(VARCHAR(8),datepart(mm,@UploadDate)),@UploadDate,'Thrift Int Adj', 0-@Amountadj1, @ReceiptNumberT2, 'SH15823',getdate(),@ThriftMaxBal-@Amountadj1)
			  	
      -- CHANGE: Removed SELECT @countadj=@countadj-1 as it's redundant with WHILE EXISTS
      -- WHY: WHILE EXISTS handles loop exit automatically; manual decrement is unnecessary
      -- PURPOSE: Simplifies code to match ThriftType3, avoiding potential count mismatches
      DELETE speccs.ThriftInterestUploading06temp2 WHERE EmpCode=@codeadj
      END 
      
      
    END--2

    --------------END For adding thrift Int on 01/04/YYYY and removing on UploadDate
     
    
END--1


GO
