IF OBJECT_ID ('speccs.SP_ThriftLoanUpdateStatus') IS NOT NULL
	DROP PROCEDURE speccs.SP_ThriftLoanUpdateStatus
GO

CREATE PROCEDURE speccs.SP_ThriftLoanUpdateStatus
    @MemCode VARCHAR(50),--MemAccNO
    @RequestedAmount DECIMAL (18,2),
   	@EmpCode VARCHAR(50),
   	@Rem VARCHAR(50),
   	@Status VARCHAR(50),
   	@Option VARCHAR(50)
   	
    
AS
BEGIN
    -- Comment: Declare variables for fetched data
    DECLARE @EmployeeName VARCHAR(100),
           
            @Amount DECIMAL(18,2)

    -- Comment: Fetch Name and MemAccNo from Members table using @EmpCode
    SELECT @EmployeeName = MemName
    FROM speccs.Members
    WHERE MemEmpCode = @EmpCode

    -- Comment: Fetch current ThriftSubscriptionAmount from MemberAccounts using @MemberAccNo
    -- Assumption: Table is speccs.MemberAccounts, column is ThriftSubscriptionAmount (adjust if column name differs)
   
   IF (@Status = 'CANCEL')
    BEGIN
        UPDATE speccs.ThriftLoanUpdateStatus
        SET Status = 'CANCEL',
            TransactionDate = GETDATE()
        WHERE MemberAccNo = @MemCode AND Status = 'REQUEST'
       
    END
    
     IF (@Status = 'UPDATE')
    BEGIN
        -- Check what type of request it is
        IF EXISTS (SELECT 1 FROM speccs.ThriftLoanUpdateStatus WHERE MemberAccNo = @MemCode AND Status = 'REQUEST' AND MemberAccNo LIKE 'M%')
        BEGIN
            -- Update Thrift
            UPDATE speccs.MemberAccount
            SET ThriftSubscriptionAmount = @RequestedAmount,
                RegTime = GETDATE()
            WHERE MemAccNo = @MemCode

            UPDATE speccs.ThriftLoanUpdateStatus
            SET Status = 'UPDATE',
                TransactionDate = GETDATE()
            WHERE MemberAccNo = @MemCode AND Status = 'REQUEST'

            
        END
        ELSE IF EXISTS (SELECT 1 FROM speccs.ThriftLoanUpdateStatus WHERE MemberAccNo = @MemCode AND Status = 'REQUEST' AND MemberAccNo LIKE 'LTL%')
        BEGIN
            -- Update LTL Loan
            UPDATE speccs.Loans
            SET MonthlyInstallments = @RequestedAmount
            WHERE LoanAccNo= @MemCode AND LoanType ='LTL'

            UPDATE speccs.ThriftLoanUpdateStatus
            SET Status = 'UPDATE',
                TransactionDate = GETDATE()
            WHERE MemberAccNo = @MemCode AND Status = 'REQUEST'

           
        END
        ELSE IF EXISTS (SELECT 1 FROM speccs.ThriftLoanUpdateStatus WHERE MemberAccNo = @MemCode AND Status = 'REQUEST' AND MemberAccNo LIKE 'EXL%')
        BEGIN
            -- Update EXL Loan
            UPDATE speccs.Loans
            SET MonthlyInstallments = @RequestedAmount
            WHERE LoanAccNo= @MemCode AND LoanType ='EXL'

            UPDATE speccs.ThriftLoanUpdateStatus
            SET Status = 'UPDATE',
                TransactionDate = GETDATE()
            WHERE MemberAccNo = @MemCode AND Status = 'REQUEST'

          
        END
        END 

-----------------------

IF NOT EXISTS (SELECT 1 FROM speccs.ThriftLoanUpdateStatus WHERE MemAccNo = @MemCode AND Status = 'REQUEST' )
        BEGIN
        
        
   IF(@Option = 'THRIFT')
   BEGIN 
   
   
    SELECT @Amount = ThriftSubscriptionAmount
    FROM speccs.MemberAccount
    WHERE MemAccNo = @MemCode

    -- Comment: Insert the record into ThriftRequests
    INSERT INTO speccs.ThriftLoanUpdateStatus (
        EmployeeName,
        MemberAccNo,
        TLEAmount,
        RequestedAmount,
        TransactionDate,
        Status,
        RegTime,
        UserId
    )
    VALUES (
        @EmployeeName,
        @MemCode,
        @Amount,
        @RequestedAmount,
        GETDATE(),  -- Requested date
        @Status,  -- Initial status
        GETDATE(),  -- Reg time
        @EmpCode  -- UserId
    )
    
    END 
    ELSE IF(@Option = 'LTL')
    BEGIN
    /*
    
    SELECT
    FROM speccs.Loans
    WHERE MemAccNo = @MemCode AND LoanType='LTL'
*/
    -- Comment: Insert the record into ThriftRequests
    INSERT INTO speccs.ThriftLoanUpdateStatus (
        EmployeeName,
        MemberAccNo,
        TLEAmount,
        RequestedAmount,
        TransactionDate,
        Status,
        RegTime,
        UserId
    )
    VALUES (
        @EmployeeName,
        @MemCode,
        @Amount,
        @RequestedAmount,
        GETDATE(),  -- Requested date
        @Status,  -- Initial status
        GETDATE(),  -- Reg time
        @EmpCode  -- UserId
    )
    
    END 
    
    ELSE IF (@Option = 'EXL')
    BEGIN
    /*
    
     
    SELECT
    FROM speccs.Loans
    WHERE MemAccNo = @MemCode AND LoanType='EXL'
*/


    -- Comment: Insert the record into ThriftRequests
    INSERT INTO speccs.ThriftLoanUpdateStatus (
        EmployeeName,
        MemberAccNo,
        TLEAmount,
        RequestedAmount,
        TransactionDate,
        Status,
        RegTime,
        UserId
    )
    VALUES (
        @EmployeeName,
        @MemCode,
        @Amount,
        @RequestedAmount,
        GETDATE(),  -- Requested date
        @Status,  -- Initial status
        GETDATE(),  -- Reg time
        @EmpCode  -- UserId
    )
    
    END 
    -- Comment: Optional - You can add error handling here if needed, e.g., IF @@ERROR != 0 ...
        
        END 

END

GO

