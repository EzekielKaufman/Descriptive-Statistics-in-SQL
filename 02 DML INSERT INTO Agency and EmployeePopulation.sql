USE LawEnforcementEmployees;
GO

/***************************************************
********** INSERT INTO AGENCY **********************
***************************************************/

IF NOT EXISTS (SELECT Ori FROM dbo.Agency WHERE Agency = 'Anchorage')
	BEGIN INSERT INTO dbo.Agency VALUES ('AK0010100','Anchorage'); END;

IF NOT EXISTS (SELECT Ori FROM dbo.Agency WHERE Agency = 'St. Louis')
	BEGIN INSERT INTO dbo.Agency VALUES ('MOSPD0000','St. Louis'); END;


/***************************************************
********** INSERT INTO EmployeePopulation **********
***************************************************/

/*Anchorage, AK*/
IF NOT EXISTS (SELECT Id FROM dbo.EmployeePopulation WHERE Ori = 'AK0010100')
BEGIN
	INSERT INTO dbo.EmployeePopulation (Ori,YearSurveyed,OfficerTotal) VALUES
	('AK0010100',2014,374),('AK0010100',2015,374),('AK0010100',2016,356),('AK0010100',2017,408),('AK0010100',2018,427),('AK0010100',2019,427)
	,('AK0010100',2020,425),('AK0010100',2021,413),('AK0010100',2022,406),('AK0010100',2023,400);
END;

/*St. Louis, MO*/
IF NOT EXISTS (SELECT Id FROM dbo.EmployeePopulation WHERE Ori = 'MOSPD0000')
BEGIN
	INSERT INTO dbo.EmployeePopulation (Ori,YearSurveyed,OfficerTotal) VALUES
	('MOSPD0000',2014,1384),('MOSPD0000',2015,1230),('MOSPD0000',2016,1194),('MOSPD0000',2017,1188),('MOSPD0000',2018,1189),('MOSPD0000',2019,1201)
	,('MOSPD0000',2020,1262),('MOSPD0000',2021,1131),('MOSPD0000',2022,1010),('MOSPD0000',2023,926);
END;