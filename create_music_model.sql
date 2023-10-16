--
-- Create schema music_model to hold the tables, primary/unique indexes, constraints, functions and triggers and data.
--
CREATE SCHEMA IF NOT EXISTS music_model AUTHORIZATION postgres;

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
,created_on            TIMESTAMP   NOT NULL
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
CREATE OR REPLACE TRIGGER rights_holders_id_changes_albums
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
                             
                             

--
-- Select all data from each table
--
select * from music_model.users_role;
select * from music_model.users;
select * from music_model.users_authentication;
                             
select * from music_model.music_albums;        
select * from music_model.music_tracks;  
                             
select * from music_model.rights_holders_organization;
select * from music_model.rights_holders;
select * from music_model.rights_holders_albums;
select * from music_model.rights_holders_tracks;
                             
select * from music_model.compilation_albums;
select * from music_model.compilation_albums_tracks;         
select * from music_model.compilation_albums_history;
select * from music_model.compilation_albums_tracks_history;








