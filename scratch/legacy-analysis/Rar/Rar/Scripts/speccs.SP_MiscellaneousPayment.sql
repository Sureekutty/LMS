
IF OBJECT_ID('speccs.SP_MiscellaneousPayment') IS NOT NULL
    DROP PROCEDURE speccs.SP_MiscellaneousPayment
GO

CREATE PROCEDURE speccs.SP_MiscellaneousPayment
    @MemAccNo     VARCHAR(10),
    @PurposeCode  VARCHAR(5),
    @PayDate      VARCHAR(10),
    @Amount       NUMERIC(15,2),
    @ChequeNo     VARCHAR(30),
    @Remarks      VARCHAR(200),
    @PayCode      VARCHAR(10),
    @UserId       VARCHAR(10),
    @IpAddress    VARCHAR(30)
AS
BEGIN
    DECLARE @ReceiptNo VARCHAR(14)

    EXEC speccs.SP_AutoNumber 'RECEIPTNO', NULL, @ReceiptNo OUTPUT

    INSERT INTO speccs.MiscellaneousPayment
    (MemAccNo, PurposeCode, PayDate, Amount, ChequeNo, Remarks, PayCode, UserId, RegTime, IpAddress)
    VALUES
    (@MemAccNo, @PurposeCode, @PayDate, @Amount, @ChequeNo, @Remarks, @PayCode, @UserId, GETDATE(), @IpAddress)

   -- INSERT INTO speccs.Receipts
   -- (MemAccNo, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment, UserId, RegTime, Status, Remarks, RefNo)
   --VALUES
   --(@MemAccNo, @ReceiptNo, @PayDate, @PurposeCode, @Amount, 'MISC', @UserId, GETDATE(), 'ACTIVE', @Remarks, @PayCode)

    INSERT INTO speccs.TransactionLog
    (UserId, Module, KeyId, Description, RecTime, ClientIP, Remarks)
    VALUES
    (@UserId, 'MiscPayment', @MemAccNo, 'Misc Payment Saved', GETDATE(), @IpAddress, @Remarks)
END
GO