IF OBJECT_ID ('speccs.SP_Surety') IS NOT NULL
	DROP PROCEDURE speccs.SP_Surety
GO

CREATE  PROCEDURE speccs.SP_Surety
@Option  		VARCHAR (20),
@MemAccNo  		VARCHAR(10)= NULL,
@LoanAccNo		VARCHAR(10)=NULL,
@SuretyOrder  	INT= NULL,
@Surety1        VARCHAR(7)=NULL,
@Surety2        VARCHAR(7)=NULL,
@Surety3        VARCHAR(7)=NULL,
@Status 		VARCHAR(10)=NULL,
@Ipaddress      VARCHAR(30)=NULL,
@UserId	 		VARCHAR(7)= NULL

AS

/*
	DROP PROCEDURE  speccs.SP_Surety
	
	speccs.SP_Surety "MEMELGTOBSURETY",'00003'
	GRANT Execute ON speccs.SP_Surety TO speccsgroup
	GRANT ALL ON speccs.SP_Surety to speccsgroup

   --	IF (@Option="SAVE") 
   BEGIN
		
	 --	BEGIN TRANSACTION
		
	  INSERT INTO speccs.Surety
		VALUES (@MemAccNo,  @LoanAccNo, @SuretyOrder, @Status, @UserId, getdate())
		RETURN
		
	
		IF(@@ERROR!=0)
		BEGIN
			RAISERROR 99999 "Error while inserting data in Surety :SP_Surety "
			ROLLBACK TRANSACTION
			RETURN
		END
		
	  	COMMIT TRANSACTION
	END
   ELSE IF (@Option="UPDATE") 
  BEGIN
		
		BEGIN TRANSACTION
		
	   	UPDATE  speccs.Surety
		SET	 IsActive=@Status, UserId=@UserId, RegTime=getdate()
		WHERE SMemAccNo=@MemAccNo AND LoanAccNo=@LoanAccNo AND SuretyOrder=@SuretyOrder
		
		IF(@@ERROR!=0)
		BEGIN
			RAISERROR 99999 "Error while updating data in Surety :SP_Surety "
			ROLLBACK TRANSACTION
			RETURN
		END
		
	  	COMMIT TRANSACTION
	END 
	--ELSE IF (@Option="MEMELGTOBSURETY") 
  BEGIN
   
   DECLARE @MaxSuretyCount INT	
	SELECT @MaxSuretyCount=RuleValue FROM speccs.Rules WHERE RuleCode = '105'	

-- getting all the members who's status is ACTIVE
	SELECT mem.MemAccNo,mem.MemName,acc.ThriftBalance  INTO  #Sur
	FROM speccs.Members mem 
	LEFT JOIN speccs.MemberAccount acc
	ON mem.MemAccNo = acc.MemAccNo
	WHERE mem.Status = 'ACTIVE' AND datediff(yy,getdate(),mem.RetiredDate) > 2

-- getting existing surities 
	SELECT SMemAccNo,count(LoanAccNo) AS NOOFSURETY INTO #Surcoun
	FROM speccs.Surety 
	WHERE IsActive="Y"
	GROUP BY SMemAccNo
	HAVING (count(LoanAccNo) <@MaxSuretyCount)

	SELECT sur.MemAccNo+'-'+sur.MemName+'-'+convert(VARCHAR,sur.ThriftBalance) AS sureties
	FROM #Sur sur 
	LEFT JOIN #Surcoun count1
	ON count1.SMemAccNo = sur.MemAccNo AND count1.NOOFSURETY < 3
	WHERE sur.MemAccNo != @MemAccNo
		
	END 
 	 
	ELSE IF (@Option="MEMGIVNSURETY") 
   BEGIN
	
	   SELECT A.SMemAccNo, B.MemAccNo AS lonee, C.MemEmpCode AS LoneeEmployeeCode
		FROM speccs.Surety A, speccs.Loans B,speccs.Members C
		WHERE A.IsActive="Y"
		AND A.LoanAccNo=B.LoanAccNo
		AND B.ClosedOnDate=NULL 
    	AND B.LoanStatus="SANCTION"
		AND B.MemAccNo=C.MemAccNo
		AND C.ClosedDate=NULL
		AND (A.SMemAccNo=@MemAccNo OR A.SMemAccNo=(SELECT MemAccNo FROM speccs.Members WHERE MemEmpCode= @MemAccNo) ) 
	  	
	END    
	*/
	--surety insertion
		IF (@Option="SAVE") 
   BEGIN
   
   --Added to resolve the Problem of More Surety for Same Member on 28/01/2026
   DELETE FROM speccs.Surety WHERE MemAccNo=@MemAccNo
		
	 --	BEGIN TRANSACTION
	 
	 /* 	INSERT INTO speccs.Surety
		VALUES (@MemAccNo,@Surety1, 0, 'Y', @UserId, getdate())
		INSERT INTO speccs.Surety
		VALUES (@MemAccNo,@Surety2, 0, 'Y', @UserId, getdate())
		INSERT INTO speccs.Surety
		VALUES (@MemAccNo,@Surety3, 0, 'Y', @UserId, getdate())	*/
		
		SELECT @Surety1 AS SurMem INTO #tempSurety
		UNION SELECT @Surety2
		UNION SELECT @Surety3
		
		DECLARE @smem VARCHAR(10)
		
		WHILE EXISTS (SELECT 1 FROM #tempSurety)
		BEGIN
			SELECT TOP 1 @smem=SurMem FROM #tempSurety
			
		IF NOT EXISTS(SELECT * FROM speccs.Surety WHERE MemAccNo=@MemAccNo AND SMemAccNo=@smem)
		BEGIN
			INSERT INTO speccs.Surety
			VALUES (@MemAccNo,@smem, 0, 'Y', @UserId, getdate())
		END
		
		DELETE FROM #tempSurety WHERE SurMem = @smem
		END 
		
		RETURN
		
	
		IF(@@ERROR!=0)
		BEGIN
			RAISERROR 99999 "Error while inserting data in Surety :SP_Surety "
			ROLLBACK TRANSACTION
			RETURN
		END
		
	  	COMMIT TRANSACTION
	END
	
--Surety Eligibility
IF (@Option="MEMELGTOBSURETY") 
  BEGIN
   
   DECLARE @MaxSuretyCount INT	
	SELECT @MaxSuretyCount=RuleValue FROM speccs.Rules WHERE RuleCode = '105'	

-- getting all the members who's status is ACTIVE
	SELECT mem.MemAccNo,mem.MemName,acc.ThriftBalance  INTO  #SurMember
	FROM speccs.Members mem 
	LEFT JOIN speccs.MemberAccount acc
	ON mem.MemAccNo = acc.MemAccNo
	WHERE mem.Status = 'ACTIVE' AND datediff(yy,getdate(),mem.RetiredDate) >=2

-- getting existing surities changed on 26/07/2024 by pn
	
	SELECT MemAccNo,SMemAccNo,count(SMemAccNo) AS NOOFSURETY INTO #Surities
	FROM speccs.Surety 
	WHERE Status="Y"
	GROUP BY MemAccNo
	HAVING (count(SMemAccNo) <=@MaxSuretyCount)
	

	SELECT sur.MemAccNo+'-'+sur.MemName+'-'+convert(VARCHAR,sur.ThriftBalance) AS sureties,count1.NOOFSURETY
	FROM #SurMember sur 
	LEFT JOIN #Surities count1
	ON count1.MemAccNo = sur.MemAccNo AND count1.NOOFSURETY <= 4
	WHERE sur.MemAccNo = @MemAccNo
		
	END 

 IF (@Option='MEMSURETYDETAIL') 
	BEGIN
 
  SELECT loan.MemAccNo+"-"+mem.MemEmpCode+"-"+loan.LoanAccNo+"-"+mem.MemName AS 'LonedPerson' ,loanAcc.LoanSanctionAmount
FROM speccs.Loans loanAcc

LEFT JOIN speccs.Loans loan  ON   loanAcc.LoanAccNo=loan.LoanAccNo
LEFT JOIN speccs.Members mem ON   mem.MemAccNo=loan.MemAccNo
WHERE loanAcc.LoanAccNo  LIKE '%LTL%'	--loan.LoanStatus IN ('FRESH') changed by pn on 21/04/2025 
RETURN
END


 IF (@Option='UPDATESURETY') 
	BEGIN

UPDATE speccs.Loans  SET Surety1=@Surety1,Surety2=@Surety2 ,Surety3=@Surety3 ,UserId =@UserId,RegTime=getdate() WHERE LoanAccNo=@LoanAccNo

UPDATE speccs.Loanstatus SET Surety1=@Surety1,Surety2=@Surety2 ,Surety3=@Surety3 ,UserId =@UserId,RegTime=getdate() WHERE LoanAccNo=@LoanAccNo

--added by pn on 22/04/2025 to insert in surety table start
SELECT @Surety1 AS SurMem INTO #a1
UNION SELECT @Surety2
UNION SELECT @Surety3

DECLARE @smemaccno VARCHAR(10)

WHILE EXISTS (SELECT 1 FROM #a1)
BEGIN
	SELECT TOP 1 @smemaccno=SurMem FROM #a1
	
IF NOT EXISTS(SELECT * FROM speccs.Surety WHERE MemAccNo=@MemAccNo AND SMemAccNo=@smemaccno)
BEGIN
	INSERT INTO speccs.Surety
	VALUES (@MemAccNo,@smemaccno, 0, 'Y', @UserId, getdate())
END

DELETE FROM #a1 WHERE SurMem = @smemaccno
END 
--end
INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@UserId,@LoanAccNo,@MemAccNo,'Loan Surety Updated',getdate(),@Ipaddress,'Surety Updated')
	
RETURN
END

GO

