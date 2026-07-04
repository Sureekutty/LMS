IF OBJECT_ID ('speccs.Sp_getInterestRates') IS NOT NULL
	DROP PROCEDURE speccs.Sp_getInterestRates
GO

CREATE  PROCEDURE speccs.Sp_getInterestRates
@option VARCHAR(10),
@IntCode VARCHAR(3),
@Duration INT = NULL,
@intRate NUMERIC(5,2) output,
@opendate VARCHAR(10)

--DROP PROCEDURE  Sp_getInterestRates
--GRANT Execute ON speccs.Sp_getInterestRates TO speccsgroup

AS

begin

  if (@IntCode = 'RCD' or  @IntCode = 'FXD')
    begin
 	select @intRate = RateOfInterest
 	from speccs.Interest 
 	where IntCode=@IntCode and @Duration between  MinMonth and MaxMonth and @opendate between EffFromDate and EffToDate
 end
 ELSE if (@IntCode = 'SRB' or @IntCode = 'MIS' OR @IntCode = 'LTL' OR @IntCode = 'EXL' OR @IntCode = 'FDL')
   begin
 	SELECT @intRate = RateOfInterest
 	from speccs.Interest 
 	where IntCode=@IntCode  and getdate() between EffFromDate and EffToDate
 END

  ELSE if (@IntCode = 'LTL' or @IntCode = 'FDL' OR @IntCode = 'EXL')
   begin
 	SELECT @intRate = RateOfInterest
 	from speccs.Interest 
 	where IntCode=@IntCode  and @option between EffFromDate and EffToDate
 END
 ELSE 
   begin
 	select -1
 end
end







GO

