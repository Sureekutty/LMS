IF OBJECT_ID ('speccs.SP_DepositsDetails') IS NOT NULL
	DROP PROCEDURE speccs.SP_DepositsDetails
GO

CREATE  PROCEDURE speccs.SP_DepositsDetails
@option  		VARCHAR (20),
@depositType VARCHAR(5),
@status VARCHAR(10),
@depositNumber VARCHAR(15) = NULL,
@memAccNo CHAR(5) = NULL
AS 

/*
	DROP PROCEDURE  speccs.SP_DepositsDetails
	
	GRANT ALL ON speccs.SP_DepositsDetails to speccsgroup
*/

	IF(@option = 'all')
	begin
	  		SELECT mem.MemEmpCode,mem.MemName,mem.Designation,
			deposit.MemAccNo, deposit.DepositNo,deposit.DepositType, deposit.OpenDate, 
			deposit.Duration, deposit.IntRate,deposit.PenalIntRate, deposit.Subscription, 
			 deposit.MaturityAmount,deposit.PreviousDepositNo, deposit.Status, 
			deposit.Remarks, deposit.RegTime, deposit.UserId
			FROM speccs.Deposits deposit
		LEFT JOIN speccs.Members mem
		ON deposit.MemAccNo = mem.MemAccNo
		WHERE deposit.DepositType = @depositType AND deposit.Status = @status 		
	end
	IF (@option="individual")
	begin 
		if(@depositNumber = null)
		begin
			SELECT mem.MemEmpCode,mem.MemName,mem.Designation,
			deposit.MemAccNo, deposit.DepositNo,deposit.DepositType, deposit.OpenDate,
			deposit.Duration, deposit.IntRate,deposit.PenalIntRate, deposit.Subscription, 
			 deposit.MaturityAmount,deposit.PreviousDepositNo, deposit.Status, 
			deposit.Remarks, deposit.RegTime, deposit.UserId
			FROM speccs.Deposits deposit
			LEFT JOIN speccs.Members mem
			ON deposit.MemAccNo = mem.MemAccNo
			WHERE deposit.DepositType = @depositType  AND deposit.MemAccNo = @memAccNo
		end
		else
		begin
		
	   		SELECT mem.MemEmpCode,mem.MemName,mem.Designation,
			deposit.MemAccNo, deposit.DepositNo,deposit.DepositType, deposit.OpenDate,
			deposit.Duration, deposit.IntRate,deposit.PenalIntRate, deposit.Subscription, 
		 deposit.MaturityAmount,deposit.PreviousDepositNo, deposit.Status, 
			deposit.Remarks, deposit.RegTime, deposit.UserId
			FROM speccs.Deposits deposit
			LEFT JOIN speccs.Members mem
			ON deposit.MemAccNo = mem.MemAccNo
			WHERE deposit.Status = @status AND deposit.DepositNo = @depositNumber
		end
	end


	IF(@option = 'DEPOSITNUM')
	BEGIN
	--'FRESH'in status removed by pn on 20/05/2025 told by Rama Rao
	
   
	SELECT deposit.DepositNo,deposit.Subscription,deposit.IntRate FROM speccs.Deposits deposit WHERE  deposit.Status IN('ACTIVE') AND deposit.DepositType ='FXD'
		AND deposit.MemAccNo =@memAccNo AND deposit.DepositNo NOT IN  ( SELECT loan.FundId  FROM speccs.Loans loan WHERE loan.FundId = deposit.DepositNo AND loan.LoanStatus IN ('RELEASED'))


	RETURN
	END

	IF(@option = 'DEPOSITNUMLOAD')
	BEGIN
	
	SELECT ss.MemAccNo,ss.DepositNo,ss.Subscription FROM speccs.Deposits ss WHERE ss.DepositNo=@depositNumber
	
	RETURN
	END

GO

