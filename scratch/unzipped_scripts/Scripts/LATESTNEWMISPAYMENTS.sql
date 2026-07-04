
IF OBJECT_ID ('speccs.SP_MiscellaneousPayment') IS NOT NULL
	DROP PROCEDURE speccs.SP_MiscellaneousPayment
GO

CREATE PROCEDURE speccs.SP_MiscellaneousPayment
    @MemAccNo VARCHAR(5),
    @PayDate VARCHAR(10),        -- Expects DD/MM/YYYY format
    @Amount NUMERIC(15,2),
    @ChequeNo VARCHAR(50),
    @Remarks VARCHAR(200),
    @UserId VARCHAR(50),
    @IpAddress VARCHAR(50)
AS
BEGIN
    -- CHANGED: Declare variables for hardcoded PurposeCode, generated PaymentNo, and parsed date
    DECLARE @PurposeCode VARCHAR(5),  -- Hardcode PurposeCode to M46
            @PaymentNo VARCHAR(14),
            @V_MemAccNo VARCHAR(20),
            @ParsedPayDate DATETIME

    -- CHANGED: Parse PayDate from DD/MM/YYYY to MM/DD/YYYY for Payments21082025
    SET @ParsedPayDate = CONVERT(DATETIME, 
        SUBSTRING(@PayDate, 4, 2) + '/' +  -- MM
        SUBSTRING(@PayDate, 1, 2) + '/' +  -- DD
        SUBSTRING(@PayDate, 7, 4),        -- YYYY
        101)  -- 101 = MM/DD/YYYY format

    -- CHANGED: Validate member against Members21082025
    SELECT @V_MemAccNo = MemAccNo
    FROM speccs.Members21082025 
    WHERE MemAccNo = @MemAccNo AND Status = 'ACTIVE'

    IF @V_MemAccNo IS NOT NULL 
    BEGIN 
        BEGIN TRANSACTION

        -- CHANGED: Generate PaymentNo using existing SP_AutoNumber with PAYMENTVOUCHER option
        EXEC speccs.SP_AutoNumber 'PAYMENTVOUCHER', NULL, @PaymentNo OUTPUT

        -- CHANGED: Insert into Payments21082025 using MemAccNo and parsed PayDate
        INSERT INTO speccs.Payments21082025 
            (MemAccNo, PayVoucherNo, VoucherDate, PurposeCode, Amount, ModeOfPayment, Status, RefNo, Remarks, UserId, RegTime)
        VALUES 
            (@V_MemAccNo, @PaymentNo, @ParsedPayDate, @PurposeCode, @Amount, 'CHEQUE', 'ACTIVE', @ChequeNo, @Remarks, @UserId, GETDATE())

        IF (@@ERROR != 0)
        BEGIN
            -- CHANGED: Use SELECT for error handling for older Sybase compatibility
            SELECT '99999' AS ErrorCode, 'Error inserting into Payments21082025' AS ErrorMessage
            ROLLBACK TRANSACTION
            RETURN
        END

        -- CHANGED: Insert into MiscellaneousPayment with original PayDate (VARCHAR) and generated PaymentNo
        INSERT INTO speccs.MiscellaneousPayment
            (MemAccNo, PurposeCode, PayDate, Amount, ChequeNo, Remarks, PaymentNo)
        VALUES
            (@V_MemAccNo, @PurposeCode, @PayDate, @Amount, @ChequeNo, @Remarks, @PaymentNo)

        IF (@@ERROR != 0)
        BEGIN
            -- CHANGED: Use SELECT for error handling
            SELECT '99999' AS ErrorCode, 'Error inserting into MiscellaneousPayment' AS ErrorMessage
            ROLLBACK TRANSACTION
            RETURN
        END

        COMMIT TRANSACTION
    END
    ELSE
    BEGIN
        -- CHANGED: Use SELECT for error handling
        SELECT '99999' AS ErrorCode, 'Invalid Member Account Number' AS ErrorMessage
        RETURN
    END
END
GO

-- CHANGED: Grant permissions to speccsgroup
GRANT ALL ON speccs.SP_MiscellaneousPayment TO speccsgroup
GO