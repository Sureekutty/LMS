IF OBJECT_ID ('speccs.sp_ThriftInterestUpload') IS NOT NULL
	DROP PROCEDURE speccs.sp_ThriftInterestUpload
GO

CREATE PROCEDURE speccs.sp_ThriftInterestUpload
    @EmpCode     VARCHAR(50),
    @UploadDate  DATETIME,
    @Amount      FLOAT,
    @ThriftType  INT
AS
BEGIN
    -- Declare variable to check if EmpCode exists
    		DECLARE @EmpCodeExists INT,
    		@ReceiptNo VARCHAR(15),
    		@ReceiptNumber VARCHAR(15)
    

    -- Check if EmpCode exists in the table
    		SELECT @EmpCodeExists = COUNT(*)
    		FROM speccs.ThriftInterestUploading
    		WHERE EmpCode = @EmpCode
-----------Start 0 ------------
    	IF @EmpCodeExists = 0
    	BEGIN
        -- If EmpCode does not exist, insert new record
        			INSERT INTO speccs.ThriftInterestUploading (EmpCode, UploadDate, RegDate, Amount, ThriftType)
       				VALUES (@EmpCode, @UploadDate, GETDATE(), @Amount, @ThriftType)
    	END
    	ELSE
    	BEGIN
       		 -- If EmpCode exists, check if UploadDate matches an existing record
        		IF EXISTS (
            		SELECT 1 
            		FROM speccs.ThriftInterestUploading 
            		WHERE EmpCode = @EmpCode AND UploadDate = @UploadDate
        			)
        		BEGIN
            		-- Update Amount and ThriftType for the matching record
            	UPDATE speccs.ThriftInterestUploading
            	SET Amount = @Amount,
                ThriftType = @ThriftType,
                RegDate = GETDATE() -- Update RegDate on modification
            	WHERE EmpCode = @EmpCode AND UploadDate = @UploadDate
       
        		END
        		ELSE
        		BEGIN
           		 -- If UploadDate differs, insert new record for the same EmpCode
            	INSERT INTO speccs.ThriftInterestUploading (EmpCode, UploadDate, RegDate, Amount, ThriftType)
            	VALUES (@EmpCode, @UploadDate, GETDATE(), @Amount, @ThriftType)
        		END
    	END
    
    
    
    
    
      				
				    
		   
    
    
    
    
    
		EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@ReceiptNo output
		DECLARE @MemAccNum VARCHAR(15)

		SELECT @MemAccNum=MemAccNo FROM speccs.Members WHERE MemEmpCode=@EmpCode

		INSERT INTO speccs.Payments(MemAccNo, PayVoucherNo, VoucherDate, PurposeCode, Amount, ModeOfPayment,Status,RefNo,Remarks,UserId,RegTime)
		VALUES (@MemAccNum, @ReceiptNo, @UploadDate, 'M04', @Amount, 'cheque','ACTIVE',@MemAccNum,'THRIFT INT','SH15823',getdate())

		IF(@@ERROR!=0)
		BEGIN
		RAISERROR 99999 "Error while inserting data in Receipts :speccs.sp_ThriftInterestUpload "
		ROLLBACK TRANSACTION
		RETURN
		END

 
    ------START For adding thrift Int on 01/04/YYYY and removing on UploadDate
 			DECLARE @RefNumber1 VARCHAR(15)
    		DECLARE @Adddate DATETIME
    		DECLARE @YYYY INT
    		DECLARE @ThriftMinBal FLOAT
   			DECLARE @ThriftMaxBal FLOAT
    		DECLARE @ThriftAmtMin FLOAT
    		DECLARE @ThriftAmtMax FLOAT
    		DECLARE @ReceiptNumberT1 VARCHAR(15)
    		DECLARE @ReceiptNumberT2 VARCHAR(15)

    		-- Set the current year and construct April 1 date

			SELECT @MemAccNum=MemAccNo FROM speccs.Members WHERE MemEmpCode=@EmpCode
    		SELECT @YYYY = DATEPART(YY, GETDATE())
    		SELECT @Adddate = CAST('04/01/' + CAST(@YYYY AS VARCHAR(4)) AS DATETIME)

    		-- Get the member account number for the employee
     		------For adding thrift Int on 01/04/YYYY and removing on UploadDate
         
    
    
    		SELECT @RefNumber1= MemAccNo FROM speccs.Members m WHERE MemEmpCode=@EmpCode AND m.Status='ACTIVE'
     
/*
     		SELECT speccs.ThriftTransactions.MemAccNo,speccs.ThriftTransactions.Month, speccs.ThriftTransactions.TransactionDate, speccs.ThriftTransactions.ModeOfPayment, speccs.ThriftTransactions.Amount, 
			speccs.ThriftTransactions.ReceiptNo, speccs.ThriftTransactions.UserId,  speccs.ThriftTransactions.RegTime,speccs.ThriftTransactions.ThriftBalance INTO #tempData81 FROM speccs.ThriftTransactions WHERE MemAccNo=@RefNumber1 AND TransactionDate>@Adddate AND TransactionDate<@UploadDate
    
       		   
    		DECLARE @MAccNo1 VARCHAR(10), @RecNum1 VARCHAR(14)
     		
     		
     		WHILE EXISTS (SELECT 1 FROM #tempData81)
			BEGIN
			
			    SELECT TOP 1 @MAccNo1 = MemAccNo,@RecNum1=ReceiptNo FROM #tempData81
			    
					UPDATE speccs.ThriftTransactions
				   	SET ThriftBalance=ThriftBalance+@Amount
				   	WHERE MemAccNo=@MAccNo1 AND ReceiptNo=@RecNum1
				    
			    DELETE FROM #tempData81 WHERE MemAccNo=@MAccNo1 AND ReceiptNo=@RecNum1
				    
			END

			  
			     		SELECT TOP 1 @ThriftMaxBal=ThriftBalance  FROM speccs.ThriftTransactions WHERE MemAccNo=@RefNumber1 AND TransactionDate<@UploadDate  ORDER BY TransactionDate DESC 
  			---   SELECT TOP 1 @ThriftAmtMax=Amount  FROM speccs.ThriftTransactions WHERE MemAccNo=@RefNumber1 AND TransactionDate BETWEEN @Adddate AND @UploadDate ORDER BY RegTime DESC 

     		SELECT TOP 1 @ThriftMinBal=ThriftBalance  FROM speccs.ThriftTransactions WHERE MemAccNo=@RefNumber1 AND TransactionDate<=@Adddate  ORDER BY TransactionDate DESC 
      	   ---	SELECT TOP 1 @ThriftAmtMin=Amount  FROM speccs.ThriftTransactions WHERE MemAccNo=@RefNumber1 AND TransactionDate BETWEEN @Adddate AND @UploadDate ORDER BY RegTime ASC 

						
		   		EXEC speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNumberT1 output
	
		   	
		   		INSERT INTO speccs.ThriftTransactions(MemAccNo,Month,TransactionDate,ModeOfPayment,Amount,ReceiptNo,UserId,RegTime,ThriftBalance)
				VALUES (@MemAccNum,convert(VARCHAR(8),datepart(mm,@Adddate)),@Adddate,'Thrift Int ADj', @Amount, @ReceiptNumberT1, 'SH15823',getdate(),@ThriftMinBal+@Amount)
				
			    
       			EXEC speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNumberT2 output
      	   		INSERT INTO speccs.ThriftTransactions(MemAccNo,Month,TransactionDate,ModeOfPayment,Amount,ReceiptNo,UserId,RegTime,ThriftBalance)
				VALUES (@MemAccNum,convert(VARCHAR(8),datepart(mm,@Adddate)),@UploadDate,'Thrift Int Adj', 0-@Amount, @ReceiptNumberT2, 'SH15823',getdate(),@ThriftMaxBal-@Amount)
			  	
     

    --------------END For adding thrift Int on 01/04/YYYY and removing on UploadDate

*

    
    IF @ThriftType = 2 
    BEGIN
    	EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNumber output
    	DECLARE @RefNo VARCHAR(15)
    	SELECT @RefNo= l.LoanAccNo FROM speccs.Members m,speccs.Loans l WHERE m.MemAccNo=l.MemAccNo AND m.MemEmpCode=@EmpCode AND m.Status='ACTIVE'
    
 			IF EXISTS (SELECT * FROM speccs.LoanTransactions WHERE LoanAccNo=@RefNo) 
   	 		BEGIN
   	 		
   	 		
				DECLARE @maxTranDate DATE 
	   			SELECT @maxTranDate=max(TransactionDate) FROM speccs.LoanTransactions WHERE LoanAccNo=@RefNo
	   			--added for missed receipt transactions start
	   			
					IF(@UploadDate<@maxTranDate)
					BEGIN 
		
			/* Adaptive Server has expanded all '*' elements in the following statement */ 
						SELECT speccs.LoanTransactions.LoanAccNo, speccs.LoanTransactions.TransactionDate, speccs.LoanTransactions.PayCode, speccs.LoanTransactions.Amount, speccs.LoanTransactions.P_I, speccs.LoanTransactions.ReceiptNo, speccs.LoanTransactions.Modeofpay, speccs.LoanTransactions.ClosingBal, speccs.LoanTransactions.RegTime, speccs.LoanTransactions.UserId INTO #tempData78 FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)>@UploadDate AND LoanAccNo=@RefNo
						DECLARE @LoanAccNo VARCHAR(10), @ReceiptNum VARCHAR(14)
						DECLARE @ModeOfPayment	VARCHAR(15),@ClosingBalance NUMERIC(15,2),@purposecode VARCHAR(5), @Message VARCHAR(255)
						DECLARE @txMonth DATETIME, @FromDate DATETIME,@ToDate DATETIME,  @InterestToBePaid INT ,@DepositTypeCode VARCHAR(3)

			
							WHILE EXISTS (SELECT 1 FROM #tempData78)
							BEGIN
			
			    				SELECT TOP 1 @LoanAccNo = LoanAccNo,@ReceiptNum=ReceiptNo FROM #tempData78
			    
								UPDATE speccs.LoanTransactions
				  				SET ClosingBal=ClosingBal-@Amount
				   				WHERE LoanAccNo=@LoanAccNo AND ReceiptNo=@ReceiptNum
				    
			    				DELETE FROM #tempData78 WHERE LoanAccNo=@LoanAccNo AND ReceiptNo=@ReceiptNum
							END
							
							
						SELECT TOP 1 @ClosingBalance=ClosingBal FROM speccs.LoanTransactions WHERE convert(DATE,TransactionDate)<@UploadDate AND LoanAccNo=@RefNo AND PayCode IN('L23','L24','L26') ORDER BY TransactionDate desc
					END	--end of missed receipts transactions 
					
		  
		  			
					ELSE
					BEGIN 
						SELECT  @ClosingBalance=ClosingBal
						FROM speccs.LoanTransactions
						WHERE LoanAccNo=@RefNo AND P_I='P' AND PayCode IN('L23','L24','L26') AND TransactionDate=(SELECT max(TransactionDate) FROM speccs.LoanTransactions WHERE LoanAccNo=@RefNo)	
					END --end else part
			END	   
 	
 					UPDATE speccs.Loans
 					SET LoanSanctionAmount=LoanSanctionAmount-@Amount,RegTime=getdate()
 					WHERE LoanAccNo=@RefNo AND LoanStatus='RELEASED'
 	 			
   					INSERT INTO speccs.LoanTransactions(LoanAccNo,TransactionDate,PayCode,  Amount, P_I, ReceiptNo, Modeofpay, ClosingBal,RegTime,UserId)
   					VALUES (@RefNo,@UploadDate,'L26', @Amount, 'P', @ReceiptNumber, 'Thrift Int', (@ClosingBalance-@Amount),getdate(), 'SH15823')
	
   					INSERT INTO speccs.Receipts (MemAccNO,ReceiptNo,ReceiptDate,PurposeCode,Amount,ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo,BankCode)
  					VALUES (@MemAccNum,@ReceiptNumber,@UploadDate,'L26',@Amount,'Cheque','SH15823',getdate(),'ACTIVE','Thrift Int',@RefNo,'')
	
					INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
   					VALUES('SH15823',@MemAccNum,@ReceiptNumber,'Thrift Interest Upload',getdate(),'','Thrift Int')
	
	
	
					IF(@@ERROR!=0)
					BEGIN
   	   							SELECT @Message="Error while inserting "+@MemAccNum+" data in LoanTransactions  :speccs.sp_ThriftInterestUpload"
   	   							RAISERROR 99999 @Message
   	   							ROLLBACK TRANSACTION
   								RETURN
					END
    
    END
    --------------------------Thrift 2-------------------------------------
    
    
    		
    
    
    	ELSE IF @ThriftType = 3
    	   
    	BEGIN
    	DECLARE @oldThrift DECIMAL(15,2)
			SELECT @oldThrift=ThriftBalance FROM speccs.MemberAccount WHERE MemAccNo=@MemAccNum
    			DECLARE @ReceiptNumberT VARCHAR(15)
    			EXEC speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNumberT output
  
   
   				DECLARE @RefNumber VARCHAR(15)
    			SELECT @RefNumber= MemAccNo FROM speccs.Members m WHERE MemEmpCode=@EmpCode AND m.Status='ACTIVE'
    			
     -------------Missed Thrift Transcation update
     
     
 			IF EXISTS (SELECT * FROM speccs.ThriftTransactions WHERE MemAccNo=@RefNumber) 
			BEGIN
				DECLARE @maxTranThriftDate DATE 
				SELECT @maxTranThriftDate =max(TransactionDate) FROM speccs.ThriftTransactions WHERE MemAccNo=@RefNumber
		--added for missed receipt transactions start
		
		
				IF(@UploadDate<@maxTranThriftDate)
				BEGIN 
		
			/* Adaptive Server has expanded all '*' elements in the following statement */ 
					SELECT speccs.ThriftTransactions.MemAccNo,speccs.ThriftTransactions.Month, speccs.ThriftTransactions.TransactionDate, speccs.ThriftTransactions.ModeOfPayment, speccs.ThriftTransactions.Amount, 
					speccs.ThriftTransactions.ReceiptNo, speccs.ThriftTransactions.UserId,  speccs.ThriftTransactions.RegTime,speccs.ThriftTransactions.ThriftBalance INTO #tempData79 FROM speccs.ThriftTransactions WHERE convert(DATE,TransactionDate)>@UploadDate AND speccs.ThriftTransactions.MemAccNo=@RefNumber
					DECLARE @MAccNo VARCHAR(10), @RecNum VARCHAR(14)
					DECLARE @ModOfPay	VARCHAR(15),@ThriftBal NUMERIC(15,2),@ThriftBalance DECIMAL(15,2)
			


			
					WHILE EXISTS (SELECT 1 FROM #tempData79)
					BEGIN
			
			    		SELECT TOP 1 @MAccNo = MemAccNo,@RecNum=ReceiptNo FROM #tempData79
			    
							UPDATE speccs.ThriftTransactions
				   			SET ThriftBalance=ThriftBalance+@Amount
				   			WHERE MemAccNo=@MAccNo AND ReceiptNo=@RecNum
				    
			    		DELETE FROM #tempData79 WHERE MemAccNo=@MAccNo AND ReceiptNo=@RecNum
				    
					END--While end 
					
					
					SELECT TOP 1 @ThriftBalance=ThriftBalance FROM speccs.ThriftTransactions WHERE convert(DATE,TransactionDate)<@UploadDate AND MemAccNo=@RefNumber ORDER BY TransactionDate desc
				END
   
   				ELSE
				BEGIN 
				
					SELECT  @oldThrift=ThriftBalance
					FROM speccs.ThriftTransactions
					WHERE  MemAccNo=@RefNumber  AND TransactionDate=(SELECT max(TransactionDate) FROM speccs.ThriftTransactions WHERE  MemAccNo=@RefNumber AND convert(DATE,TransactionDate)<=@UploadDate )
					----(SELECT max(TransactionDate) FROM speccs.ThriftTransactions WHERE  MemAccNo=@RefNumber AND convert(DATE,TransactionDate)<=@UploadDate ORDER BY TransactionDate DESC)
					--SELECT @oldThrift=@ThriftBalance

				END --end else part

			END
	
   	   				SELECT  @oldThrift=ThriftBalance
					FROM speccs.ThriftTransactions
					WHERE  MemAccNo=@RefNumber  AND TransactionDate=(SELECT max(TransactionDate) FROM speccs.ThriftTransactions WHERE  MemAccNo=@RefNumber AND convert(DATE,TransactionDate)<=@UploadDate )	
	
	
					UPDATE speccs.MemberAccount
 					SET ThriftBalance=ThriftBalance+@Amount, UserId='SH15823' ,RegTime=getdate()
 					WHERE MemAccNo=@MemAccNum
 	 			
	
	
					INSERT INTO speccs.ThriftTransactions(MemAccNo,Month,TransactionDate,ModeOfPayment,Amount,ReceiptNo,UserId,RegTime,ThriftBalance)
					VALUES (@MemAccNum,convert(VARCHAR(8),datepart(mm,@UploadDate)),@UploadDate,'Thrift Int', @Amount, @ReceiptNumberT, 'SH15823',getdate(),@oldThrift+@Amount)
		
		
					INSERT INTO speccs.Receipts (MemAccNO,ReceiptNo,ReceiptDate,PurposeCode,Amount,ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo,BankCode)
					VALUES (@MemAccNum,@ReceiptNumberT,@UploadDate,'M43',@Amount,'Cheque','SH15823',getDate(),'ACTIVE','Thrift Int',@MemAccNum,'')
	
	
	
	
					DECLARE @TxnIdNum NUMERIC(18,0),
					@DepositClosingBal  FLOAT
  	 				SELECT	@DepositClosingBal= ThriftBalance FROM speccs.MemberAccount WHERE MemAccNo=@MemAccNum
	
	
    				EXEC speccs.SP_AutoNumber "TxnId",NULL ,@TxnIdNum output
					
					
					INSERT INTO speccs.DepositTransactions(MemaccNo,TxnId,DepositTypeCode,RefNo,Month,TxnDate,ModeOfPayment,Amount,OpeningBalance,ClosingBalance,ReceiptNo,UserId,RegTime)
	 				VALUES(@MemAccNum,@TxnIdNum,'THR',@MemAccNum,'',@UploadDate,'Thrift Int' ,@Amount,@oldThrift,@DepositClosingBal,@ReceiptNumberT,'SH15823',getdate())		   
	
	
	
					INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
					VALUES('SH15823',@MemAccNum,@ReceiptNumberT,'Receipt Saved',getdate(),'','Thrift Int')	
	
	
					IF(@@ERROR!=0)
					BEGIN
   	   					SELECT @Message="Error while inserting "+@MemAccNum+" data in ThriftTransactions  :speccs.sp_ThriftInterestUpload"
   	   					RAISERROR 99999 @Message
   	   					ROLLBACK TRANSACTION
   						RETURN
					END  
    
    
    
    
    
    END ----Type 3 End
    




---------------End 0------------------------------------------


	 
    ----Error because of Multiple Receipt Creation New receipt Not created ---It placed Null if Null exist it will rollback
	 
      	   	   
END




GO

