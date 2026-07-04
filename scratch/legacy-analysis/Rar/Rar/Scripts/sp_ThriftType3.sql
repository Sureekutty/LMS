
IF OBJECT_ID ('speccs.sp_ThriftType3') IS NOT NULL
	DROP PROCEDURE speccs.sp_ThriftType3
GO

CREATE PROCEDURE speccs.sp_ThriftType3
	@EmpCode  VARCHAR(15),
    @MemAccNum   VARCHAR(5),
    @UploadDate  DATETIME,
    @Amount      DECIMAL(15,2),
    @ThriftType  INT
AS
BEGIN--1
    --BEGIN TRANSACTION

	DECLARE @ReceiptNumberT VARCHAR(15)
		DECLARE @oldThrift DECIMAL(15,2)
		
    ---&&&&
    DECLARE @count INT,@Empcode VARCHAR(50),@Amount1 DECIMAL(15,2),@Message VARCHAR(255)
	SELECT @count=count(*) FROM speccs.ThriftInterestUploading06temp WHERE ThriftType=3 
	SELECT @count
		DECLARE @RefNumber VARCHAR(5)
    	    
	WHILE EXISTS (SELECT 1 FROM speccs.ThriftInterestUploading06temp WHERE ThriftType=3 AND UploadDate=@UploadDate )
	 BEGIN--2
		-- CHANGE: Combined Empcode and Amount1 selection into one query with UploadDate filter
		-- WHY: Ensures Empcode and Amount1 come from the same record, preventing mismatches
		-- PURPOSE: Guarantees DELETE removes the selected record, avoiding infinite loop
		-- SYBASE 7.3: Added ORDER BY EmpCode for deterministic SET ROWCOUNT 1
		SET ROWCOUNT 1
		SELECT @Empcode=EmpCode, @Amount1=Amount 
		FROM speccs.ThriftInterestUploading06temp 
		WHERE ThriftType=3 AND UploadDate=@UploadDate
		ORDER BY EmpCode
		SET ROWCOUNT 0
		
		-- CHANGE: Added debugging output
		-- WHY: Logs selected Empcode, Amount1, UploadDate to verify each record is processed once
		-- PURPOSE: Helps detect if the same record is reprocessed, indicating a loop issue
		SELECT @Empcode, @Amount1, @UploadDate
		
		SELECT @RefNumber= MemAccNo FROM speccs.Members m WHERE MemEmpCode=@Empcode AND m.Status='ACTIVE'
		SELECT @RefNumber
		
		IF @RefNumber IS NULL
		BEGIN--3
			-- CHANGE: Added ISNULL to handle NULL Empcode in error message
			-- WHY: Prevents concatenation error in Sybase ASE 7.3 if Empcode is NULL
			-- PURPOSE: Ensures clear error reporting without procedure failure
			SELECT @Message = 'No active member found for EmpCode: ' + ISNULL(@Empcode, 'NULL')
			RAISERROR 99999 @Message
			DELETE FROM speccs.ThriftInterestUploading06temp 
			WHERE EmpCode=@Empcode AND ThriftType=3 AND UploadDate=@UploadDate
			SELECT @count=@count-1
		END--3
		ELSE
		BEGIN--4
			EXEC speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNumberT output
			
			SELECT @oldThrift=ThriftBalance FROM speccs.MemberAccount WHERE MemAccNo=@RefNumber
			
			SELECT @ReceiptNumberT
			SELECT @RefNumber
			SELECT @UploadDate
			SELECT @Amount1
			SELECT @oldThrift+@Amount1
			
			----8888888888----------
			DECLARE @maxTranThriftDate DATE 
				SELECT @maxTranThriftDate =max(TransactionDate) FROM speccs.ThriftTransactions WHERE MemAccNo=@RefNumber
			IF(@UploadDate<@maxTranThriftDate)
				BEGIN--5
			SELECT speccs.ThriftTransactions.MemAccNo,speccs.ThriftTransactions.Month, speccs.ThriftTransactions.TransactionDate, speccs.ThriftTransactions.ModeOfPayment, speccs.ThriftTransactions.Amount, 
					speccs.ThriftTransactions.ReceiptNo, speccs.ThriftTransactions.UserId,  speccs.ThriftTransactions.RegTime,speccs.ThriftTransactions.ThriftBalance INTO #tempData79 FROM speccs.ThriftTransactions WHERE convert(DATE,TransactionDate)>@UploadDate AND speccs.ThriftTransactions.MemAccNo=@RefNumber
		   
		   
		   DECLARE @MAccNo VARCHAR(5), @RecNum VARCHAR(14)
					DECLARE @ModOfPay	VARCHAR(15),@ThriftBal DECIMAL(15,2),@ThriftBalance DECIMAL(15,2)
			


			
					WHILE EXISTS (SELECT 1 FROM #tempData79)
					BEGIN--6
			
			    		SELECT @MAccNo = MemAccNo,@RecNum=ReceiptNo FROM #tempData79
			    
							UPDATE speccs.ThriftTransactions
				   			SET ThriftBalance=ThriftBalance+@Amount1
				   			WHERE MemAccNo=@MAccNo AND ReceiptNo=@RecNum
				    
			    		DELETE FROM #tempData79 WHERE MemAccNo=@MAccNo AND ReceiptNo=@RecNum
				    
					END--While end --6
		   
		   SELECT @ThriftBalance=ThriftBalance FROM speccs.ThriftTransactions WHERE convert(DATE,TransactionDate)<=@UploadDate AND MemAccNo=@RefNumber ORDER BY TransactionDate desc
				
			 	SELECT  @ThriftBalance=ThriftBalance
					FROM speccs.ThriftTransactions
					WHERE  MemAccNo=@RefNumber  AND TransactionDate=(SELECT max(TransactionDate) FROM speccs.ThriftTransactions WHERE  MemAccNo=@RefNumber AND convert(DATE,TransactionDate)<=@UploadDate )
			  	 SELECT  @oldThrift=@ThriftBalance	
				
					
				END--5
		   
		   ELSE
				BEGIN --7
			 	SELECT @oldThrift=ThriftBalance FROM speccs.MemberAccount WHERE MemAccNo=@RefNumber
	
				   
			  	END --end else part	--7
		  
	SELECT @oldThrift=@oldThrift+@Amount1
			INSERT INTO speccs.ThriftTransactions(MemAccNo,Month,TransactionDate,ModeOfPayment,Amount,ReceiptNo,UserId,RegTime,ThriftBalance)
					VALUES (@RefNumber,convert(VARCHAR(8),datepart(mm,@UploadDate)),@UploadDate,'Thrift Int', @Amount1, @ReceiptNumberT, 'SH15823',getdate(),@oldThrift)
			
	
					UPDATE speccs.MemberAccount
 					SET ThriftBalance=ThriftBalance+@Amount1, UserId='SH15823' ,RegTime=getdate()
 					WHERE MemAccNo=@RefNumber
			
				INSERT INTO speccs.Receipts (MemAccNO,ReceiptNo,ReceiptDate,PurposeCode,Amount,ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo,BankCode)
					VALUES (@RefNumber,@ReceiptNumberT,@UploadDate,'M43',@Amount1,'Cheque','SH15823',getDate(),'ACTIVE','Thrift Int',@MemAccNum,'')
   					DECLARE @TxnIdNum NUMERIC(18,0),
					@DepositClosingBal  DECIMAL(15,2)
  	 				SELECT	@DepositClosingBal= ThriftBalance FROM speccs.MemberAccount WHERE MemAccNo=@RefNumber
	
	
	
    			 --- 	EXEC speccs.SP_AutoNumber "TxnId1",NULL ,@TxnIdNum output
    			--  	SELECT @TxnIdNum=000000000000000001
			   --		SELECT @TxnIdNum=convert(VARCHAR(18),@TxnIdNum+1) 
					
				--	INSERT INTO speccs.DepositTransactions06082025temp(MemaccNo,TxnId,DepositTypeCode,RefNo,Month,TxnDate,ModeOfPayment,Amount,OpeningBalance,ClosingBalance,ReceiptNo,UserId,RegTime)
	 			 --	VALUES(@RefNumber,@TxnIdNum,'THR',@RefNumber,'',@UploadDate,'Thrift Int' ,@Amount,@oldThrift,@DepositClosingBal,@ReceiptNumberT,'SH15823',getdate())		   
	
	
	
				 --	IF(@@ERROR!=0)
				  --	BEGIN
   	   			  --		SELECT @Message="Error while inserting "+@MemAccNum+" data in ThriftTransactions  :speccs.sp_ThriftInterestUpload"
   	   			   --		RAISERROR 99999 @Message
   	   					--ROLLBACK TRANSACTION
   					--	RETURN
				  --	END  
    
			-------888888888888---
			
			DELETE FROM speccs.ThriftInterestUploading06temp 
			WHERE EmpCode=@Empcode AND ThriftType=3 AND UploadDate=@UploadDate
			SELECT @count=@count-1
		END--4
	 END--2
		
    ----&&&
    
     ---	ELSE IF @ThriftType = 3
    	   
     ---	BEGIN
       
   
			SELECT @oldThrift=ThriftBalance FROM speccs.MemberAccount WHERE MemAccNo=@MemAccNum
    		 
    			EXEC speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNumberT output
  
   
   				
     -------------Missed Thrift Transcation update
     
     	/* 
 			IF EXISTS (SELECT * FROM speccs.ThriftTransactions06082025temp WHERE MemAccNo=@MemAccNum) 
			BEGIN--8
			   --	DECLARE @maxTranThriftDate DATE 
				SELECT @maxTranThriftDate =max(TransactionDate) FROM speccs.ThriftTransactions06082025temp WHERE MemAccNo=@MemAccNum
		--added for missed receipt transactions start
		
		
				IF(@UploadDate<@maxTranThriftDate)
				BEGIN --9
		
		   Adaptive Server has expanded all '*' elements in the following statement */ 
				  --	SELECT speccs.ThriftTransactions06082025temp.MemAccNo,speccs.ThriftTransactions06082025temp.Month, speccs.ThriftTransactions06082025temp.TransactionDate, speccs.ThriftTransactions06082025temp.ModeOfPayment, speccs.ThriftTransactions06082025temp.Amount, 
				   --	speccs.ThriftTransactions06082025temp.ReceiptNo, speccs.ThriftTransactions06082025temp.UserId,  speccs.ThriftTransactions06082025temp.RegTime,speccs.ThriftTransactions06082025temp.ThriftBalance INTO #tempData79 FROM speccs.ThriftTransactions06082025temp WHERE convert(DATE,TransactionDate)>@UploadDate AND speccs.ThriftTransactions06082025temp.MemAccNo=@MemAccNum
				   /*	DECLARE @MAccNo VARCHAR(5), @RecNum VARCHAR(14)
					DECLARE @ModOfPay	VARCHAR(15),@ThriftBal DECIMAL(15,2),@ThriftBalance DECIMAL(15,2)
			


			
					WHILE EXISTS (SELECT 1 FROM #tempData79)
					BEGIN
			
			    		SELECT @MAccNo = MemAccNo,@RecNum=ReceiptNo FROM #tempData79
			    
							UPDATE speccs.ThriftTransactions06082025temp
				   			SET ThriftBalance=ThriftBalance+@Amount
				   			WHERE MemAccNo=@MAccNo AND ReceiptNo=@RecNum
				    
			    		DELETE FROM #tempData79 WHERE MemAccNo=@MAccNo AND ReceiptNo=@RecNum
				    
					END--While end 
				 	
					
					SET ROWCOUNT 1
					SELECT @ThriftBalance=ThriftBalance FROM speccs.ThriftTransactions06082025temp WHERE convert(DATE,TransactionDate)<@UploadDate AND MemAccNo=@MemAccNum ORDER BY TransactionDate desc
					SET ROWCOUNT 0
				END
   
   				ELSE
				BEGIN 
				
					SELECT  @ThriftBalance=ThriftBalance
					FROM speccs.ThriftTransactions06082025temp
					WHERE  MemAccNo=@MemAccNum  AND TransactionDate=(SELECT max(TransactionDate) FROM speccs.ThriftTransactions06082025temp WHERE  MemAccNo=@MemAccNum AND convert(DATE,TransactionDate)<=@UploadDate )
					----(SELECT max(TransactionDate) FROM speccs.ThriftTransactions WHERE  MemAccNo=@MemAccNum AND convert(DATE,TransactionDate)<=@UploadDate ORDER BY TransactionDate DESC)

				END --end else part

			END
	
   	   				SELECT  @oldThrift=ISNULL(@ThriftBalance, @oldThrift)
	
	
					UPDATE speccs.MemberAccount08082025
 					SET ThriftBalance=ThriftBalance+@Amount, UserId='SH15823' ,RegTime=getdate()
 					WHERE MemAccNo=@MemAccNum
 	 			
	
	
				  -- 	INSERT INTO speccs.ThriftTransactions06082025temp(MemAccNo,Month,TransactionDate,ModeOfPayment,Amount,ReceiptNo,UserId,RegTime,ThriftBalance)
				  --	VALUES (@RefNumber,convert(VARCHAR(8),datepart(mm,@UploadDate)),@UploadDate,'Thrift Int', @Amount1, @ReceiptNumberT, 'SH15823',getdate(),@oldThrift+@Amount1)
		
					INSERT INTO speccs.Receipts06082025temp (MemAccNO,ReceiptNo,ReceiptDate,PurposeCode,Amount,ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo,BankCode)
					VALUES (@RefNumber,@ReceiptNumberT,@UploadDate,'M43',@Amount,'Cheque','SH15823',getDate(),'ACTIVE','Thrift Int',@MemAccNum,'')
	
  
	
	
					DECLARE @TxnIdNum NUMERIC(18,0),
					@DepositClosingBal  DECIMAL(15,2)
  	 				SELECT	@DepositClosingBal= ThriftBalance FROM speccs.MemberAccount08082025 WHERE MemAccNo=@MemAccNum
	
	
    				EXEC speccs.SP_AutoNumber "TxnId",NULL ,@TxnIdNum output
					
					
					INSERT INTO speccs.DepositTransactions06082025temp(MemaccNo,TxnId,DepositTypeCode,RefNo,Month,TxnDate,ModeOfPayment,Amount,OpeningBalance,ClosingBalance,ReceiptNo,UserId,RegTime)
	 				VALUES(@RefNumber,@TxnIdNum,'THR',@MemAccNum,'',@UploadDate,'Thrift Int' ,@Amount,@oldThrift,@DepositClosingBal,@ReceiptNumberT,'SH15823',getdate())		   
	
	
	
					IF(@@ERROR!=0)
					BEGIN
   	   					SELECT @Message="Error while inserting "+@MemAccNum+" data in ThriftTransactions  :speccs.sp_ThriftInterestUpload"
   	   					RAISERROR 99999 @Message
   	   					--ROLLBACK TRANSACTION
   						RETURN
					END  
    
    
    
    	*/
    
   --- END ----Type 3 End


     --	    DELETE FROM speccs.ThriftInterestUploading06temp WHERE @code=EmpCode 
   --  SELECT @count=@count-0
 --  END	
    

 
END


GO

