/*

-- Comment: Create the new table ThriftRequests with specified columns
-- EmployeeName: Name of the employee
-- MemberAccNo: Account number from Members
-- ThriftSubscriptionAmount: Current subscription amount from MemberAccounts
-- RequestedAmount: The new amount requested by user
-- TransactionDate: Requested date (defaults to GETDATE())
-- Status: Defaults to 'Requested' (can be Requested, Rejected, Approved)
-- RegTime: Registration time (defaults to GETDATE())
-- UserId: empCode/session Id
CREATE TABLE speccs.ThriftUpdateStatus (
    EmployeeName VARCHAR(100),
    MemberAccNo VARCHAR(50),
    ThriftSubscriptionAmount DECIMAL(18,2),
    RequestedAmount DECIMAL(18,2),
    TransactionDate DATETIME ,
    Status VARCHAR(20) ,
    RegTime DATETIME ,
    UserId VARCHAR(50)
)



*/

-- Comment: Create the Sybase procedure to insert a request
-- Inputs: @EmpCode (from session), @RequestedAmount (from input)
-- Fetches: Name and MemAccNo from Members, ThriftSubscriptionAmount from MemberAccounts
-- Inserts: Into ThriftRequests with defaults for dates and status

IF OBJECT_ID ('speccs.SP_ThriftUpdateStatus') IS NOT NULL
	DROP PROCEDURE speccs.SP_ThriftUpdateStatus
GO
CREATE PROCEDURE speccs.SP_ThriftUpdateStatus
    @EmpCode VARCHAR(50),
    @RequestedAmount DECIMAL(18,2)
AS
BEGIN
    -- Comment: Declare variables for fetched data
    DECLARE @EmployeeName VARCHAR(100),
            @MemberAccNo VARCHAR(50),
            @ThriftSubscriptionAmount DECIMAL(18,2)

    -- Comment: Fetch Name and MemAccNo from Members table using @EmpCode
    SELECT @EmployeeName = MemName, @MemberAccNo = MemAccNo
    FROM speccs.Members
    WHERE MemEmpCode = @EmpCode

    -- Comment: Fetch current ThriftSubscriptionAmount from MemberAccounts using @MemberAccNo
    -- Assumption: Table is speccs.MemberAccounts, column is ThriftSubscriptionAmount (adjust if column name differs)
    SELECT @ThriftSubscriptionAmount = ThriftSubscriptionAmount
    FROM speccs.MemberAccount
    WHERE MemAccNo = @MemberAccNo

    -- Comment: Insert the record into ThriftRequests
    INSERT INTO speccs.ThriftUpdateStatus (
        EmployeeName,
        MemberAccNo,
        ThriftSubscriptionAmount,
        RequestedAmount,
        TransactionDate,
        Status,
        RegTime,
        UserId
    )
    VALUES (
        @EmployeeName,
        @MemberAccNo,
        @ThriftSubscriptionAmount,
        @RequestedAmount,
        GETDATE(),  -- Requested date
        'Requested',  -- Initial status
        GETDATE(),  -- Reg time
        @EmpCode  -- UserId
    )
    
    -- Comment: Optional - You can add error handling here if needed, e.g., IF @@ERROR != 0 ...
END