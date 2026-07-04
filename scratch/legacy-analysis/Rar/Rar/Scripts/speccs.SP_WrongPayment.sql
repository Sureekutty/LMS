
IF OBJECT_ID ('speccs.SP_WrongPayment') IS NOT NULL
	DROP PROCEDURE speccs.SP_WrongPayment
GO

CREATE PROCEDURE speccs.SP_WrongPayment
    @MemAccNo VARCHAR(5),        -- Member account number
    @PayDate DATETIME,           -- Expects MM/DD/YYYY format from controller
    @Amount NUMERIC(15,2),       -- Payment amount
    @ChequeNo VARCHAR(50),       -- Cheque number
    @Remarks VARCHAR(200),       -- Payment remarks
    @UserId VARCHAR(50),         -- User ID from session
    @IpAddress VARCHAR(50)       -- IP address of the client
    
AS
BEGIN
    -- CHANGED: Declare variables for PurposeCode, PaymentNo, and Member check
    DECLARE @PurposeCode VARCHAR(5),
    @PaymentNo	VARCHAR(14) 
    DECLARE @V_MemAccNo VARCHAR(20)

    -- CHANGED: Initialize PurposeCode using SELECT for old Sybase compatibility
    SELECT @PurposeCode = 'P34'  -- Hardcode PurposeCode to M46

    -- CHANGED: Check if member exists and is active in Members21082025
    SELECT @V_MemAccNo = MemAccNo
    FROM speccs.Members
    WHERE MemAccNo = @MemAccNo AND Status = 'ACTIVE'

    -- CHANGED: Proceed with inserts if member is valid
    IF @V_MemAccNo IS NOT NULL 
    BEGIN 
        -- CHANGED: Generate unique PaymentNo using SP_AutoNumber
        EXEC  speccs.SP_AutoNumber "PAYMENTNO",NULL ,@PaymentNo output

        -- CHANGED: Insert payment details into Payments21082025 with PayDate as DATETIME
        INSERT INTO speccs.Payments 
            (MemAccNo, PayVoucherNo, VoucherDate, PurposeCode, Amount, ModeOfPayment, Status, RefNo, Remarks, UserId, RegTime)
        VALUES 
            (@V_MemAccNo, @PaymentNo, @PayDate, @PurposeCode, @Amount, 'CHEQUE', 'ACTIVE', @ChequeNo, @Remarks, @UserId, GETDATE())

        -- CHANGED: Insert into speccs.WrongPayment, converting PayDate to VARCHAR(10) as DD/MM/YYYY
        INSERT INTO speccs.WrongPayment
            (MemAccNo, PurposeCode, PayDate, Amount, ChequeNo, Remarks, PaymentNo)
        VALUES
            (@V_MemAccNo, @PurposeCode, CONVERT(VARCHAR(10), @PayDate, 103), @Amount, @ChequeNo, @Remarks, @PaymentNo)
    END
END



GO
/*


IF OBJECT_ID ('speccs.WrongPayment') IS NOT NULL
	DROP TABLE speccs.WrongPayment
GO

CREATE TABLE speccs.WrongPayment
	(
	MemAccNo    VARCHAR (10) NOT NULL,
	PurposeCode VARCHAR (5) NOT NULL,
	PayDate     VARCHAR (10) NOT NULL,
	Amount      NUMERIC (15,2) NOT NULL,
	ChequeNo    VARCHAR (30) NOT NULL,
	Remarks     VARCHAR (200) NOT NULL,
	PaymentNo   VARCHAR (13) NOT NULL
	)
GO



*/
