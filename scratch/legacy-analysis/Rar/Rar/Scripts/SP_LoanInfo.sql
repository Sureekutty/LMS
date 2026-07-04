IF OBJECT_ID ('speccs.SP_LoanInfo') IS NOT NULL
	DROP PROCEDURE speccs.SP_LoanInfo
GO

CREATE PROCEDURE speccs.SP_LoanInfo
@LoanAppNo VARCHAR(12),
@date VARCHAR(10),
@I_CBL numeric(13,2) output,
@P_Inst numeric(15,2) output,
@I_Inst numeric(15,2) output

as
/*
drop proc speccs.SP_LoanInfo
	GRANT ALL ON speccs.SP_Loans to speccsgroup
	
	EXEC speccs.SP_LoanInfo 'FDL0001','04/15/2025',0,@priBal output,@intAmnt output 

*/
--changed LoanStatus from SANCTION to RELEASED by pn on 26/05/2025
if not exists(select * from speccs.Loans where LoanAccNo=@LoanAppNo and LoanStatus='RELEASED')
begin
	RAISERROR 99999 "This is not a sanctioned/active loan"
return
end






select @P_Inst=(SELECT LoanSanctionAmount FROM speccs.Loans where LoanAccNo=@LoanAppNo AND LoanStatus='RELEASED')

DECLARE @intRate FLOAT
SELECT @intRate=InterestRate FROM speccs.Loans where LoanAccNo=@LoanAppNo AND LoanStatus='RELEASED'
DECLARE @intAmount NUMERIC(15,2)
EXEC speccs.SP_getFDLInterestAmount 'FDL',@date,@LoanAppNo,@intRate,@intAmount output 

select @I_Inst=@intAmount

return









GO

