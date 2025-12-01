USE [master];
GO

/***************************************************
********** DROP DATABASE ***************************
***************************************************/

IF EXISTS (SELECT db.database_id FROM sys.databases db WHERE db.name = 'LawEnforcementEmployees')
BEGIN
	ALTER DATABASE [LawEnforcementEmployees] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [LawEnforcementEmployees];
END;
GO

/***************************************************
********** CREATE DATABASE *************************
***************************************************/

IF NOT EXISTS (SELECT db.database_id FROM sys.databases db WHERE db.name = 'LawEnforcementEmployees')
	BEGIN
		CREATE DATABASE [LawEnforcementEmployees];
	END;
GO

/***************************************************
********** CREATE TABLES ***************************
***************************************************/

USE [LawEnforcementEmployees];
GO

IF NOT EXISTS (SELECT t.object_id FROM sys.tables t WHERE t.name = 'Agency')
BEGIN
	CREATE TABLE dbo.Agency (
		Ori VARCHAR(10) NOT NULL
		,Agency VARCHAR(130) NULL
		,CONSTRAINT [PK_Agency_Ori] PRIMARY KEY CLUSTERED (Ori)
		)
END;

IF NOT EXISTS (SELECT t.object_id FROM sys.tables t WHERE t.name = 'EmployeePopulation')
	BEGIN
		CREATE TABLE dbo.EmployeePopulation (
			Id SMALLINT IDENTITY(1,1)
			,Ori VARCHAR(10) NOT NULL
			,YearSurveyed SMALLINT NULL
			,OfficerTotal INTEGER NULL
			,CONSTRAINT [PK_EmployeePopulation_Id] PRIMARY KEY CLUSTERED (Id)
			,CONSTRAINT [FK_EmployeePopulation_Agency_Ori] FOREIGN KEY (Ori) REFERENCES dbo.Agency (Ori)
			);
	END;
GO