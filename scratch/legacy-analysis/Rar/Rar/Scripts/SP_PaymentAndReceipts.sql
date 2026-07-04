IF OBJECT_ID ('speccs.SP_PaymentAndReceipts') IS NOT NULL
	DROP PROCEDURE speccs.SP_PaymentAndReceipts
GO

CREATE PROCEDURE SP_PaymentAndReceipts
@RecordType VARCHAR (20)


AS
BEGIN

IF(@RecordType='RECEIPTS')

SELECT PayCode,Description 
		FROM speccs.TransactionType
		WHERE PaymentReceipt = 'R' AND PayCode NOT IN ('L24','L25','L29','L30','M08','M12','D08','L35')

END
IF (@RecordType='PAYMENTS') 
BEGIN
	SELECT PayCode,Description 
		FROM speccs.TransactionType
		WHERE PaymentReceipt = 'P' AND ScreenType='Y'

END

RETURN

/*
GRANT ALL ON speccs.SP_PaymentAndReceipts TO speccs
DROP PROC SP_PaymentAndReceipts
*/












GO

