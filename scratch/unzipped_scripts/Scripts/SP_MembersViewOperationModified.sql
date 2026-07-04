IF OBJECT_ID ('speccs.SP_MembersViewOperationModified') IS NOT NULL
	DROP PROCEDURE speccs.SP_MembersViewOperationModified
GO

CREATE PROCEDURE speccs.SP_MembersViewOperationModified
@Option  	   		VARCHAR (20), 
@MemAccNo 	   		VARCHAR(5),
@UserId     CHAR (7) ,
@Remarks VARCHAR(250) = NULL,
@Memempcode VARCHAR(8) = NULL,
@Ipaddress VARCHAR(30)=NULL
AS 

--Drop proc speccs.SP_MembersViewOperation

	IF (@Option="REGISTER")
	BEGIN
		BEGIN TRANSACTION
		
		IF EXISTS(SELECT MemAccNo   FROM speccs.Members WHERE @MemAccNo LIKE '%M%')
		
		
	 	 UPDATE speccs.Members 
			SET Status = 'ACTIVE',RegTime = getdate() ,UserId = @UserId,Remarks =@Remarks
			WHERE  MemAccNo = @MemAccNo
		    INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	       VALUES(@UserId,@Memempcode,@MemAccNo,'user Approving MemberView',getdate(),@Ipaddress,@Remarks)
		  
		  UPDATE speccs.MemberAccount  SET MembershipFee=1 WHERE MemAccNo=@MemAccNo
		  
		  
		  
		  
			IF(@@ERROR!=0)
			BEGIN
				RAISERROR 99999 "Error while Registering member :SP_MembersViewOperation"
				ROLLBACK TRANSACTION
				RETURN
			END
		 	
   ELSE
   
   
    	 UPDATE speccs.Staff
			SET RegStatus = 'ACTIVE',RegTime = getdate() ,UserID = @UserId,Remarks =@Remarks
			WHERE SMemAccNo= @MemAccNo
			
		    INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	       VALUES(@UserId,@Memempcode,@MemAccNo,'user Approving StaffMemberView',getdate(),@Ipaddress,@Remarks)
		  
		  UPDATE speccs.MemberAccount  SET MembershipFee=1 WHERE MemAccNo=@MemAccNo
		  
			IF(@@ERROR!=0)
			BEGIN
				RAISERROR 99999 "Error while Registering member :SP_MembersViewOperation"
				ROLLBACK TRANSACTION
				RETURN
			END 
			
		   
		  --Newly Added on 09-12-2025 -Start
		  	DECLARE @ReceiptNumber VARCHAR(15),@Memappdate DATE
	SELECT @Memappdate=MemDate FROM speccs.Members WHERE MemEmpCode=@MemAccNo 
	
	DECLARE @ShareReq NUMERIC
	SELECT @ShareReq=ShareAmount FROM speccs.MemberAccount WHERE MemAccNo=@MemAccNo
	
		  	EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNumber output
		  	
		INSERT INTO speccs.Receipts (MemAccNO,ReceiptNo,ReceiptDate,PurposeCode,Amount,ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo,BankCode)
  					VALUES (@MemAccNo,@ReceiptNumber,@Memappdate,'M06',@ShareReq,'Cheque','SH15823',getdate(),'ACTIVE','Membership',' ',' ')
  			   --Newly Added on 09-12-2025 -End 
		 
	       
		COMMIT TRANSACTION
	END
	IF (@Option="CANCEL")
	BEGIN
		BEGIN TRANSACTION
	 	 UPDATE speccs.Members 
			SET Status = 'CANCEL',RegTime = getdate(),Remarks =  @Remarks ,UserId = @UserId
			WHERE  MemAccNo = @MemAccNo
			IF(@@ERROR!=0)
			BEGIN
				RAISERROR 99999 "Error while Registering member :SP_MembersViewOperation"
				ROLLBACK TRANSACTION
				RETURN
			END
		COMMIT TRANSACTION
	END


 /*	IF (@Option="CANCEL")
	BEGIN
	
		BEGIN TRANSACTION
		
		DECLARE @isDataPresent INT
		SELECT @isDataPresent=0
		
		    IF EXISTS (SELECT surity.SMemAccNo FROM speccs.Surety surity WHERE surity.SMemAccNo='00002' AND IsActive='Y' )
        	BEGIN
	         SELECT  @isDataPresent=1
	       
	         	RAISERROR 99999 "Error while Canceling member present in surety table:SP_MembersViewOperation"
				ROLLBACK TRANSACTION
				RETURN
         	END
         	
         	
         	IF(@isDataPresent=0)
         	BEGIN
         
		  	UPDATE speccs.Members 
			SET Status = 'CANCELED',RegTime = getdate(), ClosedDate = getdate(),
			Remarks =  @Remarks ,UserId = @UserId
			WHERE  MemAccNo = @MemAccNo
					
			IF(@@ERROR!=0)
			BEGIN
				RAISERROR 99999 "Error while Canceling member :SP_MembersViewOperation"
				ROLLBACK TRANSACTION
				RETURN
			END
			END
			
		COMMIT TRANSACTION
	END
	
 */












GO

