IF OBJECT_ID ('speccs.sp_RDUpload') IS NOT NULL
	DROP PROCEDURE speccs.sp_RDUpload
GO

CREATE PROCEDURE speccs.sp_RDUpload
    @EmpCode     VARCHAR(50),
    @UploadDate  DATETIME,
    @Amount      FLOAT,
    @RDNumber	VARCHAR(50)
AS
BEGIN
    -- Declare variable to check if EmpCode exists
    		DECLARE @EmpCodeExists INT
    	 DECLARE @ReceiptNo varchar(13)
    	 DECLARE @MemAccno varchar(15)
    	 
    	 

    -- Check if EmpCode exists in the table
    		SELECT @EmpCodeExists = COUNT(*)
    		FROM speccs.SP_RDUploads
    		WHERE EmpCode = @EmpCode
-----------Start 0 ------------
    	IF @EmpCodeExists = 0
    	BEGIN
        -- If EmpCode does not exist, insert new record
        			INSERT INTO speccs.SP_RDUploads (EmpCode, UploadDate, RegDate, Amount,RDNumber)
       				VALUES (@EmpCode, @UploadDate, getdate(), @Amount,@RDNumber)
       				
       				
       				-----------------------
       				SELECT @MemAccno=MemAccNo FROM speccs.Members WHERE MemEmpCode=@EmpCode
       				EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNo output
   INSERT INTO speccs.Receipts(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
   VALUES (@MemAccno, @ReceiptNo, @UploadDate, 'D20', @Amount, 'RD MONTHLY SUB','',getdate(),'ACTIVE','',@RDNumber)
   
 

   
       				--------------------------
    	END
    	ELSE
    	BEGIN
       		 -- If EmpCode exists, check if UploadDate matches an existing record
        		IF EXISTS (
            		SELECT 1 
            		FROM speccs.SP_RDUploads 
            		WHERE EmpCode = @EmpCode AND UploadDate = @UploadDate AND RDNumber=@RDNumber
        			)
        		BEGIN
            		-- Update Amount and ThriftType for the matching record
            	UPDATE speccs.SP_RDUploads
            	SET Amount = @Amount,
                RegDate = getdate() -- Update RegDate on modification
            	WHERE EmpCode = @EmpCode AND UploadDate = @UploadDate AND RDNumber=@RDNumber
       
       
       
       
       				-----------------------
       			  	SELECT @MemAccno=MemAccNo FROM speccs.Members WHERE MemEmpCode=@EmpCode
       				EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNo output
   INSERT INTO speccs.Receipts(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
   VALUES (@MemAccno, @ReceiptNo, @UploadDate, 'D20', @Amount, 'RD MONTHLY SUB','',getdate(),'ACTIVE','',@RDNumber)
   
   
    	 
       				
        		END
        		ELSE
        		BEGIN
           		 -- If UploadDate differs, insert new record for the same EmpCode
            	INSERT INTO speccs.SP_RDUploads (EmpCode, UploadDate, RegDate, Amount,RDNumber)
            	VALUES (@EmpCode, @UploadDate, getdate(), @Amount,@RDNumber)
            	
            	
            	
       				-----------------------
       					SELECT @MemAccno=MemAccNo FROM speccs.Members WHERE MemEmpCode=@EmpCode
       				EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNo output
       				
       				
   INSERT INTO speccs.Receipts(MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo)
   VALUES (@MemAccno, @ReceiptNo, @UploadDate, 'D20', @Amount, 'RD MONTHLY SUB','',getdate(),'ACTIVE','',@RDNumber)
   
   
       
   
   
       				--------------------------
        		END
    	END
    
    
    
    
          	   	   
END












GO

