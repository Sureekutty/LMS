IF OBJECT_ID ('speccs.SP_AutoNumber') IS NOT NULL
	DROP PROCEDURE speccs.SP_AutoNumber
GO

CREATE  PROCEDURE speccs.SP_AutoNumber
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
	
	IF EXISTS (SELECT * FROM speccs.AutoNumbers WHERE DataItemName= @Option)
	BEGIN
		
		SELECT @startValue=StartValue,@SlNo=convert(INT,LastUpdatedNo), @LengthOfDataItem=LengthOfDataItem 
		FROM speccs.AutoNumbers WHERE DataItemName= @Option

		SELECT @isDataPresent = 1
	
	END 
   
   	IF (@Option= "MEMAPPNO")  -- 5 digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='AppMembers',@startValue="MA",@LengthOfDataItem=5,@SlNo=1
	   	
   	END
   	
   	ELSE IF (@Option= "MEMACCNO")  
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='Members',@startValue="M",@LengthOfDataItem=5,@SlNo=1
	   	
   	END
   	ELSE IF (@Option= "SMEMACCNO")  
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='Staff',@startValue="S",@LengthOfDataItem=5,@SlNo=1
	   	
   	END
   	ELSE IF (@Option= "RECEIPTNO")  -- 13 digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='Receipts',@startValue="R",@LengthOfDataItem=13,@SlNo=1
	   	
   	END
   	ELSE IF (@Option= "PAYMENTNO")  -- 13 digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='Payments',@startValue="P",@LengthOfDataItem=13,@SlNo=1
	   	
   	END
   	ELSE IF (@Option= "BILLNO")  -- 13 digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='Bills',@startValue="B",@LengthOfDataItem=13,@SlNo=1
	   	
   	END
   	ELSE IF (@Option= "PAYVOUCHER")  -- 13 digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='PayVouchers',@startValue="P",@LengthOfDataItem=13,@SlNo=1
	   	
   	END
   	ELSE IF (@Option= "JVOUCHER")  -- 13 digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='JournalEntries',@startValue="J",@LengthOfDataItem=13,@SlNo=1
	   	
   	END
   	ELSE IF (@Option= "RDNO")  -- 7 digit RD+ 5digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='Deposits',@startValue="RD",@LengthOfDataItem=7,@SlNo=1
	   	
   	END
   	ELSE IF (@Option= "FDNO")  -- 7 digit FD+ 5digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='Deposits',@startValue="FD",@LengthOfDataItem=7,@SlNo=1
	   	
   	END
   	
   	ELSE IF (@Option= "MISNO")  -- 7 digit FD+ 5digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='Deposits',@startValue="MS",@LengthOfDataItem=7,@SlNo=1
	   	
   	END
   	
   	
   	 	ELSE IF (@Option= "SRBNO")  -- 7 digit FD+ 5digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='Deposits',@startValue="SR",@LengthOfDataItem=7,@SlNo=1
	   	
   	END
   -------------------------------------------------------nominee autonumber-----
   	ELSE IF (@Option= "NOMNO")  -- 8 digit NOM+ 5digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='Nominee',@startValue="NOM",@LengthOfDataItem=8,@SlNo=1
	   	
   	END
   	--------------------------------------------------------ending nominee auto number
   	 -------------------------------------------------------address autonumber-----
   	ELSE IF (@Option= "ADRNO")  -- 8 digit ADR+ 5digit running numbers
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='MemAddress',@startValue="ADR",@LengthOfDataItem=8,@SlNo=1
	   	
   	END
   	
   	-------------------------------------ending address------------------------------
   	----------------------------------EXL-----------------------------
   		ELSE IF (@Option= "EXL")  
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='Loans',@startValue="EXL",@LengthOfDataItem=7,@SlNo=1
	   	
   	END
   	-----------------------------FDL-------------------------------
   			ELSE IF (@Option= "FDL")  
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='Loans',@startValue="FDL",@LengthOfDataItem=7,@SlNo=1
	   	
   	END
   	-------------------------------------------------------------------------------
   	ELSE IF (@Option= "RECOVERY")  
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='Loans',@startValue="LR",@LengthOfDataItem=10,@SlNo=1
	   	
   	END
   	----------------------------LTL------------------------------
  	ELSE IF (@Option= "LTL")  
   	BEGIN
	   	 IF (@isDataPresent = 1)
	   	 		SELECT @SlNo= @SlNo+1
	     ELSE
		   	 	SELECT @tableName='Loans',@startValue="LTL",@LengthOfDataItem=7,@SlNo=1
	   	
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
   			UPDATE speccs.AutoNumbers 
	   	 	SET LastUpdatedNo=@NumberGenerated,LastUpdatedTime=getdate(),UserId=suser_name()
	   	 	WHERE DataItemName= @Option
   END
   ELSE   
   BEGIN
   			INSERT INTO speccs.AutoNumbers (TableName, DataItemName, StartValue, StartNo, LengthOfDataItem, LastUpdatedNo,LastUpdatedTime,UserId,RegTime)
	   		VALUES (@tableName, @Option, @startValue,@NumberGenerated, @LengthOfDataItem, @NumberGenerated,getdate(),suser_name(),getdate())
	   	
   END
   
	IF(@@ERROR!=0)
	BEGIN
			SELECT @Message="Error while generating autonumbers for "+@Option+"  :SP_Receipts "
			RAISERROR 99999 @Message
			ROLLBACK TRANSACTION
			RETURN
	END
   
  	SELECT @NumberGenerated =rtrim(ltrim( rtrim(ltrim(StartValue))+LastUpdatedNo)) FROM speccs.AutoNumbers WHERE DataItemName= @Option
   	

   	COMMIT TRANSACTION 

RETURN








GO

