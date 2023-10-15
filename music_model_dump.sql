--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0 (Debian 16.0-1.pgdg110+1)
-- Dumped by pg_dump version 16.0 (Debian 16.0-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: music_model; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA music_model;


ALTER SCHEMA music_model OWNER TO postgres;

--
-- Name: log_rights_holders_id_changes_albums(); Type: FUNCTION; Schema: music_model; Owner: postgres
--

CREATE FUNCTION music_model.log_rights_holders_id_changes_albums() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

   IF NEW.rights_holders_id <> OLD.rights_holders_id  THEN
		 
      INSERT INTO music_model.compilation_albums_history(compilation_albums_id, rights_holders_id, created_on, updated_on, bywhat)
	  VALUES(OLD.compilation_albums_id, OLD.rights_holders_id, OLD.created_on, now(), OLD.bywhat);

   END IF;

   RETURN NEW;

END;
$$;


ALTER FUNCTION music_model.log_rights_holders_id_changes_albums() OWNER TO postgres;

--
-- Name: log_rights_holders_id_changes_tracks(); Type: FUNCTION; Schema: music_model; Owner: postgres
--

CREATE FUNCTION music_model.log_rights_holders_id_changes_tracks() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

   IF NEW.rights_holders_id <> OLD.rights_holders_id  THEN
		 
      INSERT INTO music_model.compilation_albums_tracks_history(compilation_albums_id, music_tracks_id, rights_holders_id, created_on, updated_on, bywhat)
	  VALUES(OLD.compilation_albums_id, OLD.music_tracks_id, OLD.rights_holders_id, OLD.created_on, now(), OLD.bywhat);
      
   END IF;

   RETURN NEW;
   
END;
$$;


ALTER FUNCTION music_model.log_rights_holders_id_changes_tracks() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: compilation_albums; Type: TABLE; Schema: music_model; Owner: postgres
--

CREATE TABLE music_model.compilation_albums (
    compilation_albums_id integer NOT NULL,
    name character varying(50) NOT NULL,
    release_date timestamp without time zone NOT NULL,
    rights_holders_id integer NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone,
    bywhat character varying(50) DEFAULT 'Pex App'::character varying
);


ALTER TABLE music_model.compilation_albums OWNER TO postgres;

--
-- Name: compilation_albums_compilation_albums_id_seq; Type: SEQUENCE; Schema: music_model; Owner: postgres
--

CREATE SEQUENCE music_model.compilation_albums_compilation_albums_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE music_model.compilation_albums_compilation_albums_id_seq OWNER TO postgres;

--
-- Name: compilation_albums_compilation_albums_id_seq; Type: SEQUENCE OWNED BY; Schema: music_model; Owner: postgres
--

ALTER SEQUENCE music_model.compilation_albums_compilation_albums_id_seq OWNED BY music_model.compilation_albums.compilation_albums_id;


--
-- Name: compilation_albums_history; Type: TABLE; Schema: music_model; Owner: postgres
--

CREATE TABLE music_model.compilation_albums_history (
    compilation_albums_id integer NOT NULL,
    rights_holders_id integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_on timestamp without time zone NOT NULL,
    bywhat character varying(50) DEFAULT 'Pex App'::character varying
);


ALTER TABLE music_model.compilation_albums_history OWNER TO postgres;

--
-- Name: compilation_albums_history_compilation_albums_id_seq; Type: SEQUENCE; Schema: music_model; Owner: postgres
--

CREATE SEQUENCE music_model.compilation_albums_history_compilation_albums_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE music_model.compilation_albums_history_compilation_albums_id_seq OWNER TO postgres;

--
-- Name: compilation_albums_history_compilation_albums_id_seq; Type: SEQUENCE OWNED BY; Schema: music_model; Owner: postgres
--

ALTER SEQUENCE music_model.compilation_albums_history_compilation_albums_id_seq OWNED BY music_model.compilation_albums_history.compilation_albums_id;


--
-- Name: compilation_albums_tracks; Type: TABLE; Schema: music_model; Owner: postgres
--

CREATE TABLE music_model.compilation_albums_tracks (
    compilation_albums_id integer NOT NULL,
    music_tracks_id integer NOT NULL,
    rights_holders_id integer NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone,
    bywhat character varying(50) DEFAULT 'Pex App'::character varying
);


ALTER TABLE music_model.compilation_albums_tracks OWNER TO postgres;

--
-- Name: compilation_albums_tracks_history; Type: TABLE; Schema: music_model; Owner: postgres
--

CREATE TABLE music_model.compilation_albums_tracks_history (
    compilation_albums_id integer NOT NULL,
    music_tracks_id integer NOT NULL,
    rights_holders_id integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_on timestamp without time zone NOT NULL,
    bywhat character varying(50) DEFAULT 'Pex App'::character varying
);


ALTER TABLE music_model.compilation_albums_tracks_history OWNER TO postgres;

--
-- Name: music_albums; Type: TABLE; Schema: music_model; Owner: postgres
--

CREATE TABLE music_model.music_albums (
    music_albums_id integer NOT NULL,
    name character varying(50) NOT NULL,
    release_date timestamp without time zone NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone,
    bywhat character varying(50) DEFAULT 'Pex App'::character varying
);


ALTER TABLE music_model.music_albums OWNER TO postgres;

--
-- Name: music_albums_music_albums_id_seq; Type: SEQUENCE; Schema: music_model; Owner: postgres
--

CREATE SEQUENCE music_model.music_albums_music_albums_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE music_model.music_albums_music_albums_id_seq OWNER TO postgres;

--
-- Name: music_albums_music_albums_id_seq; Type: SEQUENCE OWNED BY; Schema: music_model; Owner: postgres
--

ALTER SEQUENCE music_model.music_albums_music_albums_id_seq OWNED BY music_model.music_albums.music_albums_id;


--
-- Name: music_tracks; Type: TABLE; Schema: music_model; Owner: postgres
--

CREATE TABLE music_model.music_tracks (
    music_tracks_id integer NOT NULL,
    name character varying(50) NOT NULL,
    duration_seconds integer NOT NULL,
    music_albums_id integer,
    release_date timestamp without time zone,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone,
    bywhat character varying(50) DEFAULT 'Pex App'::character varying
);


ALTER TABLE music_model.music_tracks OWNER TO postgres;

--
-- Name: music_tracks_music_tracks_id_seq; Type: SEQUENCE; Schema: music_model; Owner: postgres
--

CREATE SEQUENCE music_model.music_tracks_music_tracks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE music_model.music_tracks_music_tracks_id_seq OWNER TO postgres;

--
-- Name: music_tracks_music_tracks_id_seq; Type: SEQUENCE OWNED BY; Schema: music_model; Owner: postgres
--

ALTER SEQUENCE music_model.music_tracks_music_tracks_id_seq OWNED BY music_model.music_tracks.music_tracks_id;


--
-- Name: rights_holders; Type: TABLE; Schema: music_model; Owner: postgres
--

CREATE TABLE music_model.rights_holders (
    rights_holders_id integer NOT NULL,
    name character varying(50) NOT NULL,
    rights_holders_organization_id integer,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone,
    bywhat character varying(50) DEFAULT 'Pex App'::character varying
);


ALTER TABLE music_model.rights_holders OWNER TO postgres;

--
-- Name: rights_holders_albums; Type: TABLE; Schema: music_model; Owner: postgres
--

CREATE TABLE music_model.rights_holders_albums (
    rights_holders_id integer NOT NULL,
    music_albums_id integer NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone,
    bywhat character varying(50) DEFAULT 'Pex App'::character varying
);


ALTER TABLE music_model.rights_holders_albums OWNER TO postgres;

--
-- Name: rights_holders_organization; Type: TABLE; Schema: music_model; Owner: postgres
--

CREATE TABLE music_model.rights_holders_organization (
    rights_holders_organization_id integer NOT NULL,
    organization_name character varying(50) NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone,
    bywhat character varying(50) DEFAULT 'Pex App'::character varying
);


ALTER TABLE music_model.rights_holders_organization OWNER TO postgres;

--
-- Name: rights_holders_organization_rights_holders_organization_id_seq; Type: SEQUENCE; Schema: music_model; Owner: postgres
--

CREATE SEQUENCE music_model.rights_holders_organization_rights_holders_organization_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE music_model.rights_holders_organization_rights_holders_organization_id_seq OWNER TO postgres;

--
-- Name: rights_holders_organization_rights_holders_organization_id_seq; Type: SEQUENCE OWNED BY; Schema: music_model; Owner: postgres
--

ALTER SEQUENCE music_model.rights_holders_organization_rights_holders_organization_id_seq OWNED BY music_model.rights_holders_organization.rights_holders_organization_id;


--
-- Name: rights_holders_rights_holders_id_seq; Type: SEQUENCE; Schema: music_model; Owner: postgres
--

CREATE SEQUENCE music_model.rights_holders_rights_holders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE music_model.rights_holders_rights_holders_id_seq OWNER TO postgres;

--
-- Name: rights_holders_rights_holders_id_seq; Type: SEQUENCE OWNED BY; Schema: music_model; Owner: postgres
--

ALTER SEQUENCE music_model.rights_holders_rights_holders_id_seq OWNED BY music_model.rights_holders.rights_holders_id;


--
-- Name: rights_holders_tracks; Type: TABLE; Schema: music_model; Owner: postgres
--

CREATE TABLE music_model.rights_holders_tracks (
    rights_holders_id integer NOT NULL,
    music_tracks_id integer NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone,
    bywhat character varying(50) DEFAULT 'Pex App'::character varying
);


ALTER TABLE music_model.rights_holders_tracks OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: music_model; Owner: postgres
--

CREATE TABLE music_model.users (
    users_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    surname character varying(50) NOT NULL,
    users_role_id smallint NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone,
    bywhat character varying(50) DEFAULT 'Pex App'::character varying
);


ALTER TABLE music_model.users OWNER TO postgres;

--
-- Name: users_authentication; Type: TABLE; Schema: music_model; Owner: postgres
--

CREATE TABLE music_model.users_authentication (
    email_address character varying(50) NOT NULL,
    password character varying(50) NOT NULL,
    users_id integer NOT NULL,
    last_login timestamp without time zone,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone,
    bywhat character varying(50) DEFAULT 'Pex App'::character varying
);


ALTER TABLE music_model.users_authentication OWNER TO postgres;

--
-- Name: users_role; Type: TABLE; Schema: music_model; Owner: postgres
--

CREATE TABLE music_model.users_role (
    users_role_id smallint NOT NULL,
    users_role_name character varying(255) NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone,
    bywhat character varying(50) DEFAULT 'Pex App'::character varying
);


ALTER TABLE music_model.users_role OWNER TO postgres;

--
-- Name: users_users_id_seq; Type: SEQUENCE; Schema: music_model; Owner: postgres
--

CREATE SEQUENCE music_model.users_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE music_model.users_users_id_seq OWNER TO postgres;

--
-- Name: users_users_id_seq; Type: SEQUENCE OWNED BY; Schema: music_model; Owner: postgres
--

ALTER SEQUENCE music_model.users_users_id_seq OWNED BY music_model.users.users_id;


--
-- Name: compilation_albums compilation_albums_id; Type: DEFAULT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.compilation_albums ALTER COLUMN compilation_albums_id SET DEFAULT nextval('music_model.compilation_albums_compilation_albums_id_seq'::regclass);


--
-- Name: compilation_albums_history compilation_albums_id; Type: DEFAULT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.compilation_albums_history ALTER COLUMN compilation_albums_id SET DEFAULT nextval('music_model.compilation_albums_history_compilation_albums_id_seq'::regclass);


--
-- Name: music_albums music_albums_id; Type: DEFAULT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.music_albums ALTER COLUMN music_albums_id SET DEFAULT nextval('music_model.music_albums_music_albums_id_seq'::regclass);


--
-- Name: music_tracks music_tracks_id; Type: DEFAULT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.music_tracks ALTER COLUMN music_tracks_id SET DEFAULT nextval('music_model.music_tracks_music_tracks_id_seq'::regclass);


--
-- Name: rights_holders rights_holders_id; Type: DEFAULT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.rights_holders ALTER COLUMN rights_holders_id SET DEFAULT nextval('music_model.rights_holders_rights_holders_id_seq'::regclass);


--
-- Name: rights_holders_organization rights_holders_organization_id; Type: DEFAULT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.rights_holders_organization ALTER COLUMN rights_holders_organization_id SET DEFAULT nextval('music_model.rights_holders_organization_rights_holders_organization_id_seq'::regclass);


--
-- Name: users users_id; Type: DEFAULT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.users ALTER COLUMN users_id SET DEFAULT nextval('music_model.users_users_id_seq'::regclass);


--
-- Data for Name: compilation_albums; Type: TABLE DATA; Schema: music_model; Owner: postgres
--

COPY music_model.compilation_albums (compilation_albums_id, name, release_date, rights_holders_id, created_on, updated_on, bywhat) FROM stdin;
1	A made complilation	2022-11-18 00:00:00	2	2023-10-15 01:01:18.855439	\N	Pex App
\.


--
-- Data for Name: compilation_albums_history; Type: TABLE DATA; Schema: music_model; Owner: postgres
--

COPY music_model.compilation_albums_history (compilation_albums_id, rights_holders_id, created_on, updated_on, bywhat) FROM stdin;
1	1	2023-10-15 01:01:18.855439	2023-10-15 01:01:18.862045	Pex App
\.


--
-- Data for Name: compilation_albums_tracks; Type: TABLE DATA; Schema: music_model; Owner: postgres
--

COPY music_model.compilation_albums_tracks (compilation_albums_id, music_tracks_id, rights_holders_id, created_on, updated_on, bywhat) FROM stdin;
1	1	2	2023-10-15 01:01:18.873063	\N	Pex App
\.


--
-- Data for Name: compilation_albums_tracks_history; Type: TABLE DATA; Schema: music_model; Owner: postgres
--

COPY music_model.compilation_albums_tracks_history (compilation_albums_id, music_tracks_id, rights_holders_id, created_on, updated_on, bywhat) FROM stdin;
1	1	1	2023-10-15 01:01:18.873063	2023-10-15 01:01:18.887151	Pex App
\.


--
-- Data for Name: music_albums; Type: TABLE DATA; Schema: music_model; Owner: postgres
--

COPY music_model.music_albums (music_albums_id, name, release_date, created_on, updated_on, bywhat) FROM stdin;
1	Day & Age	2008-11-18 00:00:00	2023-10-15 01:01:18.437115	\N	Pex App
\.


--
-- Data for Name: music_tracks; Type: TABLE DATA; Schema: music_model; Owner: postgres
--

COPY music_model.music_tracks (music_tracks_id, name, duration_seconds, music_albums_id, release_date, created_on, updated_on, bywhat) FROM stdin;
1	Losing Touch	255	1	\N	2023-10-15 01:01:18.444858	\N	Pex App
2	Human	249	1	\N	2023-10-15 01:01:18.45175	\N	Pex App
3	Spaceman	283	1	\N	2023-10-15 01:01:18.457788	\N	Pex App
4	Joy Ride	213	1	\N	2023-10-15 01:01:18.4683	\N	Pex App
5	A Dustland Fairytale	225	1	\N	2023-10-15 01:01:18.474472	\N	Pex App
6	This Is Your Life	221	1	\N	2023-10-15 01:01:18.478983	\N	Pex App
7	I Can't Stay	186	1	\N	2023-10-15 01:01:18.486263	\N	Pex App
8	Neon Tiger	185	1	\N	2023-10-15 01:01:18.491647	\N	Pex App
9	The World We Live In	280	1	\N	2023-10-15 01:01:18.500575	\N	Pex App
10	Goodnight, Travel Well	411	1	\N	2023-10-15 01:01:18.507471	\N	Pex App
\.


--
-- Data for Name: rights_holders; Type: TABLE DATA; Schema: music_model; Owner: postgres
--

COPY music_model.rights_holders (rights_holders_id, name, rights_holders_organization_id, created_on, updated_on, bywhat) FROM stdin;
1	The Killers	1	2023-10-15 01:01:18.589146	\N	Pex App
2	Eldridge	\N	2023-10-15 01:01:18.59536	\N	Pex App
\.


--
-- Data for Name: rights_holders_albums; Type: TABLE DATA; Schema: music_model; Owner: postgres
--

COPY music_model.rights_holders_albums (rights_holders_id, music_albums_id, created_on, updated_on, bywhat) FROM stdin;
1	1	2023-10-15 01:01:18.604124	\N	Pex App
2	1	2023-10-15 01:01:18.611106	\N	Pex App
\.


--
-- Data for Name: rights_holders_organization; Type: TABLE DATA; Schema: music_model; Owner: postgres
--

COPY music_model.rights_holders_organization (rights_holders_organization_id, organization_name, created_on, updated_on, bywhat) FROM stdin;
1	Universal Music	2023-10-15 01:01:18.579239	\N	Pex App
\.


--
-- Data for Name: rights_holders_tracks; Type: TABLE DATA; Schema: music_model; Owner: postgres
--

COPY music_model.rights_holders_tracks (rights_holders_id, music_tracks_id, created_on, updated_on, bywhat) FROM stdin;
1	1	2023-10-15 01:01:18.62003	\N	Pex App
1	2	2023-10-15 01:01:18.626349	\N	Pex App
1	3	2023-10-15 01:01:18.632685	\N	Pex App
1	4	2023-10-15 01:01:18.641706	\N	Pex App
1	5	2023-10-15 01:01:18.648028	\N	Pex App
1	6	2023-10-15 01:01:18.655771	\N	Pex App
1	7	2023-10-15 01:01:18.662109	\N	Pex App
1	8	2023-10-15 01:01:18.671028	\N	Pex App
1	9	2023-10-15 01:01:18.678317	\N	Pex App
1	10	2023-10-15 01:01:18.683294	\N	Pex App
2	1	2023-10-15 01:01:18.690505	\N	Pex App
2	2	2023-10-15 01:01:18.69562	\N	Pex App
2	3	2023-10-15 01:01:18.702076	\N	Pex App
2	4	2023-10-15 01:01:18.708055	\N	Pex App
2	5	2023-10-15 01:01:18.716896	\N	Pex App
2	6	2023-10-15 01:01:18.724145	\N	Pex App
2	7	2023-10-15 01:01:18.732096	\N	Pex App
2	8	2023-10-15 01:01:18.740767	\N	Pex App
2	9	2023-10-15 01:01:18.747046	\N	Pex App
2	10	2023-10-15 01:01:18.753755	\N	Pex App
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: music_model; Owner: postgres
--

COPY music_model.users (users_id, first_name, surname, users_role_id, created_on, updated_on, bywhat) FROM stdin;
1	Leon	Collacott	1	2023-10-15 01:01:18.347694	\N	Pex App
2	Dave	Southwell	2	2023-10-15 01:01:18.361372	\N	Pex App
3	Lenka	Caisová	3	2023-10-15 01:01:18.366668	\N	Pex App
\.


--
-- Data for Name: users_authentication; Type: TABLE DATA; Schema: music_model; Owner: postgres
--

COPY music_model.users_authentication (email_address, password, users_id, last_login, created_on, updated_on, bywhat) FROM stdin;
leon_collacott@hotmail.com	Password	1	\N	2023-10-15 01:01:18.374162	\N	Pex App
dave@pex.com	Soccer	2	\N	2023-10-15 01:01:18.382075	\N	Pex App
lenka@pex.com	Baby	3	\N	2023-10-15 01:01:18.39047	\N	Pex App
\.


--
-- Data for Name: users_role; Type: TABLE DATA; Schema: music_model; Owner: postgres
--

COPY music_model.users_role (users_role_id, users_role_name, created_on, updated_on, bywhat) FROM stdin;
1	Admin role	2023-10-15 01:01:18.328762	\N	Pex App
2	Write role	2023-10-15 01:01:18.337467	\N	Pex App
3	Read-Only role	2023-10-15 01:01:18.344269	\N	Pex App
\.


--
-- Name: compilation_albums_compilation_albums_id_seq; Type: SEQUENCE SET; Schema: music_model; Owner: postgres
--

SELECT pg_catalog.setval('music_model.compilation_albums_compilation_albums_id_seq', 1, true);


--
-- Name: compilation_albums_history_compilation_albums_id_seq; Type: SEQUENCE SET; Schema: music_model; Owner: postgres
--

SELECT pg_catalog.setval('music_model.compilation_albums_history_compilation_albums_id_seq', 1, false);


--
-- Name: music_albums_music_albums_id_seq; Type: SEQUENCE SET; Schema: music_model; Owner: postgres
--

SELECT pg_catalog.setval('music_model.music_albums_music_albums_id_seq', 1, true);


--
-- Name: music_tracks_music_tracks_id_seq; Type: SEQUENCE SET; Schema: music_model; Owner: postgres
--

SELECT pg_catalog.setval('music_model.music_tracks_music_tracks_id_seq', 10, true);


--
-- Name: rights_holders_organization_rights_holders_organization_id_seq; Type: SEQUENCE SET; Schema: music_model; Owner: postgres
--

SELECT pg_catalog.setval('music_model.rights_holders_organization_rights_holders_organization_id_seq', 1, true);


--
-- Name: rights_holders_rights_holders_id_seq; Type: SEQUENCE SET; Schema: music_model; Owner: postgres
--

SELECT pg_catalog.setval('music_model.rights_holders_rights_holders_id_seq', 2, true);


--
-- Name: users_users_id_seq; Type: SEQUENCE SET; Schema: music_model; Owner: postgres
--

SELECT pg_catalog.setval('music_model.users_users_id_seq', 3, true);


--
-- Name: compilation_albums_history compilation_albums_history_pkey; Type: CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.compilation_albums_history
    ADD CONSTRAINT compilation_albums_history_pkey PRIMARY KEY (compilation_albums_id, rights_holders_id, updated_on);


--
-- Name: compilation_albums compilation_albums_name_release_date_key; Type: CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.compilation_albums
    ADD CONSTRAINT compilation_albums_name_release_date_key UNIQUE (name, release_date);


--
-- Name: compilation_albums compilation_albums_pkey; Type: CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.compilation_albums
    ADD CONSTRAINT compilation_albums_pkey PRIMARY KEY (compilation_albums_id);


--
-- Name: compilation_albums_tracks_history compilation_albums_tracks_history_pkey; Type: CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.compilation_albums_tracks_history
    ADD CONSTRAINT compilation_albums_tracks_history_pkey PRIMARY KEY (compilation_albums_id, music_tracks_id, rights_holders_id, updated_on);


--
-- Name: compilation_albums_tracks compilation_albums_tracks_pkey; Type: CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.compilation_albums_tracks
    ADD CONSTRAINT compilation_albums_tracks_pkey PRIMARY KEY (compilation_albums_id, music_tracks_id);


--
-- Name: music_albums music_albums_name_release_date_key; Type: CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.music_albums
    ADD CONSTRAINT music_albums_name_release_date_key UNIQUE (name, release_date);


--
-- Name: music_albums music_albums_pkey; Type: CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.music_albums
    ADD CONSTRAINT music_albums_pkey PRIMARY KEY (music_albums_id);


--
-- Name: music_tracks music_tracks_pkey; Type: CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.music_tracks
    ADD CONSTRAINT music_tracks_pkey PRIMARY KEY (music_tracks_id);


--
-- Name: rights_holders_albums rights_holders_albums_pkey; Type: CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.rights_holders_albums
    ADD CONSTRAINT rights_holders_albums_pkey PRIMARY KEY (rights_holders_id, music_albums_id);


--
-- Name: rights_holders_organization rights_holders_organization_organization_name_key; Type: CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.rights_holders_organization
    ADD CONSTRAINT rights_holders_organization_organization_name_key UNIQUE (organization_name);


--
-- Name: rights_holders_organization rights_holders_organization_pkey; Type: CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.rights_holders_organization
    ADD CONSTRAINT rights_holders_organization_pkey PRIMARY KEY (rights_holders_organization_id);


--
-- Name: rights_holders rights_holders_pkey; Type: CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.rights_holders
    ADD CONSTRAINT rights_holders_pkey PRIMARY KEY (rights_holders_id);


--
-- Name: rights_holders_tracks rights_holders_tracks_pkey; Type: CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.rights_holders_tracks
    ADD CONSTRAINT rights_holders_tracks_pkey PRIMARY KEY (rights_holders_id, music_tracks_id);


--
-- Name: users_authentication users_authentication_pkey; Type: CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.users_authentication
    ADD CONSTRAINT users_authentication_pkey PRIMARY KEY (email_address);


--
-- Name: users_authentication users_authentication_users_id_key; Type: CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.users_authentication
    ADD CONSTRAINT users_authentication_users_id_key UNIQUE (users_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (users_id);


--
-- Name: users_role users_role_pkey; Type: CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.users_role
    ADD CONSTRAINT users_role_pkey PRIMARY KEY (users_role_id);


--
-- Name: users_role users_role_users_role_name_key; Type: CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.users_role
    ADD CONSTRAINT users_role_users_role_name_key UNIQUE (users_role_name);


--
-- Name: compilation_albums rights_holders_id_changes_albums; Type: TRIGGER; Schema: music_model; Owner: postgres
--

CREATE TRIGGER rights_holders_id_changes_albums BEFORE UPDATE ON music_model.compilation_albums FOR EACH ROW EXECUTE FUNCTION music_model.log_rights_holders_id_changes_albums();


--
-- Name: compilation_albums_tracks rights_holders_id_changes_tracks; Type: TRIGGER; Schema: music_model; Owner: postgres
--

CREATE TRIGGER rights_holders_id_changes_tracks BEFORE UPDATE ON music_model.compilation_albums_tracks FOR EACH ROW EXECUTE FUNCTION music_model.log_rights_holders_id_changes_tracks();


--
-- Name: compilation_albums_tracks fk_compilation_albums; Type: FK CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.compilation_albums_tracks
    ADD CONSTRAINT fk_compilation_albums FOREIGN KEY (compilation_albums_id) REFERENCES music_model.compilation_albums(compilation_albums_id);


--
-- Name: compilation_albums_tracks_history fk_compilation_albums; Type: FK CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.compilation_albums_tracks_history
    ADD CONSTRAINT fk_compilation_albums FOREIGN KEY (compilation_albums_id) REFERENCES music_model.compilation_albums(compilation_albums_id);


--
-- Name: music_tracks fk_music_albums; Type: FK CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.music_tracks
    ADD CONSTRAINT fk_music_albums FOREIGN KEY (music_albums_id) REFERENCES music_model.music_albums(music_albums_id);


--
-- Name: rights_holders_albums fk_music_albums; Type: FK CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.rights_holders_albums
    ADD CONSTRAINT fk_music_albums FOREIGN KEY (music_albums_id) REFERENCES music_model.music_albums(music_albums_id);


--
-- Name: rights_holders_tracks fk_music_tracks; Type: FK CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.rights_holders_tracks
    ADD CONSTRAINT fk_music_tracks FOREIGN KEY (music_tracks_id) REFERENCES music_model.music_tracks(music_tracks_id);


--
-- Name: compilation_albums_tracks fk_music_tracks; Type: FK CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.compilation_albums_tracks
    ADD CONSTRAINT fk_music_tracks FOREIGN KEY (music_tracks_id) REFERENCES music_model.music_tracks(music_tracks_id);


--
-- Name: compilation_albums_tracks_history fk_music_tracks; Type: FK CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.compilation_albums_tracks_history
    ADD CONSTRAINT fk_music_tracks FOREIGN KEY (music_tracks_id) REFERENCES music_model.music_tracks(music_tracks_id);


--
-- Name: rights_holders_albums fk_rights_holders; Type: FK CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.rights_holders_albums
    ADD CONSTRAINT fk_rights_holders FOREIGN KEY (rights_holders_id) REFERENCES music_model.rights_holders(rights_holders_id);


--
-- Name: rights_holders_tracks fk_rights_holders; Type: FK CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.rights_holders_tracks
    ADD CONSTRAINT fk_rights_holders FOREIGN KEY (rights_holders_id) REFERENCES music_model.rights_holders(rights_holders_id);


--
-- Name: compilation_albums fk_rights_holders; Type: FK CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.compilation_albums
    ADD CONSTRAINT fk_rights_holders FOREIGN KEY (rights_holders_id) REFERENCES music_model.rights_holders(rights_holders_id);


--
-- Name: compilation_albums_tracks fk_rights_holders; Type: FK CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.compilation_albums_tracks
    ADD CONSTRAINT fk_rights_holders FOREIGN KEY (rights_holders_id) REFERENCES music_model.rights_holders(rights_holders_id);


--
-- Name: compilation_albums_history fk_rights_holders; Type: FK CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.compilation_albums_history
    ADD CONSTRAINT fk_rights_holders FOREIGN KEY (rights_holders_id) REFERENCES music_model.rights_holders(rights_holders_id);


--
-- Name: compilation_albums_tracks_history fk_rights_holders; Type: FK CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.compilation_albums_tracks_history
    ADD CONSTRAINT fk_rights_holders FOREIGN KEY (rights_holders_id) REFERENCES music_model.rights_holders(rights_holders_id);


--
-- Name: rights_holders fk_rights_holders_organization; Type: FK CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.rights_holders
    ADD CONSTRAINT fk_rights_holders_organization FOREIGN KEY (rights_holders_organization_id) REFERENCES music_model.rights_holders_organization(rights_holders_organization_id);


--
-- Name: users_authentication fk_users; Type: FK CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.users_authentication
    ADD CONSTRAINT fk_users FOREIGN KEY (users_id) REFERENCES music_model.users(users_id);


--
-- Name: users fk_usersrole; Type: FK CONSTRAINT; Schema: music_model; Owner: postgres
--

ALTER TABLE ONLY music_model.users
    ADD CONSTRAINT fk_usersrole FOREIGN KEY (users_role_id) REFERENCES music_model.users_role(users_role_id);


--
-- PostgreSQL database dump complete
--

