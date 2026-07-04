
IF OBJECT_ID('speccs.sp_ThriftProcessUpload') IS NOT NULL
    DROP PROCEDURE speccs.sp_ThriftProcessUpload
GO

CREATE PROCEDURE speccs.sp_ThriftProcessUpload
AS
BEGIN
    -- Commented DROP and CREATE TABLE statements for prerequisites
    /*
    IF OBJECT_ID('speccs.ThriftInterestUploadTempNew') IS NOT NULL
        DROP TABLE speccs.ThriftInterestUploadTempNew
    CREATE TABLE speccs.ThriftInterestUploadTempNew (
        SerialNo INT,                -- Serial number
        EmpCode VARCHAR(50),         -- Employee code
        UploadDate DATETIME,         -- Upload date
        Amount FLOAT,                -- Amount
        ThriftType INT,              -- Thrift type
        MemAccNum VARCHAR(15)        -- Member account number
    )

    IF OBJECT_ID('speccs.Payments06082025temp') IS NOT NULL
        DROP TABLE speccs.Payments06082025temp
    CREATE TABLE speccs.Payments06082025temp (
        MemAccNo VARCHAR(15),        -- Member account number
        PayVoucherNo VARCHAR(15),    -- Payment voucher number
        VoucherDate DATETIME,        -- Voucher date
        PurposeCode VARCHAR(5),      -- Purpose code (e.g., 'M04')
        Amount FLOAT,                -- Payment amount
        ModeOfPayment VARCHAR(15),   -- Payment mode (e.g., 'cheque')
        Status VARCHAR(10),          -- Status (e.g., 'ACTIVE')
        RefNo VARCHAR(15),           -- Reference number
        Remarks VARCHAR(50),         -- Remarks (e.g., 'THRIFT INT')
        UserId VARCHAR(10),          -- User ID (e.g., 'SH15823')
        RegTime DATETIME             -- Registration time
    )

    IF OBJECT_ID('speccs.ThriftTransaction06082025temp') IS NOT NULL
        DROP TABLE speccs.ThriftTransaction06082025temp
    CREATE TABLE speccs.ThriftTransaction06082025temp (
        MemAccNo VARCHAR(15),        -- Member account number
        Month VARCHAR(8),            -- Transaction month
        TransactionDate DATETIME,    -- Transaction date
        ModeOfPayment VARCHAR(15),   -- Payment mode (e.g., 'Thrift Int ADj')
        Amount FLOAT,                -- Transaction amount
        ReceiptNo VARCHAR(15),       -- Receipt number
        UserId VARCHAR(10),          -- User ID
        RegTime DATETIME,            -- Registration time
        ThriftBalance FLOAT          -- Thrift balance
    )

    IF OBJECT_ID('speccs.LoanTransactions06082025temp') IS NOT NULL
        DROP TABLE speccs.LoanTransactions06082025temp
    CREATE TABLE speccs.LoanTransactions06082025temp (
        LoanAccNo VARCHAR(10),       -- Loan account number
        TransactionDate DATETIME,    -- Transaction date
        PayCode VARCHAR(5),          -- Payment code (e.g., 'L26')
        Amount FLOAT,                -- Transaction amount
        P_I CHAR(1),                 -- Principal/Interest flag (e.g., 'P')
        ReceiptNo VARCHAR(14),       -- Receipt number
        Modeofpay VARCHAR(15),       -- Mode of payment (e.g., 'Thrift Int')
        ClosingBal NUMERIC(15,2),    -- Closing balance
        RegTime DATETIME,            -- Registration time
        UserId VARCHAR(10)           -- User ID
    )

    IF OBJECT_ID('speccs.Receipts06082025temp') IS NOT NULL
        DROP TABLE speccs.Receipts06082025temp
    CREATE TABLE speccs.Receipts06082025temp (
        MemAccNO VARCHAR(15),        -- Member account number (Note: Capital 'O')
        ReceiptNo VARCHAR(15),       -- Receipt number
        ReceiptDate DATETIME,        -- Receipt date
        PurposeCode VARCHAR(5),      -- Purpose code (e.g., 'L26')
        Amount FLOAT,                -- Receipt amount
        ModeOfPayment VARCHAR(15),   -- Payment mode (e.g., 'Cheque')
        UserId VARCHAR(10),          -- User ID
        RegTime DATETIME,            -- Registration time
        Status VARCHAR(10),          -- Status (e.g., 'ACTIVE')
        Remarks VARCHAR(50),         -- Remarks (e.g., 'Thrift Int')
        RefNo VARCHAR(15),           -- Reference number
        BankCode VARCHAR(10)         -- Bank code
    )

    IF OBJECT_ID('speccs.Loans06082025temp') IS NOT NULL
        DROP TABLE speccs.Loans06082025temp
    CREATE TABLE speccs.Loans06082025temp (
        MemAccNo VARCHAR(15),        -- Member account number
        LoanAccNo VARCHAR(10),       -- Loan account number
        LoanSanctionAmount FLOAT,    -- Sanctioned loan amount
        LoanStatus VARCHAR(10),      -- Loan status (e.g., 'RELEASED')
        RegTime DATETIME             -- Registration time
    )

    IF OBJECT_ID('speccs.ThriftProcessingErrors06082025temp') IS NOT NULL
        DROP TABLE speccs.ThriftProcessingErrors06082025temp
    CREATE TABLE speccs.ThriftProcessingErrors06082025temp (
        SerialNo INT,                -- Serial number
        EmpCode VARCHAR(50),         -- Employee code
        ErrorMessage VARCHAR(255),   -- Error message
        ErrorDate DATETIME           -- Error date
    )
    */

    -- Declare variables
    DECLARE @SerialNo INT,
            @EmpCode VARCHAR(50),
            @UploadDate DATETIME,
            @Amount FLOAT,
            @ThriftType INT,
            @MemAccNum VARCHAR(15),
            @ReceiptNo VARCHAR(15),
            @ReceiptNumberT1 VARCHAR(15),
            @ReceiptNumberT2 VARCHAR(15),
            @RefNumber1 VARCHAR(15),
            @Adddate DATETIME,
            @YYYY INT,
            @ThriftMinBal FLOAT,
            @ThriftMaxBal FLOAT,
            @Message VARCHAR(255),
            @RecordCount INT,
            @MAccNo1 VARCHAR(10),
            @RecNum1 VARCHAR(14),
            @RefNo VARCHAR(15),
            @ClosingBalance NUMERIC(15,2)

    -- Get the count of records to process
    SELECT @RecordCount = COUNT(*)
    FROM speccs.ThriftInterestUploadTempNew

    -- Process each record one by one
    WHILE @RecordCount > 0
    BEGIN
        -- Fetch the next record
        SELECT TOP 1
            @SerialNo = SerialNo,
            @EmpCode = EmpCode,
            @UploadDate = UploadDate,
            @Amount = Amount,
            @ThriftType = ThriftType,
            @MemAccNum = MemAccNum
        FROM speccs.ThriftInterestUploadTempNew
        ORDER BY SerialNo

        -- ********** Start Payments Generation **********
        EXEC speccs.SP_AutoNumber 'PAYMENTNO', NULL, @ReceiptNo OUTPUT
        WAITFOR DELAY '00:00:01' -- 1-second delay to ensure unique receipt generation

        IF @ReceiptNo IS NULL
        BEGIN
            SELECT @Message = 'Failed to generate PAYMENTNO for EmpCode ' + @EmpCode
            INSERT INTO speccs.ThriftProcessingErrors06082025temp (SerialNo, EmpCode, ErrorMessage, ErrorDate)
            VALUES (@SerialNo, @EmpCode, @Message, GETDATE())
            DELETE FROM speccs.ThriftInterestUploadTempNew WHERE SerialNo = @SerialNo
            SET @RecordCount = @RecordCount - 1
            CONTINUE
        END

        INSERT INTO speccs.Payments06082025temp (MemAccNo, PayVoucherNo, VoucherDate, PurposeCode, Amount, ModeOfPayment, Status, RefNo, Remarks, UserId, RegTime)
        VALUES (@MemAccNum, @ReceiptNo, @UploadDate, 'M04', @Amount, 'cheque', 'ACTIVE', @MemAccNum, 'THRIFT INT', 'SH15823', GETDATE())

        IF @@ERROR != 0
        BEGIN
            SELECT @Message = 'Error inserting into Payments06082025temp for EmpCode ' + @EmpCode
            INSERT INTO speccs.ThriftProcessingErrors06082025temp (SerialNo, EmpCode, ErrorMessage, ErrorDate)
            VALUES (@SerialNo, @EmpCode, @Message, GETDATE())
            DELETE FROM speccs.ThriftInterestUploadTempNew WHERE SerialNo = @SerialNo
            SET @RecordCount = @RecordCount - 1
            CONTINUE
        END
        -- ********** End Payments Generation **********

        -- ********** Start Thrift Adjustment **********
        -- Calculate Adddate (April 1st of current year)
        SELECT @YYYY = DATEPART(YY, GETDATE())
        SELECT @Adddate = CAST('04/01/' + CAST(@YYYY AS VARCHAR(4)) AS DATETIME)

        -- Get the member account number
        SELECT @RefNumber1 = MemAccNo
        FROM speccs.Members
        WHERE MemEmpCode = @EmpCode AND Status = 'ACTIVE'

        IF @RefNumber1 IS NULL
        BEGIN
            SELECT @Message = 'No active member found for EmpCode ' + @EmpCode
            INSERT INTO speccs.ThriftProcessingErrors06082025temp (SerialNo, EmpCode, ErrorMessage, ErrorDate)
            VALUES (@SerialNo, @EmpCode, @Message, GETDATE())
            DELETE FROM speccs.ThriftInterestUploadTempNew WHERE SerialNo = @SerialNo
            SET @RecordCount = @RecordCount - 1
            CONTINUE
        END

        -- Create temp table for thrift transactions
        SELECT MemAccNo, TransactionDate, ThriftBalance, ReceiptNo
        INTO #tempData81
        FROM speccs.ThriftTransaction06082025temp
        WHERE MemAccNo = @RefNumber1 AND TransactionDate > @Adddate AND TransactionDate < @UploadDate

        -- Nested loop for thrift adjustments (moved before ThriftMinBal selection)
        WHILE EXISTS (SELECT 1 FROM #tempData81)
        BEGIN
            SELECT TOP 1 @MAccNo1 = MemAccNo, @RecNum1 = ReceiptNo
            FROM #tempData81

            UPDATE speccs.ThriftTransaction06082025temp
            SET ThriftBalance = ThriftBalance + @Amount
            WHERE MemAccNo = @MAccNo1 AND ReceiptNo = @RecNum1

            DELETE FROM #tempData81
            WHERE MemAccNo = @MAccNo1 AND ReceiptNo = @RecNum1
        END

        -- Calculate ThriftMinBal and ThriftMaxBal
        SELECT TOP 1 @ThriftMinBal = ThriftBalance
        FROM speccs.ThriftTransaction06082025temp
        WHERE MemAccNo = @RefNumber1 AND TransactionDate <= @Adddate
        ORDER BY TransactionDate DESC

        SELECT TOP 1 @ThriftMaxBal = ThriftBalance
        FROM speccs.ThriftTransaction06082025temp
        WHERE MemAccNo = @RefNumber1 AND TransactionDate < @UploadDate
        ORDER BY TransactionDate DESC

        -- Insert adjustment records
        EXEC speccs.SP_AutoNumber 'RECEIPTNO', NULL, @ReceiptNumberT1 OUTPUT
        WAITFOR DELAY '00:00:01' -- 1-second delay for receipt generation

        IF @ReceiptNumberT1 IS NULL
        BEGIN
            SELECT @Message = 'Failed to generate RECEIPTNO T1 for EmpCode ' + @EmpCode
            INSERT INTO speccs.ThriftProcessingErrors06082025temp (SerialNo, EmpCode, ErrorMessage, ErrorDate)
            VALUES (@SerialNo, @EmpCode, @Message, GETDATE())
            DELETE FROM speccs.ThriftInterestUploadTempNew WHERE SerialNo = @SerialNo
            SET @RecordCount = @RecordCount - 1
            CONTINUE
        END

        INSERT INTO speccs.ThriftTransaction06082025temp (MemAccNo, Month, TransactionDate, ModeOfPayment, Amount, ReceiptNo, UserId, RegTime, ThriftBalance)
        VALUES (@MemAccNum, CONVERT(VARCHAR(8), DATEPART(MM, @Adddate)), @Adddate, 'Thrift Int ADj', @Amount, @ReceiptNumberT1, 'SH15823', GETDATE(), COALESCE(@ThriftMinBal, 0) + @Amount)

        EXEC speccs.SP_AutoNumber 'RECEIPTNO', NULL, @ReceiptNumberT2 OUTPUT
        WAITFOR DELAY '00:00:01' -- 1-second delay for receipt generation

        IF @ReceiptNumberT2 IS NULL
        BEGIN
            SELECT @Message = 'Failed to generate RECEIPTNO T2 for EmpCode ' + @EmpCode
            INSERT INTO speccs.ThriftProcessingErrors06082025temp (SerialNo, EmpCode, ErrorMessage, ErrorDate)
            VALUES (@SerialNo, @EmpCode, @Message, GETDATE())
            DELETE FROM speccs.ThriftInterestUploadTempNew WHERE SerialNo = @SerialNo
            SET @RecordCount = @RecordCount - 1
            CONTINUE
        END

        INSERT INTO speccs.ThriftTransaction06082025temp (MemAccNo, Month, TransactionDate, ModeOfPayment, Amount, ReceiptNo, UserId, RegTime, ThriftBalance)
        VALUES (@MemAccNum, CONVERT(VARCHAR(8), DATEPART(MM, @UploadDate)), @UploadDate, 'Thrift Int Adj', 0 - @Amount, @ReceiptNumberT2, 'SH15823', GETDATE(), COALESCE(@ThriftMaxBal, 0) - @Amount)
        -- ********** End Thrift Adjustment **********

        -- ********** Start ThriftType Checking **********
        IF @ThriftType = 2
        BEGIN
            -- Loan Transaction Logic
            EXEC speccs.SP_AutoNumber 'RECEIPTNO', NULL, @ReceiptNo OUTPUT
            WAITFOR DELAY '00:00:01' -- 1-second delay for receipt generation

            IF @ReceiptNo IS NULL
            BEGIN
                SELECT @Message = 'Failed to generate RECEIPTNO for loan transaction for EmpCode ' + @EmpCode
                INSERT INTO speccs.ThriftProcessingErrors06082025temp (SerialNo, EmpCode, ErrorMessage, ErrorDate)
                VALUES (@SerialNo, @EmpCode, @Message, GETDATE())
                DELETE FROM speccs.ThriftInterestUploadTempNew WHERE SerialNo = @SerialNo
                SET @RecordCount = @RecordCount - 1
                CONTINUE
            END

            SELECT @RefNo = l.LoanAccNo
            FROM speccs.Members m
            JOIN speccs.Loans06082025temp l ON m.MemAccNo = l.MemAccNo
            WHERE m.MemEmpCode = @EmpCode AND m.Status = 'ACTIVE'

            IF @RefNo IS NULL
            BEGIN
                SELECT @Message = 'No active loan found for EmpCode ' + @EmpCode
                INSERT INTO speccs.ThriftProcessingErrors06082025temp (SerialNo, EmpCode, ErrorMessage, ErrorDate)
                VALUES (@SerialNo, @EmpCode, @Message, GETDATE())
                DELETE FROM speccs.ThriftInterestUploadTempNew WHERE SerialNo = @SerialNo
                SET @RecordCount = @RecordCount - 1
                CONTINUE
            END

            SELECT TOP 1 @ClosingBalance = ClosingBal
            FROM speccs.LoanTransactions06082025temp
            WHERE LoanAccNo = @RefNo AND P_I = 'P' AND PayCode IN ('L23', 'L24', 'L26')
            ORDER BY TransactionDate DESC

            UPDATE speccs.Loans06082025temp
            SET LoanSanctionAmount = LoanSanctionAmount - @Amount,
                RegTime = GETDATE()
            WHERE LoanAccNo = @RefNo AND LoanStatus = 'RELEASED'

            INSERT INTO speccs.LoanTransactions06082025temp (LoanAccNo, TransactionDate, PayCode, Amount, P_I, ReceiptNo, Modeofpay, ClosingBal, RegTime, UserId)
            VALUES (@RefNo, @UploadDate, 'L26', @Amount, 'P', @ReceiptNo, 'Thrift Int', COALESCE(@ClosingBalance, 0) - @Amount, GETDATE(), 'SH15823')

            INSERT INTO speccs.Receipts06082025temp (MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment, UserId, RegTime, Status, Remarks, RefNo, BankCode)
            VALUES (@MemAccNum, @ReceiptNo, @UploadDate, 'L26', @Amount, 'Cheque', 'SH15823', GETDATE(), 'ACTIVE', 'Thrift Int', @RefNo, '')
        END
        ELSE IF @ThriftType = 3
        BEGIN
            -- Thrift Transaction Logic
            EXEC speccs.SP_AutoNumber 'RECEIPTNO', NULL, @ReceiptNo OUTPUT
            WAITFOR DELAY '00:00:01' -- 1-second delay for receipt generation

            IF @ReceiptNo IS NULL
            BEGIN
                SELECT @Message = 'Failed to generate RECEIPTNO for thrift transaction for EmpCode ' + @EmpCode
                INSERT INTO speccs.ThriftProcessingErrors06082025temp (SerialNo, EmpCode, ErrorMessage, ErrorDate)
                VALUES (@SerialNo, @EmpCode, @Message, GETDATE())
                DELETE FROM speccs.ThriftInterestUploadTempNew WHERE SerialNo = @SerialNo
                SET @RecordCount = @RecordCount - 1
                CONTINUE
            END

            SELECT TOP 1 @ThriftMinBal = ThriftBalance
            FROM speccs.ThriftTransaction06082025temp
            WHERE MemAccNo = @MemAccNum
            ORDER BY TransactionDate DESC

            INSERT INTO speccs.ThriftTransaction06082025temp (MemAccNo, Month, TransactionDate, ModeOfPayment, Amount, ReceiptNo, UserId, RegTime, ThriftBalance)
            VALUES (@MemAccNum, CONVERT(VARCHAR(8), DATEPART(MM, @UploadDate)), @UploadDate, 'Thrift Int', @Amount, @ReceiptNo, 'SH15823', GETDATE(), COALESCE(@ThriftMinBal, 0) + @Amount)

            INSERT INTO speccs.Receipts06082025temp (MemAccNO, ReceiptNo, ReceiptDate, PurposeCode, Amount, ModeOfPayment, UserId, RegTime, Status, Remarks, RefNo, BankCode)
            VALUES (@MemAccNum, @ReceiptNo, @UploadDate, 'M43', @Amount, 'Cheque', 'SH15823', GETDATE(), 'ACTIVE', 'Thrift Int', @MemAccNum, '')
        END
        -- ********** End ThriftType Checking **********

        -- Delete the processed record
        DELETE FROM speccs.ThriftInterestUploadTempNew
        WHERE SerialNo = @SerialNo

        -- Decrement the record count
        SET @RecordCount = @RecordCount - 1
    END
END
GO