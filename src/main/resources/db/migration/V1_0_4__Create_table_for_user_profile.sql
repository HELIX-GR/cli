--
-- Profile
--

DROP TABLE IF EXISTS web.account_profile;

DROP SEQUENCE IF EXISTS web.account_profile_id_seq;

CREATE SEQUENCE web.account_profile_id_seq INCREMENT 1 MINVALUE 1 START 1 CACHE 1;

CREATE TABLE web.account_profile
(
  id                integer NOT NULL DEFAULT nextval('web.account_profile_id_seq'::regclass),
  "account"         integer,
  "private_email"   character varying(64) NOT NULL,
  "public_email"    character varying(64) NOT NULL,
  "name"          character varying,
  "resume"          character varying,
  "url"             character varying,
  "company"         character varying,
  "location"        character varying,
  "image_binary"    bytea,
  "image_mime_type" character varying(30),
  "created_on"      timestamp DEFAULT now(),
  "modified_on"     timestamp DEFAULT now(),
  CONSTRAINT pk_account_profile PRIMARY KEY (id),
  CONSTRAINT uq_pk_account_profile_email UNIQUE ("private_email"),
  CONSTRAINT fk_account_profile_account FOREIGN KEY ("account")
      REFERENCES web.account (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE SET NULL
);
