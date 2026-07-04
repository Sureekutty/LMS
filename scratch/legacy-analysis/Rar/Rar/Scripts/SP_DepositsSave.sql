IF OBJECT_ID ('speccs.SP_DepositsSave') IS NOT NULL
	DROP PROCEDURE speccs.SP_DepositsSave
GO

CREATE  PROCEDURE speccs.SP_DepositsSave
@Option  		VARCHAR (20),
@MemAccNo  		VARCHAR(10)= NULL,
@TypeOfDeposit	VARCHAR(3)= NULL,
@FixedDeposit   VARCHAR(10)=NULL,
@DepositDate	VARCHAR(10)= NULL,
@Amount			DECIMAL(15,2)= NULL,
@Duration	    INT= NULL,
@Remarks		varchar(250)=null,
@MaturityDate   VARCHAR(10) =NULL,
@ShCloseDate    VARCHAR(10)=NULL,
@MaturityAmt  DECIMAL(15,2)= NULL,
@AdjustedAmt    DECIMAL(15,2)= NULL,
@AdjustRefNo    VARCHAR(15)=NULL,
@Month          CHAR(2)=NULL,
@UserId	 		VARCHAR(7),
@Ipaddress      VARCHAR(30)=NULL,
@DepositNo		VARCHAR(10) output


AS



--DROP PROC speccs.SP_DepositsSave
--select @ReceiptNo=''
--GRANT Execute ON speccs.SP_DepositsSave TO speccsgroup


BEGIN TRANSACTION

declare @intrate numeric(5,2)
DECLARE @maturitydate DATE
EXEC  speccs.Sp_getInterestRates 'VAlues',@TypeOfDeposit,@Duration,@intrate output,@DepositDate

--validations ST commented by pn on 24/01/2025 told by Society

/* if(@Amount%100 != 0)
begin
	RAISERROR 99999 "Invalid Amount value :SP_Deposits"
	ROLLBACK TRANSACTION
	RETURN
end  */
--validations ND


IF (@TypeOfDeposit = 'FXD')  -- Start of Fixed deposit
BEGIN 
-- generating serial number ST
EXEC  speccs.SP_AutoNumber "FDNO",NULL ,@DepositNo output
-- generating serial number ND

--getting details of FD rates ST

declare @mindur int
declare @maxdur int

declare @penaltyrate numeric(5,2)
declare @maturity numeric (15,2)



select @mindur=RuleValue from speccs.Rules where RuleCode='121'
select @maxdur=RuleValue from speccs.Rules where RuleCode='122'
select @penaltyrate=RateOfInterest from speccs.Interest where IntCode='FXP' and getdate() between EffFromDate and EffToDate
--select @maturity=@Amount*@Duration*@intrate/1200  commented by pn on 02/04/2025

--commented by pn on 02/04/2025
/* DECLARE @day int,@month int,@year INT
SELECT @day=datepart(dd,@DepositDate)
IF (@day=1)
BEGIN
SELECT @maturitydate=DATEADD(mm,@Duration,@DepositDate)
END

ELSE
BEGIN
SELECT @day=1
SELECT @month=datepart(mm,(dateadd(mm,@Duration+1,@DepositDate)))
select @year=datepart(yy,(dateadd(mm,@Duration+1,@DepositDate)))

SELECT @maturitydate=convert(VARCHAR(2),@month)+'/'+convert(VARCHAR(2),@day)+'/'+convert(VARCHAR(4),@year)
END	*/

--getting details of FD rates ND

--validations ST

if(@Duration <@mindur) or (@Duration>@maxdur)
begin
	RAISERROR 99999 "Invalid Duration value for FD :SP_Deposits"
	ROLLBACK TRANSACTION
	RETURN
end
--validations ND
			
-- saving Deposit entry ST

INSERT INTO speccs.Deposits
	(MemAccNo,DepositNo,DepositType,OpenDate,MaturityDate,Duration,IntRate,PenalIntRate,Subscription,
	MaturityAmount,Status,Remarks,RegTime,UserId)
VALUES 
	(
	@MemAccNo,@DepositNo,@TypeOfDeposit,@DepositDate,@MaturityDate,@Duration,@intrate,@penaltyrate,@Amount,
	@MaturityAmt,'REQUEST',@Remarks,getdate(),@UserId)
	
	
	
		
	INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@UserId,@DepositNo,@MemAccNo,'Deposit Saved',getdate(),@Ipaddress,@Remarks)
	
IF(@@ERROR!=0)
BEGIN
	RAISERROR 99999 "Error while inserting data in Deposits :SP_Deposits"
	ROLLBACK TRANSACTION
	RETURN
END


-- saving Deposit entry ND
end-- end of Fixed deposit


IF (@TypeOfDeposit = 'RCD')  -- Start of Reccuring  deposit
BEGIN 

-- generating serial number ST

EXEC  speccs.SP_AutoNumber "RDNO",NULL ,@DepositNo output

declare @mindurrd int
declare @maxdurrd int

declare @penaltyraterd numeric(5,2)
declare @maturityrd numeric (15,2)



select @mindurrd=RuleValue from speccs.Rules where RuleCode='123'
select @maxdurrd=RuleValue from speccs.Rules where RuleCode='124'


select @penaltyraterd=RateOfInterest from speccs.Interest where IntCode='RCD' and getdate() between EffFromDate and EffToDate
-- select @maturityrd=@Amount*@Duration*@intrate/1200	commented by pn on 02/04/2025
-- generating serial number ND

-- saving Deposit entry ST
IF (@Month='01' OR @Month='1')
BEGIN
SELECT @maturitydate=DATEADD(mm,@Duration,@DepositDate)
END
ELSE
BEGIN
SELECT @maturitydate=DATEADD(mm,@Duration+1,@DepositDate)
END

INSERT INTO speccs.Deposits
	(MemAccNo,DepositNo,DepositType,OpenDate,MaturityDate,Duration,IntRate,PenalIntRate,Subscription,
	MaturityAmount,Status,Remarks,RegTime,UserId)
VALUES 
	(
	@MemAccNo,@DepositNo,@TypeOfDeposit,@DepositDate,@MaturityDate,@Duration,@intrate,@penaltyraterd,@Amount,
	@MaturityAmt,'REQUEST',@Remarks,getdate(),@UserId)
	
	
	
	INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@UserId,@DepositNo,@MemAccNo,'Deposit Saved',getdate(),@Ipaddress,@Remarks)
	
	

IF(@@ERROR!=0)
BEGIN
   RAISERROR 99999 "Error while inserting data in Deposits :SP_Deposits"
   ROLLBACK TRANSACTION
   RETURN
END

-- saving Deposit entry ND

end
-- end of Reccuring  deposit

-- Start of MOnthly installment scheme deposit
-- Saving new SERBS
IF (@TypeOfDeposit = 'SRB')  
BEGIN 
		
-- saving Deposit entry ST

EXEC  speccs.SP_AutoNumber "SRBNO",NULL ,@DepositNo output

INSERT INTO speccs.Deposits	(MemAccNo,DepositNo,DepositType,OpenDate,Duration,IntRate,
	Subscription,Status,Remarks,RegTime,UserId)
	
VALUES 
	(
	@MemAccNo,@DepositNo,@TypeOfDeposit,@DepositDate,0,@intrate
   	,@Amount,'REQUEST',@Remarks,getdate(),@UserId
	)
	
	
	INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@UserId,@DepositNo,@MemAccNo,'Deposit Saved',getdate(),@Ipaddress,@Remarks)
	
	
	
IF(@@ERROR!=0)
BEGIN
	RAISERROR 99999 "Error while inserting data in Deposits :SP_Deposits"
	ROLLBACK TRANSACTION
	RETURN
END
 

END
   
IF (@TypeOfDeposit = 'MIS')  
BEGIN 

-- generating serial number ST

EXEC  speccs.SP_AutoNumber "MISNO",NULL ,@DepositNo output

-- generating serial number ND


--getting details of MIS rates ST


declare @multFactor numeric(13,2)
declare @minamount numeric (15,2)


select @multFactor=RuleValue from speccs.Rules where RuleCode='120'
SELECT @minamount=RuleValue from speccs.Rules where RuleCode='119'
select @Duration=RuleValue from speccs.Rules where RuleCode='118'

--getting details of MIS rates ND

--validation ST
IF (@Month='01' OR @Month='1')
BEGIN
SELECT @maturitydate=DATEADD(mm,@Duration,@DepositDate)
END 
ELSE
BEGIN
SELECT @maturitydate=DATEADD(mm,@Duration+1,@DepositDate)
SELECT @maturitydate=convert(VARCHAR(2),datepart(mm,@maturitydate))+"/01/"+convert(VARCHAR(4),datepart(yy,@maturitydate))
END

if(@Amount<@minamount) or (@Amount%@multFactor!=0)
begin
	RAISERROR 99999 "Invalid Amount value for MIS :SP_Deposits"
	ROLLBACK TRANSACTION
	RETURN
end

--validation ND
			
-- saving Deposit entry ST
 
--changed by pn on 06/05/2025 told by Rama Rao
INSERT INTO speccs.Deposits
	(
	MemAccNo,DepositNo,DepositType,OpenDate,MaturityDate,Duration,IntRate,PenalIntRate,Subscription,MaturityAmount,
	Status,Remarks,RegTime,UserId)
VALUES 
	(
	@MemAccNo,@DepositNo,@TypeOfDeposit,@DepositDate,@maturitydate,@Duration,@intrate,0,@Amount,@MaturityAmt,'REQUEST',@Remarks,getdate(),@UserId
	)
	
	INSERT INTO speccs.speccs.TransactionLog(UserId,Module,KeyId,Description,RecTime,ClientIP,Remarks)
	VALUES(@UserId,@DepositNo,@MemAccNo,'Deposit Saved',getdate(),@Ipaddress,@Remarks)
	
	
	

IF(@@ERROR!=0)
BEGIN
	RAISERROR 99999 "Error while inserting data in Deposits :SP_Deposits"
	ROLLBACK TRANSACTION
	RETURN
END





	  
--DROP PROC speccs.SP_DepositsSave




END 



COMMIT TRANSACTION
















GO

