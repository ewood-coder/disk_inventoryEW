/*****************************************************************************************************
* Date			Programmer			Description
* -----         ----------          -----------
* 10/8/2021		Emma				- Initial implementation of disk db.
* 10/14/2021	Emma				- Added insert statements to populate db.
* 10/20/2021	Emma				- Added query to find missing/On Loan disks (h. on PROJECT 3 rubric).
* 10/21/2021	Emma				- Created T-SQL queries for your disk_inventory database.
* 10/22/2021	Emma				- Finished making T-SQL queries for disk_inventory database.
*										-- Also added code to fix fname & lname issues with artists.
* 10/25/2021	Emma				- Add ins & upd sp's for disk_has_borrower (PART OF W5D1 LAB).
* 10/27/2021	Emma				- Add ins, upd & del sp's for artist, borrower & disk.
******************************************************************************************************/

--drop & create database
use master;
DROP DATABASE IF EXISTS disk_inventoryEW;
go
CREATE DATABASE disk_inventoryEW;
go

-- drop and create server login
IF SUSER_ID('ProjectUserEmmaW') IS NULL
	CREATE LOGIN ProjectUserEmmaW WITH PASSWORD='MSPress#1',
	DEFAULT_DATABASE = disk_inventoryEW;
go

-- create server login
--CREATE LOGIN ProjectUserEmmaW WITH PASSWORD = 'MSPress#1',
--    DEFAULT_DATABASE = disk_inventoryEW;
--go

use disk_inventoryEW;
go

-- create db user
CREATE USER ProjectUserEmmaW;
go

-- grant read-all to new user alter db_dataread
ALTER ROLE db_datareader ADD MEMBER ProjectUserEmmaW;
go

-- create tables
-- disk type, genre, status and artist_type first
	-- create indexes, if not done in table definition
-------------------------------------------------------------------------------------------------
CREATE TABLE disk_type
(disk_type_id				INT         NOT NULL PRIMARY KEY IDENTITY (1, 1),
 description				CHAR(60)	NOT NULL);
-------------------------------------------------------------------------------------------------
CREATE TABLE status
(status_id					INT         NOT NULL PRIMARY KEY IDENTITY (1, 1),
 description				CHAR(60)	NOT NULL);
-------------------------------------------------------------------------------------------------
CREATE TABLE genre
(genre_id					INT         NOT NULL PRIMARY KEY IDENTITY (1, 1),
 description				CHAR(60)	NOT NULL);
-------------------------------------------------------------------------------------------------
CREATE TABLE disk
(cd_id						INT         NOT NULL PRIMARY KEY IDENTITY (1, 1),
 cd_name					CHAR(60)	NOT NULL,
 release_date				DATE		NOT NULL,
 disk_type_id				INT			NOT NULL REFERENCES disk_type (disk_type_id),
 status_id					INT			NOT NULL REFERENCES status (status_id),
 genre_id					INT			NOT NULL REFERENCES genre (genre_id));
-------------------------------------------------------------------------------------------------
CREATE TABLE artist_type
(artist_type_id				INT         NOT NULL PRIMARY KEY IDENTITY (1, 1),
 description				CHAR(60)	NOT NULL);
-------------------------------------------------------------------------------------------------
CREATE TABLE artist
(artist_id					INT         NOT NULL PRIMARY KEY IDENTITY (1, 1),
 artist_type_id				INT         NOT NULL REFERENCES artist_type (artist_type_id),
 artist_name				NVARCHAR(60)	NOT NULL);
-------------------------------------------------------------------------------------------------
CREATE TABLE disk_has_artist
(disk_has_artist_id			INT         NOT NULL PRIMARY KEY IDENTITY (1, 1),
 cd_id						INT         NOT NULL REFERENCES disk (cd_id),
 artist_id					INT			NOT NULL REFERENCES artist (artist_id));
-------------------------------------------------------------------------------------------------
CREATE TABLE borrower
(borrower_id				INT         NOT NULL PRIMARY KEY IDENTITY (1, 1),
 fname						CHAR(60)	NOT NULL,
 lname						CHAR(60)	NOT NULL,
 phone_num					CHAR(15)	NOT NULL);
-------------------------------------------------------------------------------------------------
CREATE TABLE disk_has_borrower
(disk_has_borrower_id		INT         NOT NULL PRIMARY KEY IDENTITY (1, 1),
 borrower_id				INT         NOT NULL REFERENCES borrower (borrower_id),
 cd_id						INT         NOT NULL REFERENCES disk (cd_id),
 borrowed_date				DATE		NOT NULL,
 returned_date				DATE		NULL);
-------------------------------------------------------------------------------------------------
go







-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*	PROJECT 3	10/15/2021	*/

-- Create insert tables for all tables in database diagram
INSERT INTO artist_type (description)
VALUES
	('Solo'),		-- 1
	('Group');		-- 2
go

INSERT INTO disk_type (description)
VALUES
	('CD'),			-- 1
	('Vinyl'),		-- 2
	('8Track'),		-- 3
	('Cassette'),	-- 4
	('DVD');		-- 5
go

INSERT INTO genre (description)
VALUES
	('Classic Rock'),	-- 1
	('Country'),		-- 2
	('Jazz'),			-- 3
	('AltRock'),		-- 4
	('Metal'),			-- 5
	('Techno');			-- 6
go

INSERT INTO status (description)
VALUES
	('Available'),		-- 1
	('On loan'),		-- 2
	('Damaged'),		-- 3
	('Missing');		-- 4
go


-- Disk Inserts:
	/*  1. Insert at least 20 rows of data into the table using real-world disk names
		2. Update only 1 row using a where clause					
		3. At least 1 disk has only 1 word in the name			
		4. At least 1 disk has only 2 words in the name				
		5. At least 1 disk has more than words in the name						*/
INSERT INTO disk
	(cd_name, release_date, 
	disk_type_id, genre_id, status_id)
VALUES
	('Panama', '06-18-1984', 1, 1, 1),							-- by Van Halen
	('Dream On', '06-27-1973', 2, 1, 2),						-- by Aerosmith
	('Carry On Wayward Son', '11-23-1976', 4, 1, 4),			-- by Kansas
	('The Outsiders', '02-11-2014', 1, 2, 3),					-- by Eric Church
	('Old 8 X 10', '07-12-1988', 1, 2, 2),						-- by Randy Travis
	('What a Crying Shame', '02-01-1994', 5, 2, 1),				-- by The Mavericks
	('Satchmo at Symphony Hall', '04-30-1951', 3, 3, 1),		-- by Louis Armstrong
	('Afro', '01-01-1954', 3, 3, 4),							-- by Dizzy Gillespie
	('Count Basie at Newport', '09-07-1957', 4, 3, 1),			-- by Art Tatum
	('Doolittle', '04-17-1989', 2, 4, 2),						-- by Pixies
	('Automatic for the People', '10-6-1992', 5, 4, 1),			-- by R.E.M.
	('Definitely Maybe', '08-29-1994', 2, 4, 2),				-- by Oasis
	('City of Evil', '06-06-2005', 1, 5, 2),					-- by Avenged Sevenfold
	('From Mars to Sirius', '09-27-2005', 1, 5, 1),				-- by Gojira
	('Meir', '03-25-2013', 1, 5, 2),							-- by Kvelertak
	('Dubnobasswithmyheadman', '01-24-1994', 1, 6, 2),			-- by Underworld
	('Selected Ambient Works 85-92', '02-12-1992', 1, 6, 1),	-- by Aphex Twin
	('90', '12-04-1989', 2, 6, 2),								-- by 808 State
	('Frequencies', '07-22-1991', 2, 6, 4),						-- by LFO
	('Charlie Parker with Strings', '11-30-1949', 2, 3, 3),		-- by Charlie Parker
	('The Ruby Sea', '05-01-1991', 1, 1, 2),					-- by Thin White Rope
	('Van Halen II', '03-23-1979', 1, 1, 1),					-- by Van Halen
	('Somebody That I Used To Know', '07-05-2011', 1, 4, 1);	-- by: Gotye | Featuring: Kimbra
--update 1 row using a where clause:
UPDATE disk
SET release_date = '07-22-1991'
WHERE cd_id = 19;

-- select * from disk_type;
-- select * from disk;


-- Borrower inserts:
/*  1. Insert at least 20 rows of data into the table using real-world borrower names
	2. Delete only 1 row using a where clause	*/
INSERT INTO Borrower
	(fname, lname, phone_num)
VALUES
	('Mickey', 'Mouse', '123-123-1234'),
	('Kim', 'Turnpike', '121-212-4321'),
	('Katherine', 'Kuhic', '122-134-7865'),
	('Garret', 'Schumm', '124-245-9201'),
	('Arch', 'Kassulke', '125-657-0814'),
	('Linda', 'Flatley', '126-473-0889'),
	('Alexandre', 'Cremin', '127-317-3362'),
	('Gustave', 'Ankunding', '128-864-2710'),
	('Ruben', 'Parker', '129-425-6745'),
	('Dorothea', 'Fritsch', '130-273-6776'),
	('Anabelle', 'Legros', '131-901-2451'),
	('Sigurd', 'Shoel', '132-356-1662'),
	('Noelle', 'Okon', '133-208-5563'),
	('Roscoe', 'Hamill', '134-683-1038'),
	('Hershel', 'Connell', '135-887-7309'),
	('Dwight', 'Predovic', '136-352-2452'),
	('Verdie', 'Schultz', '137-904-3267'),
	('Justine', 'Steuber', '138-462-7722'),
	('Rossie', 'Konopelski', '139-136-8823'),
	('Charlie', 'Harris', '140-445-5589'),
	('Kaylie', 'Branwen', '141-675-8351');		/*	THERE ARE 21 BORROWERS	|  last one should be deleted */
-- Delete only 1 row using a where clause:
DELETE FROM borrower
WHERE borrower_id = 21;
go

-- select * from borrower


-- Artist Inserts:
/*  1. Insert at least 20 rows of data into the table using real-world artist names
	2. At least 1 artist is known by 1 name and is a group					
	3. At least 1 artist is known by 1 name and is an individual artist		
	4. At least 1 artist has only 2 words in the name					
	5. At least 1 artist has more than 2 words in the name						*/	
INSERT INTO Artist
	(artist_name, artist_type_id)
VALUES
	('Van Halen', 2),
	('Aerosmith', 2),
	('Kansas', 2),
	('Eric Church', 1),
	('Randy Travis', 1),
	('The Mavericks', 2),
	('Louis Armstrong', 1),
	('Dizzy Gillespie', 1),
	('Art Tatum', 1),
	('Pixies', 2),
	('R.E.M.', 2),
	('Oasis', 2),
	('Avenged Sevenfold', 2),
	('Gojira', 2),
	('Kvelertak', 2),
	('Underworld', 2),
	('Aphex Twin', 1),
	('808 State', 2),
	('LFO', 2),
	('Charlie Parker', 1),
	('Thin White Rope', 2),
	('Gotye', 1),
	('Kimbra', 1);	-- 23

-- select * from artist

-- DiskHasBorrower inserts:
/*	1. Insert at least 20 rows of data into the table											
	2. Insert at least 2 different disks														
	3. Insert at least 2 different borrowers													
	4. At least 1 disk has been borrowed by the same borrower 2 different times					
	5. At least 1 disk in the disk table does not have a related row here (id = 14)				
	6. At least 1 disk must have at least 2 different rows here									
	7. At least 1 borrower in the borrower table does not have a related row here (id = 20)		
	8. At least 1 borrower must have at least 2 different rows here									*/
INSERT INTO disk_has_borrower
	(borrower_id, cd_id, borrowed_date, returned_date)
VALUES
	(1, 1, '01-02-2012', '02-15-2012'),
	(1, 1, '06-12-2014', '07-12-2014'),
	(2, 17, '03-27-2013', '04-15-2013'),
	(3, 17, '12-27-2013', '1-27-2014'),
	(1, 2, '08-13-2013', '09-13-2013'),
	(4, 6, '09-13-2014', '10-13-2014'),
	(5, 7, '05-01-2014', '05-29-2014'),
	(6, 5, '04-23-2015', '05-23-2015'),
	(7, 9, '06-02-2015', '07-05-2015'),
	(8, 11, '01-15-2016', '02-15-2016'),
	(9, 3, '09-10-2016', '12-10-2016'),
	(9, 22, '09-10-2016', '12-10-2016'),
	(9, 23, '09-10-2016', '12-10-2016'),
	--------------	MISSING	 ---------------
	(19, 3, '05-15-2017', NULL),
	(19, 8, '05-15-2017', NULL),
	(19, 19, '05-15-2017', NULL),
	--------------	ON LOAN	 ---------------
	(10, 2, '09-01-2021', NULL),
	(11, 5, '09-02-2021', NULL),
	(12, 10, '09-03-2021', NULL),
	(13, 12, '09-04-2021', NULL),
	(14, 13, '10-01-2021', NULL),
	(15, 15, '10-02-2021', NULL),
	(16, 16, '10-03-2021', NULL),
	(17, 18, '10-04-2021', NULL),
	(18, 21, '10-05-2021', NULL);

/*	PART H: NEEDED CORRECTING	*/
SELECT borrower_id, cd_id, borrowed_date, returned_date
FROM disk_has_borrower
WHERE returned_date IS NULL;


--select * from borrower
--select * from disk_has_borrower

-- DiskHasArtist inserts:
/*	1. Insert at least 20 rows of data into the table
	2. At least 1 disk must have at least 2 different artist rows here
	3. At least 1 artist must have at least 2 different disk rows here
	4. Correct variation of disk & artist data similar to DiskHasBorrower	*/
INSERT INTO disk_has_artist
	(cd_id, artist_id)
VALUES
	(1, 1),
	(2, 2),
	(3, 3),
	(4, 4),
	(5, 5),
	(6, 6),
	(7, 7),
	(8, 8),
	(9, 9),
	(10, 10),
	(11, 11),
	(12, 12),
	(13, 13),
	(14, 14),
	(15, 15),
	(16, 16),
	(17, 17),
	(18, 18),
	(19, 19),
	(20, 20),
	(21, 21),
	(22, 1),
	(23, 22),
	(23, 23);

-- select * from disk_has_artist
-- select * from disk
-- select * from artist







-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*	PROJECT 4	10/22/2021	*/

-- 3. Show the disks in your database and any associated Individual artists only

SELECT 
	cd_name as 'Disk Name', 
	CONVERT(varchar, release_date, 110) as 'Release Date', 
	-- Artist Names:
	IIF(CHARINDEX(' ', artist_name) > 0, LEFT(artist_name, CHARINDEX(' ', artist_name)), artist_name) as First_Name, 
	IIF(CHARINDEX(' ', artist_name) > 0, RIGHT(artist_name, LEN(artist_name) - CHARINDEX(' ', artist_name)), '') as Last_Name
FROM disk
	JOIN disk_has_artist ON disk.cd_id = disk_has_artist.cd_id
	JOIN artist ON artist.artist_id = disk_has_artist.artist_id
WHERE artist_type_id = 1;
go



-- 4. Create a view called View_Individual_Artist that shows the artists? names and not group names. Include the artist id in the view definition but do not display the id in your output.

DROP VIEW IF EXISTS View_Individual_Artist;
go
CREATE VIEW View_Individual_Artist
AS
	SELECT artist_id, artist_name
	FROM artist
	WHERE artist_type_id = 1;
go
SELECT IIF(CHARINDEX(' ', artist_name) > 0, LEFT(artist_name, CHARINDEX(' ', artist_name)), artist_name) as First_Name, 
	   IIF(CHARINDEX(' ', artist_name) > 0, RIGHT(artist_name, LEN(artist_name) - CHARINDEX(' ', artist_name)), '') as Last_Name
FROM View_Individual_Artist;
go



-- 5. Show the disks in your database and any associated Group artists only

SELECT 
	cd_name as 'Disk Name', 
	CONVERT(varchar, release_date, 110) as 'Release Date', 
	artist_name as 'Group Name'
FROM disk
	JOIN disk_has_artist ON disk.cd_id = disk_has_artist.cd_id
	JOIN artist ON artist.artist_id = disk_has_artist.artist_id
WHERE artist_type_id = 2;
go



-- 6. Re-write the previous query using the View_Individual_Artist view. Do not redefine the view. Consider using ?NOT EXISTS? or ?NOT IN? as the only restriction in the WHERE clause or a join. The output matches the output from the previous query.

SELECT 
	cd_name as 'Disk Name', 
	CONVERT(varchar, release_date, 110) as 'Release Date', 
	artist_name as 'Group Name'
FROM disk
	JOIN disk_has_artist ON disk.cd_id = disk_has_artist.cd_id
	JOIN artist ON artist.artist_id = disk_has_artist.artist_id
WHERE artist.artist_id NOT IN
	(SELECT artist_id
	FROM View_Individual_Artist);
go



-- 7. Show the borrowed disks and who borrowed them.

SELECT 
	fname as 'First Name', 
	lname as 'Last Name', 
	cd_name as 'Disk Name', 
	borrowed_date as 'Borrowed Date', 
	returned_date as 'Returned Date'
FROM borrower
	JOIN disk_has_borrower ON disk_has_borrower.borrower_id = borrower.borrower_id
	JOIN disk ON disk.cd_id = disk_has_borrower.cd_id;
go



-- 8. Show the number of times a disk has been borrowed

SELECT 
	disk.cd_id as 'DiskID', 
	cd_name as 'Disk Name', 
	COUNT(disk_has_borrower.cd_id) AS 'Times Borrowed'
FROM disk
	JOIN disk_has_borrower ON disk_has_borrower.cd_id = disk.cd_id
GROUP BY disk.cd_id, cd_name
ORDER BY disk.cd_id;
go



-- 9. Show the disks outstanding or on-loan and who has each disk.

SELECT 
	cd_name as 'Disk Name', 
	borrowed_date AS 'Borrowed', 
	returned_date AS 'Returned', 
	lname as 'Last Name'
FROM disk_has_borrower
	JOIN disk ON disk_has_borrower.cd_id = disk.cd_id
	JOIN borrower ON borrower.borrower_id = disk_has_borrower.borrower_id
WHERE returned_date IS NULL
ORDER BY lname;
go







-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*	WEEK 5 DAY 1 LAB	10/25/2021	*/

-- 1. Create 2 stored procedures:
		-- 1a. Insert into diskHasBorrower. Parameters for all columns except the PK. 
		-- 1b. Update to diskHasBorrower. Accept all columns & updates based on the PK. Set a default value of null for the return date. 
		-- 1c. Include drop logic, error checking, and execution statements (1 that works & 1 that generates a user error).

-- 1a. Insert into diskHasBorrower:
DROP PROC IF EXISTS sp_ins_disk_has_borrower
GO
CREATE PROC sp_ins_disk_has_borrower
	@borrower_id int, 
	@cd_id int, 
	@borrowed_date date,
	@returned_date date = NULL
AS
BEGIN TRY
	INSERT INTO disk_has_borrower
		(borrower_id, cd_id, borrowed_date, returned_date)
	VALUES
		(@borrower_id, @cd_id, @borrowed_date, @returned_date);
END TRY
BEGIN CATCH
	PRINT 'An error occurred. Row was not inserted.';
    PRINT 'Error number: ' + CONVERT(varchar, ERROR_NUMBER());
    PRINT 'Error message: ' + CONVERT(varchar(255), ERROR_MESSAGE());
END CATCH
GO
EXEC sp_ins_disk_has_borrower 1, 1, '03-12-2012', '06-25-2012'
GO
EXEC sp_ins_disk_has_borrower 10, 2, '11-14-2021'
GO
EXEC sp_ins_disk_has_borrower 20, 100, '08-01-2021', '10-07-2021'
GO
GRANT EXEC ON sp_ins_disk_has_borrower TO ProjectUserEmmaW;
go

-- 1b. Update to diskHasBorrower:
DROP PROC IF EXISTS sp_upd_disk_has_borrower
GO
CREATE PROC sp_upd_disk_has_borrower
	@disk_has_borrower_id int, 
	@borrower_id int, 
	@cd_id int, 
	@borrowed_date date, 
	@returned_date date = NULL
AS
BEGIN TRY
UPDATE disk_has_borrower
SET borrower_id = @borrower_id, cd_id = @cd_id, borrowed_date = @borrowed_date, returned_date = @returned_date
WHERE disk_has_borrower_id = @disk_has_borrower_id;
END TRY
BEGIN CATCH
	PRINT 'An error occurred. Row was not updated.';
    PRINT 'Error number: ' + CONVERT(varchar, ERROR_NUMBER());
    PRINT 'Error message: ' + CONVERT(varchar(255), ERROR_MESSAGE());
END CATCH
GO
EXEC sp_upd_disk_has_borrower 22, 1, 11, '1/2/2021', '2/1/2021';
go
EXEC sp_upd_disk_has_borrower 22, 1, 11, '1/2/2021';
go
EXEC sp_upd_disk_has_borrower 22, 1, 111, '1/2/2021', '2/1/2021';
go
GRANT EXEC ON sp_ins_disk_has_borrower TO ProjectUserEmmaW;
go









-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	/*	PROJECT 5	10/29/2021 */

-- 2. Create Insert, Update, and Delete stored procedures for the ARTIST table.

-- 2a. Create Inserts
DROP PROC IF EXISTS sp_ins_artist
GO
CREATE PROC sp_ins_artist
	@artist_name nvarchar(60), 
	@artist_type_id int
AS
BEGIN TRY
	INSERT INTO Artist
		(artist_name, artist_type_id)
	VALUES
		(@artist_name, @artist_type_id);
END TRY
BEGIN CATCH
	PRINT 'An error occurred. Row was not inserted.';
    PRINT 'Error number: ' + CONVERT(varchar, ERROR_NUMBER());
    PRINT 'Error message: ' + CONVERT(varchar(255), ERROR_MESSAGE());
END CATCH
GO
EXEC sp_ins_artist 'Cher', 1;
GO
EXEC sp_ins_artist 'Jared Leto', 1;
GO
EXEC sp_ins_artist 'Jared Leto', 1111;	-- causes error message
GO
GRANT EXEC ON sp_ins_artist TO ProjectUserEmmaW;
GO

-- 2b. Update artist procedure
DROP PROC IF EXISTS sp_upd_artist
GO
CREATE PROC sp_upd_artist
	@artist_id int, 
	@artist_name nvarchar(60), 
	@artist_type_id int
AS
BEGIN TRY
	UPDATE artist
	SET artist_name = @artist_name, artist_type_id = @artist_type_id
	WHERE artist_id = @artist_id;
END TRY
BEGIN CATCH
	PRINT 'An error occurred. Row was not updated.';
    PRINT 'Error number: ' + CONVERT(varchar, ERROR_NUMBER());
    PRINT 'Error message: ' + CONVERT(varchar(255), ERROR_MESSAGE());
END CATCH
GO
EXEC sp_upd_artist 24, 'UPD-Cher', 1;
GO
EXEC sp_upd_artist 25, 'UPD-Jared', 1;
GO
EXEC sp_upd_artist 26, 'Causes error', 1111;	-- causes error message
GO
GRANT EXEC ON sp_upd_artist TO ProjectUserEmmaW;
GO

-- 2c. Delete artist procedure
DROP PROC IF EXISTS sp_del_artist
GO
CREATE PROC sp_del_artist
	@artist_id int
AS
BEGIN TRY
	DELETE artist
	WHERE artist_id = @artist_id
END TRY
BEGIN CATCH
	PRINT 'An error occurred. Row was not deleted.';
    PRINT 'Error number: ' + CONVERT(varchar, ERROR_NUMBER());
    PRINT 'Error message: ' + CONVERT(varchar(255), ERROR_MESSAGE());
END CATCH
GO
EXEC sp_del_artist 24;
GO
EXEC sp_del_artist 25;
GO
EXEC sp_del_artist 1;	-- causes error message
GO
GRANT EXEC ON sp_del_artist TO ProjectUserEmmaW;
GO



-- 3. Create Insert, Update, and Delete stored procedures for the BORROWER table.

-- 3a. Create Inserts
DROP PROC IF EXISTS sp_ins_borrower
GO
CREATE PROC sp_ins_borrower
	@fname char(60), 
	@lname char(60), 
	@phone_num char(15)
AS
BEGIN TRY
	INSERT INTO Borrower
		(fname, lname, phone_num)
	VALUES
		(@fname, @lname, @phone_num);
END TRY
BEGIN CATCH
	PRINT 'An error occurred. Row was not inserted.';
    PRINT 'Error number: ' + CONVERT(varchar, ERROR_NUMBER());
    PRINT 'Error message: ' + CONVERT(varchar(255), ERROR_MESSAGE());
END CATCH
GO
EXEC sp_ins_borrower 'Mickey', 'Mouse', '123-123-1234';
GO
EXEC sp_ins_borrower 'Mickey', NULL, '123-123-1234';	-- causes error message
GO
GRANT EXEC ON sp_ins_borrower TO ProjectUserEmmaW;
GO

-- 3b.  Update BORROWER procedure
DROP PROC IF EXISTS sp_upd_borrower
GO
CREATE PROC sp_upd_borrower
	@borrower_id int, 
	@fname char(60),
	@lname char(60),
	@phone_num char(15)
AS
BEGIN TRY
	UPDATE borrower
	SET fname = @fname,
		lname = @lname,
		phone_num = @phone_num
	WHERE borrower_id = @borrower_id;
END TRY
BEGIN CATCH
	PRINT 'An error occurred. Row was not updated.';
    PRINT 'Error number: ' + CONVERT(varchar, ERROR_NUMBER());
    PRINT 'Error message: ' + CONVERT(varchar(255), ERROR_MESSAGE());
END CATCH
GO
EXEC sp_upd_borrower 22, 'UPD-Mickey', 'UPD-Mouse', '123-123-1234';
GO
EXEC sp_upd_borrower 22, 'UPD-Mickey', NULL, '123-123-1234';	-- causes error message
GO
GRANT EXEC ON sp_upd_borrower TO ProjectUserEmmaW;
GO

-- 3c. delete BORROWER procedure
DROP PROC IF EXISTS sp_del_borrower
GO
CREATE PROC sp_del_borrower
	@borrower_id int
AS
BEGIN TRY
	DELETE borrower
	WHERE borrower_id = @borrower_id
END TRY
BEGIN CATCH
	PRINT 'An error occurred. Row was not deleted.';
    PRINT 'Error number: ' + CONVERT(varchar, ERROR_NUMBER());
    PRINT 'Error message: ' + CONVERT(varchar(255), ERROR_MESSAGE());
END CATCH
GO
EXEC sp_del_borrower 22;
GO
EXEC sp_del_borrower 1;		-- causes error
GO
GRANT EXEC ON sp_del_borrower TO ProjectUserEmmaW;
GO



-- 4. Create Insert, Update, and Delete stored procedures for the DISK table.

-- 4a. Create Inserts
DROP PROC IF EXISTS sp_ins_disk
GO
CREATE PROC sp_ins_disk
	@cd_name char(60), 
	@release_date date, 
	@disk_type_id int,
	@status_id int,
	@genre_id int
AS
BEGIN TRY
	INSERT INTO disk
		(cd_name, release_date, disk_type_id, status_id, genre_id)
	VALUES
		(@cd_name, @release_date, @disk_type_id, @status_id, @genre_id);
END TRY
BEGIN CATCH
	PRINT 'An error occurred. Row was not inserted.';
    PRINT 'Error number: ' + CONVERT(varchar, ERROR_NUMBER());
    PRINT 'Error message: ' + CONVERT(varchar(255), ERROR_MESSAGE());
END CATCH
GO
EXEC sp_ins_disk 'The Outsiders', '02-11-2014', 1, 2, 3;
GO
EXEC sp_ins_disk 'The Outsiders', '02-11-2014', NULL, NULL, NULL;	-- causes error message
GO
GRANT EXEC ON sp_ins_disk TO ProjectUserEmmaW;
GO

-- 4b. Update DISK procedure
DROP PROC IF EXISTS sp_upd_disk
GO
CREATE PROC sp_upd_disk
	@cd_id int,
	@cd_name char(60), 
	@release_date date, 
	@disk_type_id int,
	@status_id int,
	@genre_id int
AS
BEGIN TRY
	UPDATE disk
	SET cd_name = @cd_name,
		release_date = @release_date,
		disk_type_id = @disk_type_id,
		status_id = @status_id,
		genre_id = @genre_id
	WHERE cd_id = @cd_id;
END TRY
BEGIN CATCH
	PRINT 'An error occurred. Row was not updated.';
    PRINT 'Error number: ' + CONVERT(varchar, ERROR_NUMBER());
    PRINT 'Error message: ' + CONVERT(varchar(255), ERROR_MESSAGE());
END CATCH
GO
EXEC sp_upd_disk 24, 'UPD-The Outsiders', '02-11-2014', 1, 2, 3;
GO
EXEC sp_upd_disk 24, 'UPD-The Outsiders', '02-11-2014', NULL, NULL, NULL;	-- causes error message
GO
GRANT EXEC ON sp_upd_disk TO ProjectUserEmmaW;
GO

-- 4c. Create delete DISK procedure
DROP PROC IF EXISTS sp_del_disk
GO
CREATE PROC sp_del_disk
	@cd_id int
AS
BEGIN TRY
	DELETE disk
	WHERE cd_id = @cd_id
END TRY
BEGIN CATCH
	PRINT 'An error occurred. Row was not deleted.';
    PRINT 'Error number: ' + CONVERT(varchar, ERROR_NUMBER());
    PRINT 'Error message: ' + CONVERT(varchar(255), ERROR_MESSAGE());
END CATCH
GO
EXEC sp_del_disk 24;
GO
EXEC sp_del_disk 1;		-- causes error
GO
GRANT EXEC ON sp_del_disk TO ProjectUserEmmaW;
GO