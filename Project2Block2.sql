/*****************************************************************************************************
* Date			Programmer			Description
* -----         ----------          -----------
* 10/8/2021		Emma				- Initial implementation of disk db.
*
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
(disk_type_id				INT         NOT NULL PRIMARY KEY IDENTITY,
 description				CHAR(10)	NOT NULL);
-------------------------------------------------------------------------------------------------
CREATE TABLE status
(status_id					INT         NOT NULL PRIMARY KEY IDENTITY,
 description				CHAR(10)	NOT NULL);
-------------------------------------------------------------------------------------------------
CREATE TABLE genre
(genre_id					INT         NOT NULL PRIMARY KEY IDENTITY,
 description				CHAR(10)	NOT NULL);
-------------------------------------------------------------------------------------------------
CREATE TABLE disk
(cd_id						INT         NOT NULL PRIMARY KEY IDENTITY,
 cd_name					CHAR(10)	NOT NULL,
 release_date				DATE		NOT NULL,
 disk_type_id				INT			NOT NULL REFERENCES disk_type (disk_type_id),
 status_id					INT			NOT NULL REFERENCES status (status_id),
 genre_id					INT			NOT NULL REFERENCES genre (genre_id));
-------------------------------------------------------------------------------------------------
CREATE TABLE artist_type
(artist_type_id				INT         NOT NULL PRIMARY KEY IDENTITY,
 description				CHAR(10)	NOT NULL);
-------------------------------------------------------------------------------------------------
CREATE TABLE artist
(artist_id					INT         NOT NULL PRIMARY KEY IDENTITY,
 artist_type_id				INT         NOT NULL REFERENCES artist_type (artist_type_id),
 artist_name				CHAR(10)	NOT NULL);
-------------------------------------------------------------------------------------------------
CREATE TABLE disk_has_artist
(disk_has_artist_id			INT         NOT NULL PRIMARY KEY IDENTITY,
 cd_id						INT         NOT NULL REFERENCES disk (cd_id),
 artist_id					INT			NOT NULL REFERENCES artist (artist_id));
-------------------------------------------------------------------------------------------------
CREATE TABLE borrower
(borrower_id				INT         NOT NULL PRIMARY KEY IDENTITY,
 fname						CHAR(10)	NOT NULL,
 lname						CHAR(60)	NOT NULL,
 phone_num					CHAR(15)	NOT NULL);
-------------------------------------------------------------------------------------------------
CREATE TABLE disk_has_borrower
(disk_has_borrower_id		INT         NOT NULL PRIMARY KEY IDENTITY,
 borrower_id				INT         NOT NULL REFERENCES borrower (borrower_id),
 cd_id						INT         NOT NULL REFERENCES disk (cd_id),
 borrowed_date				DATE		NOT NULL,
 returned_date				DATE		NULL);
-------------------------------------------------------------------------------------------------
go
--  after testing, create new GitHub repository and push