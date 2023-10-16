# Readme document for Part One: Create a SQL Database

## Assumptions
For this work while I have created and tested this model on PostgreSQL 16, all I have assumed is that any  Postgres Cluster used by the reviewer will have an o/s user of postgres which based on my understanding that is pretty standard, the only way you can usually have a non-postgres user is by compiling from sources or changing all the uid/gid's post installation.

## This github repo contains 

readme.md:

This file contains all the details of the decisions I made as well as the SQL to create tables, primary keys, unique keys, default values and foreign key constraints. Also sample data to test the model and test the triggers/functions for the two history tables.
   
music_model_dump.sql:

This file is a clear text dump file created with `pg_dump`  using the following command

```sh
sudo su - postgres
pg_dump -U postgres -F p postgres > music_model_dump.sql 

``` 
To restore this dumpfile first copy it to your server where you are going to test it, can be any location that postgres has access to and need to set postgres as the owner

```sh
sudo su - 
cp /uploaded_location/music_model_dump.sql  /home/postgres/music_model_dump.sql 
cd /home/postgres/
chown postgres:postgres music_model_dump.sql 
``` 

and then can restore this dumpfile use the following command

```sh
sudo su - postgres
cd /home/postgres/
psql -U postgres  < music_model_dump.sql 

``` 
I have tested that this dumpfile can be restored into any of postgres 11-16,

create_music_model.sql:
 
If for any reason the dumpfile does not work I have provided a standard SQL script to first to drop any objects created by the failed dump and then the above name script to install the model again. Similarly to above need to ensure that these files are uploaded to a location that postgres user has access to them and need to set postgres as the owner

```sh
sudo su - 
cp /uploaded_location/drop_music_model.sql  /home/postgres/drop_music_model.sql
cp /uploaded_location/create_music_model.sql  /home/postgres/create_music_model.sql
cd /home/postgres/
chown postgres:postgres drop_music_model.sql
chown postgres:postgres create_music_model.sql
``` 

and then can run these sql scripts using the following command
```sh
cd /home/postgres/
psql -U postgres postgres < drop_music_model.sql
psql -U postgres postgres < create_music_model.sql
``` 

drop_music_model.sql:

This script  can be used to clean up your environment after reviewing the model and the data within, using the following command
  
```sh
 psql -U postgres postgres < drop_music_model.sql
``` 

## Assumptions for the music model
I have tried to keep this very simple, I have ensured all tables have primary keys, and unique keys where I am certain that there is uniqueness, I have added three columns created_on, updated_on and bywhat to each table for tracking when data was first created, last updated and bywhat (being what application or user made the change). I have not defined any cascading rules for the foreign key constraints either.

### Create Schema for the music_model tables 
As stated earlier I have assumed that PostgreSQL database in use is an open source version that should contain a postgres database by default and a postgres user too. This is true on all three editions of postgres I have worked on, Opensource postgres, EDB Extended and EDB Advanced.

```sql
--
-- Create schema music_model to hold the tables, primary/unique indexes, constraints, functions and triggers and data.
--
CREATE SCHEMA IF NOT EXISTS music_model AUTHORIZATION postgres;
``` 

### Create Users, Users_Role and Users Authentication tables

For this simple data model, I decided to create three tables, 1) Users that models a generic user, 2) Users_Role that covers the three different user types of Administrative, Write privs and Read-only privs and 3) the User_Authentication table that holds email_address and password to login.

I also assumed that an admin user has admin rights and write/read rights, that a write user has read rights too, but no admin rights and that a read-only user only has read access. I could have modeled a more generic case of a user who could have had all three roles but I thought that was overkill and wanted to keep the model simple in this case. Also I have kept email_address with password within the user_authentication table instead of moving it into the user table as felt that made more sense.

Finally for User_authentication I should be storing the password in encrypted mode, but for this case kept things simple. Also what I could have done is already create an admin_role that owned the schema and had all administrative privileges on the schema and objects within it, similarly for a write_role had insert, update and delete privileges and a read_only role that had selct privileges only. 

```sql
--
-- DDL for music_model.users_role
--
CREATE TABLE music_model.users_role
(users_role_id   SMALLINT     PRIMARY KEY
,users_role_name VARCHAR(255) UNIQUE NOT NULL
,created_on      TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
,updated_on      TIMESTAMP 
,bywhat          VARCHAR(50)  DEFAULT 'Pex App'
);

--
-- DDL for music_model.users
--
CREATE TABLE music_model.users
(users_id      SERIAL      PRIMARY KEY
,first_name    VARCHAR(50) NOT NULL
,surname       VARCHAR(50) NOT NULL
,users_role_id SMALLINT    NOT NULL
,created_on    TIMESTAMP   DEFAULT CURRENT_TIMESTAMP
,updated_on    TIMESTAMP 
,bywhat        VARCHAR(50) DEFAULT 'Pex App'
,CONSTRAINT fk_usersrole
 FOREIGN KEY(users_role_id) REFERENCES music_model.users_role(users_role_id)
);

--
-- DDL for music_model.users_authentication
--
CREATE TABLE music_model.users_authentication
(email_address VARCHAR(50)  PRIMARY KEY
,password      VARCHAR(50)         NOT NULL
,users_id      INT          UNIQUE NOT NULL 
,last_login    TIMESTAMP
,created_on    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
,updated_on    TIMESTAMP 
,bywhat        VARCHAR(50)  DEFAULT 'Pex App'
,CONSTRAINT fk_users 
 FOREIGN KEY(users_id) REFERENCES music_model.users(users_id)
);


--
-- Loading data into user tables to test model
--
INSERT INTO music_model.users_role(users_role_id, users_role_name) 
VALUES(1, 'Admin role');
INSERT INTO music_model.users_role(users_role_id, users_role_name) 
VALUES(2, 'Write role');
INSERT INTO music_model.users_role(users_role_id, users_role_name) 
VALUES(3, 'Read-Only role');

INSERT INTO music_model.users(first_name, surname, users_role_id) 
VALUES('Leon',  'Collacott', 1);
INSERT INTO music_model.users(first_name, surname, users_role_id) 
VALUES('Dave',  'Southwell', 2);
INSERT INTO music_model.users(first_name, surname, users_role_id) 
VALUES('Lenka', 'Caisová'  , 3);

INSERT INTO music_model.users_authentication(email_address, password, users_id) 
VALUES('leon_collacott@hotmail.com',  'Password', 1);
INSERT INTO music_model.users_authentication(email_address, password, users_id) 
VALUES('dave@pex.com', 'Soccer', 2);
INSERT INTO music_model.users_authentication(email_address, password, users_id) 
VALUES('lenka@pex.com',  'Baby', 3);
``` 

### Create Music_Albums and Music_Tracks tables

Again here I have kept the tables extremely simple as at Omnifone we tracked loads of attributes for albums and tracks. Also we had an artists and genre tables but that is not being included either as I suppose that is not important for a rights holders database.

Now obviously an album name is not unique but an album name and its release date should be. I did think about making track_name and duration unique but as there are millions and possibly billions of tracks in existence i did not want to take that risk. That also raised the thought of using BIGINT for track_Id but decided to leave as is for now.

Also I am aware that in a each country that an Album could be released at different date, in different formats  and that the same albums in different countries may also have different sets of tracks by country, and this could also be due to licensing issues and censoring as well. Finally tracks are usually ordered in an album too but that is not important for Rights Holder management.

Initially I left music_album_id out of the music_tracks table, but decided to put it back in but leave it NULL, as I think a track does not have to belong to an album. 

  
```sql
--
-- DDL for music_model.music_albums
--
CREATE TABLE music_model.music_albums 
(music_albums_id SERIAL      PRIMARY KEY
,name            VARCHAR(50) NOT NULL
,release_date    TIMESTAMP   NOT NULL
,created_on      TIMESTAMP   DEFAULT CURRENT_TIMESTAMP
,updated_on      TIMESTAMP 
,bywhat          VARCHAR(50) DEFAULT 'Pex App'
,UNIQUE (name, release_date)
);

--
-- DDL for music_model.music_tracks
--
CREATE TABLE music_model.music_tracks 
(music_tracks_id  SERIAL      PRIMARY KEY
,name             VARCHAR(50) NOT NULL
,duration_seconds INT         NOT NULL
,music_albums_id  INT
,release_date     TIMESTAMP   
,created_on       TIMESTAMP   DEFAULT CURRENT_TIMESTAMP
,updated_on       TIMESTAMP 
,bywhat           VARCHAR(50) DEFAULT 'Pex App'
,CONSTRAINT fk_music_albums
 FOREIGN KEY(music_albums_id) REFERENCES music_model.music_albums(music_albums_id)
);

--
-- Loading data into music tables to test model (choose a killers album as an example)
--
INSERT INTO music_model.music_albums(name, release_date) 
VALUES('Day & Age',  TO_DATE('18 Nov 2008,', 'DD Mon YYYY'));

INSERT INTO music_model.music_tracks(name, duration_seconds, music_albums_id) 
VALUES('Losing Touch', ROUND(EXTRACT(EPOCH FROM '00:04:15'::time),0), 1);

INSERT INTO music_model.music_tracks(name, duration_seconds, music_albums_id) 
VALUES('Human', ROUND(EXTRACT(EPOCH FROM '00:04:09'::time),0), 1);

INSERT INTO music_model.music_tracks(name, duration_seconds, music_albums_id) 
VALUES('Spaceman', ROUND(EXTRACT(EPOCH FROM '00:04:43'::time),0), 1);

INSERT INTO music_model.music_tracks(name, duration_seconds, music_albums_id) 
VALUES('Joy Ride', ROUND(EXTRACT(EPOCH FROM '00:03:33'::time),0), 1);

INSERT INTO music_model.music_tracks(name, duration_seconds, music_albums_id) 
VALUES('A Dustland Fairytale', ROUND(EXTRACT(EPOCH FROM '00:03:45'::time),0), 1);

INSERT INTO music_model.music_tracks(name, duration_seconds, music_albums_id) 
VALUES('This Is Your Life', ROUND(EXTRACT(EPOCH FROM '00:03:41'::time),0), 1);

INSERT INTO music_model.music_tracks(name, duration_seconds, music_albums_id) 
VALUES('I Can''t Stay', ROUND(EXTRACT(EPOCH FROM '00:03:06'::time),0), 1);

INSERT INTO music_model.music_tracks(name, duration_seconds, music_albums_id) 
VALUES('Neon Tiger', ROUND(EXTRACT(EPOCH FROM '00:03:05'::time),0), 1);

INSERT INTO music_model.music_tracks(name, duration_seconds, music_albums_id) 
VALUES('The World We Live In', ROUND(EXTRACT(EPOCH FROM '00:04:40'::time),0), 1);

INSERT INTO music_model.music_tracks(name, duration_seconds, music_albums_id) 
VALUES('Goodnight, Travel Well', ROUND(EXTRACT(EPOCH FROM '00:06:51'::time),0), 1);
``` 

### Create Rights_Holders, Rights_Holders_Albums, Rights_Holders_Tracks and Rights_Holders_Organization tables

Now my understanding of Rights_Holders is there can be many Rights_Holders for each album and track from Artists, Song Writers, Record Labels, DIstributers etc. Also these can also vary by country as well, but kept the model simple for this challenge. Maybe I should have added a Rights_Holders_Type table but that was not in scope.

Also what I have not done is add any numbers for royalties in the model as no idea about how that part works. I added the Right_holders_organization here as there is an order to the tables, and I could have modelled that organizations may have parents too but decided to leave it at one level. Also left right_holders_organization_id NULL on Right_Holders as maybe they dont belong to an organization too. 

FInally I did not decide to link users and right_holders as would expect that some admin in a band or organization would have an account on the application and setup all the Rights Holders metadata for each organization and possibly much of this would be automated.

```sql
--
-- DDL for music_model.rights_holders_organization
--
CREATE TABLE music_model.rights_holders_organization 
(rights_holders_organization_id SERIAL      PRIMARY KEY
,organization_name              VARCHAR(50) UNIQUE NOT NULL
,created_on                     TIMESTAMP   DEFAULT CURRENT_TIMESTAMP
,updated_on                     TIMESTAMP 
,bywhat                         VARCHAR(50) DEFAULT 'Pex App'
);

--
-- DDL for music_model.rights_holders
--
CREATE TABLE music_model.rights_holders 
(rights_holders_id              SERIAL      PRIMARY KEY
,name                           VARCHAR(50) NOT NULL
,rights_holders_organization_id INT 
,created_on                     TIMESTAMP   DEFAULT CURRENT_TIMESTAMP
,updated_on                     TIMESTAMP 
,bywhat                         VARCHAR(50) DEFAULT 'Pex App'
,CONSTRAINT fk_rights_holders_organization 
 FOREIGN KEY(rights_holders_organization_id) REFERENCES music_model.rights_holders_organization(rights_holders_organization_id)
);

--
-- DDL for music_model.rights_holders_albums 
--
CREATE TABLE music_model.rights_holders_albums 
(rights_holders_id  INT         NOT NULL
,music_albums_id    INT         NOT NULL
,created_on         TIMESTAMP   DEFAULT CURRENT_TIMESTAMP
,updated_on         TIMESTAMP 
,bywhat             VARCHAR(50) DEFAULT 'Pex App'
,PRIMARY KEY (rights_holders_id, music_albums_id)
,CONSTRAINT fk_rights_holders 
 FOREIGN KEY (rights_holders_id) REFERENCES music_model.rights_holders(rights_holders_id)
,CONSTRAINT fk_music_albums
 FOREIGN KEY (music_albums_id)   REFERENCES music_model.music_albums(music_albums_id)
);

--
-- DDL for music_model.rights_holders_tracks 
--
CREATE TABLE music_model.rights_holders_tracks 
(rights_holders_id INT         NOT NULL
,music_tracks_id   INT         NOT NULL
,created_on        TIMESTAMP   DEFAULT CURRENT_TIMESTAMP
,updated_on        TIMESTAMP 
,bywhat            VARCHAR(50) DEFAULT 'Pex App'
,PRIMARY KEY (rights_holders_id, music_tracks_id)
,CONSTRAINT fk_rights_holders 
 FOREIGN KEY (rights_holders_id) REFERENCES music_model.rights_holders(rights_holders_id)
,CONSTRAINT fk_music_tracks
 FOREIGN KEY (music_tracks_id)   REFERENCES music_model.music_tracks(music_tracks_id)
);

--
-- Loading data into rights holders tables to test model
--
INSERT INTO music_model.rights_holders_organization(organization_name) 
VALUES('Universal Music');


INSERT INTO music_model.rights_holders(name, rights_holders_organization_id) 
VALUES('The Killers', 1);

INSERT INTO music_model.rights_holders(name) 
VALUES('Eldridge');


INSERT INTO music_model.rights_holders_albums(rights_holders_id, music_albums_id) 
VALUES(1, 1);

INSERT INTO music_model.rights_holders_albums(rights_holders_id, music_albums_id) 
VALUES(2, 1);


INSERT INTO music_model.rights_holders_tracks(rights_holders_id, music_tracks_id)
VALUES(1,1);

INSERT INTO music_model.rights_holders_tracks(rights_holders_id, music_tracks_id)
VALUES(1,2);

INSERT INTO music_model.rights_holders_tracks(rights_holders_id, music_tracks_id)
VALUES(1,3);

INSERT INTO music_model.rights_holders_tracks(rights_holders_id, music_tracks_id)
VALUES(1,4);

INSERT INTO music_model.rights_holders_tracks(rights_holders_id, music_tracks_id)
VALUES(1,5);

INSERT INTO music_model.rights_holders_tracks(rights_holders_id, music_tracks_id)
VALUES(1,6);

INSERT INTO music_model.rights_holders_tracks(rights_holders_id, music_tracks_id)
VALUES(1,7);

INSERT INTO music_model.rights_holders_tracks(rights_holders_id, music_tracks_id)
VALUES(1,8);

INSERT INTO music_model.rights_holders_tracks(rights_holders_id, music_tracks_id)
VALUES(1,9);

INSERT INTO music_model.rights_holders_tracks(rights_holders_id, music_tracks_id)
VALUES(1,10);

INSERT INTO music_model.rights_holders_tracks(rights_holders_id, music_tracks_id)
VALUES(2,1);

INSERT INTO music_model.rights_holders_tracks(rights_holders_id, music_tracks_id)
VALUES(2,2);

INSERT INTO music_model.rights_holders_tracks(rights_holders_id, music_tracks_id)
VALUES(2,3);

INSERT INTO music_model.rights_holders_tracks(rights_holders_id, music_tracks_id)
VALUES(2,4);

INSERT INTO music_model.rights_holders_tracks(rights_holders_id, music_tracks_id)
VALUES(2,5);

INSERT INTO music_model.rights_holders_tracks(rights_holders_id, music_tracks_id)
VALUES(2,6);

INSERT INTO music_model.rights_holders_tracks(rights_holders_id, music_tracks_id)
VALUES(2,7);

INSERT INTO music_model.rights_holders_tracks(rights_holders_id, music_tracks_id)
VALUES(2,8);

INSERT INTO music_model.rights_holders_tracks(rights_holders_id, music_tracks_id)
VALUES(2,9);

INSERT INTO music_model.rights_holders_tracks(rights_holders_id, music_tracks_id)
VALUES(2,10);

``` 


### Create Compilation_albums, Compilation_albums_tracks,  and Rights_Holders_Tracks tables

Now what I did maybe wrong but for Compilation_albums I decided to model that there could be a rights_holder at the album level who distributes/advertises the album and separate rights_holders at the compilation_albums_tracks level too that give royalties to the rights holders of the individual songs.

I also created a history table for each of Compilation_albums and Compilation_albums_tracks that are loaded with history of the before record after any rights_holders are changed at either the album or track level using before update row level triggers on the base tables that only fire when the rights_holder_id is different.


```sql

--
-- DDL for music_model.compilation_albums  
--
CREATE TABLE music_model.compilation_albums  
(compilation_albums_id SERIAL      PRIMARY KEY
,name                  VARCHAR(50) NOT NULL
,release_date          TIMESTAMP   NOT NULL
,rights_holders_id     INT         NOT NULL
,created_on            TIMESTAMP   DEFAULT CURRENT_TIMESTAMP
,updated_on            TIMESTAMP 
,bywhat                VARCHAR(50) DEFAULT 'Pex App'
,UNIQUE (name, release_date)
,CONSTRAINT fk_rights_holders 
 FOREIGN KEY (rights_holders_id) REFERENCES music_model.rights_holders(rights_holders_id)
);

--
-- DDL for music_model.compilation_albums_tracks  
--
CREATE TABLE music_model.compilation_albums_tracks  
(compilation_albums_id INT         NOT NULL
,music_tracks_id       INT         NOT NULL
,rights_holders_id     INT         NOT NULL
,created_on            TIMESTAMP   DEFAULT CURRENT_TIMESTAMP
,updated_on            TIMESTAMP 
,bywhat                VARCHAR(50) DEFAULT 'Pex App'
,PRIMARY KEY (compilation_albums_id, music_tracks_id)
,CONSTRAINT fk_compilation_albums
 FOREIGN KEY (compilation_albums_id) REFERENCES music_model.compilation_albums(compilation_albums_id)
,CONSTRAINT fk_music_tracks
 FOREIGN KEY (music_tracks_id)       REFERENCES music_model.music_tracks(music_tracks_id)
,CONSTRAINT fk_rights_holders 
 FOREIGN KEY (rights_holders_id)     REFERENCES music_model.rights_holders(rights_holders_id)
);

--
-- DDL for music_model.compilation_albums_history 
-- (to make this work a row level update trigger is needed on compilation_albums 
-- that keeps a history of changes to rights_holders_id for each compilation albums and the date this occured)
--
CREATE TABLE music_model.compilation_albums_history  
(compilation_albums_id SERIAL      NOT NULL
,rights_holders_id     INT         NOT NULL
,created_on            TIMESTAMP   NOT NULL
,updated_on            TIMESTAMP   NOT NULL
,bywhat                VARCHAR(50) DEFAULT 'Pex App'
,PRIMARY KEY (compilation_albums_id, rights_holders_id, updated_on)
,CONSTRAINT fk_rights_holders 
 FOREIGN KEY (rights_holders_id) REFERENCES music_model.rights_holders(rights_holders_id)
);



--
-- DDL for music_model.compilation_albums_tracks_history 
-- (to make this work a row level update trigger is needed on compilation_albums_tracks 
-- that keeps a history of changes to rights_holders_id for each compilation_albums_tracks and the date this occured)  
--
CREATE TABLE music_model.compilation_albums_tracks_history
(compilation_albums_id INT         NOT NULL
,music_tracks_id       INT         NOT NULL
,rights_holders_id     INT         NOT NULL
,created_on            TIMESTAMP  NOT NULL
,updated_on            TIMESTAMP   NOT NULL
,bywhat                VARCHAR(50) DEFAULT 'Pex App'
,PRIMARY KEY (compilation_albums_id, music_tracks_id, rights_holders_id, updated_on)
,CONSTRAINT fk_compilation_albums
 FOREIGN KEY (compilation_albums_id) REFERENCES music_model.compilation_albums(compilation_albums_id)
,CONSTRAINT fk_music_tracks
 FOREIGN KEY (music_tracks_id)       REFERENCES music_model.music_tracks(music_tracks_id)
,CONSTRAINT fk_rights_holders 
 FOREIGN KEY (rights_holders_id)     REFERENCES music_model.rights_holders(rights_holders_id)
);

--
-- Function that tracks changes to rights_holders for albums
--
CREATE OR REPLACE FUNCTION music_model.log_rights_holders_id_changes_albums()
RETURNS TRIGGER 
LANGUAGE PLPGSQL
AS
$$
BEGIN

   IF NEW.rights_holders_id <> OLD.rights_holders_id  THEN
		 
      INSERT INTO music_model.compilation_albums_history(compilation_albums_id, rights_holders_id, created_on, updated_on, bywhat)
	  VALUES(OLD.compilation_albums_id, OLD.rights_holders_id, OLD.created_on, now(), OLD.bywhat);

   END IF;

   RETURN NEW;

END;
$$
;

--
-- Trigger that tracks changes to rights_holders for albums
--
CREATE TRIGGER rights_holders_id_changes_albums
BEFORE UPDATE
ON music_model.compilation_albums  
FOR EACH ROW
EXECUTE FUNCTION music_model.log_rights_holders_id_changes_albums();

--
-- Function that tracks changes to rights_holders for tracks
--
CREATE OR REPLACE FUNCTION music_model.log_rights_holders_id_changes_tracks()
RETURNS TRIGGER 
LANGUAGE PLPGSQL
AS
$$
BEGIN

   IF NEW.rights_holders_id <> OLD.rights_holders_id  THEN
		 
      INSERT INTO music_model.compilation_albums_tracks_history(compilation_albums_id, music_tracks_id, rights_holders_id, created_on, updated_on, bywhat)
	  VALUES(OLD.compilation_albums_id, OLD.music_tracks_id, OLD.rights_holders_id, OLD.created_on, now(), OLD.bywhat);
      
   END IF;

   RETURN NEW;
   
END;
$$
;

--
-- Trigger that tracks changes to rights_holders for tracks
--
CREATE OR REPLACE TRIGGER rights_holders_id_changes_tracks
BEFORE UPDATE
ON music_model.compilation_albums_tracks  
FOR EACH ROW
EXECUTE FUNCTION music_model.log_rights_holders_id_changes_tracks();

--
-- Loading data into rights holders tables to test model
--
INSERT INTO music_model.compilation_albums(name, release_date, rights_holders_id)
VALUES('A made complilation',TO_DATE('18 Nov 2022,', 'DD Mon YYYY'), 1);

UPDATE music_model.compilation_albums
SET rights_holders_id = 2
WHERE name = 'A made complilation';

INSERT INTO music_model.compilation_albums_tracks(compilation_albums_id, music_tracks_id, rights_holders_id)
VALUES(1, 1, 1);

UPDATE music_model.compilation_albums_tracks
SET rights_holders_id = 2
WHERE compilation_albums_id = 1 
AND music_tracks_id = 1;

```