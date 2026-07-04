

-- Step 1: Store the selected rows in a temporary table from table you want
SELECT Amount,MemAccNo,MonthlyInstallment INTO #tempData5 FROM speccs.TempEXLLoan

-- Step 2: Declare variables for iteration
DECLARE @MemAccNo VARCHAR(10), @Amount NUMERIC(15,2),@MonthlyInstallments INT ,@LoanNoNew VARCHAR(10),@ReceiptNo VARCHAR(14)

-- Step 3: Loop through the temporary table
WHILE EXISTS (SELECT 1 FROM #tempData5)
BEGIN
    -- Fetch the first row
    SELECT TOP 1 @MemAccNo=MemAccNo,@Amount=Amount,@MonthlyInstallments=MonthlyInstallment FROM #tempData5
 
	EXEC  speccs.SP_AutoNumber 'EXL',NULL ,@LoanNoNew output
	    -- Insert into LoanTransactions
   
	INSERT INTO speccs.Loans (MemAccNo, LoanAccNo, LoanType, LoanPurpose, NoOfInstallments, MonthlyInstallments, Thriftdudamt, LoanStatus, FundId, LoanSanctionAmount, InterestMethod, InterestRate, LoanSanctionDate, InterestCalculatedFromDate, DisbursedOnDate, DisbursedOnUserId, ClosedOnDate, ClosedOnUserId, Surety1, Surety2, Surety3, Loanappdate, Loanrejecteddate, Recoverydate, Releaseddate, Remarks, UserId, RegTime, ChequeAmount)
	VALUES (@MemAccNo, @LoanNoNew, 'EXL', 'purp', 12, @MonthlyInstallments, 0, 'RELEASED', ' ', @Amount, NULL, 9, convert(DATE,'02/28/2025'), NULL, NULL, NULL, NULL, NULL, 'sur1', 'sur2','sur2', convert(DATE,'02/28/2025'), NULL, convert(DATE,'02/28/2025'), convert(DATE,'02/28/2025'), 'Manually Inserted', 'SH15823', getdate(), @Amount)
   
		    -- Call SP_Receipts
		    EXEC SP_Receipts 'SAVE', @MemAccNo, '02/28/2025', 'L28', @Amount, 'CHEQUE', @LoanNoNew, 'SH15823', '', '',
		        'Loan Disbursement', @ReceiptNo OUTPUT
		
		    -- Insert into LoanTransactions
		    INSERT INTO speccs.LoanTransactions
		    VALUES (@LoanNoNew, convert(DATE,'02/28/2025'), 'L28', 0, 'P', @ReceiptNo, 'Bal Update', @Amount, GETDATE(), 'SH15823') 

    -- Remove the processed row
    DELETE FROM #tempData5 WHERE MemAccNo = @MemAccNo
END




-- to insert into LoanTransaction table


--to generate receipt and loan transaction 
-- Step 1: Store the selected rows in a temporary table from table you want
SELECT a.* INTO #tempData7 FROM speccs.TempLoanSanctionAmount a 
--SELECT * FROM speccs.Loans WHERE LoanAccNo NOT IN (SELECT LoanAccNo FROM speccs.LoanTransactions) AND LoanType='EXL'
-- Step 2: Declare variables for iteration
DECLARE @Amount NUMERIC(15,2),@MemAccNo VARCHAR(10),@LoanAccNo VARCHAR(10)

-- Step 3: Loop through the temporary table
WHILE EXISTS (SELECT 1 FROM #tempData7)
BEGIN
    -- Fetch the first row
    SELECT TOP 1 @MemAccNo = MemAccNo,
                 @LoanAccNo = LoanAccNo,
                 @Amount = Amount
                 
    FROM #tempData7

    -- Assign purpose codes
      /*  IF (@LoanAccNo LIKE 'LTL%') BEGIN
            SELECT @purposecode_principal = 'L23'
            
        END	*/
         IF (@LoanAccNo LIKE 'EXL%') BEGIN
            SELECT @purposecode_principal = 'L28'
            
        END
        /*IF (@LoanAccNo LIKE 'FDL%') BEGIN
            SELECT @purposecode_principal = 'L34'
            SELECT @purposecode_interest = 'L35'
		END	
		--LTL start
	   	IF(@purposecode_principal='L23')
		BEGIN 
		    -- Call SP_Receipts
		    EXEC SP_Receipts 'SAVE', @MemAccNo, '04/01/2025', @purposecode_principal, round(@Amount/100,-3), 'CHEQUE', @LoanAccNo, 'SH15823', '', '',
		        'Loan Principle Amount', @ReceiptNo OUTPUT
		
		    -- Insert into LoanTransactions
		    INSERT INTO speccs.LoanTransactions
		    VALUES (@LoanAccNo, '04/01/2025', @purposecode_principal, 0, 'P', @ReceiptNo, 'Loan Disbursment', @LoanCBL, GETDATE(), 'SH15823') 
		END */
		
	  /*	IF(@purposecode_interest='L25')
		BEGIN 
			-- Call SP_Receipts
		    EXEC SP_Receipts 'SAVE', @MemAccNo, '11/26/2024', @purposecode_interest, @IntAmount, 'CHEQUE', @LoanAccNo, 'SH15823', '', '',
		        'Loan Interest Amount', @ReceiptNo OUTPUT
		        
		    INSERT INTO speccs.LoanTransactions
		    VALUES (@LoanAccNo, GETDATE(), @purposecode_interest, @IntAmount, 'I', @ReceiptNo, 'CHEQUE', 0, GETDATE(), 'SH15823')
		END */
		--LTL end	
		--EXL start
	 	IF(@purposecode_principal='L28')
		BEGIN 
		    -- Call SP_Receipts
		    EXEC SP_Receipts 'SAVE', @MemAccNo, '11/26/2024', @purposecode_principal, @PriAmount, 'CHEQUE', @LoanAccNo, 'SH15606', '', '',
		        'EXL Principle Amount', @ReceiptNo OUTPUT
		
		    -- Insert into LoanTransactions
		    INSERT INTO speccs.LoanTransactions
		    VALUES (@LoanAccNo, GETDATE(), @purposecode_principal, @PriAmount, 'P', @ReceiptNo, 'CHEQUE', @LoanCBL, GETDATE(), 'SH15606') 
		END 
		
	 /* 	IF(@purposecode_interest='L30')
		BEGIN 
			-- Call SP_Receipts
		    EXEC SP_Receipts 'SAVE', @MemAccNo, '11/26/2024', @purposecode_interest, @IntAmount, 'CHEQUE', @LoanAccNo, 'SH15606', '', '',
		        'EXL Interest Amount', @ReceiptNo OUTPUT
		        
		    INSERT INTO speccs.LoanTransactions
		    VALUES (@LoanAccNo, GETDATE(), @purposecode_interest, @IntAmount, 'I', @ReceiptNo, 'CHEQUE', 0, GETDATE(), 'SH15606')
		END */
		--EXL end
		
    -- Remove the processed row
    DELETE FROM #tempData7 WHERE LoanAccNo = @LoanAccNo
END







-----------------------------------------------

SELECT a.MemAccNo,a.LoanAccNo,c.Amount INTO #a1 FROM speccs.Loans a
Join (SELECT MemAccNo ,max(RegTime) AS RegTime
FROM speccs.Loans WHERE LoanType='EXL' GROUP BY MemAccNo) b 
ON a.MemAccNo=b.MemAccNo AND a.RegTime=b.RegTime AND LoanType='EXL' JOIN speccs.TempEXLLoan c
ON a.MemAccNo=c.MemAccNo

UPDATE speccs.Loans
SET RegTime=getdate(), LoanSanctionAmount=b.Amount
FROM speccs.Loans l,#a1 b
WHERE l.LoanAccNo=b.LoanAccNo


SELECT * FROM speccs.TempEXLLoan WHERE MemAccNo NOT IN (SELECT MemAccNo FROM speccs.Loans WHERE LoanType='EXL' and convert(DATE,RegTime)='04/09/2025')

SELECT convert(DATETIME,'04/09/2025',103)


-- these much member should have to be inserted in ltl loan table
SELECT * FROM speccs.Loans WHERE LoanType='LTL' and MemAccNo IN ('M1964', 'M1966', 'M1892', 'M2033', 'M1894', 'M4926', 'M1897', 'M1899', 'M1971', 'M1972', 'M1904', 'M2039', 'M1906', 'M1907', 'M1908', 'M1973', 'M1911', 'M1914', 'M1974', 'M1918', 'M1919', 'M1976', 'M1978', 'M1920', 'M1922', 'M1980', 'M2037', 'M1923', 'M1924', 'M1925', 'M1982', 'M1926', 'M1985', 'M1986', 'M1930', 'M1931', 'M1932', 'M1989', 'M1990', 'M1993', 'M1996', 'M1937', 'M1938', 'M2000', 'M2001', 'M2042', 'M2003', 'M2043', 'M2004', 'M1943', 'M1946', 'M2006', 'M2007', 'M2008', 'M2012', 'M2015', 'M2017', 'M2034', 'M2035', 'M2036', 'M2025', 'M2040', 'M2026', 'M2027', 'M2030', 'M1855', 'M1856', 'M1860', 'M2009', 'M1945', 'M2020', 'M1944', 'M1913', 'M1903', 'M1999', 'M2022', 'M1917', 'M2021', 'M2014', 'M1994', 'M1991', 'M1862', 'M1934', 'M1977', 'M1935', 'M2011', 'M1929', 'M1970', 'M1890', 'M1889', 'M2041', 'M1988', 'M1941', 'M1995', 'M1940', 'M2002', 'M1984', 'M1939', 'M1933', 'M1928', 'M2019', 'M1992', 'M2018', 'M2016', 'M2045', 'M1902', 'M1853', 'M1936', 'M1898', 'M1969', 'M1895', 'M1927', 'M1979', 'M1997', 'M1916', 'M2029', 'M2013', 'M1965', 'M1896', 'M1891', 'M1887', 'M1909', 'M1857', 'M1858', 'M1863', 'M1947', 'M1859', 'M1893', 'M1968', 'M2038', 'M1905', 'M1975', 'M1921', 'M1981', 'M1983', 'M1987', 'M1998', 'M1942', 'M2010', 'M2044', 'M1888', 'M2005', 'M2028', 'M1861', 'M1912', 'M1901', 'M1915')

---- these much member should have to be inserted in EXL  loan table

WHERE MemAccNo IN ('M0167', 'M0181', 'M0182', 'M0283', 'M0371', 'M0417', 'M1859', 'M0620', 'M0632', 'M0676', 'M0683', 'M0711', 'M0816', 'M0844', 'M0856', 'M0903', 'M0916', 'M0921', 'M0933', 'M0940', 'M0951', 'M0960', 'M0990', 'M0997', 'M1015', 'M1027', 'M1029', 'M1080', 'M1216', 'M1221', 'M1238', 'M1270', 'M1292', 'M1313', 'M1319', 'M1329', 'M1354', 'M1371', 'M1423', 'M1474', 'M1492', 'M1631', 'M1699', 'M1733', 'M1988', 'M1993', 'M1994', 'M2042', 'M2008', 'M2036', 'M2025', 'M1782', 'M1786', 'M2028', 'M1800', 'M1816', 'M0121', 'M0297', 'M0317', 'M0542', 'M0749', 'M0920', 'M1070', 'M1104', 'M1202', 'M1450', 'M1671', 'M1906')

SELECT * FROM speccs.Loans WHERE convert(DATE,RegTime)='04/09/2025' AND  LoanAccNo IN ('LTL012', 'LTL019', 'LTL022', 'LTL023', 'LTL031', 'LTL038', 'LTL041', 'LTL042', 'LTL095', 'LTL1002', 'LTL1004', 'LTL1013', 'LTL1018', 'LTL1019', 'LTL1020', 'LTL1022', 'LTL1026', 'LTL1030', 'LTL1032', 'LTL1034', 'LTL1036', 'LTL1040', 'LTL1043', 'LTL105', 'LTL1054', 'LTL1057', 'LTL1062', 'LTL1071', 'LTL1081', 'LTL1083', 'LTL1084', 'LTL1085', 'LTL1087', 'LTL1091', 'LTL1096', 'LTL1097', 'LTL1098', 'LTL1099', 'LTL1100', 'LTL1103', 'LTL1105', 'LTL1106', 'LTL1107', 'LTL1127', 'LTL1149', 'LTL1154', 'LTL1163', 'LTL1171', 'LTL1183', 'LTL1185', 'LTL1186', 'LTL1188', 'LTL1194', 'LTL1195', 'LTL1200', 'LTL1213', 'LTL1214', 'LTL1215', 'LTL1219', 'LTL1229', 'LTL1231', 'LTL1232', 'LTL1237', 'LTL1239', 'LTL1242', 'LTL1243', 'LTL1245', 'LTL1248', 'LTL1249', 'LTL1250', 'LTL1254', 'LTL1255', 'LTL1259', 'LTL1262', 'LTL1263', 'LTL1267', 'LTL1269', 'LTL1285', 'LTL1289', 'LTL1294', 'LTL1297', 'LTL1301', 'LTL1305', 'LTL1307', 'LTL131', 'LTL1318', 'LTL1324', 'LTL1333', 'LTL1336', 'LTL1339', 'LTL1344', 'LTL1351', 'LTL1355', 'LTL1360', 'LTL1368', 'LTL1369', 'LTL137', 'LTL1370', 'LTL1375', 'LTL1380', 'LTL1392', 'LTL1395', 'LTL1398', 'LTL1408', 'LTL1415', 'LTL142', 'LTL1426', 'LTL1431', 'LTL1433', 'LTL1434', 'LTL1435', 'LTL1436', 'LTL1437', 'LTL1439', 'LTL144', 'LTL1445', 'LTL1446', 'LTL1447', 'LTL1453', 'LTL1454', 'LTL1455', 'LTL1464', 'LTL1467', 'LTL1468', 'LTL1475', 'LTL1479', 'LTL1487', 'LTL1489', 'LTL1493', 'LTL1504', 'LTL1516', 'LTL1520', 'LTL1521', 'LTL1522', 'LTL1523', 'LTL1526', 'LTL1532', 'LTL1539', 'LTL154', 'LTL1543', 'LTL1545', 'LTL1553', 'LTL1556', 'LTL157', 'LTL1581', 'LTL1587', 'LTL1588', 'LTL1589', 'LTL1590', 'LTL1595', 'LTL160', 'LTL1606', 'LTL1609', 'LTL1612', 'LTL1617', 'LTL1621', 'LTL1636', 'LTL1642', 'LTL1666', 'LTL1675', 'LTL1688', 'LTL1689', 'LTL1695', 'LTL1696', 'LTL1705', 'LTL172', 'LTL1729', 'LTL173', 'LTL1732', 'LTL1736', 'LTL1740', 'LTL1742', 'LTL1751', 'LTL1755', 'LTL1757', 'LTL1764', 'LTL1767', 'LTL1768', 'LTL1793', 'LTL1794', 'LTL1894', 'LTL1904', 'LTL1905', 'LTL1909', 'LTL1936', 'LTL1941', 'LTL1961', 'LTL1971', 'LTL1973', 'LTL1975', 'LTL1979', 'LTL1985', 'LTL1999', 'LTL2007', 'LTL2018', 'LTL205', 'LTL207', 'LTL218', 'LTL231', 'LTL245', 'LTL248', 'LTL249', 'LTL250', 'LTL252', 'LTL253', 'LTL254', 'LTL257', 'LTL258', 'LTL260', 'LTL261', 'LTL267', 'LTL308', 'LTL314', 'LTL315', 'LTL325', 'LTL342', 'LTL349', 'LTL352', 'LTL357', 'LTL359', 'LTL366', 'LTL369', 'LTL372', 'LTL383', 'LTL391', 'LTL400', 'LTL415', 'LTL429', 'LTL434', 'LTL446', 'LTL458', 'LTL464', 'LTL465', 'LTL470', 'LTL473', 'LTL474', 'LTL476', 'LTL485', 'LTL494', 'LTL495', 'LTL498', 'LTL499', 'LTL504', 'LTL505', 'LTL507', 'LTL510', 'LTL530', 'LTL541', 'LTL550', 'LTL551', 'LTL554', 'LTL558', 'LTL560', 'LTL561', 'LTL564', 'LTL565', 'LTL569', 'LTL570', 'LTL576', 'LTL583', 'LTL584', 'LTL590', 'LTL594', 'LTL595', 'LTL596', 'LTL598', 'LTL602', 'LTL606', 'LTL607', 'LTL608', 'LTL611', 'LTL613', 'LTL614', 'LTL617', 'LTL619', 'LTL626', 'LTL627', 'LTL629', 'LTL631', 'LTL639', 'LTL640', 'LTL643', 'LTL646', 'LTL647', 'LTL648', 'LTL649', 'LTL652', 'LTL653', 'LTL655', 'LTL656', 'LTL659', 'LTL673', 'LTL675', 'LTL677', 'LTL702', 'LTL703', 'LTL706', 'LTL708', 'LTL713', 'LTL715', 'LTL716', 'LTL717', 'LTL722', 'LTL723', 'LTL728', 'LTL730', 'LTL734', 'LTL746', 'LTL747', 'LTL753', 'LTL754', 'LTL757', 'LTL761', 'LTL762', 'LTL764', 'LTL765', 'LTL767', 'LTL773', 'LTL785', 'LTL786', 'LTL788', 'LTL789', 'LTL791', 'LTL793', 'LTL796', 'LTL798', 'LTL811', 'LTL814', 'LTL818', 'LTL824', 'LTL825', 'LTL826', 'LTL834', 'LTL835', 'LTL837', 'LTL839', 'LTL840', 'LTL841', 'LTL845', 'LTL846', 'LTL849', 'LTL854', 'LTL855', 'LTL858', 'LTL861', 'LTL862', 'LTL870', 'LTL872', 'LTL880', 'LTL881', 'LTL884', 'LTL885', 'LTL896', 'LTL897', 'LTL898', 'LTL901', 'LTL906', 'LTL911', 'LTL913', 'LTL917', 'LTL926', 'LTL931', 'LTL934', 'LTL936', 'LTL938', 'LTL939', 'LTL943', 'LTL944', 'LTL948', 'LTL950', 'LTL953', 'LTL956', 'LTL958', 'LTL967', 'LTL972', 'LTL974', 'LTL980', 'LTL984', 'LTL985', 'LTL986')


UPDATE speccs.Loans
SET RegTime=getdate(), LoanSanctionAmount=t.Amount FROM
  speccs.Loans l,speccs.TempLoanSanctionAmount t
WHERE l.MemAccNo=t.MemAccNo AND l.LoanAccNo IN ('LTL012', 'LTL019', 'LTL022', 'LTL023', 'LTL031', 'LTL038', 'LTL041', 'LTL042', 'LTL095', 'LTL1002', 'LTL1004', 'LTL1013', 'LTL1018', 'LTL1019', 'LTL1020', 'LTL1022', 'LTL1026', 'LTL1030', 'LTL1032', 'LTL1034', 'LTL1036', 'LTL1040', 'LTL1043', 'LTL105', 'LTL1054', 'LTL1057', 'LTL1062', 'LTL1071', 'LTL1081', 'LTL1083', 'LTL1084', 'LTL1085', 'LTL1087', 'LTL1091', 'LTL1096', 'LTL1097', 'LTL1098', 'LTL1099', 'LTL1100', 'LTL1103', 'LTL1105', 'LTL1106', 'LTL1107', 'LTL1127', 'LTL1149', 'LTL1154', 'LTL1163', 'LTL1171', 'LTL1183', 'LTL1185', 'LTL1186', 'LTL1188', 'LTL1194', 'LTL1195', 'LTL1200', 'LTL1213', 'LTL1214', 'LTL1215', 'LTL1219', 'LTL1229', 'LTL1231', 'LTL1232', 'LTL1237', 'LTL1239', 'LTL1242', 'LTL1243', 'LTL1245', 'LTL1248', 'LTL1249', 'LTL1250', 'LTL1254', 'LTL1255', 'LTL1259', 'LTL1262', 'LTL1263', 'LTL1267', 'LTL1269', 'LTL1285', 'LTL1289', 'LTL1294', 'LTL1297', 'LTL1301', 'LTL1305', 'LTL1307', 'LTL131', 'LTL1318', 'LTL1324', 'LTL1333', 'LTL1336', 'LTL1339', 'LTL1344', 'LTL1351', 'LTL1355', 'LTL1360', 'LTL1368', 'LTL1369', 'LTL137', 'LTL1370', 'LTL1375', 'LTL1380', 'LTL1392', 'LTL1395', 'LTL1398', 'LTL1408', 'LTL1415', 'LTL142', 'LTL1426', 'LTL1431', 'LTL1433', 'LTL1434', 'LTL1435', 'LTL1436', 'LTL1437', 'LTL1439', 'LTL144', 'LTL1445', 'LTL1446', 'LTL1447', 'LTL1453', 'LTL1454', 'LTL1455', 'LTL1464', 'LTL1467', 'LTL1468', 'LTL1475', 'LTL1479', 'LTL1487', 'LTL1489', 'LTL1493', 'LTL1504', 'LTL1516', 'LTL1520', 'LTL1521', 'LTL1522', 'LTL1523', 'LTL1526', 'LTL1532', 'LTL1539', 'LTL154', 'LTL1543', 'LTL1545', 'LTL1553', 'LTL1556', 'LTL157', 'LTL1581', 'LTL1587', 'LTL1588', 'LTL1589', 'LTL1590', 'LTL1595', 'LTL160', 'LTL1606', 'LTL1609', 'LTL1612', 'LTL1617', 'LTL1621', 'LTL1636', 'LTL1642', 'LTL1666', 'LTL1675', 'LTL1688', 'LTL1689', 'LTL1695', 'LTL1696', 'LTL1705', 'LTL172', 'LTL1729', 'LTL173', 'LTL1732', 'LTL1736', 'LTL1740', 'LTL1742', 'LTL1751', 'LTL1755', 'LTL1757', 'LTL1764', 'LTL1767', 'LTL1768', 'LTL1793', 'LTL1794', 'LTL1894', 'LTL1904', 'LTL1905', 'LTL1909', 'LTL1936', 'LTL1941', 'LTL1961', 'LTL1971', 'LTL1973', 'LTL1975', 'LTL1979', 'LTL1985', 'LTL1999', 'LTL2007', 'LTL2018', 'LTL205', 'LTL207', 'LTL218', 'LTL231', 'LTL245', 'LTL248', 'LTL249', 'LTL250', 'LTL252', 'LTL253', 'LTL254', 'LTL257', 'LTL258', 'LTL260', 'LTL261', 'LTL267', 'LTL308', 'LTL314', 'LTL315', 'LTL325', 'LTL342', 'LTL349', 'LTL352', 'LTL357', 'LTL359', 'LTL366', 'LTL369', 'LTL372', 'LTL383', 'LTL391', 'LTL400', 'LTL415', 'LTL429', 'LTL434', 'LTL446', 'LTL458', 'LTL464', 'LTL465', 'LTL470', 'LTL473', 'LTL474', 'LTL476', 'LTL485', 'LTL494', 'LTL495', 'LTL498', 'LTL499', 'LTL504', 'LTL505', 'LTL507', 'LTL510', 'LTL530', 'LTL541', 'LTL550', 'LTL551', 'LTL554', 'LTL558', 'LTL560', 'LTL561', 'LTL564', 'LTL565', 'LTL569', 'LTL570', 'LTL576', 'LTL583', 'LTL584', 'LTL590', 'LTL594', 'LTL595', 'LTL596', 'LTL598', 'LTL602', 'LTL606', 'LTL607', 'LTL608', 'LTL611', 'LTL613', 'LTL614', 'LTL617', 'LTL619', 'LTL626', 'LTL627', 'LTL629', 'LTL631', 'LTL639', 'LTL640', 'LTL643', 'LTL646', 'LTL647', 'LTL648', 'LTL649', 'LTL652', 'LTL653', 'LTL655', 'LTL656', 'LTL659', 'LTL673', 'LTL675', 'LTL677', 'LTL702', 'LTL703', 'LTL706', 'LTL708', 'LTL713', 'LTL715', 'LTL716', 'LTL717', 'LTL722', 'LTL723', 'LTL728', 'LTL730', 'LTL734', 'LTL746', 'LTL747', 'LTL753', 'LTL754', 'LTL757', 'LTL761', 'LTL762', 'LTL764', 'LTL765', 'LTL767', 'LTL773', 'LTL785', 'LTL786', 'LTL788', 'LTL789', 'LTL791', 'LTL793', 'LTL796', 'LTL798', 'LTL811', 'LTL814', 'LTL818', 'LTL824', 'LTL825', 'LTL826', 'LTL834', 'LTL835', 'LTL837', 'LTL839', 'LTL840', 'LTL841', 'LTL845', 'LTL846', 'LTL849', 'LTL854', 'LTL855', 'LTL858', 'LTL861', 'LTL862', 'LTL870', 'LTL872', 'LTL880', 'LTL881', 'LTL884', 'LTL885', 'LTL896', 'LTL897', 'LTL898', 'LTL901', 'LTL906', 'LTL911', 'LTL913', 'LTL917', 'LTL926', 'LTL931', 'LTL934', 'LTL936', 'LTL938', 'LTL939', 'LTL943', 'LTL944', 'LTL948', 'LTL950', 'LTL953', 'LTL956', 'LTL958', 'LTL967', 'LTL972', 'LTL974', 'LTL980', 'LTL984', 'LTL985', 'LTL986')

UPDATE speccs.TempEXLLoan
SET LoanAccNo=l.LoanAccNo
FROM speccs.Loans l,speccs.TempEXLLoan t
WHERE l.MemAccNo=t.MemAccNo AND convert(DATE,l.RegTime)='04/09/2025' AND l.LoanType='EXL'

SELECT a.* FROM speccs.TempLoanSanctionAmount a 
UNION 
SELECT b.* FROM speccs.TempEXLLoan b


SELECT lts.* FROM speccs.LoanTransactions lts,speccs.TempLoanSanctionAmount t
WHERE lts.LoanAccNo=t.LoanAccNo AND lts.P_I='P'

SELECT round(4096873/100,-3)


SELECT  a.LoanAccNo,a.Amount,a.TransactionDate FROM speccs.LoanTransactions a
Join (SELECT LoanAccNo ,max(TransactionDate) AS TransactionDate
FROM speccs.LoanTransactions WHERE P_I='P' AND LoanAccNo LIKE 'LTL%' GROUP BY LoanAccNo) b 
ON a.LoanAccNo=b.LoanAccNo AND a.TransactionDate=b.TransactionDate AND a.LoanAccNo LIKE 'LTL%' AND a.P_I='P' 

SELECT LoanAccNo,Amount,max(TransactionDate) AS TransactionDate FROM speccs.LoanTransactions WHERE P_I='P' AND LoanAccNo LIKE 'LTL%' GROUP BY LoanAccNo



SELECT * FROM speccs.TempLoanSanctionAmount WHERE LoanAccNo IN (SELECT LoanAccNo FROM speccs.LoanTransactions WHERE LoanAccNo LIKE 'LTL%')



SELECT convert(DATE,'01/01/2025')
SELECT convert(VARCHAR(8),datepart(MM,convert(DATE,'01/16/2025')))
UPDATE speccs.TempEXLLoan
SET MemAccNo=a.MemAccNo
FROM speccs.Members a,speccs.TempEXLLoan t
WHERE a.MemEmpCode=t.MemEmpCode


-------------------------------------------------------
-- to insert ltl or exl into loanTransactions


--to generate receipt and loan transaction 
-- Step 1: Store the selected rows in a temporary table from table you want
SELECT a.* INTO #tempData7 FROM speccs.TempLoanSanctionAmount a  WHERE a.LoanAccNo IS NOT NULL 

-- Step 2: Declare variables for iteration
DECLARE @Amount NUMERIC(15,2),@MemAccNo VARCHAR(10),@LoanAccNo VARCHAR(10), @ReceiptNo VARCHAR(14)

-- Step 3: Loop through the temporary table
WHILE EXISTS (SELECT 1 FROM #tempData7)
BEGIN
    -- Fetch the first row
    SELECT TOP 1 @MemAccNo = MemAccNo,
                 @LoanAccNo = LoanAccNo,
                 @Amount = Amount
                 
    FROM #tempData7

    -- Assign purpose codes
     
      
		--LTL start
	  
		 
		    -- Call SP_Receipts
		    EXEC SP_Receipts 'SAVE', @MemAccNo, '04/01/2025', 'L23', @Amount, 'CHEQUE', @LoanAccNo, 'SH15823', '', '',
		        'Loan Principle Amount', @ReceiptNo OUTPUT
		
		    -- Insert into LoanTransactions
		    INSERT INTO speccs.LoanTransactions
		    VALUES (@LoanAccNo, '04/01/2025', 'L23', 0, 'P', @ReceiptNo, 'Loan Disbursment', @Amount, GETDATE(), 'SH15823') 
	 
		
	  
		--LTL end	
	   
    DELETE FROM #tempData7 WHERE LoanAccNo = @LoanAccNo
END


INSERT INTO speccs.Loans (MemAccNo, LoanAccNo, LoanType, LoanPurpose, NoOfInstallments, MonthlyInstallments, Thriftdudamt,
 LoanStatus, FundId, LoanSanctionAmount, InterestMethod, InterestRate, LoanSanctionDate, InterestCalculatedFromDate,
  DisbursedOnDate, DisbursedOnUserId, ClosedOnDate, ClosedOnUserId, Surety1, Surety2, Surety3, Loanappdate, Loanrejecteddate, 
  Recoverydate, Releaseddate, Remarks, UserId, RegTime, ChequeAmount)
	VALUES ('M0063', 'LTL2348', 'LTL', 'purp', 100, 0, 0, 'RELEASED', ' ', 1329000, NULL, 8.4, '04/01/2025',
	 NULL, NULL, NULL, NULL, NULL, 'M0024', 'M0325','M0277', '04/01/2025', NULL, NULL, '04/01/2025', 'LTL loans', 
	 'SH15823', getdate(), 0)

INSERT INTO speccs.LoanTransactions
VALUES ('LTL2348', '04/01/2025', 'L23', 0, 'P', 'R000000010153', 'CHEQUE', 1329000, GETDATE(), 'SH15823') 
	
	
	
   
	
	
	
	
	
  
