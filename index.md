Types of Functions: their uses and an examination of their difference

Github links: 

https://github.com/Pocatello/DBFoundations/blob/main/Assignment 07_Joshua Levenson.docx 

https://github.com/Pocatello/DBFoundations/blob/main/Assignment07_JLevenson.sql

1.	Explain when you would use a SQL UDF.
User defined functions (UDF) can be used independently of the source code. Similarly, to store procedures, UDFs do not need to be reparsed and reoptimized with each use, resulting in faster execution times. 



1.	Explain are the differences between Scalar, Inline, and Multi-Statement Functions.
A scalar function accepts any number of parameters but delivers one vale. 
This could be as simple as 5*5 =


Inline (or simple) functions return a table of data with specific parameters in a result set. The result set aspect is similar to a view but an inline can accept parameters . In Figure 1, below an inline function is used to return a table of films that have a duration longer than 150 minutes. 

Figure 1
 
SELECT
*
FROM
db.fnFilmsByDuration(150)

Figure description: All films 150 minutes and longer will be displayed
 
A multi-statement function, See Figure 2, after additional processing. However, it could be created by a union join statement. The differences between an inline function and a multi-statement function are as follows: it declares the return table structure, it starts and ends with the Begin/End block and it must be used to Return operator. 

Figure 2

Note: insert birthday date of desired director below.
INSERT INTO @people (
PersonName,
PersonRole,
Dob
)
SELECT
DirectorName,
'Director',
DirectorDob
FROM
tblDirector
WHERE
Year(DirectorDob) = @BirthYear

Figure description: This UDF will display all birthdays of the director that are input. This would be helpful to understand the patterns of film and era of a particular director or film.



