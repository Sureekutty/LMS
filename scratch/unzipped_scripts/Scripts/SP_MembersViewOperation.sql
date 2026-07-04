

IF OBJECT_ID ('speccs.SP_MembersViewOperationModified26022026') IS NOT NULL
	DROP PROCEDURE speccs.SP_MembersViewOperationModified26022026
GO

CREATE PROCEDURE speccs.SP_MembersViewOperationModified26022026
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
			-----------------------------------------------
			
			
			DECLARE @ReceiptNoS VARCHAR(7) 

  			EXEC speccs.SP_AutoNumber "STAFF ECODE",NULL ,@ReceiptNoS output

  
			INSERT INTO speccs.Members (MemAccNo, MemEmpCode, MemName, PanNo, AadharNo, MailId, Designation, Division, Phone, OffPhone,
 			BankAccNo, IfscCode, BankName, BankAddress, BankPlace, BasicPay, MemDate, Dob, RetiredDate, Status, CareOf, ClosedDate, Remarks, UserId, RegTime)
			SELECT s.SMemAccNo,@ReceiptNoS,s.SEmpName,s.PanNo,s.AdhaarNo,s.MailId,s.Remarks,'Speccs',s.Phone,s.OfficePhone, 
			b.Bankaccno,b.Ifsccode,b.Bankname,b.Bankplace,b.Bankplace,s.BasicPay,s.MemDate,s.Dob,'01/01/2030',s.RegStatus,s.CareOf,NULL ,s.Remarks,s.UserID,getDate() 
			FROM speccs.Staff s,speccs.MemberBank b 
			WHERE s.SMemAccNo=@MemAccNo AND s.SMemAccNo=b.MemAccNo 

			
			---------------------------------------------------

		    INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	       VALUES(@UserId,@Memempcode,@MemAccNo,'user Approving StaffMemberView',getdate(),@Ipaddress,@Remarks)
		  
		  UPDATE speccs.MemberAccount  SET MembershipFee=1 WHERE MemAccNo=@MemAccNo
		  
			IF(@@ERROR!=0)
			BEGIN
				RAISERROR 99999 "Error while Registering member :SP_MembersViewOperation"
				ROLLBACK TRANSACTION
				RETURN
			END 
	       
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
	   
			
		  
			
	IF (@Option="Bank")
	BEGIN
		BEGIN TRANSACTION
	 		  
		  -------------------------
		  DECLARE @BAppdate DATE,@BRNO VARCHAR (50),@Bsharecap FLOAT 
		  
		  SELECT @BAppdate= MemDate  FROM speccs.Members WHERE MemAccNo=@MemAccNo 
		  SELECT @Bsharecap= ShareAmount FROM speccs.MemberAccount WHERE MemAccNo=@MemAccNo
		  SELECT @BRNO=ReceiptNo FROM speccs.Receipts WHERE MemAccNO=@MemAccNo AND ReceiptDate=@BAppdate
		  
		  
			----------------------Bank Transaction 24-02-2026 START
DECLARE @BankBalance FLOAT ,@BTransactiondate DATE,@BTransNo VARCHAR(50),@BAmount FLOAT,@BrefNo VARCHAR(50),@Purname VARCHAR(75)

SELECT @BTransactiondate=@BAppdate
SELECT @BTransNo=@BRNO
---For receipts+,For payments-
SELECT @BAmount=@Bsharecap
SELECT @BrefNo=@MemAccNo
SELECT @Purname=Description FROM speccs.TransactionType WHERE PayCode='M06'
SELECT @BankBalance=BankBalance  FROM speccs.BankBalance



    DECLARE @BmaxTranDate DATE
    
    SELECT @BmaxTranDate = MAX(TransactionDate) 
    FROM speccs.BankTransactions
    
     IF (@BTransactiondate < @BmaxTranDate)
    BEGIN
    	 SELECT ReceiptNo, TransactionDate, Amount, BankBalance, PurCode, 
            RefNo, RegTime, UserId 
        INTO #tempB10 
        FROM speccs.BankTransactions
        WHERE CONVERT(DATE, TransactionDate) > @BTransactiondate
        
      DECLARE @Bankbalnce1 FLOAT,@BAmt FLOAT,@BNo VARCHAR(14)
     
     
             SELECT TOP 1 @Bankbalnce1= BankBalance FROM speccs.BankTransactions WHERE TransactionDate>@BTransactiondate  ORDER BY TransactionDate ASC, RegTime ASC
             SELECT  TOP 1 @BAmt= Amount FROM  speccs.BankTransactions WHERE TransactionDate>@BTransactiondate  ORDER BY TransactionDate ASC, RegTime ASC
             SELECT  TOP 1 @BNo= ReceiptNo from speccs.BankTransactions WHERE TransactionDate>@BTransactiondate  ORDER BY TransactionDate ASC, RegTime ASC

      /*  IF (LEFT(@BNo,1) = 'P')
                BEGIN SELECT  @Bankbalnce1 = @Bankbalnce1+ @BAmt
                END
            	ELSE
            	BEGIN
                SELECT  @Bankbalnce1 = @Bankbalnce1-@BAmt
            	END  */
            	SELECT  @Bankbalnce1 = @Bankbalnce1- @BAmt
       
              UPDATE speccs.BankBalance
				SET BankBalance=@BankBalance+@BAmount WHERE BankName='SBI'
				INSERT INTO speccs.BankTransactions (ReceiptNo,TransactionDate,Amount,BankName,BankBalance,PurCode,RefNo,RegTime,UserId)
			VALUES (@BTransNo,@BTransactiondate,@BAmount,'SBI',@Bankbalnce1+@BAmount,@Purname,@BrefNo,getDate(),'SH15823')

               
      DECLARE @CurrentReceiptNo VARCHAR(14), 
                @CurrentAmount DECIMAL(18,2), 
                @CurrentPurCode VARCHAR(10), 
                @CurrentRefNo VARCHAR(10),
                @CurrentBBalance FLOAT, 
                @CurrentTransactionDate DATE, 
                @CurrentRegTime DATETIME  
                
                 WHILE EXISTS (SELECT 1 FROM #tempB10)
       			 BEGIN
                SELECT TOP 1 
                @CurrentReceiptNo       = ReceiptNo,
                @CurrentAmount          = Amount,
                @CurrentPurCode         = PurCode,
                @CurrentRefNo           = RefNo,
                @CurrentBBalance=BankBalance,
                @CurrentTransactionDate = TransactionDate,
                @CurrentRegTime         = RegTime
            	 FROM #tempB10 
           		 ORDER BY TransactionDate ASC, RegTime ASC
                
               /* IF (LEFT(@CurrentReceiptNo,1) = 'R')
                BEGIN SELECT  @CurrentBalance = - @CurrentAmount
                END
            	ELSE
            	BEGIN
                SELECT  @CurrentBalance = @CurrentAmount
            	END */
            	
            	
            UPDATE speccs.BankTransactions
            SET BankBalance =BankBalance + @BAmount
            WHERE RefNo = @CurrentRefNo 
              AND ReceiptNo = @CurrentReceiptNo
            
           
            -- Remove processed row from temp table
            DELETE FROM #tempB10 
            WHERE RefNo = @CurrentRefNo 
              AND ReceiptNo = @CurrentReceiptNo
              
          
              
             
              
              
    END
     
    END
    ELSE
    BEGIN
    SELECT @BankBalance=BankBalance  FROM speccs.BankBalance 
---SELECT @Transdate=Max(TransactionDate) FROM speccs.BankTransactions ORDER BY TransactionDate IN DESC

UPDATE speccs.BankBalance 
SET BankBalance=@BankBalance+@BAmount WHERE BankName='SBI'
INSERT INTO speccs.BankTransactions (ReceiptNo,TransactionDate,Amount,BankName,BankBalance,PurCode,RefNo,RegTime,UserId)
VALUES (@BTransNo,@BTransactiondate,@BAmount,'SBI',@BankBalance+@BAmount,@Purname,@BrefNo,getDate(),'SH15823')

---------------
    
    
    
    END
----------------------Bank Transaction 24-02-2026 END
	
		  
		  
		  
		  -----------------------
	 	
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

