--
-- drop music_model tables in order to be dropped without getting integrity error
--
drop table music_model.compilation_albums_tracks_history;
drop table music_model.compilation_albums_history;
drop table music_model.compilation_albums_tracks;
drop table music_model.compilation_albums;
drop table music_model.rights_holders_tracks;
drop table music_model.rights_holders_albums;
drop table music_model.rights_holders;
drop table music_model.rights_holders_organization;
drop table music_model.music_tracks;
drop table music_model.music_albums;
drop table music_model.users_authentication;
drop table music_model.users;
drop table music_model.users_role;

--
-- drop two functions containing code for triggers
--
DROP FUNCTION music_model.log_rights_holders_id_changes_albums;
DROP FUNCTION music_model.log_rights_holders_id_changes_tracks;

--
-- finally drop the schema
--
DROP SCHEMA music_model;


