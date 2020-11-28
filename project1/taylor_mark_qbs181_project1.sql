-- 1 (a:f)
SELECT tri_age AS Age, gendercode AS Gender, contactid AS ID,
	address1_stateorprovince AS State, tri_imaginecareenrollmentemailsentdate AS EmailSentdate,
	tri_enrollmentcompletedate AS Completedate
INTO qbs181.mtaylor.Q1
FROM qbs181.dbo.Demographics;


-- 1 (g)
ALTER TABLE qbs181.mtaylor.Q1
ADD DaysToComplete AS CASE WHEN  TRY_CONVERT(DATETIME,Completedate) IS NULL THEN NULL
					WHEN TRY_CONVERT(DATETIME,EmailSentdate) IS NULL THEN NULL
					ELSE DATEDIFF(day, CONVERT(DATETIME,EmailSentdate), CONVERT(DATETIME,Completedate))
					END;


SELECT TOP 10 * FROM qbs181.mtaylor.Q1
ORDER BY NEWID();


-- 2
ALTER TABLE qbs181.mtaylor.HW1
ADD Enrollment_Status AS CASE WHEN tri_imaginecareenrollmentstatus = 167410011 THEN 'Complete'
							  WHEN tri_imaginecareenrollmentstatus = 167410001 THEN 'Email sent'
							  WHEN tri_imaginecareenrollmentstatus = 167410004 THEN 'Non responder'
							  WHEN tri_imaginecareenrollmentstatus = 167410005 THEN 'Facilitated Enrollment'
							  WHEN tri_imaginecareenrollmentstatus = 167410002 THEN 'Incomplete Enrollments'
							  WHEN tri_imaginecareenrollmentstatus = 167410003 THEN 'Opted Out'
							  WHEN tri_imaginecareenrollmentstatus = 167410000 THEN 'Unprocessed'
							  WHEN tri_imaginecareenrollmentstatus = 167410006 THEN 'Second email sent'
						 END;

SELECT TOP 10 * FROM qbs181.mtaylor.HW1
ORDER BY NEWID();


--3
ALTER TABLE qbs181.mtaylor.HW1
DROP COLUMN gender

ALTER TABLE qbs181.mtaylor.HW1
ADD Gender AS CASE WHEN gendercode = 'NULL' THEN 'Unknown'
				   WHEN gendercode = 2 THEN 'female'
				   WHEN gendercode = 1 THEN 'male'
				   WHEN tri_imaginecareenrollmentstatus = 167410000 THEN 'other'
			  END;

SELECT TOP 10 * FROM qbs181.mtaylor.HW1
ORDER BY NEWID();


--4
SELECT *
INTO qbs181.mtaylor.Q4
FROM qbs181.dbo.Demographics;

ALTER TABLE qbs181.mtaylor.Q4
ADD Age_group AS CASE WHEN tri_age < 25 THEN '0-25'
					  WHEN tri_age < 51 THEN '26-50'
					  WHEN tri_age < 76 THEN '51-75'
					  ELSE '75+'
			  END;

SELECT TOP 10 * FROM qbs181.mtaylor.Q4
ORDER BY NEWID();