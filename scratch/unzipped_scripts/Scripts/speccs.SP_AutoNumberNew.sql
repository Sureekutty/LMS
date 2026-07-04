IF OBJECT_ID ('speccs.SP_AutoNumberNew') IS NOT NULL
	DROP PROCEDURE speccs.SP_AutoNumberNew
GO

CREATE  PROCEDURE speccs.SP_AutoNumberNew
@Option  		VARCHAR (20),
@LoanType 		VARCHAR(3)=NULL,
@NumberGenerated VARCHAR(14) OUTPUT
AS

/*
	DROP PROCEDURE  speccs.SP_AutoNumber
	GRANT ALL ON speccs.SP_AutoNumber to speccsgroup
	
	declare @num varchar(14)
	exec speccs.SP_AutoNumber "LOANAPPNO","MEMACCNO",'JHF' output
	select @num
*/
	
	
	DECLARE @LengthOfDataItem INT, @LastUpdatedNo VARCHAR(12),@SlNo INT ,@isDataPresent INT,@startValue VARCHAR(5),@tableName VARCHAR(50),@Message VARCHAR(255)
	SELECT @isDataPresent = 0
	
	BEGIN TRANSACTION 
	
	IF EXISTS (SELECT * FROM speccs.AutoNumbersTemp12092025 WHERE DataItemName= @Option)
	BEGIN
		
		SELECT @startValue=StartValue,@SlNo=convert(INT,LastUpdatedNo), @LengthOfDataItem=LengthOfDataItem 
		FROM speccs.AutoNumbersTemp12092025 WHERE DataItemName= @Option

		SELECT @isDataPresent = 1
	
	END 
   
   	IF (@Option= "MEMAPPNO")  -- 5 digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='AppMembersTemp12092025',@startValue="MA",@LengthOfDataItem=5,@SlNo=1
	   	
   	END
   	
   	ELSE IF (@Option= "TxnId1")  -- 5 digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='DepositTransactionsTemp12092025',@startValue=convert(VARCHAR(8),1),@LengthOfDataItem=13,@SlNo=1
	   	
   	END
   	
   	ELSE IF (@Option= "MEMACCNO")  
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='MembersTemp12092025',@startValue="M",@LengthOfDataItem=5,@SlNo=1
	   	
   	END
   	ELSE IF (@Option= "SMEMACCNO")  
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='StaffTemp12092025',@startValue="S",@LengthOfDataItem=5,@SlNo=1
	   	
   	END
   	ELSE IF (@Option= "RECEIPTNO")  -- 13 digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='ReceiptsTemp12092025',@startValue="R",@LengthOfDataItem=13,@SlNo=1
	   	
   	END
   	ELSE IF (@Option= "PAYMENTNO")  -- 13 digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='PaymentsTemp12092025',@startValue="P",@LengthOfDataItem=13,@SlNo=1
	   	
   	END
   	ELSE IF (@Option= "BILLNO")  -- 13 digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='BillsTemp12092025',@startValue="B",@LengthOfDataItem=13,@SlNo=1
	   	
   	END
   	ELSE IF (@Option= "PAYVOUCHER")  -- 13 digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='PayVouchersTemp12092025',@startValue="P",@LengthOfDataItem=13,@SlNo=1
	   	
   	END
   	ELSE IF (@Option= "JVOUCHER")  -- 13 digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='JournalEntriesTemp12092025',@startValue="J",@LengthOfDataItem=13,@SlNo=1
	   	
   	END
   	ELSE IF (@Option= "RDNO")  -- 7 digit RD+ 5digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='DepositsTemp12092025',@startValue="RD",@LengthOfDataItem=7,@SlNo=1
	   	
   	END
   	ELSE IF (@Option= "FDNO")  -- 7 digit FD+ 5digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='DepositsTemp12092025',@startValue="FD",@LengthOfDataItem=7,@SlNo=1
	   	
   	END
   	
   	ELSE IF (@Option= "MISNO")  -- 7 digit FD+ 5digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='DepositsTemp12092025',@startValue="MS",@LengthOfDataItem=7,@SlNo=1
	   	
   	END
   	
   	
   	 	ELSE IF (@Option= "SRBNO")  -- 7 digit FD+ 5digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='DepositsTemp12092025',@startValue="SR",@LengthOfDataItem=7,@SlNo=1
	   	
   	END
   -------------------------------------------------------nominee autonumber-----
   	ELSE IF (@Option= "NOMNO")  -- 8 digit NOM+ 5digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='NomineeTemp12092025',@startValue="NOM",@LengthOfDataItem=8,@SlNo=1
	   	
   	END
   	--------------------------------------------------------ending nominee auto number
   	 -------------------------------------------------------address autonumber-----
   	ELSE IF (@Option= "ADRNO")  -- 8 digit ADR+ 5digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='MemAddressTemp12092025',@startValue="ADR",@LengthOfDataItem=8,@SlNo=1
	   	
   	END
   	
   	-------------------------------------ending address------------------------------
   	----------------------------------EXL-----------------------------
   		ELSE IF (@Option= "EXL")  
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='LoansTemp12092025',@startValue="EXL",@LengthOfDataItem=7,@SlNo=1
	   	
   	END
   	-----------------------------FDL-------------------------------
   			ELSE IF (@Option= "FDL")  
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='LoansTemp12092025',@startValue="FDL",@LengthOfDataItem=7,@SlNo=1
	   	
   	END
   	-------------------------------------------------------------------------------
   	ELSE IF (@Option= "RECOVERY")  
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='LoansTemp12092025',@startValue="LR",@LengthOfDataItem=10,@SlNo=1
	   	
   	END
   	----------------------------LTL------------------------------
  	ELSE IF (@Option= "LTL")  
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='LoansTemp12092025',@startValue="LTL",@LengthOfDataItem=7,@SlNo=1
	   	
   	END
   	ELSE
   	BEGIN
   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='',@startValue="",@SlNo=1
   	END
   	
   SELECT @NumberGenerated=replicate("0",@LengthOfDataItem-(datalength(convert(VARCHAR(10),@SlNo))
   	+CASE WHEN (@startValue="" ) THEN 0
    ELSE datalength(@startValue) END ))+convert(char,@SlNo)
	   	  
	   	  
	   	  
	   	  
   IF (@isDataPresent = 1)
   BEGIN 
   			UPDATE speccs.AutoNumbersTemp12092025
	   	 	SET LastUpdatedNo=@NumberGenerated,LastUpdatedTime=getdate(),UserId=suser_name()
	   	 	WHERE DataItemName= @Option
   END
   ELSE   
   BEGIN
   			INSERT INTO speccs.AutoNumbersTemp12092025 (TableName, DataItemName, StartValue, StartNo, LengthOfDataItem, LastUpdatedNo,LastUpdatedTime,UserId,RegTime)
	   		VALUES (@tableName, @Option, @startValue,@NumberGenerated, @LengthOfDataItem, @NumberGenerated,getdate(),suser_name(),getdate())
	   	
   END
   
   
   
	IF(@@ERROR!=0)
	BEGIN
			SELECT @Message="Error while generating autonumbers for "+@Option+"  :SP_ReceiptsNew "
			RAISERROR 99999 @Message
			ROLLBACK TRANSACTION
			RETURN
	END
   
  	SELECT @NumberGenerated =rtrim(ltrim( rtrim(ltrim(StartValue))+LastUpdatedNo)) FROM speccs.AutoNumbersTemp12092025 WHERE DataItemName= @Option
   	

   	COMMIT TRANSACTION 

RETURN










GO

