-- PHASE I of project begins
-- Q1. Create a database for a banking application called 'Bank'.

-- CREATE DATABASE IF NOT EXISTS Bank;

-- Q2. Create all the tables mentioned in the database diagram.
-- Q3. Create all the constraints based on the database diagram.

/* CREATE TABLE & ADD CONSTRAINTS Section */
-- Creating tables only with primary keys first
USE Bank;
-- Creating table named UserLogins
CREATE TABLE IF NOT EXISTS UserLogins
(
UserLoginID  INT NOT NULL AUTO_INCREMENT,
UserLogin VARCHAR(50) NOT NULL,
UserPassword VARCHAR(20) NOT NULL,
CONSTRAINT pk_UL_UserLoginID PRIMARY KEY(UserLoginID)
);


-- Creating table named UserSecurityQuestions
CREATE TABLE IF NOT EXISTS UserSecurityQuestions
(
UserSecurityQuestionID  INT NOT NULL AUTO_INCREMENT,
UserSecurityQuestion VARCHAR(50) NOT NULL,
CONSTRAINT pk_USQ_UserSecurityQuestionID PRIMARY KEY(UserSecurityQuestionID)
);



-- Creating table named AccountType
CREATE TABLE IF NOT EXISTS AccountType
(
AccountTypeID  INT NOT NULL AUTO_INCREMENT,
AccountTypeDescription VARCHAR(30) NOT NULL,
CONSTRAINT pk_AT_AccountTypeID PRIMARY KEY(AccountTypeID)
);

-- Creating table named SavingsInterestRates
/* NOTE:  Altered the table to accept datatype as NUMERIC(9,2) in order to avoid Arithmetic Conversion error using
code "ALTER TABLE SavingsInterestRates ALTER COLUMN IntetestRatesValue NUMERIC(9,2);" */

CREATE TABLE IF NOT EXISTS SavingsInterestRates
(
InterestSavingRatesID  INT NOT NULL AUTO_INCREMENT,
InterestRatesValue NUMERIC(9,9) NOT NULL,
InterestRatesDescription VARCHAR(20) NOT NULL,
CONSTRAINT pk_SIR_InterestSavingRatesID PRIMARY KEY(InterestSavingRatesID)
);


-- Creating table named AccountStatusType
CREATE TABLE IF NOT EXISTS AccountStatusType
(
AccountStatusTypeID INT NOT NULL AUTO_INCREMENT,
AccountStatusTypeDescription VARCHAR(30) NOT NULL,
CONSTRAINT pk_AST_AccountStatusTypeID PRIMARY KEY(AccountStatusTypeID)
);



-- Creating table named FailedTransactionErrorType
CREATE TABLE IF NOT EXISTS FailedTransactionErrorType
(
    FailedTransactionErrorTypeID TINYINT NOT NULL AUTO_INCREMENT,
    FailedTransactionErrorTypeDescription VARCHAR(50) NOT NULL,
    PRIMARY KEY(FailedTransactionErrorTypeID)
);

-- Creating table named LoginErrorLog
CREATE TABLE IF NOT EXISTS LoginErrorLog
(
ErrorLogID  INT NOT NULL AUTO_INCREMENT,
ErrorTime DATETIME NOT NULL,
FailedTransactionXML text,
CONSTRAINT pk_LEL_ErrorLogID PRIMARY KEY(ErrorLogID)
);


-- Creating table named Employee
CREATE TABLE IF NOT EXISTS Employee
(
EmployeeID INT NOT NULL AUTO_INCREMENT,
EmployeeFirstName VARCHAR(25) NOT NULL,
EmployeeMiddleInitial CHAR(1),
EmployeeLastName VARCHAR(25),
EmployeeisManager BIT,
CONSTRAINT pk_E_EmployeeID PRIMARY KEY(EmployeeID)
);


-- Creating table named TransactionType
CREATE TABLE IF NOT EXISTS TransactionType
(
    TransactionTypeID INT NOT NULL AUTO_INCREMENT,
    TransactionTypeName CHAR(10) NOT NULL,
    TransactionTypeDescription VARCHAR(50),
    TransactionFeeAmount DECIMAL(10, 2),
    CONSTRAINT pk_TT_TransactionTypeID PRIMARY KEY(TransactionTypeID)
);



-- Creating tables with foreign key and combination of both primary and foreign keys
-- Creating table named FailedTransactionLog
CREATE TABLE IF NOT EXISTS FailedTransactionLog
(
    FailedTransactionID INT NOT NULL AUTO_INCREMENT,
    FailedTransactionErrorTypeID TINYINT NOT NULL,
    FailedTransactionErrorTime DATETIME,
    FailedTransactionErrorXML TEXT,
    PRIMARY KEY(FailedTransactionID),
    CONSTRAINT fk_FTET_FailedTransactionErrorTypeID FOREIGN KEY(FailedTransactionErrorTypeID) REFERENCES FailedTransactionErrorType(FailedTransactionErrorTypeID)
);

-- Creating table named UserSecurityAnswers
CREATE TABLE IF NOT EXISTS UserSecurityAnswers (
    UserLoginID INT NOT NULL AUTO_INCREMENT,
    UserSecurityAnswers VARCHAR(25) NOT NULL,
    UserSecurityQuestionID int NOT NULL,
    CONSTRAINT pk_USA_UserLoginID PRIMARY KEY(UserLoginID),
    CONSTRAINT fk_UL_UserLoginID FOREIGN KEY(UserLoginID) REFERENCES UserLogins(UserLoginID),
    CONSTRAINT fk_USQ_UserSecurityQuestionID FOREIGN KEY(UserSecurityQuestionID) REFERENCES UserSecurityQuestions(UserSecurityQuestionID)
);


-- Creating table named Account
CREATE TABLE IF NOT EXISTS Account
(
AccountID INT NOT NULL AUTO_INCREMENT,
CurrentBalance INT NOT NULL,
AccountTypeID INT NOT NULL REFERENCES AccountType (AccountTypeID),
AccountStatusTypeID INT NOT NULL,
InterestSavingRatesID INT NOT NULL,
CONSTRAINT pk_A_AccounID PRIMARY KEY(AccountID),
CONSTRAINT fk_AST_AccountStatusTypeID FOREIGN KEY(AccountStatusTypeID) REFERENCES AccountStatusType(AccountStatusTypeID),
CONSTRAINT fk_SIR_InterestSavingRatesID FOREIGN KEY(InterestSavingRatesID) REFERENCES SavingsInterestRates(InterestSavingRatesID)
);


-- Creating table named LoginAccount
-- NOTE: Unlike ER diagram table name has been used as LoginAccounts instead of Login-Account
CREATE TABLE IF NOT EXISTS LoginAccount
(
UserLoginID INT NOT NULL,
AccountID INT NOT NULL,
CONSTRAINT fk_UL_UserLogins FOREIGN KEY(UserLoginID) REFERENCES UserLogins(UserLoginID),
CONSTRAINT fk_A_Account FOREIGN KEY(AccountID) REFERENCES Account(AccountID)
);


-- Creating table named Customer
CREATE TABLE IF NOT EXISTS Customer
(
CustomerID INT NOT NULL AUTO_INCREMENT,
AccountID INT NOT NULL,
CustomerAddress1 VARCHAR(30) NOT NULL,
CustomerAddress2  VARCHAR(30),
CustomerFirstName  VARCHAR(30) NOT NULL,
CustomerMiddleInitial CHAR(1),
CustomerLastName  VARCHAR(30) NOT NULL,
City  VARCHAR(20) NOT NULL,
State CHAR(2) NOT NULL,
ZipCode CHAR(10) NOT NULL,
EmailAddress CHAR(40) NOT NULL,
HomePhone VARCHAR(10) NOT NULL,
CellPhone VARCHAR(10) NOT NULL,
WorkPhone VARCHAR(10) NOT NULL,
SSN VARCHAR(9),
UserLoginID INT NOT NULL,
CONSTRAINT pk_C_CustomerID PRIMARY KEY(CustomerID),
CONSTRAINT fk_A_AccountID FOREIGN KEY(AccountID) REFERENCES Account(AccountID),
CONSTRAINT fk_UL_C_UserLoginID FOREIGN KEY(UserLoginID) REFERENCES UserLogins(UserLoginID)  
);


-- Creating table named CustomerAccount
-- NOTE: Unlike ER diagram table name has been used as CustomerAccounts instead of Customer-Account
CREATE TABLE IF NOT EXISTS CustomerAccount
(
AccountID INT NOT NULL ,
CustomerID INT NOT NULL,
CONSTRAINT fk_A_CA_AccountID FOREIGN KEY(AccountID) REFERENCES Account(AccountID),
CONSTRAINT fk_C_CA_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID)
);


-- Creating table named TransactionLog
CREATE TABLE IF NOT EXISTS TransactionLog
(
TransactionID INT NOT NULL AUTO_INCREMENT,
TransactionDate DATETIME NOT NULL,
TransactionTypeID INT NOT NULL,
TransactionAmount DECIMAL(19, 4) NOT NULL,
NewBalance DECIMAL(19, 4) NOT NULL,
AccountID INT NOT NULL,
CustomerID INT NOT NULL,
EmployeeID INT NOT NULL,
UserLoginID INT NOT NULL,
CONSTRAINT pk_TL_TransactionID PRIMARY KEY(TransactionID),
CONSTRAINT fk_TT_TL_TransactionTypeID FOREIGN KEY(TransactionTypeID) REFERENCES TransactionType(TransactionTypeID),
CONSTRAINT fk_A_TL_AccountID FOREIGN KEY(AccountID) REFERENCES Account(AccountID),
CONSTRAINT fk_C_TL_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID),
CONSTRAINT fk_E_TL_EmployeeID FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID),
CONSTRAINT fk_UL_TL_UserLoginID FOREIGN KEY(UserLoginID) REFERENCES UserLogins(UserLoginID)    
);


-- Creating table named OverDraftLog
CREATE TABLE IF NOT EXISTS OverDraftLog
(
AccountID INT NOT NULL AUTO_INCREMENT,
OverDraftDate DATETIME NOT NULL,
OverDraftAmount DECIMAL(19, 4) NOT NULL,
OverDraftTransactionXML TEXT NOT NULL,
CONSTRAINT Pk_ODL_AccountID PRIMARY KEY(AccountID),
CONSTRAINT fk_A_ODL_AccountID FOREIGN KEY(AccountID) REFERENCES Account(AccountID)
);


-- Q4. Insert at least 5 rows in each table.
/** INSERT rows section **/

-- Inserting user 1
INSERT INTO UserLogins (UserLogin, UserPassword) VALUES ('User1', 'Pass1');

-- Inserting user 2
INSERT INTO UserLogins (UserLogin, UserPassword) VALUES ('User2', 'Pass2');

-- Inserting user 3
INSERT INTO UserLogins (UserLogin, UserPassword) VALUES ('User3', 'Pass3');

-- Inserting user 4
INSERT INTO UserLogins (UserLogin, UserPassword) VALUES ('User4', 'Pass4');

-- Inserting user 5
INSERT INTO UserLogins (UserLogin, UserPassword) VALUES ('User5', 'Pass5');

-- Inserting rows into UserSecurityQuestions
INSERT INTO UserSecurityQuestions (UserSecurityQuestion) VALUES
('What is your mother''s maiden name?'),
('In which city were you born?'),
('What is the name of your first pet?'),
('What is your favorite color?'),
('What is the make and model of your first car?');

-- Inserting rows into AccountType
INSERT INTO AccountType (AccountTypeDescription) VALUES
('Checking'),
('Savings');

-- Inserting rows into SavingsInterestRates
INSERT INTO SavingsInterestRates (InterestRatesValue, InterestRatesDescription) VALUES
(0.01, '1% per annum'),
(0.02, '2% per annum'),
(0.03, '3% per annum'),
(0.04, '4% per annum'),
(0.05, '5% per annum');

-- Inserting rows into AccountStatusType
INSERT INTO AccountStatusType (AccountStatusTypeDescription) VALUES
('Active'),
('Inactive'),
('Closed');

-- Inserting rows into FailedTransactionErrorType
INSERT INTO FailedTransactionErrorType (FailedTransactionErrorTypeDescription) VALUES
('Insufficient Funds'),
('Invalid Account'),
('Transaction Error'),
('Account Frozen'),
('Other Error');

-- Inserting rows into Employee
INSERT INTO Employee (EmployeeFirstName, EmployeeMiddleInitial, EmployeeLastName, EmployeeisManager) VALUES
('John', 'M', 'Doe', 1),
('Jane', 'A', 'Smith', 0),
('Robert', 'C', 'Johnson', 0),
('Emily', 'R', 'Williams', 0),
('Michael', 'S', 'Anderson', 0);

-- Inserting rows into TransactionType
INSERT INTO TransactionType (TransactionTypeName, TransactionTypeDescription, TransactionFeeAmount) VALUES
('Deposit', 'Money deposit into the account', 0.00),
('Withdrawal', 'Money withdrawal from the account', 1.00),
('Transfer', 'Transfer of money between accounts', 2.00),
('Payment', 'Payment made from the account', 1.50),
('Other', 'Other types of transactions', 0.50);

-- Inserting rows into FailedTransactionLog
INSERT INTO FailedTransactionLog (FailedTransactionErrorTypeID, FailedTransactionErrorTime, FailedTransactionErrorXML) VALUES
(1, NOW(), '<XML data 1>'),
(3, NOW(), '<XML data 2>'),
(2, NOW(), '<XML data 3>'),
(4, NOW(), '<XML data 4>'),
(5, NOW(), '<XML data 5>');

-- Inserting rows into UserSecurityAnswers
INSERT INTO UserSecurityAnswers (UserLoginID, UserSecurityAnswers, UserSecurityQuestionID) VALUES
(1, 'Answer1', 1),
(2, 'Answer2', 2),
(3, 'Answer3', 3),
(4, 'Answer4', 4),
(5, 'Answer5', 5);

-- Inserting rows into Account
INSERT INTO Account (CurrentBalance, AccountTypeID, AccountStatusTypeID, InterestSavingRatesID) VALUES
(1000, 1, 1, 1),
(5000, 2, 1, 2),
(200, 1, 2, 3),
(8000, 2, 1, 4),
(300, 1, 1, 5);

-- Inserting rows into LoginAccount
INSERT INTO LoginAccount (UserLoginID, AccountID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Inserting rows into Customer
INSERT INTO Customer (AccountID, CustomerAddress1, CustomerFirstName, CustomerMiddleInitial, CustomerLastName, City, State, ZipCode, EmailAddress, HomePhone, CellPhone, WorkPhone, SSN, UserLoginID) VALUES
(1, '123 Main St', 'John', 'M', 'Doe', 'Anytown', 'ON', 'A1B2C3', 'john.doe@email.com', '1234567890', '9876543210', '5678901234', '123456789', 1),
(2, '456 Oak St', 'Jane', 'A', 'Smith', 'Sometown', 'ON', 'X1Y2Z3', 'jane.smith@email.com', '2345678901', '8765432109', '6789012345', '234567890', 2),
(3, '789 Maple St', 'Robert', 'C', 'Johnson', 'Anotherplace', 'ON', 'L3M4N5', 'robert.johnson@email.com', '3456789012', '7654321098', '7890123456', '345678901', 3),
(4, '101 Pine St', 'Emily', 'R', 'Williams', 'Newcity', 'ON', 'K1L2P3', 'emily.williams@email.com', '4567890123', '6543210987', '9012345678', '456789012', 4),
(5, '202 Cedar St', 'Michael', 'S', 'Anderson', 'Yourtown', 'ON', 'Q2W3E4', 'michael.anderson@email.com', '5678901234', '5432109876', '3456789012', '567890123', 5);

-- Inserting rows into CustomerAccount
INSERT INTO CustomerAccount (AccountID, CustomerID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Inserting rows into TransactionLog
INSERT INTO TransactionLog (TransactionDate, TransactionTypeID, TransactionAmount, NewBalance, AccountID, CustomerID, EmployeeID, UserLoginID) VALUES
(NOW(), 1, 1000.00, 2000.00, 1, 1, 1, 1),
(NOW(), 2, 500.00, 4500.00, 2, 2, 2, 2),
(NOW(), 3, 200.00, 0.00, 3, 3, 3, 3),
(NOW(), 4, 800.00, 7200.00, 4, 4, 4, 4),
(NOW(), 5, 300.00, 0.00, 5, 5, 5, 5);

-- Inserting rows into OverDraftLog
INSERT INTO OverDraftLog (OverDraftDate, OverDraftAmount, OverDraftTransactionXML) VALUES
(NOW(), 50.00, '<XML data 1>'),
(NOW(), 30.00, '<XML data 2>'),
(NOW(), 20.00, '<XML data 3>'),
(NOW(), 10.00, '<XML data 4>'),
(NOW(), 40.00, '<XML data 5>'); 

CREATE VIEW ONProvinceCheckingCustomers AS
SELECT c.*
FROM Customer c
JOIN CustomerAccount ca ON c.CustomerID = ca.CustomerID
JOIN Account a ON ca.AccountID = a.AccountID
JOIN AccountType at ON a.AccountTypeID = at.AccountTypeID
WHERE at.AccountTypeDescription = 'Checking' AND c.State = 'ON';

CREATE VIEW HighBalanceCustomers AS
SELECT c.*, (a.CurrentBalance + (a.CurrentBalance * sir.InterestRatesValue)) AS TotalBalance
FROM Customer c
JOIN CustomerAccount ca ON c.CustomerID = ca.CustomerID
JOIN Account a ON ca.AccountID = a.AccountID
JOIN SavingsInterestRates sir ON a.InterestSavingRatesID = sir.InterestSavingRatesID
HAVING TotalBalance > 5000;

CREATE VIEW AccountCountsByCustomer AS
SELECT c.CustomerID, c.CustomerFirstName, c.CustomerLastName,
       COUNT(CASE WHEN at.AccountTypeDescription = 'Checking' THEN 1 END) AS CheckingCount,
       COUNT(CASE WHEN at.AccountTypeDescription = 'Savings' THEN 1 END) AS SavingsCount
FROM Customer c
JOIN CustomerAccount ca ON c.CustomerID = ca.CustomerID
JOIN Account a ON ca.AccountID = a.AccountID
JOIN AccountType at ON a.AccountTypeID = at.AccountTypeID
GROUP BY c.CustomerID, c.CustomerFirstName, c.CustomerLastName;

CREATE VIEW UserLoginPasswordByAccount AS
SELECT la.AccountID, ul.UserLogin, ul.UserPassword
FROM LoginAccount la
JOIN UserLogins ul ON la.UserLoginID = ul.UserLoginID;

CREATE VIEW OverdraftAmountByCustomer AS
SELECT c.CustomerID, c.CustomerFirstName, c.CustomerLastName, odl.OverDraftAmount
FROM Customer c
JOIN CustomerAccount ca ON c.CustomerID = ca.CustomerID
JOIN Account a ON ca.AccountID = a.AccountID
JOIN OverDraftLog odl ON a.AccountID = odl.AccountID;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM LoginErrorLog
WHERE ErrorLogID > 0 AND ErrorTime >= NOW() - INTERVAL 1 HOUR;

ALTER TABLE Customer
DROP COLUMN SSN;








