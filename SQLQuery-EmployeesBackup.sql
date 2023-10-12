/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.4206)
    Source Database Engine Edition : Microsoft SQL Server Express Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Express Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [TSQL2012]
GO

/****** Object:  Table [HR].[EmployeesBackup]    Script Date: 10/25/2017 10:33:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [HR].[EmployeesBackup](
	[empid] [int] IDENTITY(1,1) NOT NULL,
	[lastname] [nvarchar](20) NOT NULL,
	[firstname] [nvarchar](10) NOT NULL,
	[title] [nvarchar](30) NOT NULL,
	[titleofcourtesy] [nvarchar](25) NOT NULL,
	[birthdate] [datetime] NOT NULL,
	[hiredate] [datetime] NOT NULL,
	[address] [nvarchar](60) NOT NULL,
	[city] [nvarchar](15) NOT NULL,
	[region] [nvarchar](15) NULL,
	[postalcode] [nvarchar](10) NULL,
	[country] [nvarchar](15) NOT NULL,
	[phone] [nvarchar](24) NOT NULL,
	[mgrid] [int] NULL,
 CONSTRAINT [PK_EmployeesBackup] PRIMARY KEY CLUSTERED 
(
	[empid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

--Praktikum 5---
INSERT INTO HR.EmployeesBackup (
	lastname, firstname, title, titleofcourtesy, birthdate, hiredate,[address], city,
	region, postalcode, country, phone, mgrid)
SELECT
	lastname, firstname, title, titleofcourtesy, birthdate, hiredate,[address], city,
	region, postalcode, country, phone, mgrid
FROM HR.Employees;


IF OBJECT_ID('HR.trgDivertInsertEmployeeToBackup') IS NOT NULL
	DROP TRIGGER HR.trgDivertInsertEmployeeToBackup
GO;

CREATE TRIGGER trgDivertInsertEmployeeToBackup ON HR.Employees
INSTEAD OF INSERT
AS
	PRINT 'TRIGGER trgDivertInsertEmployeeToBackup DIPANGGIL';
	INSERT INTO HR.EmployeesBackup(
	lastname, firstname, title, titleofcourtesy, birthdate, hiredate,
[address], city,
	region, postalcode, country, phone, mgrid)
	SELECT
	lastname, firstname, title, titleofcourtesy, birthdate, hiredate,
[address], city,
	region, postalcode, country, phone, mgrid
FROM inserted;
	PRINT 'Employee baru disimpan di tabel HR.EmployeeBackup..'; 
GO;

INSERT INTO HR.Employees
VALUES
	('Santoso', 'Adi', 'staff', 'Mr. ', '19830101','20170101',
	'Jl. Soekarno-Hatta', 'Malang', 'Jawa Timur', '65150', 'Indonesia',
	'(085) 123-456', 1)
SELECT * FROM HR.EmployeesBackup


--SOAL 13--

IF OBJECT_ID('HR.trgDivertUpdateEmployeeToBackup') IS NOT NULL
	DROP TRIGGER HR.trgDivertUpdateEmployeeToBackup;
GO

CREATE TRIGGER trgDivertUpdateEmployeeToBackup ON HR.Employees
INSTEAD OF UPDATE
AS
	PRINT 'TRIGGER trgDivertUpdateEmployeeToBackup DIPANGGIL';
	DECLARE @firstname NVARCHAR(20) = (SELECT firstname FROM inserted);
	DECLARE @lastname NVARCHAR(20) = (SELECT lastname FROM inserted);
	DECLARE @fstname NVARCHAR(20) = COALESCE((SELECT firstname FROM
inserted), 0.0);
	DECLARE @empid INT = (SELECT empid FROM inserted WHERE firstname =
@firstname);
	UPDATE HR.EmployeesBackup
		SET firstname = @firstname,
		lastname = @lastname
		WHERE firstname = @fstname
		PRINT 'Employee baru dengan empid : ' + CAST(@empid AS
VARCHAR) +'
		yang ada di tabel HR.EmployeesBackup yang diupdate.';
GO

UPDATE HR.Employees SET firstname = 'DEPAN', lastname = 'BELAKANG'
WHERE firstname = 'Adi';

IF OBJECT_ID('HR.trgDivertDeleteEmployeeToBackup') IS NOT NULL
	DROP TRIGGER HR.trgDivertDeleteEmployeeToBackup;
GO

CREATE TRIGGER trgDivertDeleteEmployeeToBackup ON HR.Employees
INSTEAD OF DELETE
AS
PRINT 'TRIGGER trgDivertDeleteEmployeeToBackup DIPANGGIL';
DECLARE @firstname VARCHAR(10) = (SELECT firstname FROM deleted);
DECLARE @lastname VARCHAR(10) = (SELECT lastname FROM deleted);
DELETE FROM HR.EmployeesBackup
WHERE firstname = @firstname;
SELECT @firstname = firstname FROM deleted;
PRINT 'Karyawan dengan nama : ' + @firstname + ' ' + @lastname + ' 
dihapus di 
HR.EmployeesBackup saja.
Di tabel aslinta tetap.';

DELETE FROM HR.Employees WHERE firstname = 'Maria'

SELECT * FROM HR.EmployeesBackup;



