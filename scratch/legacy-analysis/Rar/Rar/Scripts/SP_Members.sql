IF OBJECT_ID ('speccs.SP_Members') IS NOT NULL
	DROP PROCEDURE speccs.SP_Members
GO

CREATE  PROCEDURE speccs.SP_Members


--DROP PROC speccs.SP_Members

@Option  	   		VARCHAR (20), 
@MemAccNo 	   		VARCHAR(5)= NULL, 
@MemEmpCode    		VARCHAR(7)= NULL,
@MemName 			VARCHAR(50)= NULL,
@PanNo 		   		VARCHAR(10)=NULL,
@AadharNo 	   		VARCHAR(12)=NULL,
@MailId 	   		VARCHAR(50)=NULL,
@Designation   		VARCHAR(50)=NULL,
@Division 	  		VARCHAR(50)=NULL,
@Phone 		  		VARCHAR(12)=NULL,
@OffPhone 	  		VARCHAR(12)=NULL,
@BankAccNo 	  		VARCHAR(15)=NULL,
@IfscCode  	  		VARCHAR(11)=NULL,
@BankName 	  		VARCHAR(50)=NULL,
@BankAddress  		VARCHAR(80)=NULL,
@BankPlace    		VARCHAR(80)=NULL,
@BasicPay 	  		NUMERIC(15,2)=NULL,
@MemDate 	  		DATETIME=NULL,
@Dob   	   	  		DATETIME=NULL,
@RetiredDate  		DATETIME=NULL,
@RegStatus 	  		VARCHAR(5)=NULL,
@CareOf 			VARCHAR(25)=NULL,
@ShareCapital		NUMERIC(15,2)=NULL,
@Share			    INT=NULL,
@NomName	   		VARCHAR(25)= NULL,
@NomDateOfBirth	  	DATETIME= NULL,
@NomRelation		VARCHAR(25)= NULL,
@NomGender			VARCHAR(10)= NULL,
@EntranceFee		NUMERIC(15,2)=NULL,
@ThriftAmt  NUMERIC(13,2) = NULL,
@ThriftSubscription INT = 0,
@Remarks			VARCHAR(255)=NULL,
@UserId	 			VARCHAR(7)= NULL,
@ThriftRecieptNo CHAR(14) output,
@ShareRecieptNo CHAR(14) output,
@EntranceFeeRecieptNo CHAR(14) output,
@MemAccNoNew VARCHAR(5) output

AS

/*
	DROP PROCEDURE  speccs.SP_Members
	
	GRANT ALL ON speccs.SP_Members to speccsgroup
*/


select  @ThriftRecieptNo = ''
select  @ShareRecieptNo = ''
select  @EntranceFeeRecieptNo  = ''
   
   		
   	IF (@Option="SAVE") 
  
	BEGIN
  
	BEGIN TRANSACTION
	

				EXEC  speccs.SP_AutoNumber 'MEMACCNO',NULL ,@MemAccNoNew output
		INSERT INTO speccs.Members(
			MemAccNo,MemEmpCode,MemName,PanNo,AadharNo,MailId,Designation,Division,Phone,OffPhone,BankAccNo,
			IfscCode,BankName,BankAddress,BankPlace,BasicPay,MemDate,Dob,RetiredDate,Status,CareOf,
			Remarks,UserId,RegTime)
		VALUES (
		 	@MemAccNoNew,@MemEmpCode,@MemName,@PanNo,@AadharNo,@MailId,@Designation,@Division,@Phone,@OffPhone,@BankAccNo,
			@IfscCode,@BankName,@BankAddress,@BankPlace,@BasicPay,@MemDate,@Dob,@RetiredDate,'NEW',@CareOf,
			@Remarks,@UserId,getdate()
	)
   	IF(@@ERROR!=0)
			BEGIN
				RAISERROR 99999 "Error while saving in Members :SP_Members "
				ROLLBACK TRANSACTION
				RETURN
	END
	  INSERT INTO speccs.MemberAccount(
	  		MemAccNo,MembershipFee,ThriftSubscriptionAmount,ThriftBalance,ShareAmount,NoOfShares
			,UserId,RegTime)
		VALUES 	(
		@MemAccNoNew,@EntranceFee,@ThriftSubscription,@ThriftAmt,@ShareCapital,@Share,  
		@UserId,getdate()
	)
	IF(@@ERROR!=0)
			BEGIN
				RAISERROR 99999 "Error while saving MemberAccount :SP_Members "
				ROLLBACK TRANSACTION
				RETURN
	END
	
	
	INSERT INTO speccs.Nominee
	(MemAccNo,NomName,Relationship,Gender,Status,UserId,RegTime)
	VALUES 
	(@MemAccNoNew,@NomName,@NomRelation,@NomGender,'ACTIVE',@UserId,getdate())

	IF(@@ERROR!=0)
	BEGIN
		RAISERROR 99999 "Error while saving Nominee :SP_Members "
		ROLLBACK TRANSACTION
		RETURN
	END
	
	 EXEC speccs.SP_Receipts  'SAVE',@MemAccNoNew,@MemDate,'M01',
	 @EntranceFee,'CASH',@MemAccNoNew,@UserId,@Remarks,@EntranceFeeRecieptNo output
	     
	   
	IF(@@ERROR!=0)
			BEGIN
				RAISERROR 99999 "Error while saving SP_Receipts ('M01') :SP_Members "
				ROLLBACK TRANSACTION
				RETURN
	END
	
	-- share capital
    EXEC speccs.SP_Receipts  'SAVE',@MemAccNoNew,@MemDate,'M06',
	 @ShareCapital,'CASH',@MemAccNoNew,@UserId,@Remarks,@ShareRecieptNo output
	IF(@@ERROR!=0)
	BEGIN
				RAISERROR 99999 "Error while saving SP_Receipts ('M06') :SP_Members "
				ROLLBACK TRANSACTION
				RETURN
	END
	
	/*
	INSERT INTO speccs.Shares
	(MemAccNo,FromDate,ModeOfPayment,IssuedShare,TotalSubscribedShare,CapitalAmount,
	ReceiptNo,UserId,RegTime)
	VALUES 
	(@MemAccNoNew,@MemDate,'CASH',@Share,@Share,@ShareCapital,
	@ShareRecieptNo,@UserId,getdate()
	)
	IF(@@ERROR!=0)
	   BEGIN
			RAISERROR 99999 "Error while saving Shares :SP_Members "
			ROLLBACK TRANSACTION
			RETURN
	END
*/
	
	-- thrift amount
	IF(@ThriftAmt > 0)
	BEGIN
	--	 EXEC speccs.SP_Receipts  'SAVE',@MemAccNoNew,@MemDate,'M03',@ThriftAmt,'CASH',@MemAccNoNew,@Share,@UserId,'N',@ShareRecieptNo output
	      
	     EXEC speccs.SP_Receipts  'SAVE',@MemAccNoNew,@MemDate,'M03',
	 @ThriftAmt,'CASH',@MemAccNoNew,@UserId,@Remarks,@ThriftRecieptNo output
	   
	IF(@@ERROR!=0)
			BEGIN
				RAISERROR 99999 "Error while saving SP_Receipts ('M03') :SP_Members "
				ROLLBACK TRANSACTION
				RETURN
  		END

	INSERT INTO speccs.ThriftTransactions
	(MemAccNo,Month,TransactionDate,ModeOfPayment,Amount,
	ReceiptNo,UserId,RegTime,ThriftBalance)
	VALUES 
	(@MemAccNoNew,@MemDate,@MemDate,'CASH',@ThriftAmt,
	@ThriftRecieptNo,@UserId,getdate(),@ThriftAmt)

	IF(@@ERROR!=0)
		BEGIN
				RAISERROR 99999 "Error while saving ThriftTransactions  :SP_Members "
				ROLLBACK TRANSACTION
		RETURN
	END		
	END
	COMMIT TRANSACTION

   	END    
  	IF (@Option='UPDATE') 
   	BEGIN

   	BEGIN TRANSACTION 
   		INSERT INTO speccs.MembersHistory
	(
	MemAccNo,	MemEmpCode,MemName,PanNo,AadharNo,MailId,Designation,Division,Phone,OffPhone,BankAccNo,
	IfscCode,BankName,BankAddress,BankPlace,BasicPay,MemDate,Dob,RetiredDate,Status,CareOf,ClosedDate,
	Remarks,UserId,RegTime)
   	SELECT 	
   	MemAccNo,MemEmpCode,MemName,PanNo,AadharNo,MailId,Designation,Division,Phone,OffPhone,BankAccNo,
	IfscCode,BankName,BankAddress,BankPlace,BasicPay,MemDate,Dob,RetiredDate,Status,CareOf,ClosedDate,
	Remarks,UserId,RegTime
	FROM speccs.Members
	WHERE MemAccNo = @MemAccNo
		IF(@@ERROR!=0)
		BEGIN
			RAISERROR 99999 "Error while updating data in MembersHistory :SP_Members "
			ROLLBACK TRANSACTION
			RETURN
		END
			UPDATE speccs.Members 
			SET MailId = @MailId, PanNo = @PanNo, AadharNo = @AadharNo ,
				Phone  = @Phone,OffPhone = @OffPhone,BankAccNo=@BankAccNo, IfscCode =@IfscCode, 
				BankName =@BankName, BankAddress =@BankAddress, BankPlace =@BankAddress,Remarks=@Remarks  ,
				CareOf =@CareOf,
				UserId=@UserId,
				RegTime = getdate()
			WHERE  MemAccNo = @MemAccNo

   			IF(@@ERROR!=0)
			BEGIN
				RAISERROR 99999 "Error while updating data in Members :SP_Members"
				ROLLBACK TRANSACTION
				RETURN
			END

			UPDATE  speccs.Nominee 
			SET NomName = @NomName,Relationship =@NomRelation,
		   --	 NomDOB=@NomDateOfBirth, Gender=@NomGender,
				UserId=@UserId,RegTime = getdate()
			WHERE  MemAccNo = @MemAccNo
			IF(@@ERROR!=0)
			BEGIN
				RAISERROR 99999 "Error while updating data in Nominee :SP_Members"
				ROLLBACK TRANSACTION
				RETURN
			END	
		
   	COMMIT TRANSACTION
   	
   	
   	END








GO

