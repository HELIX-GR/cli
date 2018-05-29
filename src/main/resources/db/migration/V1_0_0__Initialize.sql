
-- Create schema for objects specific to helix-core web application
CREATE SCHEMA IF NOT EXISTS "web"; 

--
-- Account
--

CREATE SEQUENCE web.account_id_seq INCREMENT 1 MINVALUE 1 START 1 CACHE 1;

CREATE TABLE web.account
(
  id integer NOT NULL DEFAULT nextval('web.account_id_seq'::regclass),
  "username" character varying(32) NOT NULL,
  "active" boolean,
  "blocked" boolean,
  "email" character varying(64) NOT NULL,
  "family_name" character varying(64),
  "given_name" character varying(64),
  "lang" character varying(2),
  "password" character varying(64),
  "registered_at" timestamp DEFAULT now(),
  CONSTRAINT pk_account PRIMARY KEY (id),
  CONSTRAINT uq_account_email UNIQUE ("email"),
  CONSTRAINT uq_account_username UNIQUE ("username")
);

CREATE INDEX idx_account_username ON web.account USING btree (username COLLATE pg_catalog."default");

--
-- Role
--

CREATE SEQUENCE web.account_role_id_seq INCREMENT 1 MINVALUE 1 START 1 CACHE 1;

CREATE TABLE web.account_role
(
  id integer NOT NULL DEFAULT nextval('web.account_role_id_seq'::regclass),
  "role" character varying(64) NOT NULL,
  "account" integer NOT NULL,
  "granted_at" timestamp DEFAULT now(),
  "granted_by" integer,
  CONSTRAINT pk_account_role PRIMARY KEY (id),
  CONSTRAINT fk_account_role_account FOREIGN KEY ("account")
      REFERENCES web.account (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT fk_account_role_granted_by FOREIGN KEY ("granted_by")
      REFERENCES web.account (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT uq_account_role UNIQUE ("account", "role")
); 

--
-- Event
--

CREATE SEQUENCE web.log4j_message_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 128;

CREATE TABLE web.log4j_message
(
  "id" bigint PRIMARY KEY DEFAULT nextval('web.log4j_message_id_seq'::regclass) NOT NULL,
  "application" character varying(64) NOT NULL,
  "generated" timestamp without time zone,
  "level" character varying(12),
  "message" text,
  "throwable" text,
  "logger" character varying(256),
  "client_address" character varying(16),
  "username" character varying(64)
);

--
-- Session
--

CREATE TABLE web.spring_session (
  session_id character(36) NOT NULL,
  creation_time bigint NOT NULL,
  last_access_time bigint NOT NULL,
  max_inactive_interval integer NOT NULL,
  principal_name character varying(100),
  CONSTRAINT pk_spring_session PRIMARY KEY (session_id)
);

CREATE INDEX idx_spring_session 
    ON web.spring_session USING btree(last_access_time);

CREATE TABLE web.spring_session_attributes
(
  session_id character(36) NOT NULL,
  attribute_name character varying(200) NOT NULL,
  attribute_bytes bytea NOT NULL,
  CONSTRAINT pk_spring_session_attributes PRIMARY KEY (session_id, attribute_name),
  CONSTRAINT fk_spring_session_attributes FOREIGN KEY (session_id) REFERENCES web.spring_session (session_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);

CREATE INDEX idx_spring_session_attributes 
    ON web.spring_session_attributes USING btree(session_id);

