USE LawEnforcementEmployees;
GO

/***************************************************
********** Mode (Most Frequent) ********************
***************************************************/

/* 01. Get dataset */

WITH Dataset AS (
SELECT
	Agency.Agency AS Category
	,Employees.OfficerTotal AS Observation
FROM
	dbo.Agency Agency
	INNER JOIN dbo.EmployeePopulation Employees ON Agency.Ori = Employees.Ori
WHERE 1=1
)

/* 02. Get the "frequency" of observations through the ROW_NUMBER windows function. */

,ModePrep AS (
SELECT
	Dataset.Category
	,Dataset.Observation
	,ROW_NUMBER()
		OVER (PARTITION BY Dataset.Category, Dataset.Observation ORDER BY Observation ASC) AS [Observation Freq]
FROM
	Dataset
WHERE 1=1
)

/* 03. Compute the modal score and variation ratio to observe "typicality" and "dispersion." */

SELECT DISTINCT
	ModePrep.Category
	,CategoryTotal.[Total Obs]
	,LEFT(ModalScore.ModeObsFreq,LEN(ModalScore.ModeObsFreq) - 2) AS [Mode: Obs Freq]
	,IIF(
		LEFT(ModalScore.ModeObsFreq,LEN(ModalScore.ModeObsFreq) - 2) LIKE '%||%'
		,'---' /*Can't compute Variation Ratio on multi-modal distributions*/
		,FORMAT(
			1 - (CONVERT(FLOAT,SUBSTRING(ModalScore.ModeObsFreq,CHARINDEX(':',ModalScore.ModeObsFreq,1) + 2,CHARINDEX('|',ModalScore.ModeObsFreq,1) - CHARINDEX(':',ModalScore.ModeObsFreq,1) - 2)) / CategoryTotal.[Total Obs])
			,N'#0.#0'
			)
		) AS [Variation Ratio]
FROM
	ModePrep
	OUTER APPLY (
		SELECT TOP(1) WITH TIES
			CONCAT(ms.Observation,':',SPACE(1),ms.[Observation Freq],SPACE(1),'||') AS "data()"
		FROM
			ModePrep ms
		WHERE 1=1
			AND ms.Category = ModePrep.Category
		ORDER BY
			ms.[Observation Freq] DESC
		FOR XML PATH('')
		) AS ModalScore(ModeObsFreq)
	OUTER APPLY (SELECT COUNT(1) AS [Total Obs] FROM ModePrep total WHERE total.Category = ModePrep.Category) CategoryTotal
WHERE 1=1
;

/***************************************************
********** Median (50th Percentile) ****************
***************************************************/

/* 01. Get dataset */

WITH Dataset AS (
SELECT
	Agency.Agency AS Category
	,Employees.OfficerTotal AS Observation
FROM
	dbo.Agency Agency
	INNER JOIN dbo.EmployeePopulation Employees ON Agency.Ori = Employees.Ori
WHERE 1=1
)

/* 02. Get the observations and the "percentiles" through the ROW_NUMBER windows function. */

,MedianPrep AS (
SELECT
	Dataset.Category
	,Dataset.Observation
	,PERCENTILE_CONT(.25)	WITHIN GROUP ( ORDER BY Dataset.Observation)	OVER(PARTITION BY Dataset.Category) AS [Q1]
	,PERCENTILE_CONT(.5)	WITHIN GROUP ( ORDER BY Dataset.Observation)	OVER(PARTITION BY Dataset.Category) AS [Median]
	,PERCENTILE_CONT(.75)	WITHIN GROUP ( ORDER BY Dataset.Observation)	OVER(PARTITION BY Dataset.Category) AS [Q3]
FROM
	Dataset
WHERE 1=1
)

/* 03. Compute the median score and IQR to observe "typicality" and "dispersion."*/

SELECT DISTINCT
	MedianPrep.Category
	,CategoryTotal.[Total Obs]
	,MedianPrep.Median
	,MedianPrep.[Q3] - MedianPrep.[Q1] AS IQR
	,MedianPrep.[Q1] - CEILING(1.5 * (MedianPrep.[Q3] - MedianPrep.[Q1])) AS [Lower Wisker]
	,MedianPrep.[Q3] + CEILING(1.5 * (MedianPrep.[Q3] - MedianPrep.[Q1])) AS [Upper Wisker]
FROM
	MedianPrep
	OUTER APPLY (SELECT COUNT(1) AS [Total Obs] FROM MedianPrep total WHERE total.Category = MedianPrep.Category) CategoryTotal
WHERE 1=1
;

/***************************************************
********** Mean (Average) **************************
***************************************************/

/* 01. Compute the mean and standard deviation to observe "typicality" and "dispersion." */

SELECT
	Agency.Agency AS Category
	,COUNT(Employees.OfficerTotal) AS [Total Obs]
	,AVG(Employees.OfficerTotal) AS [Mean]
	,STDEV(Employees.OfficerTotal) AS [Std. Dev.]
FROM
	dbo.Agency Agency
	INNER JOIN dbo.EmployeePopulation Employees ON Agency.Ori = Employees.Ori
WHERE 1=1
GROUP BY
	Agency.Agency
;

/***************************************************
********** Descriptive Statistics ******************
***************************************************/
--/*
/* 01. Get dataset */

WITH Dataset AS (
SELECT
	Agency.Agency AS Category
	,Employees.OfficerTotal AS Observation
FROM
	dbo.Agency Agency
	INNER JOIN dbo.EmployeePopulation Employees ON Agency.Ori = Employees.Ori
WHERE 1=1
)

/* 02. Get the "frequency" of observations through the ROW_NUMBER windows function. */

,ModeMedianPrep AS (
SELECT
	Dataset.Category
	,Dataset.Observation
	,ROW_NUMBER()
		OVER (PARTITION BY Dataset.Category, Dataset.Observation ORDER BY Observation ASC) AS [Observation Freq]
	,PERCENTILE_CONT(.25)	WITHIN GROUP ( ORDER BY Dataset.Observation)	OVER(PARTITION BY Dataset.Category) AS [Q1]
	,PERCENTILE_CONT(.5)	WITHIN GROUP ( ORDER BY Dataset.Observation)	OVER(PARTITION BY Dataset.Category) AS [Median]
	,PERCENTILE_CONT(.75)	WITHIN GROUP ( ORDER BY Dataset.Observation)	OVER(PARTITION BY Dataset.Category) AS [Q3]
FROM
	Dataset
WHERE 1=1
)

/* 03. Get the modal and median "typicality" and "dispersion" measures */

,ModeMedianDescriptiveStats AS (
SELECT DISTINCT
	ModeMedianPrep.Category
	,CategoryTotal.[Total Obs]
	,LEFT(ModalScore.ModeObsFreq,LEN(ModalScore.ModeObsFreq) - 2) AS [Mode: Obs Freq]
	,IIF(
		LEFT(ModalScore.ModeObsFreq,LEN(ModalScore.ModeObsFreq) - 2) LIKE '%||%'
		,'---' /*Can't compute Variation Ratio on multi-modal distributions*/
		,FORMAT(
			1 - (CONVERT(FLOAT,SUBSTRING(ModalScore.ModeObsFreq,CHARINDEX(':',ModalScore.ModeObsFreq,1) + 2,CHARINDEX('|',ModalScore.ModeObsFreq,1) - CHARINDEX(':',ModalScore.ModeObsFreq,1) - 2)) / CategoryTotal.[Total Obs])
			,N'#0.#0'
			)
		) AS [Variation Ratio]
	,ModeMedianPrep.Median
	,ModeMedianPrep.[Q3] - ModeMedianPrep.[Q1] AS IQR
	,ModeMedianPrep.[Q1] - CEILING(1.5 * (ModeMedianPrep.[Q3] - ModeMedianPrep.[Q1])) AS [Lower Wisker]
	,ModeMedianPrep.[Q3] + CEILING(1.5 * (ModeMedianPrep.[Q3] - ModeMedianPrep.[Q1])) AS [Upper Wisker]
FROM
	ModeMedianPrep
	OUTER APPLY (
		SELECT TOP(1) WITH TIES
			CONCAT(ms.Observation,':',SPACE(1),ms.[Observation Freq],SPACE(1),'||') AS "data()"
		FROM
			ModeMedianPrep ms
		WHERE 1=1
			AND ms.Category = ModeMedianPrep.Category
		ORDER BY
			ms.[Observation Freq] DESC
		FOR XML PATH('')
		) AS ModalScore(ModeObsFreq)
	OUTER APPLY (SELECT COUNT(1) AS [Total Obs] FROM ModeMedianPrep total WHERE total.Category = ModeMedianPrep.Category) CategoryTotal
WHERE 1=1
)

,MeanStdDev AS (
SELECT
	Dataset.Category
	,COUNT(Dataset.Observation) AS [Total Obs]
	,AVG(Dataset.Observation) AS [Mean]
	,STDEV(Dataset.Observation) AS [Std. Dev.]
FROM
	Dataset
WHERE 1=1
GROUP BY
	Dataset.Category
)

SELECT
	ModeMedian.Category
	,ModeMedian.[Total Obs]
	,ModeMedian.[Mode: Obs Freq]
	,ModeMedian.[Variation Ratio]
	,ModeMedian.Median
	,ModeMedian.IQR
	,ModeMedian.[Lower Wisker]
	,ModeMedian.[Upper Wisker]
	,MeanStdDev.Mean
	,MeanStdDev.[Std. Dev.]
FROM
	ModeMedianDescriptiveStats ModeMedian
	INNER JOIN MeanStdDev ON ModeMedian.Category = MeanStdDev.Category
;
--*/