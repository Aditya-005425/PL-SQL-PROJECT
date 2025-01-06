BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE TaxReturns CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE TaxPayments CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE TaxPayers CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE TaxRates CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE TaxAudits CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE Deductions CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE Penalties CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE TaxConsultants CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE TaxConsultantAssignments CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        NULL; 
END;
/

-- TaxPayers Table
CREATE TABLE TaxPayers (
    TaxPayerID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Email VARCHAR2(100) UNIQUE NOT NULL,
    Phone VARCHAR2(15),
    Address VARCHAR2(200),
    TaxIdentificationNumber VARCHAR2(20) UNIQUE NOT NULL,
    CreatedDate DATE DEFAULT SYSDATE
);

-- TaxRates Table
CREATE TABLE TaxRates (
    RateID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    IncomeBracket VARCHAR2(100) NOT NULL,
    RatePercentage NUMBER(5, 2) NOT NULL
);

-- TaxReturns Table
CREATE TABLE TaxReturns (
    ReturnID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    TaxPayerID NUMBER REFERENCES TaxPayers(TaxPayerID),
    FilingDate DATE DEFAULT SYSDATE,
    TotalIncome NUMBER(15, 2) NOT NULL,
    TaxableIncome NUMBER(15, 2) NOT NULL,
    TaxAmount NUMBER(15, 2) NOT NULL,
    Status VARCHAR2(50) DEFAULT 'Pending'
);

-- TaxPayments Table
CREATE TABLE TaxPayments (
    PaymentID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    ReturnID NUMBER REFERENCES TaxReturns(ReturnID),
    PaymentDate DATE DEFAULT SYSDATE,
    AmountPaid NUMBER(15, 2) NOT NULL,
    PaymentMethod VARCHAR2(50) CHECK (PaymentMethod IN ('Credit Card', 'Bank Transfer', 'Cheque'))
);

-- TaxAudits Table
CREATE TABLE TaxAudits (
    AuditID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    TaxPayerID NUMBER REFERENCES TaxPayers(TaxPayerID),
    AuditDate DATE DEFAULT SYSDATE,
    Findings VARCHAR2(1000),
    Status VARCHAR2(50) DEFAULT 'Open'
);

-- Deductions Table
CREATE TABLE Deductions (
    DeductionID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    TaxPayerID NUMBER REFERENCES TaxPayers(TaxPayerID),
    DeductionType VARCHAR2(100),
    DeductionAmount NUMBER(15, 2) NOT NULL,
    FilingYear NUMBER NOT NULL
);

-- Penalties Table
CREATE TABLE Penalties (
    PenaltyID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    TaxPayerID NUMBER REFERENCES TaxPayers(TaxPayerID),
    Amount NUMBER(15, 2) NOT NULL,
    Reason VARCHAR2(500),
    ImposedDate DATE DEFAULT SYSDATE,
    Status VARCHAR2(50) DEFAULT 'Unpaid'
);

-- TaxConsultants Table
CREATE TABLE TaxConsultants (
    ConsultantID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Email VARCHAR2(100) UNIQUE NOT NULL,
    Phone VARCHAR2(15),
    Expertise VARCHAR2(200)
);

-- TaxConsultantAssignments Table
CREATE TABLE TaxConsultantAssignments (
    AssignmentID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    TaxPayerID NUMBER REFERENCES TaxPayers(TaxPayerID),
    ConsultantID NUMBER REFERENCES TaxConsultants(ConsultantID),
    AssignedDate DATE DEFAULT SYSDATE,
    Status VARCHAR2(50) DEFAULT 'Active'
);

-- Sample Data
BEGIN
    -- Insert TaxPayers
    INSERT INTO TaxPayers (Name, Email, Phone, Address, TaxIdentificationNumber) 
    VALUES ('Jon Snow', 'jon@gmail.com', '1234567890', '123 Elm Street', 'TAX1234567');
    INSERT INTO TaxPayers (Name, Email, Phone, Address, TaxIdentificationNumber) 
    VALUES ('Peter Parker', 'peter@gmail.com', '9876543210', '456 Oak Avenue', 'TAX7654321');
    INSERT INTO TaxPayers (Name, Email, Phone, Address, TaxIdentificationNumber) 
    VALUES ('Barry Allen', 'barry@gmail.com', '2345678901', '789 Pine Road', 'TAX2345678');
    INSERT INTO TaxPayers (Name, Email, Phone, Address, TaxIdentificationNumber) 
    VALUES ('Diana Prince', 'daina@gmail.com', '3456789012', '321 Maple Drive', 'TAX3456789');
    INSERT INTO TaxPayers (Name, Email, Phone, Address, TaxIdentificationNumber) 
    VALUES ('Clarke Kent', 'clarke@gmail.com', '4567890123', '654 Cedar Lane', 'TAX4567890');
    INSERT INTO TaxPayers (Name, Email, Phone, Address, TaxIdentificationNumber) 
    VALUES ('Wade Wilson', 'wade@gmail.com', '5678901234', '987 Birch Court', 'TAX5678901');
	INSERT INTO TaxPayers (Name, Email, Phone, Address, TaxIdentificationNumber) 
    VALUES ('Bruce Wayne', 'bruce@gmail.com', '5671341234', '987 Gotham', 'TAX9998901');
	INSERT INTO TaxPayers (Name, Email, Phone, Address, TaxIdentificationNumber) 
    VALUES ('Tony Stark', 'tony@gmail.com', '5673000234', '987 New York', 'TAX9888901');

    -- Insert Tax Rates
    INSERT INTO TaxRates (IncomeBracket, RatePercentage) VALUES ('0-300000', 0);
    INSERT INTO TaxRates (IncomeBracket, RatePercentage) VALUES ('300001-700000', 5);
    INSERT INTO TaxRates (IncomeBracket, RatePercentage) VALUES ('700001-1000000', 10);
    INSERT INTO TaxRates (IncomeBracket, RatePercentage) VALUES ('1000001-1200000', 15);
    INSERT INTO TaxRates (IncomeBracket, RatePercentage) VALUES ('1200001 and 1500000', 20);
    INSERT INTO TaxRates(IncomeBracket, RatePercentage) VALUES ('1500001 and above', 30);

    -- Insert Sample Tax Returns
    INSERT INTO TaxReturns (TaxPayerID, TotalIncome, TaxableIncome, TaxAmount, Status) 
    VALUES (1, 75000, 70000, 7000, 'Filed');
    INSERT INTO TaxReturns (TaxPayerID, TotalIncome, TaxableIncome, TaxAmount, Status) 
    VALUES (2, 150000, 140000, 21000, 'Pending');
    INSERT INTO TaxReturns (TaxPayerID, TotalIncome, TaxableIncome, TaxAmount, Status) 
    VALUES (3, 200000, 180000, 27000, 'Filed');
    INSERT INTO TaxReturns (TaxPayerID, TotalIncome, TaxableIncome, TaxAmount, Status) 
    VALUES (4, 400000, 350000, 70000, 'Pending');
    INSERT INTO TaxReturns (TaxPayerID, TotalIncome, TaxableIncome, TaxAmount, Status) 
    VALUES (5, 850000, 800000, 240000, 'Filed');
    INSERT INTO TaxReturns (TaxPayerID, TotalIncome, TaxableIncome, TaxAmount, Status) 
    VALUES (6, 1000000, 950000, 382500, 'Filed');
	INSERT INTO TaxReturns (TaxPayerID, TotalIncome, TaxableIncome, TaxAmount, Status) 
    VALUES (7, 1200000, 1150000, 405000, 'Filed');
	INSERT INTO TaxReturns (TaxPayerID, TotalIncome, TaxableIncome, TaxAmount, Status) 
    VALUES (8, 1100000, 1050000, 404000, 'Filed');
	

    -- Insert Sample Deductions
    INSERT INTO Deductions (TaxPayerID, DeductionType, DeductionAmount, FilingYear) 
    VALUES (1, 'Medical Expenses', 5000, 2024);
    INSERT INTO Deductions (TaxPayerID, DeductionType, DeductionAmount, FilingYear) 
    VALUES (2, 'Education Loan', 10000, 2024);
    INSERT INTO Deductions (TaxPayerID, DeductionType, DeductionAmount, FilingYear) 
    VALUES (3, 'Charity Donations', 15000, 2024);
    INSERT INTO Deductions (TaxPayerID, DeductionType, DeductionAmount, FilingYear) 
    VALUES (4, 'Home Loan Interest', 20000, 2024);
    INSERT INTO Deductions (TaxPayerID, DeductionType, DeductionAmount, FilingYear) 
    VALUES (5, 'Retirement Savings', 30000, 2024);
    INSERT INTO Deductions (TaxPayerID, DeductionType, DeductionAmount, FilingYear) 
    VALUES (6, 'Health Insurance', 25000, 2024);
	INSERT INTO Deductions (TaxPayerID, DeductionType, DeductionAmount, FilingYear) 
    VALUES (7, 'Health Insurance', 22000, 2024);
	INSERT INTO Deductions (TaxPayerID, DeductionType, DeductionAmount, FilingYear) 
    VALUES (8, 'Health Insurance', 20000, 2024);

    -- Insert Penalties
    INSERT INTO Penalties (TaxPayerID, Amount, Reason, Status) 
    VALUES (1, 200.00, 'Late Filing Fee', 'Unpaid');
    INSERT INTO Penalties (TaxPayerID, Amount, Reason, Status) 
    VALUES (2, 500.00, 'Audit Penalty', 'Paid');
    INSERT INTO Penalties (TaxPayerID, Amount, Reason, Status) 
    VALUES (3, 300.00, 'Missed Payment Deadline', 'Unpaid');
    INSERT INTO Penalties (TaxPayerID, Amount, Reason, Status) 
    VALUES (4, 150.00, 'Underreported Income', 'Paid');
    INSERT INTO Penalties (TaxPayerID, Amount, Reason, Status) 
    VALUES (5, 500.00, 'Late Payment Fee', 'Unpaid');
    INSERT INTO Penalties (TaxPayerID, Amount, Reason, Status) 
    VALUES (6, 1000.00, 'Non-Compliance with Audit', 'Paid');
	INSERT INTO Penalties (TaxPayerID, Amount, Reason, Status) 
    VALUES (7, 500.00, 'Non-Compliance with Audit', 'Paid');
	INSERT INTO Penalties (TaxPayerID, Amount, Reason, Status) 
    VALUES (8, 1000.00, 'Late Payment Fee', 'Unpaid');

    -- Insert Tax Consultants
    INSERT INTO TaxConsultants (Name, Email, Phone, Expertise) 
    VALUES ('Alice Brown', 'alice.brown@consultants.com', '1122334455', 'Income Tax');
    INSERT INTO TaxConsultants (Name, Email, Phone, Expertise) 
    VALUES ('Robert Green', 'robert.green@consultants.com', '2233445566', 'Corporate Tax');
    INSERT INTO TaxConsultants (Name, Email, Phone, Expertise) 
    VALUES ('David Miller', 'david.miller@consultants.com', '3344556677', 'Tax Law');
    INSERT INTO TaxConsultants (Name, Email, Phone, Expertise) 
    VALUES ('Olivia Garcia', 'olivia.garcia@consultants.com', '4455667788', 'Corporate Tax');

    -- Assign Consultants
    INSERT INTO TaxConsultantAssignments (TaxPayerID, ConsultantID) VALUES (1, 1);
    INSERT INTO TaxConsultantAssignments (TaxPayerID, ConsultantID) VALUES (2, 2);
    INSERT INTO TaxConsultantAssignments (TaxPayerID, ConsultantID) VALUES (3, 3);
    INSERT INTO TaxConsultantAssignments (TaxPayerID, ConsultantID) VALUES (4, 4);
    INSERT INTO TaxConsultantAssignments (TaxPayerID, ConsultantID) VALUES (5, 1);
    INSERT INTO TaxConsultantAssignments (TaxPayerID, ConsultantID) VALUES (6, 2);
	INSERT INTO TaxConsultantAssignments (TaxPayerID, ConsultantID) VALUES (7, 3);
	INSERT INTO TaxConsultantAssignments (TaxPayerID, ConsultantID) VALUES (8, 4);
END;
/

-- Procedure to Calculate Tax Amount
CREATE OR REPLACE PROCEDURE CalculateTax (
    p_TotalIncome IN NUMBER,
    o_TaxAmount OUT NUMBER
) AS
    v_TaxRate NUMBER;
BEGIN
    IF p_TotalIncome <= 300000 THEN
        v_TaxRate := 0;
    ELSIF p_TotalIncome <= 700000 THEN
        v_TaxRate := 5;
    ELSIF p_TotalIncome <= 1000000 THEN
        v_TaxRate := 10;
    ELSIF p_TotalIncome <= 1200000 THEN
        v_TaxRate := 15;
	ELSIF p_TotalIncome <= 1500000 THEN
        v_TaxRate := 20;
    ELSIF p_TotalIncome <= 9999999 THEN
        v_TaxRate := 30;
    ELSE
        v_TaxRate := 0;
    END IF;
    o_TaxAmount := p_TotalIncome * v_TaxRate / 100;
END;
/

CREATE OR REPLACE PROCEDURE FileTaxReturn (
    p_TaxPayerID IN NUMBER,
    p_TotalIncome IN NUMBER
) AS
    v_TaxableIncome NUMBER;
    v_TaxAmount NUMBER;
BEGIN
    SELECT NVL(SUM(DeductionAmount), 0) INTO v_TaxableIncome
    FROM Deductions
    WHERE TaxPayerID = p_TaxPayerID;
    v_TaxableIncome := p_TotalIncome - v_TaxableIncome;
    CalculateTax(v_TaxableIncome, v_TaxAmount);
    INSERT INTO TaxReturns (TaxPayerID, TotalIncome, TaxableIncome, TaxAmount, Status)
    VALUES (p_TaxPayerID, p_TotalIncome, v_TaxableIncome, v_TaxAmount, 'Filed');
    DBMS_OUTPUT.PUT_LINE('Tax return filed successfully for TaxPayer ID: ' || p_TaxPayerID);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Procedure to Show Tax Statistics
CREATE OR REPLACE PROCEDURE ShowTaxStatistics AS
    v_NoOfTaxPayers NUMBER;
    v_TotalTax NUMBER;
    v_AvgTax NUMBER;
    v_MinTax NUMBER;
    v_MaxTax NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- All Tax Payers ---');
    SELECT COUNT(*), SUM(TaxAmount), AVG(TaxAmount), MIN(TaxAmount), MAX(TaxAmount) 
    INTO v_NoOfTaxPayers, v_TotalTax, v_AvgTax, v_MinTax, v_MaxTax
    FROM TaxReturns; 
    DBMS_OUTPUT.PUT_LINE('Number of Tax Payers: ' || v_NoOfTaxPayers);
    DBMS_OUTPUT.PUT_LINE('Total Tax Paid: ' || v_TotalTax);
    DBMS_OUTPUT.PUT_LINE('Average Tax Paid: ' || v_AvgTax);
    DBMS_OUTPUT.PUT_LINE('Minimum Tax Paid: ' || v_MinTax);
    DBMS_OUTPUT.PUT_LINE('Maximum Tax Paid: ' || v_MaxTax);
    DBMS_OUTPUT.PUT_LINE('--- Tax Paid by Each Person (Highest to Lowest) ---');
    FOR r IN (
        SELECT tp.TaxPayerID, tp.Name, tr.TaxAmount
        FROM TaxReturns tr
        JOIN TaxPayers tp ON tr.TaxPayerID = tp.TaxPayerID
        ORDER BY tr.TaxAmount DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('TaxPayer: ' || r.Name || ' | Tax Paid: ' || r.TaxAmount);
    END LOOP;
    FOR r IN (
        SELECT 
            tr1.IncomeBracket, 
            COUNT(tr.TaxPayerID) AS NoOfTaxPayers, 
            SUM(tr.TaxAmount) AS TotalTax, 
            AVG(tr.TaxAmount) AS AverageTax,
            MIN(tr.TaxAmount) AS MinTax,
            MAX(tr.TaxAmount) AS MaxTax
        FROM TaxReturns tr
        JOIN TaxPayers tp ON tr.TaxPayerID = tp.TaxPayerID
        JOIN TaxRates tr1 
            ON tr.TotalIncome BETWEEN
               CASE 
                   WHEN tr1.IncomeBracket = '0-300000' THEN 0
                   WHEN tr1.IncomeBracket = '300001-700000' THEN 300001
                   WHEN tr1.IncomeBracket = '700001-1000000' THEN 700001
                   WHEN tr1.IncomeBracket = '1000001-1200000' THEN 1000001
                   WHEN tr1.IncomeBracket = '1200001-1500000' THEN 1200001
                   WHEN tr1.IncomeBracket = '1500001-9999999' THEN 1500001
                   ELSE 15000001
               END
           AND CASE 
        		   WHEN tr1.IncomeBracket = '0-300000' THEN 300000
                   WHEN tr1.IncomeBracket = '300001-700000' THEN 700000
                   WHEN tr1.IncomeBracket = '700001-1000000' THEN 1000000
                   WHEN tr1.IncomeBracket = '1000001-1200000' THEN 1200000
        		   WHEN tr1.IncomeBracket = '1200001-1500000' THEN 1500000
                   WHEN tr1.IncomeBracket = '1500001-9999999' THEN 9999999
                   ELSE 99999999
               END
        GROUP BY tr1.IncomeBracket
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('--- ' || r.IncomeBracket || ' ---');
        DBMS_OUTPUT.PUT_LINE('Number of Tax Payers: ' || r.NoOfTaxPayers);
        DBMS_OUTPUT.PUT_LINE('Total Tax Paid: ' || r.TotalTax);
        DBMS_OUTPUT.PUT_LINE('Average Tax Paid: ' || r.AverageTax);
        DBMS_OUTPUT.PUT_LINE('Minimum Tax Paid: ' || r.MinTax);
        DBMS_OUTPUT.PUT_LINE('Maximum Tax Paid: ' || r.MaxTax);
    END LOOP;
END;
/

EXEC ShowTaxStatistics;