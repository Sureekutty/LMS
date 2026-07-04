IF OBJECT_ID ('speccs.Sp_getThriftInterest') IS NOT NULL
	DROP PROCEDURE speccs.Sp_getThriftInterest
GO

CREATE  PROCEDURE speccs.Sp_getThriftInterest

@intRate float,
@fromDate VARCHAR(10),
@toDate VARCHAR(10)

--DROP PROCEDURE  Sp_getThriftInterest
--GRANT Execute ON speccs.Sp_getThriftInterest TO speccsgroup

AS

begin

DELETE FROM speccs.ThriftInterestAmnt

SELECT MemAccNo,MemEmpCode,MemName,MemDate,BankAccNo,BankName INTO #member FROM speccs.Members

DECLARE @memAccNo VARCHAR(5),@memEmpCode VARCHAR(7),@memName VARCHAR(50),@BankAccNo VARCHAR(25),@BankName VARCHAR(5)

WHILE EXISTS(SELECT 1 FROM #member)
BEGIN 
	SELECT @memAccNo=MemAccNo,@memEmpCode=MemEmpCode,@memName=MemName,@BankAccNo=BankAccNo,@BankName=BankName FROM #member
	
	SELECT MemAccNo,TransactionDate,Amount,ReceiptNo,ThriftBalance INTO #thrifts FROM speccs.ThriftTransactions 
	WHERE MemAccNo=@memAccNo AND TransactionDate BETWEEN @fromDate AND @toDate
	
	DECLARE @TransactionDate DATE,@Amount NUMERIC(15,2),@ReceiptNo VARCHAR(13),@ThriftBalance NUMERIC(15,2),
	@startDate DATE, @interestAmnt NUMERIC(15,2)
	SELECT @startDate=min(TransactionDate) FROM #thrifts
	SET @interestAmnt=0
	IF EXISTS(SELECT * FROM #thrifts)
	BEGIN 
	WHILE EXISTS(SELECT 1 FROM #thrifts)
	BEGIN 
		
		SELECT @TransactionDate=TransactionDate,@Amount=Amount,@ReceiptNo=ReceiptNo,@ThriftBalance=ThriftBalance FROM #thrifts
		--chnaged by pn on 25/06/2025 told by Rama Rao for Thrift Transaction date
		IF(datepart(dd,@TransactionDate)>5)
		BEGIN
			SELECT @TransactionDate=dateadd(dd,1,dateadd(dd,-datepart(dd,@TransactionDate),dateadd(mm,1,@TransactionDate)))
		END 
		IF(convert(DATE,@startDate)=convert(DATE,@TransactionDate))
		BEGIN 
			SET @interestAmnt=@interestAmnt+((@ThriftBalance*@intRate*(datediff(dd,@TransactionDate,@toDate)))/36500)

		END 
		ELSE
		BEGIN
		  SET @interestAmnt=@interestAmnt+((@Amount*@intRate*(datediff(dd,@TransactionDate,@toDate)))/36500)

		END
		
		DELETE FROM #thrifts WHERE ReceiptNo = @ReceiptNo
	END 
	
	
	INSERT INTO speccs.ThriftInterestAmnt
   	VALUES (@memAccNo,@memEmpCode,@memName,round(@interestAmnt,0),@BankAccNo,@BankName,getdate())
	END
	DROP TABLE #thrifts

	DELETE FROM #member WHERE MemAccNo = @memAccNo
END 
 SELECT MemAccNo,MemEmpCode,MemName,ThriftInterest,BankAccNo,BankName FROM speccs.ThriftInterestAmnt

END 

GO

