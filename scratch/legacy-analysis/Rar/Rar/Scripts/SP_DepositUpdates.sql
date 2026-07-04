IF OBJECT_ID ('speccs.SP_DepositUpdates') IS NOT NULL
	DROP PROCEDURE speccs.SP_DepositUpdates
GO

CREATE  PROCEDURE speccs.SP_DepositUpdates
@Option  		VARCHAR (50),
@Memaccno       VARCHAR(8) =NULL,
@DepositType 	VARCHAR(5)= NULL,
@OpenDate     	VARCHAR(15)=NULL,
@Duration      INT,
@Subscription  INT,
@Remarks       VARCHAR(100)=NULL,
@UserId       VARCHAR(8)=NULL,
@DepositNum    VARCHAR(15)=NULL,
@MaturityDate   VARCHAR(25) =NULL,
@ShCloseDate    VARCHAR(25)=NULL,
@SettlementAmt  DECIMAL(15,2)= NULL,
@AdjustedAmt    DECIMAL(15,2)= NULL,
@AdjustRefNo    VARCHAR(15)=NULL,
@Month          CHAR(2)=NULL,
@Ipaddress 		VARCHAR(25)=NULL

AS


--DROP PROC speccs.SP_DepositUpdates
--GRANT Execute ON speccs.SP_DepositUpdates TO speccsgroup


 IF (@Option="UPDATE") 
 BEGIN
	
  declare @intrate numeric(5,2)
DECLARE @maturitydate DATE
EXEC  speccs.Sp_getInterestRates 'VAlues',@DepositType,25,@intrate output	
	
	
	
IF (@DepositType = 'FXD')  -- Start of Fixed deposit
BEGIN 

declare @mindur int
declare @maxdur int
declare @penaltyrate numeric(5,2)
declare @maturity numeric (15,2)
select @mindur=RuleValue from speccs.Rules where RuleCode='121'
select @maxdur=RuleValue from speccs.Rules where RuleCode='122'
select @penaltyrate=RateOfInterest from speccs.Interest where IntCode='FXP' and getdate() between EffFromDate and EffToDate
select @maturity=@Subscription*@Duration*@intrate/1200


IF (@Month='01' OR @Month='1')
BEGIN
SELECT @maturitydate=DATEADD(mm,@Duration,@OpenDate)
END
ELSE
BEGIN
SELECT @maturitydate=DATEADD(mm,@Duration+1,@OpenDate)
END

if(@Duration <@mindur) or (@Duration>@maxdur)
if(@Duration <@mindur) or (@Duration>@maxdur)
begin
	RAISERROR 99999 "Invalid Duration value for FD :SP_Deposits"
	ROLLBACK TRANSACTION
	RETURN
end

UPDATE speccs.Deposits SET OpenDate =@OpenDate,MaturityDate=@maturitydate,Duration =@Duration,IntRate=@intrate,
PenalIntRate=@penaltyrate,Subscription =@Subscription,MaturityAmount=@maturity,Remarks =@Remarks,RegTime = getdate(),
UserId =@UserId WHERE DepositNo =@DepositNum

	INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@UserId,@Memaccno,@DepositNum,'Deposit Updated',getdate(),@Ipaddress,@Remarks)
RETURN
end

  ELSE IF (@DepositType = 'RCD')  -- Start of Reccuring  deposit
BEGIN 

declare @mindurrd int
declare @maxdurrd int
declare @penaltyraterd numeric(5,2)
declare @maturityrd numeric (15,2)
select @mindurrd=RuleValue from speccs.Rules where RuleCode='123'
select @maxdurrd=RuleValue from speccs.Rules where RuleCode='124'
select @penaltyraterd=RateOfInterest from speccs.Interest where IntCode='RCD' and getdate() between EffFromDate and EffToDate
select @maturityrd=@Subscription*@Duration*@intrate/1200


IF (@Month='01' OR @Month='1')
BEGIN
SELECT @maturitydate=DATEADD(mm,@Duration,@OpenDate)
END
ELSE
BEGIN
SELECT @maturitydate=DATEADD(mm,@Duration+1,@OpenDate)
END

	
UPDATE speccs.Deposits SET OpenDate =@OpenDate,MaturityDate=@maturitydate,Duration =@Duration,IntRate=@intrate,
PenalIntRate=@penaltyraterd,Subscription =@Subscription,MaturityAmount=@maturityrd,Remarks =@Remarks,RegTime = getdate(),
UserId =@UserId WHERE DepositNo =@DepositNum

	INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@UserId,@Memaccno,@DepositNum,'Deposit Updated',getdate(),@Ipaddress,@Remarks)
	RETURN
end	
ELSE IF (@DepositType = 'MIS')  
BEGIN 

declare @multFactor numeric(13,2)
declare @minamount numeric (15,2)
select @multFactor=RuleValue from speccs.Rules where RuleCode='120'
SELECT @minamount=RuleValue from speccs.Rules where RuleCode='119'
select @Duration=RuleValue from speccs.Rules where RuleCode='118'

IF (@Month='01' OR @Month='1')
BEGIN
SELECT @maturitydate=DATEADD(mm,@Duration,@OpenDate)
END 
ELSE
BEGIN
SELECT @maturitydate=DATEADD(mm,@Duration+1,@OpenDate)
END

if(@Subscription<@minamount) or (@Subscription%@multFactor!=0)
begin
	RAISERROR 99999 "Invalid Amount value for MIS :SP_Deposits"
	ROLLBACK TRANSACTION
	RETURN
end
	
		
UPDATE speccs.Deposits SET OpenDate =@OpenDate,MaturityDate=@maturitydate,Duration =@Duration,IntRate=@intrate,
PenalIntRate=0,Subscription =@Subscription,MaturityAmount=@maturityrd,Remarks =@Remarks,RegTime = getdate(),
UserId =@UserId WHERE DepositNo =@DepositNum

	INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@UserId,@Memaccno,@DepositNum,'Deposit Updated',getdate(),@Ipaddress,@Remarks)
RETURN	
	END

RETURN
END


 IF (@Option="GETINFO") 
	BEGIN
SELECT MemAccNo,MaturityDate, MaturityAmount,DepositNo, DepositType, OpenDate, Duration, IntRate, Subscription,Remarks,NomineeId 
FROM speccs.Deposits B
LEFT JOIN speccs.NomineeRef A
ON B.DepositNo =A.Depositno WHERE MemAccNo =@Memaccno AND DepositNo =@DepositNum
	
RETURN
END

 IF (@Option="PROCESSINFO") 
	BEGIN


SELECT A.MemAccNo+"-"+A.MemEmpCode+"-"+A.MemName AS Memdetails, B.DepositNo,
B.DepositType,convert(char(10),B.MaturityDate,103) AS MaturityDate,B.MaturityAmount,B.Remarks,B.Status,B.AdjustRefNo,B.AdjustedAmount,B.SettlementAmount
FROM speccs.Members A 

LEFT JOIN speccs.Deposits B
ON B.MemAccNo =A.MemAccNo WHERE B.MemAccNo =@Memaccno AND B.DepositNo =@DepositNum

RETURN
END

 IF (@Option="LOANPROCESSINFO") 
	BEGIN
SELECT L.MemAccNo,L.LoanAccNo,L.LoanSanctionAmount,L.LoanStatus 
FROM speccs.Loans L
LEFT JOIN speccs.Deposits B
ON B.MemAccNo=L.MemAccNo WHERE L.MemAccNo=@Memaccno AND L.LoanStatus='RELEASED'


RETURN
END





GO

