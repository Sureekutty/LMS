

IF OBJECT_ID ('speccs.sp_ThriftInterestUploadCorrection') IS NOT NULL
	DROP PROCEDURE speccs.sp_ThriftInterestUploadCorrection
GO

CREATE PROCEDURE speccs.sp_ThriftInterestUploadCorrection
    @EmpCode     VARCHAR(50),
    @UploadDate  DATETIME,
    @Amount      FLOAT,
    @ThriftType  INT
AS
BEGIN
    -- Declare variable to check if EmpCode exists
    		DECLARE @EmpCodeExists INT,
    		@ReceiptNo VARCHAR(15),
    		@ReceiptNumber VARCHAR(15),
   			@RefNumber1 VARCHAR(15),
    		 @Adddate DATETIME,
    		 @YYYY INT,
    		 @ThriftMinBal FLOAT,
   			 @ThriftMaxBal FLOAT,
    		 @ThriftAmtMin FLOAT,
    		 @ThriftAmtMax FLOAT,
    		 @ReceiptNumberT1 VARCHAR(15),
    		@ReceiptNumberT2 VARCHAR(15)

    -- Check if EmpCode exists in the table
    		SELECT @EmpCodeExists = COUNT(*)
    		FROM speccs.ThriftInterestUploading06temp
    		WHERE EmpCode = @EmpCode
-----------Start 0 ------------
    	IF @EmpCodeExists = 0
    	BEGIN
        -- If EmpCode does not exist, insert new record
        			INSERT INTO speccs.ThriftInterestUploading06temp (EmpCode, UploadDate, RegDate, Amount, ThriftType)
       				VALUES (@EmpCode, @UploadDate, GETDATE(), @Amount, @ThriftType)
       				
       				INSERT INTO speccs.ThriftInterestUploading06temp1 (EmpCode, UploadDate, RegDate, Amount, ThriftType)
       				VALUES (@EmpCode, @UploadDate, GETDATE(), @Amount, @ThriftType)
       			   --	INSERT INTO speccs.ThriftInterestUploading06temp2 (EmpCode, UploadDate, RegDate, Amount, ThriftType)
       			   --	VALUES (@EmpCode, @UploadDate, GETDATE(), @Amount, @ThriftType)
    	END
    	ELSE
    	BEGIN
       		 -- If EmpCode exists, check if UploadDate matches an existing record
        		IF EXISTS (
            		SELECT 1 
            		FROM speccs.ThriftInterestUploading06temp
            		WHERE EmpCode = @EmpCode AND UploadDate = @UploadDate
        			)
        		BEGIN
            		-- Update Amount and ThriftType for the matching record
            	UPDATE speccs.ThriftInterestUploading06temp
            	SET Amount = @Amount,
                ThriftType = @ThriftType,
                RegDate = GETDATE() -- Update RegDate on modification
            	WHERE EmpCode = @EmpCode AND UploadDate = @UploadDate
            	
            	
            	
            	UPDATE speccs.ThriftInterestUploading06temp1
            	SET Amount = @Amount,
                ThriftType = @ThriftType,
                RegDate = GETDATE() -- Update RegDate on modification
            	WHERE EmpCode = @EmpCode AND UploadDate = @UploadDate
            	
            	
             --	UPDATE speccs.ThriftInterestUploading06temp2
             --	SET Amount = @Amount,
             --  ThriftType = @ThriftType,
             --   RegDate = GETDATE() -- Update RegDate on modification
             --	WHERE EmpCode = @EmpCode AND UploadDate = @UploadDate
       
        		END
        		ELSE
        		BEGIN
           		 -- If UploadDate differs, insert new record for the same EmpCode
            	INSERT INTO speccs.ThriftInterestUploading06temp (EmpCode, UploadDate, RegDate, Amount, ThriftType)
            	VALUES (@EmpCode, @UploadDate, GETDATE(), @Amount, @ThriftType)
            	
            	INSERT INTO speccs.ThriftInterestUploading06temp1 (EmpCode, UploadDate, RegDate, Amount, ThriftType)
            	VALUES (@EmpCode, @UploadDate, GETDATE(), @Amount, @ThriftType)
            	
               --	INSERT INTO speccs.ThriftInterestUploading06temp2 (EmpCode, UploadDate, RegDate, Amount, ThriftType)
              --	VALUES (@EmpCode, @UploadDate, GETDATE(), @Amount, @ThriftType)
        		END
    	END
    
    
		EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@ReceiptNo output
		DECLARE @MemAccNum VARCHAR(15)

		SELECT @MemAccNum=MemAccNo FROM speccs.Members WHERE MemEmpCode=@EmpCode

	   
		 
		INSERT INTO speccs.Payments06082025temp(MemAccNo, PayVoucherNo, VoucherDate, PurposeCode, Amount, ModeOfPayment,Status,RefNo,Remarks,UserId,RegTime)
		VALUES (@MemAccNum, @ReceiptNo, @UploadDate, 'M04', @Amount, 'cheque','ACTIVE',@MemAccNum,'THRIFT INT','SH15823',getdate())

		IF(@@ERROR!=0)
		BEGIN
		RAISERROR 99999 "Error while inserting data in Receipts :speccs.sp_ThriftInterestUpload "
		ROLLBACK TRANSACTION
		RETURN
		END

 
    ------START For adding thrift Int on 01/04/YYYY and removing on UploadDate
 			

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

			  
			     		SELECT TOP 1 @ThriftMaxBal=Max(ThriftBalance)  FROM speccs.ThriftTransactions WHERE MemAccNo=@RefNumber1 AND TransactionDate<@UploadDate  ORDER BY TransactionDate DESC 
  			---   SELECT TOP 1 @ThriftAmtMax=Amount  FROM speccs.ThriftTransactions WHERE MemAccNo=@RefNumber1 AND TransactionDate BETWEEN @Adddate AND @UploadDate ORDER BY RegTime DESC 

     		SELECT TOP 1 @ThriftMinBal=Max(ThriftBalance)  FROM speccs.ThriftTransactions WHERE MemAccNo=@RefNumber1 AND TransactionDate<=@Adddate  ORDER BY TransactionDate DESC 
      	   ---	SELECT TOP 1 @ThriftAmtMin=Amount  FROM speccs.ThriftTransactions WHERE MemAccNo=@RefNumber1 AND TransactionDate BETWEEN @Adddate AND @UploadDate ORDER BY RegTime ASC 

						
		   		EXEC speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNumberT1 output
	
		   	
		   		INSERT INTO speccs.ThriftTransactions(MemAccNo,Month,TransactionDate,ModeOfPayment,Amount,ReceiptNo,UserId,RegTime,ThriftBalance)
				VALUES (@RefNumber1,convert(VARCHAR(8),datepart(mm,@Adddate)),@Adddate,'Thrift Int ADj', @Amount, @ReceiptNumberT1, 'SH15823',getdate(),@ThriftMinBal+@Amount)
				
			    
       			EXEC speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNumberT2 output
      	   		INSERT INTO speccs.ThriftTransactions(MemAccNo,Month,TransactionDate,ModeOfPayment,Amount,ReceiptNo,UserId,RegTime,ThriftBalance)
				VALUES (@RefNumber1,convert(VARCHAR(8),datepart(mm,@UploadDate)),@UploadDate,'Thrift Int Adj', 0-@Amount, @ReceiptNumberT2, 'SH15823',getdate(),@ThriftMaxBal-@Amount)
			  	
     

    --------------END For adding thrift Int on 01/04/YYYY and removing on UploadDate

*/

--SELECT * INTO speccs.ThriftInterestUploading06temp1 FROM speccs.ThriftInterestUploading06temp

---SELECT * INTO speccs.ThriftInterestUploading06temp2 FROM speccs.ThriftInterestUploading06temp



        /* Original Code: -- Type 3 logic was inline */
 
 
 
DECLARE @count INT,@code VARCHAR(50),@Amount1 FLOAT
		SELECT @count=count(*) FROM speccs.ThriftInterestUploading06temp WHERE ThriftType=2 
		SELECT @count
		  
	 WHILE EXISTS (SELECT 1 FROM speccs.ThriftInterestUploading06temp WHERE ThriftType=2 AND UploadDate=@UploadDate )
	   BEGIN
	   
		SELECT  TOP 1 @code=EmpCode FROM speccs.ThriftInterestUploading06temp WHERE ThriftType=2
		SELECT   @Amount1=Amount FROM speccs.ThriftInterestUploading06temp WHERE ThriftType=2 AND EmpCode=@code
	 SELECT @MemAccNum=MemAccNo FROM speccs.Members WHERE MemEmpCode=@code
   
    ---IF @ThriftType = 2 
    --BEGIN
    	EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNumber output
    	DECLARE @RefNo VARCHAR(15)
    	SELECT @RefNo= l.LoanAccNo FROM speccs.Members m,speccs.Loans l WHERE m.MemAccNo=l.MemAccNo AND m.MemEmpCode=@code AND m.Status='ACTIVE'
    
 			IF EXISTS (SELECT * FROM speccs.LoanTransactions06082025temp WHERE LoanAccNo=@RefNo) 
   	 		BEGIN
   	 		
   	 		
				DECLARE @maxTranDate DATE 
	   			SELECT @maxTranDate=max(TransactionDate) FROM speccs.LoanTransactions06082025temp WHERE LoanAccNo=@RefNo
	   			--added for missed receipt transactions start
	   			
					IF(@UploadDate<@maxTranDate)
					BEGIN 
		
			/* Adaptive Server has expanded all '*' elements in the following statement */ 
						SELECT speccs.LoanTransactions06082025temp.LoanAccNo, speccs.LoanTransactions06082025temp.TransactionDate, speccs.LoanTransactions06082025temp.PayCode, speccs.LoanTransactions06082025temp.Amount, speccs.LoanTransactions06082025temp.P_I, speccs.LoanTransactions06082025temp.ReceiptNo, speccs.LoanTransactions06082025temp.Modeofpay, speccs.LoanTransactions06082025temp.ClosingBal, speccs.LoanTransactions06082025temp.RegTime, speccs.LoanTransactions06082025temp.UserId INTO #tempData78 FROM speccs.LoanTransactions06082025temp WHERE convert(DATE,TransactionDate)>@UploadDate AND LoanAccNo=@RefNo
						DECLARE @LoanAccNo VARCHAR(10), @ReceiptNum VARCHAR(14)
						DECLARE @ModeOfPayment	VARCHAR(15),@ClosingBalance NUMERIC(15,2),@purposecode VARCHAR(5), @Message VARCHAR(255)
						DECLARE @txMonth DATETIME, @FromDate DATETIME,@ToDate DATETIME,  @InterestToBePaid INT ,@DepositTypeCode VARCHAR(3)

			
							WHILE EXISTS (SELECT 1 FROM #tempData78)
							BEGIN
			
			    				SELECT TOP 1 @LoanAccNo = LoanAccNo,@ReceiptNum=ReceiptNo FROM #tempData78
			    
								UPDATE speccs.LoanTransactions06082025temp
				  				SET ClosingBal=ClosingBal-@Amount1
				   				WHERE LoanAccNo=@LoanAccNo AND ReceiptNo=@ReceiptNum AND PayCode IN('L23','L24','L26')
				    
			    				DELETE FROM #tempData78 WHERE LoanAccNo=@LoanAccNo AND ReceiptNo=@ReceiptNum 
							END
							
							
						SELECT TOP 1 @ClosingBalance=Min(ClosingBal) FROM speccs.LoanTransactions06082025temp WHERE convert(DATE,TransactionDate)<=@UploadDate AND LoanAccNo=@RefNo AND PayCode IN('L23','L24','L26') ORDER BY TransactionDate desc
					END	--end of missed receipts transactions 
					
		  
		  			
					ELSE
					BEGIN 
						SELECT  @ClosingBalance=ClosingBal
						FROM speccs.LoanTransactions06082025temp
						WHERE LoanAccNo=@RefNo AND P_I='P' AND PayCode IN('L23','L24','L26') AND TransactionDate=(SELECT max(TransactionDate) FROM speccs.LoanTransactions WHERE LoanAccNo=@RefNo)	
					END --end else part
			END	   
 	
 					UPDATE speccs.Loans06082025temp
 					SET LoanSanctionAmount=LoanSanctionAmount-@Amount1,RegTime=getdate()
 					WHERE LoanAccNo=@RefNo AND LoanStatus='RELEASED'
 	 			
   					INSERT INTO speccs.LoanTransactions06082025temp(LoanAccNo,TransactionDate,PayCode,  Amount, P_I, ReceiptNo, Modeofpay, ClosingBal,RegTime,UserId)
   					VALUES (@RefNo,@UploadDate,'L26', @Amount1, 'P', @ReceiptNumber, 'Thrift Int', (@ClosingBalance-@Amount1),getdate(), 'SH15823')
	
   					INSERT INTO speccs.Receipts06082025temp (MemAccNO,ReceiptNo,ReceiptDate,PurposeCode,Amount,ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo,BankCode)
  					VALUES (@MemAccNum,@ReceiptNumber,@UploadDate,'L26',@Amount1,'Cheque','SH15823',getdate(),'ACTIVE','Thrift Int',@RefNo,'')
	
			  --		INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
   				--	VALUES('SH15823',@MemAccNum,@ReceiptNumber,'Thrift Interest Upload',getdate(),'','Thrift Int')
	
	
	
					IF(@@ERROR!=0)
					BEGIN
   	   							SELECT @Message="Error while inserting "+@MemAccNum+" data in LoanTransactions  :speccs.sp_ThriftInterestUpload"
   	   							RAISERROR 99999 @Message
   	   							ROLLBACK TRANSACTION
   								RETURN
					END
    
   --- END
  
    
     DELETE speccs.ThriftInterestUploading06temp WHERE EmpCode=@code
     SELECT @count=@count-1
    END
 
    	EXEC speccs.sp_ThriftType3 @EmpCode,@MemAccNum, @UploadDate, @Amount, @ThriftType
    	
    	
    	--EXEC speccs.sp_ThriftAdj @EmpCode, @UploadDate, @Amount, @ThriftType
    	
    --------------------------Thrift 2-------------------------------------
      -------------999999999999999-------12/08/2025
    
       
END


---------------End 0------------------------------------------


	 
    ----Error because of Multiple Receipt Creation New receipt Not created ---It placed Null if Null exist it will rollback
	 
      	   	   


--DELETE FROM speccs.ThriftInterestUploading06temp1



GO

