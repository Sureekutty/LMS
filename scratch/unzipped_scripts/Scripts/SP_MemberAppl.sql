IF OBJECT_ID ('speccs.SP_MemberAppl') IS NOT NULL
	DROP PROCEDURE speccs.SP_MemberAppl
GO

CREATE  PROCEDURE speccs.SP_MemberAppl


@Option  	   		VARCHAR (20), 
@AccNo 	   		VARCHAR(7)= NULL, 
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
@BankPlace    		VARCHAR(80)=NULL,
@BasicPay 	  		NUMERIC(15,2)=NULL,
@MemDate 	  		DATETIME=NULL,
@Dob   	   	  		DATETIME=NULL,
@RetiredDate  		DATETIME=NULL,
@CareOf 			VARCHAR(25)=NULL,
@CloseDate          DATETIME=NULL,
@SharesReq          INT = NULL,
@ThriftAmt          NUMERIC(13,2) = NULL,
@ThriftSubscription NUMERIC(13,2) = NULL,
@SharePrice         NUMERIC(13,2) = NULL, 
@Remarks			VARCHAR(255)=NULL,
@UserId	 			VARCHAR(7)= NULL,
@Ipaddress          VARCHAR(30)=NULL,
@ApplNoNew			VARCHAR(7) output

AS

/*
	--DROP PROC speccs.SP_MemberAppl
	
	GRANT ALL ON speccs.SP_Members to speccsgroup
*/

   		
   	IF (@Option="NEW") 
  
	BEGIN
	
 
	
	IF EXISTS(SELECT * FROM speccs.Members WHERE MemEmpCode=@MemEmpCode )
	BEGIN
		UPDATE speccs.Members SET 
			PanNo=@PanNo,AadharNo=@AadharNo,MailId=@MailId,Phone=@Phone,OffPhone=@OffPhone,BankAccNo=@BankAccNo,
			IfscCode=@IfscCode,BankName=@BankName,BankAddress=@BankPlace,BankPlace=@BankPlace,MemDate=@Remarks,Status='ACTIVE',CareOf=@CareOf,Remarks=@Remarks,
			UserId=@UserId,RegTime=getdate() WHERE MemEmpCode=@MemEmpCode
			
	DECLARE @AccNo1 VARCHAR(7)
	
   SELECT 	@AccNo1= MemAccNo FROM speccs.Members WHERE MemEmpCode=@MemEmpCode
		UPDATE speccs.MemberAccount SET ThriftSubscriptionAmount=@ThriftSubscription,ThriftBalance=@ThriftAmt,ShareAmount=@SharePrice,NoOfShares=@SharesReq,UserId=@UserId,RegTime=getdate() 
		
		WHERE MemAccNo=@AccNo1
	------------
	DECLARE @ReceiptNumber VARCHAR(15),@Memappdate DATE
	SELECT @Memappdate=MemDate FROM speccs.Members WHERE MemEmpCode=@MemEmpCode 
	
	---Added on 13-10-2025
		EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNumber output
		INSERT INTO speccs.Receipts (MemAccNO,ReceiptNo,ReceiptDate,PurposeCode,Amount,ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo,BankCode)
  					VALUES (@AccNo1,@ReceiptNumber,@Memappdate,'M06',0,'Cheque','SH15823',getdate(),'ACTIVE','Membership',' ',' ')
  					
  					/*
  						INSERT INTO speccs.Receipts (MemAccNO,ReceiptNo,ReceiptDate,PurposeCode,Amount,ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo,BankCode)
  					VALUES (@AccNo1,@ReceiptNumber,@Memappdate,'M06',@SharesReq*10,'Cheque','SH15823',getdate(),'ACTIVE','Membership',' ',@BankName)
  					*/
	---End for 13-10-2025
	---------------
  END
  ELSE BEGIN
	BEGIN TRANSACTION
	            
	            
                
				EXEC  speccs.SP_AutoNumber 'MEMACCNO',NULL ,@ApplNoNew output
				
		INSERT INTO speccs.Members(
			MemAccNo,MemEmpCode,MemName,PanNo,AadharNo,MailId,Designation,Division,Phone,OffPhone,BankAccNo,
			IfscCode,BankName,BankAddress,BankPlace,BasicPay,MemDate,Dob,RetiredDate,Status,CareOf,Remarks,
			UserId,RegTime)
		VALUES (
		 	@ApplNoNew,@MemEmpCode,@MemName,@PanNo,@AadharNo,@MailId,@Designation,@Division,@Phone,@OffPhone,@BankAccNo,
			@IfscCode,@BankName,@BankPlace,@BankPlace,@BasicPay,@Remarks,@Dob,@RetiredDate,'DRAFT',@CareOf,@Remarks,
			@UserId,getdate()
	)
	
		INSERT INTO speccs.MemberAccount(
			MemAccNo,ThriftSubscriptionAmount,ThriftBalance,ShareAmount,NoOfShares,UserId,RegTime)
		VALUES (
		 	@ApplNoNew,@ThriftSubscription,@ThriftAmt,@SharePrice,
			@SharesReq,@UserId,getdate()
	)
		---Added on 13-10-2025
		EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNumber output
		INSERT INTO speccs.Receipts (MemAccNO,ReceiptNo,ReceiptDate,PurposeCode,Amount,ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo,BankCode)
  					VALUES (@AccNo1,@ReceiptNumber,getdate(),'M06',@SharesReq*10,'Cheque','SH15823',getdate(),'ACTIVE','Membership',' ',@BankName)
	---End for 13-10-2025
	---------------
	
	
	
	
	
	
	  COMMIT TRANSACTION
	  END 
	END --if (option=new) 
	
	
		IF (@Option="SUBMIT") 
  
	BEGIN
	
		IF EXISTS(SELECT * FROM speccs.Members WHERE MemEmpCode=@MemEmpCode )
	BEGIN
		UPDATE speccs.Members SET 
			PanNo=@PanNo,AadharNo=@AadharNo,MailId=@MailId,Phone=@Phone,OffPhone=@OffPhone,BankAccNo=@BankAccNo,
			IfscCode=@IfscCode,BankName=@BankName,BankAddress=@BankPlace,BankPlace=@BankPlace,MemDate=@Remarks,Status='ACTIVE',CareOf=@CareOf,Remarks=@Remarks,
			UserId=@UserId,RegTime=getdate() WHERE MemEmpCode=@MemEmpCode
			
  --	DECLARE @AccNo1 VARCHAR(7)
	
   SELECT 	@AccNo1= MemAccNo FROM speccs.Members WHERE MemEmpCode=@MemEmpCode
		UPDATE speccs.MemberAccount SET ThriftSubscriptionAmount=@ThriftSubscription,ThriftBalance=@ThriftAmt,ShareAmount=@SharePrice,NoOfShares=@SharesReq,UserId=@UserId,RegTime=getdate() 
		
		WHERE MemAccNo=@AccNo1
		
			---Added on 13-10-2025
		DECLARE @Appdate DATE 
		SELECT @Appdate=MemDate FROM speccs.Members WHERE MemEmpCode=@MemEmpCode 
		EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNumber output
		INSERT INTO speccs.Receipts (MemAccNO,ReceiptNo,ReceiptDate,PurposeCode,Amount,ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo,BankCode)
  					VALUES (@AccNo1,@ReceiptNumber,@Appdate,'M06',@SharePrice,'Cheque','SH15823',getdate(),'ACTIVE','Membership',' ',@BankName)
	---End for 13-10-2025
	  
  
  END
  ELSE BEGIN
	
	
  
	BEGIN TRANSACTION
	            
	            
                
				EXEC  speccs.SP_AutoNumber 'MEMACCNO',NULL ,@ApplNoNew output
				
		INSERT INTO speccs.Members(
			MemAccNo,MemEmpCode,MemName,PanNo,AadharNo,MailId,Designation,Division,Phone,OffPhone,BankAccNo,
			IfscCode,BankName,BankAddress,BankPlace,BasicPay,MemDate,Dob,RetiredDate,Status,CareOf,Remarks,
			UserId,RegTime)
		VALUES (
		 	@ApplNoNew,@MemEmpCode,@MemName,@PanNo,@AadharNo,@MailId,@Designation,@Division,@Phone,@OffPhone,@BankAccNo,
			@IfscCode,@BankName,@BankPlace,@BankPlace,@BasicPay,@Remarks,@Dob,@RetiredDate,'SUBMIT',@CareOf,@Remarks,
			@UserId,getdate()
	)
		---Added on 13-10-2025
		DECLARE @Appdate1 DATE
		SELECT @Appdate1=MemDate FROM speccs.Members WHERE MemEmpCode=@MemEmpCode 
		EXEC  speccs.SP_AutoNumber "RECEIPTNO",NULL ,@ReceiptNumber output
		INSERT INTO speccs.Receipts (MemAccNO,ReceiptNo,ReceiptDate,PurposeCode,Amount,ModeOfPayment,UserId,RegTime,Status,Remarks,RefNo,BankCode)
  					VALUES (@ApplNoNew,@ReceiptNumber,@Appdate1,'M06',@SharePrice,'Cheque','SH15823',getdate(),'ACTIVE','Membership',' ',@BankName)
	---End for 13-10-2025
	
	
	
	INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@UserId,@MemEmpCode,@ApplNoNew,'user saving membership',getdate(),@Ipaddress,@Remarks)
	
		INSERT INTO speccs.MemberAccount(
			MemAccNo,ThriftSubscriptionAmount,ThriftBalance,ShareAmount,NoOfShares,UserId,RegTime)
		VALUES (
		 	@ApplNoNew,@ThriftSubscription,@ThriftAmt,@SharePrice,
			@SharesReq,@UserId,getdate()
	)
	   
	  COMMIT TRANSACTION
	END
	
	 
	
	END
	
----------------------------------------------------------------------------
	
		IF (@Option="SSUBMIT") 
  
	BEGIN
  
	BEGIN TRANSACTION
	            
	            
                
				EXEC  speccs.SP_AutoNumber 'SMEMACCNO',NULL ,@ApplNoNew output
				
			 
			 INSERT INTO speccs.Staff
	(SMemAccNo,SEmpName,PanNo,AdhaarNo,MailId,Phone,OfficePhone,BasicPay,MemDate,Dob
	,RegDate,RegStatus,CareOf,Remarks,UserID,RegTime)
VALUES (@ApplNoNew,@MemName,@PanNo,@AadharNo,@MailId,@Phone,@OffPhone,@BasicPay,
	getdate(),@Dob,getdate(),'SUBMIT',@CareOf,@Remarks,@UserId,getdate())

	
	INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@UserId,@UserId,@ApplNoNew,'user saving staffmembership',getdate(),@Ipaddress,@Remarks)
	
		INSERT INTO speccs.MemberAccount(
			MemAccNo,ThriftSubscriptionAmount,ThriftBalance,ShareAmount,NoOfShares,UserId,RegTime)
		VALUES (
		 	@ApplNoNew,@ThriftSubscription,@ThriftAmt,@SharePrice,
			@SharesReq,@UserId,getdate()
	)
	
	  COMMIT TRANSACTION
	END

-------------------------------------------------------------
IF (@Option="DRAFTUPDATE") 
  
	BEGIN
  
	BEGIN TRANSACTION
	            
				
		UPDATE speccs.Members SET 
			PanNo=@PanNo,AadharNo=@AadharNo,MailId=@MailId,Phone=@Phone,OffPhone=@OffPhone,BankAccNo=@BankAccNo,
			IfscCode=@IfscCode,BankName=@BankName,BankAddress=@BankPlace,BankPlace=@BankPlace,CareOf=@CareOf,Remarks=@Remarks,
			UserId=@UserId,RegTime=getdate() WHERE MemAccNo=@AccNo
	
		UPDATE speccs.MemberAccount SET ThriftSubscriptionAmount=@ThriftSubscription,ThriftBalance=@ThriftAmt,ShareAmount=@SharePrice,NoOfShares=@SharesReq,UserId=@UserId,RegTime=getdate() 
		
		WHERE MemAccNo=@AccNo
	
	  COMMIT TRANSACTION
	END 
	
	--------------------------------------------------------------
	IF (@Option="SUBMITUPDATE") 
  
	BEGIN
  
	BEGIN TRANSACTION
	            
				
		UPDATE speccs.Members SET 
			PanNo=@PanNo,AadharNo=@AadharNo,MailId=@MailId,Phone=@Phone,OffPhone=@OffPhone,BankAccNo=@BankAccNo,
			IfscCode=@IfscCode,BankName=@BankName,BankAddress=@BankPlace,BankPlace=@BankPlace,CareOf=@CareOf,Remarks=@Remarks,
			UserId=@UserId,RegTime=getdate() WHERE MemAccNo=@AccNo
	
		UPDATE speccs.MemberAccount SET ThriftSubscriptionAmount=@ThriftSubscription,ThriftBalance=@ThriftAmt,ShareAmount=@SharePrice,NoOfShares=@SharesReq,UserId=@UserId,RegTime=getdate() 
		
		WHERE MemAccNo=@AccNo
	
	  COMMIT TRANSACTION
	END
	----------------------------------------------------------
		IF (@Option="SSUBMITUPDATE") 
  
	BEGIN
  
	BEGIN TRANSACTION
	            
				
		UPDATE speccs.Staff SET SEmpName=@MemName, Dob=@Dob,
			PanNo=@PanNo,AdhaarNo=@AadharNo,MailId=@MailId,Phone=@Phone,OfficePhone=@OffPhone,
			CareOf=@CareOf,Remarks=@Remarks,
			UserID=@UserId,RegTime=getdate() WHERE SMemAccNo=@AccNo
	
		UPDATE speccs.MemberAccount SET ThriftSubscriptionAmount=@ThriftSubscription,ThriftBalance=@ThriftAmt,ShareAmount=@SharePrice,NoOfShares=@SharesReq,UserId=@UserId,RegTime=getdate() 
		
		WHERE MemAccNo=@AccNo
	
	  COMMIT TRANSACTION
	END
	------------------------member basic details----------------
   IF (@Option="LOADEMPDATA") 
  
	BEGIN
   
	SELECT DISTINCT A.MemEmpCode,A.MemName,A.Division,A.Designation,A.BasicPay,A.Dob,A.RetiredDate FROM speccs.EmployeeData A WHERE  A.MemEmpCode=@MemEmpCode
   END 
   IF (@Option="PERSONAL") 
  
	BEGIN
	/* Adaptive Server has expanded all '*' elements in the following statement */ SELECT speccs.Members.MemAccNo, speccs.Members.MemEmpCode, speccs.Members.MemName, speccs.Members.PanNo, speccs.Members.AadharNo, speccs.Members.MailId, speccs.Members.Designation, speccs.Members.Division, speccs.Members.Phone, speccs.Members.OffPhone, speccs.Members.BankAccNo, speccs.Members.IfscCode, speccs.Members.BankName, speccs.Members.BankAddress, speccs.Members.BankPlace, speccs.Members.BasicPay, speccs.Members.MemDate, speccs.Members.Dob, speccs.Members.RetiredDate, speccs.Members.Status, speccs.Members.CareOf, speccs.Members.ClosedDate, speccs.Members.Remarks, speccs.Members.UserId, speccs.Members.RegTime FROM speccs.Members where MemEmpCode=@MemEmpCode and Status in ('DRAFT','SUBMIT')
   END
 IF (@Option="SOCIETY") 
  
	BEGIN
	/* Adaptive Server has expanded all '*' elements in the following statement */ SELECT speccs.MemberAccount.MemAccNo, speccs.MemberAccount.MembershipFee, speccs.MemberAccount.ThriftSubscriptionAmount, speccs.MemberAccount.ThriftBalance, speccs.MemberAccount.ShareAmount, speccs.MemberAccount.NoOfShares, speccs.MemberAccount.WelfareFund, speccs.MemberAccount.SERBS, speccs.MemberAccount.Insurance_Loan, speccs.MemberAccount.Insurance_Thrift, speccs.MemberAccount.UserId, speccs.MemberAccount.RegTime FROM speccs.MemberAccount WHERE MemAccNo=@AccNo
   END

  /* 	
  	IF (@Option='UPDATE') 
   	BEGIN

   	BEGIN TRANSACTION 
   		
   		--DELETE FROM speccs.MemberApplications WHERE ApplNo=@ApplNo
   		
   		IF(@@ERROR!=0)
			BEGIN
				RAISERROR 99999 "Error while deleting in Appln :SP_MemberAppl "
				ROLLBACK TRANSACTION
				RETURN
	END
   		
   		
   		UPDATE speccs.MemberApplications SET ApplNo=@ApplNo, EmpCode=@MemEmpCode,Name=@MemName,PanNo=@PanNo,AadharNo=@AadharNo,MailId=@MailId,Designation=@Designation,
   	   Division=@Division,Phone=@Phone,OffPhone=@OffPhone,BankAccNo=@BankAccNo,IfscCode=@IfscCode,
   	   BankName=@BankName,BankPlace=@BankPlace,BasicPay=@BasicPay,ApplDate=@MemDate,Dob=@Dob,SuperAnnuationDate=@RetiredDate,SharesReq=@SharesReq ,
   	   ThriftDeposit=@ThriftAmt,ThriftSub=@ThriftSubscription,SharePrice=@SharePrice,Status='DRAFT',CareOf=@CareOf,Remarks=@Remarks,
   	   UserId=@UserId,RegTime=getdate()  WHERE ApplNo=@ApplNo
   		
   		
   		
   		
			--INSERT INTO speccs.MemberApplications(
			--ApplNo,EmpCode,Name,PanNo,AadharNo,MailId,Designation,Division,Phone,OffPhone,BankAccNo,
			--IfscCode,BankName,BankPlace,BasicPay,ApplDate,Dob,SuperAnnuationDate,SharesReq,ThriftDeposit,ThriftSub,SharePrice,Status,CareOf,
			--Remarks,UserId,RegTime)
		--VALUES (
		   ----	@ApplNo,@MemEmpCode,@MemName,@PanNo,@AadharNo,@MailId,@Designation,@Division,@Phone,@OffPhone,@BankAccNo,
		   --	@IfscCode,@BankName,@BankPlace,@BasicPay,@MemDate,@Dob,@RetiredDate,@SharesReq ,@ThriftAmt,@ThriftSubscription,@SharePrice,'DRAFT',@CareOf,
			--@Remarks,@UserId,getdate()
   --	)
   	IF(@@ERROR!=0)
			BEGIN
				RAISERROR 99999 "Error while updating in Appln :SP_MemberAppl "
				ROLLBACK TRANSACTION
				RETURN
	END
	  
   	   SELECT @ApplNoNew=@ApplNo
		
   	COMMIT TRANSACTION
   
   	
   	END
*/
















GO

