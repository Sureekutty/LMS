
-- Step 1: Store the selected rows in a temporary table from table you want
SELECT counts,Amount,MemAccNo,Opendate,Interate,maturityDate INTO #tempData5 FROM speccs.tempMisPayments

-- Step 2: Declare variables for iteration
DECLARE @counts INT ,@MemAccNo VARCHAR(10), @Amount NUMERIC(15,2),@DepositNo VARCHAR(10), @Opendate VARCHAR(10),@Interate FLOAT,@maturityDate VARCHAR(10)

-- Step 3: Loop through the temporary table
WHILE EXISTS (SELECT 1 FROM #tempData5)
BEGIN
    -- Fetch the first row
    SELECT TOP 1 @counts=counts,@MemAccNo=MemAccNo,@Amount=Amount,@Opendate=Opendate,@Interate=Interate,@maturityDate=maturityDate FROM #tempData5
 
   EXEC  speccs.SP_AutoNumber "MISNO",NULL ,@DepositNo output

	    -- Insert into deposits
   
	INSERT INTO speccs.Deposits
	(
	MemAccNo,DepositNo,DepositType,OpenDate,MaturityDate,Duration,IntRate,PenalIntRate,Subscription,MaturityAmount,
	Status,Remarks,RegTime,UserId)
VALUES 
	(
	@MemAccNo,@DepositNo,'MIS',convert(DATE,@Opendate),convert(DATE,@maturityDate),36,@Interate,0,@Amount,@Amount,'ACTIVE','Mannual Insertion',getdate(),'SH15823'
	)
    -- Remove the processed row
    DELETE FROM #tempData5 WHERE counts = @counts
END

DROP table #tempData5

--Deposit Insertion

-- Step 1: Store the selected rows in a temporary table from table you want
SELECT fdNumber,DepositAmount,MaturityAmount,MemAccNo,Opendate,Interate,maturityDate,Duration INTO #tempData5 FROM speccs.tempFDDeposits

-- Step 2: Declare variables for iteration
DECLARE @fdNumber INT ,@MemAccNo VARCHAR(10), @Amount NUMERIC(15,2),@MaturityAmount NUMERIC(15,2),@DepositNo VARCHAR(10), @Opendate VARCHAR(10),@Interate FLOAT,
@maturityDate VARCHAR(10),@Duration INT 

-- Step 3: Loop through the temporary table
WHILE EXISTS (SELECT 1 FROM #tempData5)
BEGIN
    -- Fetch the first row
    SELECT TOP 1 @fdNumber=fdNumber,@MemAccNo=MemAccNo,@Amount=DepositAmount,@MaturityAmount=MaturityAmount,@Opendate=Opendate,@Interate=Interate,
    @maturityDate=maturityDate,@Duration=Duration FROM #tempData5
 
   EXEC speccs.SP_AutoNumber "FDNO",NULL ,@DepositNo output

	    -- Insert into deposits
   
	INSERT INTO speccs.Deposits
	(MemAccNo,DepositNo,DepositType,OpenDate,MaturityDate,Duration,IntRate,PenalIntRate,Subscription,
	MaturityAmount,Status,Remarks,RegTime,UserId)
VALUES 
	(
	@MemAccNo,@DepositNo,'FXD',@Opendate,@maturityDate,@Duration,@Interate,-0.5,@Amount,
	@MaturityAmount,'ACTIVE','FD Manual Insertion',getdate(),'SH15823')
	
    -- Remove the processed row
    DELETE FROM #tempData5 WHERE fdNumber = @fdNumber
END