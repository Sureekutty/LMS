
IF OBJECT_ID ('speccs.sp_ThriftInterestUploadTemp') IS NOT NULL
	DROP PROCEDURE speccs.sp_ThriftInterestUploadTemp
GO

CREATE PROCEDURE speccs.sp_ThriftInterestUploadTemp
    @EmpCode     VARCHAR(50),
    @UploadDate  DATETIME,
    @Amount      FLOAT,
    @ThriftType  INT
AS
BEGIN
    -- Declare variables
    DECLARE @EmpCodeExists INT,
            @MemAccNum VARCHAR(15),
            @Message VARCHAR(255),
            @RecordCount INT,
            @SerialNo INT,
            @RefNumber1 VARCHAR(15),
            @Adddate DATETIME,
            @YYYY INT,
            @ThriftMinBal FLOAT,
            @ThriftMaxBal FLOAT,
            @ReceiptNumberT1 VARCHAR(15),
            @ReceiptNumberT2 VARCHAR(15),
            @RefNo VARCHAR(15),
            @ReceiptNumber VARCHAR(15),
            @maxTranDate DATE,
            @ClosingBalance NUMERIC(15,2),
            @oldThrift DECIMAL(15,2),
            @maxTranThriftDate DATE,
            @ThriftBalance DECIMAL(15,2),
            @ReceiptNo VARCHAR(15),
            @TxnIdNum NUMERIC(18,0),
            @DepositClosingBal FLOAT,
            @ReceiptNumberT VARCHAR(15),
            @RefNumber VARCHAR(15)
            

    -- Initialize counter
    SELECT @RecordCount = 1

    -- Create temp table for storing processed records (if not exists)
    IF OBJECT_ID('tempdb..#InputSaved') IS NULL
    BEGIN
        CREATE TABLE #InputSaved (
            SerialNo INT,
            EmpCode VARCHAR(50),
            UploadDate DATETIME,
            Amount FLOAT,
            ThriftType INT,
            MemAccNum VARCHAR(15)
        )
    END

    -- Calculate next SerialNo
    SELECT @SerialNo = COALESCE(MAX(SerialNo), 0) + 1 FROM #InputSaved

    -- Check if EmpCode exists in the table
    SELECT @EmpCodeExists = COUNT(*)
    FROM speccs.ThriftInterestUploading06082025temp
    WHERE EmpCode = @EmpCode
-----------Start 0 ------------
    IF @EmpCodeExists = 0
    BEGIN
        -- If EmpCode does not exist, insert new record
        INSERT INTO speccs.ThriftInterestUploading06082025temp (EmpCode, UploadDate, RegDate, Amount, ThriftType)
        VALUES (@EmpCode, @UploadDate, GETDATE(), @Amount, @ThriftType)
    END
    ELSE
    BEGIN
        -- If EmpCode exists, check if UploadDate matches an existing record
        IF EXISTS (
            SELECT 1 
            FROM speccs.ThriftInterestUploading06082025temp 
            WHERE EmpCode = @EmpCode AND UploadDate = @UploadDate
        )
        BEGIN
            -- Update Amount and ThriftType for the matching record
            UPDATE speccs.ThriftInterestUploading06082025temp
            SET Amount = @Amount,
                ThriftType = @ThriftType,
                RegDate = GETDATE() -- Update RegDate on modification
            WHERE EmpCode = @EmpCode AND UploadDate = @UploadDate
        END
        ELSE
        BEGIN
            -- If UploadDate differs, insert new record for the same EmpCode
            INSERT INTO speccs.ThriftInterestUploading06082025temp (EmpCode, UploadDate, RegDate, Amount, ThriftType)
            VALUES (@EmpCode, @UploadDate, GETDATE(), @Amount, @ThriftType)
        END
    END

    IF(@@ERROR!=0)
    BEGIN
        SELECT @Message = 'Error while inserting/updating ThriftInterestUploading for record ' + convert(VARCHAR(8), @RecordCount) + ' :speccs.sp_ThriftInterestUpload'
        RAISERROR 99999 @Message
        RETURN
    END

    -- Get MemAccNo
    SELECT @MemAccNum=MemAccNo FROM speccs.Members WHERE MemEmpCode=@EmpCode

    IF (@MemAccNum IS NULL)
    BEGIN
        SELECT @Message = 'Member not found for EmpCode ' + @EmpCode + ' for record ' + convert(VARCHAR(8), @RecordCount)
        RAISERROR 99999 @Message
        RETURN
    END

    -- Insert into #InputSaved with calculated SerialNo
    INSERT INTO #InputSaved (SerialNo, EmpCode, UploadDate, Amount, ThriftType, MemAccNum)
    VALUES (@SerialNo, @EmpCode, @UploadDate, @Amount, @ThriftType, @MemAccNum)

    IF(@@ERROR!=0)
    BEGIN
        SELECT @Message = 'Error while inserting into #InputSaved for record ' + convert(VARCHAR(8), @RecordCount) + ' :speccs.sp_ThriftInterestUpload'
        RAISERROR 99999 @Message
        RETURN
    END
---------------End 0------------------------------------------

    -- Process all records in #InputSaved
    WHILE EXISTS (SELECT 1 FROM #InputSaved)
    BEGIN
        -- Get the next record
        SELECT TOP 1 @SerialNo = SerialNo,
                     @EmpCode = EmpCode,
                     @UploadDate = UploadDate,
                     @Amount = Amount,
                     @ThriftType = ThriftType,
                     @MemAccNum = MemAccNum
        FROM #InputSaved
        ORDER BY SerialNo

        -- Increment counter
        SELECT @RecordCount = @RecordCount + 1

        -- Insert into Payments
        EXEC speccs.SP_AutoNumber "PAYMENTNO",NULL ,@ReceiptNo output

        INSERT INTO speccs.Payments06082025temp(MemAccNo, PayVoucherNo, VoucherDate, PurposeCode, Amount, ModeOfPayment,Status,RefNo,Remarks,UserId,RegTime)
        VALUES (@MemAccNum, @ReceiptNo, @UploadDate, 'M04', @Amount, 'cheque','ACTIVE',@MemAccNum,'THRIFT INT','SH15823',getdate())

        IF(@@ERROR!=0)
        BEGIN
            SELECT @Message = 'Error while inserting data in Payments for record ' + convert(VARCHAR(8), @RecordCount) + ' :speccs.sp_ThriftInterestUpload'
            RAISERROR 99999 @Message
            RETURN
        END

        -- Insert into ThriftTransactions
        SELECT @YYYY = DATEPART(YY, GETDATE())
        SELECT @Adddate = CAST('04/01/' + CAST(@YYYY AS VARCHAR(4)) AS DATETIME)

        SELECT @RefNumber1= MemAccNo FROM speccs.Members m WHERE MemEmpCode=@EmpCode AND m.Status='ACTIVE'
       
        DECLARE @MAccNo1 VARCHAR(10), @RecNum1 VARCHAR(14)
     		
        WHILE EXISTS (SELECT 1 FROM #tempData81)
        BEGIN
            SELECT TOP 1 @MAccNo1 = MemAccNo,@RecNum1=ReceiptNo FROM #tempData81
			    
            UPDATE speccs.ThriftTransactions06082025temp
            SET ThriftBalance=ThriftBalance+@Amount
            WHERE MemAccNo=@MAccNo1 AND ReceiptNo=@RecNum1
				    
            DELETE FROM #tempData81 WHERE MemAccNo=@MAccNo1 AND ReceiptNo=@RecNum1
        END
     
        SELECT TOP 1 @ThriftMaxBal=ThriftBalance FROM speccs.ThriftTransactions06082025temp WHERE MemAccNo=@RefNumber1 AND TransactionDate<@UploadDate ORDER BY TransactionDate DESC 
        SELECT TOP 1 @ThriftMinBal=ThriftBalance FROM speccs.ThriftTransactions06082025temp WHERE MemAccNo=@RefNumber1 AND TransactionDate<@Adddate ORDER BY TransactionDate DESC 

		
        SELECT speccs.ThriftTransactions06082025temp.MemAccNo,speccs.ThriftTransactions06082025temp.Month, speccs.ThriftTransactions06082025temp.TransactionDate, speccs.ThriftTransactions06082025temp.ModeOfPayment, speccs.ThriftTransactions06082025temp.Amount, 
        speccs.ThriftTransactions06082025temp.ReceiptNo, speccs.ThriftTransactions06082025temp.UserId, speccs.ThriftTransactions06082025temp.RegTime,speccs.ThriftTransactions06082025temp.ThriftBalance INTO #tempData81 FROM speccs.ThriftTransactions06082025temp WHERE MemAccNo=@RefNumber1 AND TransactionDate>@Adddate AND TransactionDate<@UploadDate
    
        EXEC speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNumberT1 output
      	--WAITFOR DELAY '00:00:02'
      	
      	
        INSERT INTO speccs.ThriftTransactions06082025temp(MemAccNo,Month,TransactionDate,ModeOfPayment,Amount,ReceiptNo,UserId,RegTime,ThriftBalance)
        VALUES (@MemAccNum,convert(VARCHAR(8),datepart(mm,@Adddate)),@Adddate,'Thrift Int ADj', @Amount, @ReceiptNumberT1, 'SH15823',getdate(),COALESCE(@ThriftMinBal,0)+@Amount)
		
		
		--WAITFOR DELAY '00:00:02'
		EXEC speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNumberT2 output
		
		  		
        INSERT INTO speccs.ThriftTransactions06082025temp(MemAccNo,Month,TransactionDate,ModeOfPayment,Amount,ReceiptNo,UserId,RegTime,ThriftBalance)
        VALUES (@MemAccNum,convert(VARCHAR(8),datepart(mm,@UploadDate)),@UploadDate,'Thrift Int Adj', 0-@Amount, @ReceiptNumberT2, 'SH15823',getdate(),COALESCE(@ThriftMaxBal,0)-@Amount)
		
		
		  
        
        

        IF(@@ERROR!=0)
        BEGIN
            SELECT @Message = 'Error while updating ThriftTransactions for record ' + convert(VARCHAR(8), @RecordCount) + ' :speccs.sp_ThriftInterestUpload'
            RAISERROR 99999 @Message
            RETURN
        END
       

        -- Process ThriftType-specific logic
       /* IF @ThriftType = 2
        BEGIN
            EXEC speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNumber output
    
            SELECT @RefNo= l.LoanAccNo FROM speccs.Members m,speccs.Loans l WHERE m.MemAccNo=l.MemAccNo AND m.MemEmpCode=@EmpCode AND m.Status='ACTIVE'
    
            IF EXISTS (SELECT * FROM speccs.LoanTransactions06082025temp WHERE LoanAccNo=@RefNo) 
            BEGIN
                SELECT @maxTranDate=max(TransactionDate) FROM speccs.LoanTransactions WHERE LoanAccNo=@RefNo
                IF(@UploadDate<@maxTranDate)
                BEGIN 
                    SELECT speccs.LoanTransactions06082025temp.LoanAccNo, speccs.LoanTransactions06082025temp.TransactionDate, speccs.LoanTransactions06082025temp.PayCode, speccs.LoanTransactions06082025temp.Amount, speccs.LoanTransactions06082025temp.P_I, speccs.LoanTransactions06082025temp.ReceiptNo, speccs.LoanTransactions06082025temp.Modeofpay, speccs.LoanTransactions06082025temp.ClosingBal, speccs.LoanTransactions06082025temp.RegTime, speccs.LoanTransactions06082025temp.UserId INTO #tempData78 FROM speccs.LoanTransactions06082025temp WHERE convert(DATE,TransactionDate)>@UploadDate AND LoanAccNo=@RefNo
                    DECLARE @LoanAccNo VARCHAR(10), @ReceiptNum VARCHAR(14)
                    DECLARE @ModeOfPayment VARCHAR(15),@purposecode VARCHAR(5)

                    WHILE EXISTS (SELECT 1 FROM #tempData78)
                    BEGIN
                        SELECT TOP 1 @LoanAccNo = LoanAccNo,@ReceiptNum=ReceiptNo FROM #tempData78
                        UPDATE speccs.LoanTransactions06082025temp
                        SET ClosingBal=ClosingBal-@Amount
                        WHERE LoanAccNo=@LoanAccNo AND ReceiptNo=@ReceiptNum
                        DELETE FROM #tempData78 WHERE LoanAccNo=@LoanAccNo AND ReceiptNo=@ReceiptNum
                    END
                    SELECT TOP 1 @ClosingBalance=ClosingBal FROM speccs.LoanTransactions06082025temp WHERE convert(DATE,TransactionDate)<@UploadDate AND LoanAccNo=@RefNo AND PayCode IN('L23','L24','L26') ORDER BY TransactionDate desc
                END
                ELSE
                BEGIN 
                    SELECT @ClosingBalance=ClosingBal
                    FROM speccs.LoanTransactions06082025temp
                    WHERE LoanAccNo=@RefNo AND P_I='P' AND PayCode IN('L23','L24','L26') AND TransactionDate=(SELECT max(TransactionDate) FROM speccs.LoanTransactions06082025temp WHERE LoanAccNo=@RefNo)	
                END
            END	   
 	
            UPDATE speccs.Loans06082025temp
            SET LoanSanctionAmount=LoanSanctionAmount-@Amount,RegTime=getdate()
            WHERE LoanAccNo=@RefNo AND LoanStatus='RELEASED'
 	 			
            INSERT INTO speccs.LoanTransactions06082025temp(LoanAccNo,TransactionDate,PayCode,Amount,P_I,ReceiptNo,Modeofpay,ClosingBal,RegTime,UserId)
            VALUES (@RefNo,@UploadDate,'L26',@Amount,'P',@ReceiptNumber,'Thrift Int',COALESCE(@ClosingBalance,0)-@Amount,getdate(),'SH15823')
	
            INSERT INTO speccs.Receipts06082025temp (MemAccNO,ReceiptNo,ReceiptDate,PurposeCode,Amount,ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo,BankCode)
            VALUES (@MemAccNum,@ReceiptNumber,@UploadDate,'L26',@Amount,'Cheque','SH15823',getdate(),'ACTIVE','Thrift Int',@RefNo,'')
	
         --   INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
          --  VALUES('SH15823',@MemAccNum,@ReceiptNumber,'Thrift Interest Upload for record '+convert(VARCHAR(8),@RecordCount),getdate(),'','Thrift Int')
	
            IF(@@ERROR!=0)
            BEGIN
                SELECT @Message='Error while inserting '+@MemAccNum+' data in LoanTransactions for record '+convert(VARCHAR(8),@RecordCount)+' :speccs.sp_ThriftInterestUpload'
                RAISERROR 99999 @Message
                RETURN
            END
        END
        ELSE IF @ThriftType = 3
        BEGIN
            SELECT @oldThrift=COALESCE(ThriftBalance,0) FROM speccs.MemberAccount WHERE MemAccNo=@MemAccNum
            EXEC speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNumberT output
  
            SELECT @RefNumber= MemAccNo FROM speccs.Members m WHERE MemEmpCode=@EmpCode AND m.Status='ACTIVE'
    			
            IF EXISTS (SELECT * FROM speccs.ThriftTransactions06082025temp WHERE MemAccNo=@RefNumber) 
            BEGIN
                SELECT @maxTranThriftDate =max(TransactionDate) FROM speccs.ThriftTransactions06082025temp WHERE MemAccNo=@RefNumber
                IF(@UploadDate<@maxTranThriftDate)
                BEGIN 
                    SELECT speccs.ThriftTransactions06082025temp.MemAccNo,speccs.ThriftTransactions06082025temp.Month, speccs.ThriftTransactions06082025temp.TransactionDate, speccs.ThriftTransactions06082025temp.ModeOfPayment, speccs.ThriftTransactions06082025temp.Amount, 
                    speccs.ThriftTransactions06082025temp.ReceiptNo, speccs.ThriftTransactions06082025temp.UserId, speccs.ThriftTransactions06082025temp.RegTime,speccs.ThriftTransactions06082025temp.ThriftBalance INTO #tempData79 FROM speccs.ThriftTransactions06082025temp WHERE convert(DATE,TransactionDate)>@UploadDate AND speccs.ThriftTransactions06082025temp.MemAccNo=@RefNumber
                    DECLARE @MAccNo VARCHAR(10), @RecNum VARCHAR(14)
                    DECLARE @ModOfPay VARCHAR(15),@ThriftBal NUMERIC(15,2)

                    WHILE EXISTS (SELECT 1 FROM #tempData79)
                    BEGIN
                        SELECT TOP 1 @MAccNo = MemAccNo,@RecNum=ReceiptNo FROM #tempData79
                        UPDATE speccs.ThriftTransactions06082025temp
                        SET ThriftBalance=ThriftBalance+@Amount
                        WHERE MemAccNo=@MAccNo AND ReceiptNo=@RecNum
                        DELETE FROM #tempData79 WHERE MemAccNo=@MAccNo AND ReceiptNo=@RecNum
                    END
                    SELECT TOP 1 @ThriftBalance=COALESCE(ThriftBalance,0) FROM speccs.ThriftTransactions06082025temp WHERE convert(DATE,TransactionDate)<@UploadDate AND MemAccNo=@RefNumber ORDER BY TransactionDate desc
                END
                ELSE
                BEGIN 
                    SELECT @oldThrift=COALESCE(ThriftBalance,0)
                    FROM speccs.ThriftTransactions06082025temp
                    WHERE MemAccNo=@RefNumber AND TransactionDate=(SELECT max(TransactionDate) FROM speccs.ThriftTransactions06082025temp WHERE MemAccNo=@RefNumber AND convert(DATE,TransactionDate)<=@UploadDate )
                END
            END
	
            SELECT @oldThrift=COALESCE(ThriftBalance,0)
            FROM speccs.ThriftTransactions06082025temp
            WHERE MemAccNo=@RefNumber AND TransactionDate=(SELECT max(TransactionDate) FROM speccs.ThriftTransactions06082025temp WHERE MemAccNo=@RefNumber AND convert(DATE,TransactionDate)<=@UploadDate )	
	
            UPDATE speccs.MemberAccount
            SET ThriftBalance=ThriftBalance+@Amount, UserId='SH15823' ,RegTime=getdate()
            WHERE MemAccNo=@MemAccNum
 	 			
            INSERT INTO speccs.ThriftTransactions06082025temp(MemAccNo,Month,TransactionDate,ModeOfPayment,Amount,ReceiptNo,UserId,RegTime,ThriftBalance)
            VALUES (@MemAccNum,convert(VARCHAR(8),datepart(mm,@UploadDate)),@UploadDate,'Thrift Int', @Amount, @ReceiptNumberT, 'SH15823',getdate(),@oldThrift+@Amount)
		
            INSERT INTO Receipts06082025temp (MemAccNO,ReceiptNo,ReceiptDate,PurposeCode,Amount,ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo,BankCode)
            VALUES (@MemAccNum,@ReceiptNumberT,@UploadDate,'M43',@Amount,'Cheque','SH15823',getDate(),'ACTIVE','Thrift Int',@MemAccNum,'')
	
            SELECT @DepositClosingBal= COALESCE(ThriftBalance,0) FROM speccs.MemberAccount WHERE MemAccNo=@MemAccNum
	
            EXEC speccs.SP_AutoNumber "TxnId",NULL ,@TxnIdNum output
					
            INSERT INTO speccs.DepositTransactions06082025temp(MemaccNo,TxnId,DepositTypeCode,RefNo,Month,TxnDate,ModeOfPayment,Amount,OpeningBalance,ClosingBalance,ReceiptNo,UserId,RegTime)
            VALUES(@MemAccNum,@TxnIdNum,'THR',@MemAccNum,'',@UploadDate,'Thrift Int' ,@Amount,@oldThrift,@DepositClosingBal,@ReceiptNumberT,'SH15823',getdate())		   
	
           -- INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
          --  VALUES('SH15823',@MemAccNum,@ReceiptNumberT,'Receipt Saved for record '+convert(VARCHAR(8),@RecordCount),getdate(),'','Thrift Int')	
	
            IF(@@ERROR!=0)
            BEGIN
                SELECT @Message='Error while inserting '+@MemAccNum+' data in ThriftTransactions for record '+convert(VARCHAR(8),@RecordCount)+' :speccs.sp_ThriftInterestUpload'
                RAISERROR 99999 @Message
                RETURN
            END  
        END

        -- Delete processed record
        
        */
        DELETE FROM #InputSaved WHERE SerialNo = @SerialNo
    END
    
END
GO