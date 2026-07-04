

IF OBJECT_ID ('speccs.sp_ThriftType3') IS NOT NULL
	DROP PROCEDURE speccs.sp_ThriftType3
GO

CREATE PROCEDURE speccs.sp_ThriftType3
	@EmpCode  VARCHAR(15),
    @MemAccNum   VARCHAR(15),
    @UploadDate  DATETIME,
    @Amount      NUMERIC,
    @ThriftType  INT
AS
BEGIN
    --BEGIN TRANSACTION


	DECLARE @ReceiptNumberT VARCHAR(15)
		DECLARE @oldThrift NUMERIC(13,2)
    		
    ---&&&&
    DECLARE @count INT,@Empcode VARCHAR(50),@Amount1 FLOAT,@Message VARCHAR(255)
  --  SELECT @Empcode=@EmpCode
    --SELECT @Empcode
		SELECT @count=count(*) FROM speccs.ThriftInterestUploading06temp WHERE ThriftType=3 
		SELECT @count
		   DECLARE @RefNumber VARCHAR(15)
    	    
    			
		  
	WHILE EXISTS (SELECT 1 FROM speccs.ThriftInterestUploading06temp WHERE ThriftType=3 AND UploadDate=@UploadDate )
	 BEGIN
	   --Here Type Conversion problem Happened count is int but we are trying to store Varchar
		SELECT  TOP 1 @Empcode=EmpCode FROM speccs.ThriftInterestUploading06temp WHERE ThriftType=3
		--SELECT @Empcode
		SELECT @RefNumber= MemAccNo FROM speccs.Members m WHERE MemEmpCode=@Empcode AND m.Status='ACTIVE'
		SELECT @RefNumber
		
		SELECT  TOP 1 @Amount1=Amount FROM speccs.ThriftInterestUploading06temp WHERE ThriftType=3
		SELECT @Amount1
			EXEC speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNumberT output
		
		SELECT @oldThrift=ThriftBalance FROM speccs.MemberAccount08082025 WHERE MemAccNo=@RefNumber
		
		SELECT @ReceiptNumberT
		SELECT @RefNumber
		SELECT @UploadDate
		SELECT @Amount
		SELECT @oldThrift+@Amount
		
			INSERT INTO speccs.ThriftTransactions06082025temp(MemAccNo,Month,TransactionDate,ModeOfPayment,Amount,ReceiptNo,UserId,RegTime,ThriftBalance)
					VALUES (@RefNumber,convert(VARCHAR(8),datepart(mm,@UploadDate)),@UploadDate,'Thrift Int', @Amount1, @ReceiptNumberT, 'SH15823',getdate(),@oldThrift+@Amount1)
			 
		
   
    	    DELETE FROM speccs.ThriftInterestUploading06temp WHERE EmpCode=@Empcode
     SELECT @count=@count-1
    
    END
		
    ----&&&
    
     ---	ELSE IF @ThriftType = 3
    	   
     ---	BEGIN
       
   
			SELECT @oldThrift=ThriftBalance FROM speccs.MemberAccount08082025 WHERE MemAccNo=@RefNumber
    		 
    			EXEC speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNumberT output
  
   
   				
    			
     -------------Missed Thrift Transcation update
     
     
 			IF EXISTS (SELECT * FROM speccs.ThriftTransactions06082025temp WHERE MemAccNo=@RefNumber) 
			BEGIN
				DECLARE @maxTranThriftDate DATE 
				SELECT @maxTranThriftDate =max(TransactionDate) FROM speccs.ThriftTransactions06082025temp WHERE MemAccNo=@RefNumber
		--added for missed receipt transactions start
		
		
				IF(@UploadDate<@maxTranThriftDate)
				BEGIN 
		
			/* Adaptive Server has expanded all '*' elements in the following statement */ 
					SELECT speccs.ThriftTransactions06082025temp.MemAccNo,speccs.ThriftTransactions06082025temp.Month, speccs.ThriftTransactions06082025temp.TransactionDate, speccs.ThriftTransactions06082025temp.ModeOfPayment, speccs.ThriftTransactions06082025temp.Amount, 
					speccs.ThriftTransactions06082025temp.ReceiptNo, speccs.ThriftTransactions06082025temp.UserId,  speccs.ThriftTransactions06082025temp.RegTime,speccs.ThriftTransactions06082025temp.ThriftBalance INTO #tempData79 FROM speccs.ThriftTransactions06082025temp WHERE convert(DATE,TransactionDate)>@UploadDate AND speccs.ThriftTransactions06082025temp.MemAccNo=@RefNumber
					DECLARE @MAccNo VARCHAR(10), @RecNum VARCHAR(14)
					DECLARE @ModOfPay	VARCHAR(15),@ThriftBal NUMERIC(15,2),@ThriftBalance DECIMAL(15,2)
			


			
					WHILE EXISTS (SELECT 1 FROM #tempData79)
					BEGIN
			
			    		SELECT TOP 1 @MAccNo = MemAccNo,@RecNum=ReceiptNo FROM #tempData79
			    
							UPDATE speccs.ThriftTransactions06082025temp
				   			SET ThriftBalance=ThriftBalance+@Amount
				   			WHERE MemAccNo=@MAccNo AND ReceiptNo=@RecNum
				    
			    		DELETE FROM #tempData79 WHERE MemAccNo=@MAccNo AND ReceiptNo=@RecNum
				    
					END--While end 
					
					
					SELECT TOP 1 @ThriftBalance=ThriftBalance FROM speccs.ThriftTransactions06082025temp WHERE convert(DATE,TransactionDate)<@UploadDate AND MemAccNo=@RefNumber ORDER BY TransactionDate desc
				END
   
   				ELSE
				BEGIN 
				
					SELECT  @oldThrift=ThriftBalance
					FROM speccs.ThriftTransactions06082025temp
					WHERE  MemAccNo=@RefNumber  AND TransactionDate=(SELECT max(TransactionDate) FROM speccs.ThriftTransactions06082025temp WHERE  MemAccNo=@RefNumber AND convert(DATE,TransactionDate)<=@UploadDate )
					----(SELECT max(TransactionDate) FROM speccs.ThriftTransactions WHERE  MemAccNo=@RefNumber AND convert(DATE,TransactionDate)<=@UploadDate ORDER BY TransactionDate DESC)
					--SELECT @oldThrift=@ThriftBalance

				END --end else part

			END
	
   	   				SELECT  @oldThrift=ThriftBalance
					FROM speccs.ThriftTransactions06082025temp
					WHERE  MemAccNo=@RefNumber  AND TransactionDate=(SELECT max(TransactionDate) FROM speccs.ThriftTransactions06082025temp WHERE  MemAccNo=@RefNumber AND convert(DATE,TransactionDate)<=@UploadDate )	
	
	
					UPDATE speccs.MemberAccount08082025
 					SET ThriftBalance=ThriftBalance+@Amount, UserId='SH15823' ,RegTime=getdate()
 					WHERE MemAccNo=@RefNumber
 	 			
	
	
					INSERT INTO speccs.ThriftTransactions06082025temp(MemAccNo,Month,TransactionDate,ModeOfPayment,Amount,ReceiptNo,UserId,RegTime,ThriftBalance)
					VALUES (@MemAccNum,convert(VARCHAR(8),datepart(mm,@UploadDate)),@UploadDate,'Thrift Int', @Amount, @ReceiptNumberT, 'SH15823',getdate(),@oldThrift+@Amount)
		
		
					INSERT INTO speccs.Receipts06082025temp (MemAccNO,ReceiptNo,ReceiptDate,PurposeCode,Amount,ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo,BankCode)
					VALUES (@MemAccNum,@ReceiptNumberT,@UploadDate,'M43',@Amount,'Cheque','SH15823',getDate(),'ACTIVE','Thrift Int',@MemAccNum,'')
	
	
	
	
					DECLARE @TxnIdNum NUMERIC(18,0),
					@DepositClosingBal  FLOAT
  	 				SELECT	@DepositClosingBal= ThriftBalance FROM speccs.MemberAccount08082025 WHERE MemAccNo=@MemAccNum
	
	
    				EXEC speccs.SP_AutoNumber "TxnId",NULL ,@TxnIdNum output
					
					
					INSERT INTO speccs.DepositTransactions06082025temp(MemaccNo,TxnId,DepositTypeCode,RefNo,Month,TxnDate,ModeOfPayment,Amount,OpeningBalance,ClosingBalance,ReceiptNo,UserId,RegTime)
	 				VALUES(@MemAccNum,@TxnIdNum,'THR',@MemAccNum,'',@UploadDate,'Thrift Int' ,@Amount,@oldThrift,@DepositClosingBal,@ReceiptNumberT,'SH15823',getdate())		   
	
	
	
				   --	INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
				  --	VALUES('SH15823',@MemAccNum,@ReceiptNumberT,'Receipt Saved',getdate(),'','Thrift Int')	
	
	
					IF(@@ERROR!=0)
					BEGIN
   	   					SELECT @Message="Error while inserting "+@MemAccNum+" data in ThriftTransactions  :speccs.sp_ThriftInterestUpload"
   	   					RAISERROR 99999 @Message
   	   					ROLLBACK TRANSACTION
   						RETURN
					END  
    
    
    
    
    
   --- END ----Type 3 End


     --	    DELETE FROM speccs.ThriftInterestUploading06temp WHERE @code=EmpCode 
   --  SELECT @count=@count-0
 --  END	
    

 
END
GO
    
   
    