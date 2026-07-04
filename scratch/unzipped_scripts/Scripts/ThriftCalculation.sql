


CREATE TABLE speccs.ThriftInterestAmnt
	(
	MemAccNo      VARCHAR (5) ,
	MemEmpCode    VARCHAR (7) ,
	MemName       VARCHAR (100) ,
	ThriftInterest NUMERIC(15,2),
	BankAccNo 		VARCHAR(25),
	BankName		VARCHAR(5),
	RegTime 		DATETIME,
	)

DELETE FROM speccs.ThriftInterestAmnt

DECLARE @intRate FLOAT,@fromDate VARCHAR(10),@toDate VARCHAR(10)
SELECT @intRate=8.4,@fromDate='05/01/2025',@toDate='06/07/2025'
SELECT MemAccNo,MemEmpCode,MemName,MemDate,BankAccNo,BankName INTO #member FROM speccs.Members
 --WHERE MemAccNo='M0001' AND MemDate BETWEEN @fromDate AND @toDate

DECLARE @memAccNo VARCHAR(5),@memEmpCode VARCHAR(7),@memName VARCHAR(50),@BankAccNo VARCHAR(25),@BankName VARCHAR(5)

WHILE EXISTS(SELECT 1 FROM #member)
BEGIN 
	SELECT @memAccNo=MemAccNo,@memEmpCode=MemEmpCode,@memName=MemName,@BankAccNo=BankAccNo,@BankName=BankName FROM #member
	
	SELECT MemAccNo,TransactionDate,Amount,ReceiptNo,ThriftBalance INTO #RamaRao FROM speccs.ThriftTransactions 
	WHERE MemAccNo=@memAccNo AND TransactionDate BETWEEN @fromDate AND @toDate
	
	DECLARE @TransactionDate DATE,@Amount NUMERIC(15,2),@ReceiptNo VARCHAR(13),@ThriftBalance NUMERIC(15,2),
	@startDate DATE, @interestAmnt NUMERIC(15,2)
	SELECT @startDate=min(TransactionDate) FROM #RamaRao
	SET @interestAmnt=0
	WHILE EXISTS(SELECT 1 FROM #RamaRao)
	BEGIN 
		
		SELECT @TransactionDate=TransactionDate,@Amount=Amount,@ReceiptNo=ReceiptNo,@ThriftBalance=ThriftBalance FROM #RamaRao
		
		IF(convert(DATE,@startDate)=convert(DATE,@TransactionDate))
		BEGIN 
			SET @interestAmnt=@interestAmnt+((@ThriftBalance*@intRate*(datediff(dd,@TransactionDate,@toDate)))/36500)

		END 
		ELSE
		BEGIN
		  SET @interestAmnt=@interestAmnt+((@Amount*@intRate*(datediff(dd,@TransactionDate,@toDate)))/36500)

		END
		
		DELETE FROM #RamaRao WHERE ReceiptNo = @ReceiptNo
	END 
	--SELECT @interestAmnt AS outside
	 
   --	INSERT INTO speccs.ThriftInterestAmnt
   --	(MemAccNo,	MemEmpCode,	MemName,ThriftInterest) VALUES (@memAccNo,@memEmpCode,@memName,@interestAmnt) 
	INSERT INTO speccs.ThriftInterestAmnt
   	VALUES (@memAccNo,@memEmpCode,@memName,@interestAmnt,@BankAccNo,@BankName,getdate())
	
	DROP TABLE #RamaRao

	DELETE FROM #member WHERE MemAccNo = @memAccNo
END 

 SELECT MemAccNo,MemEmpCode,MemName,ThriftInterest,BankAccNo,BankName FROM speccs.ThriftInterestAmnt

/*
CASE WHEN @interestAmnt=NULL THEN 0 ELSE @interestAmnt END
DELETE FROM speccs.ThriftInterestAmnt 
DROP TABLE speccs.ThriftInterestAmnt
DROP TABLE #member
DROP TABLE #RamaRao
*/