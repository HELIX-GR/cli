CREATE SCHEMA IF NOT EXISTS "lab"; 

CREATE SEQUENCE lab.account_to_server_id_seq INCREMENT 1 MINVALUE 1 START 1 CACHE 1;

CREATE SEQUENCE lab.server_id_seq INCREMENT 1 MINVALUE 1 START 1 CACHE 1;

CREATE SEQUENCE lab.group_id_seq INCREMENT 1 MINVALUE 1 START 1 CACHE 1;

CREATE TABLE lab.hub_server (
    id integer NOT NULL DEFAULT nextval('lab.server_id_seq'::regclass),
    name character varying(100) NOT NULL,
    server_url character varying(200) NOT NULL,
    description character varying(100) NOT NULL,
    available boolean,
    admin_token character varying(255) NOT NULL,
    started_at timestamp without time zone DEFAULT now(),
    role_eligible character varying(64) NOT NULL,
    ram real NOT NULL,
    vcpu real NOT NULL,
    CONSTRAINT pk_hub_server PRIMARY KEY (id)
);

CREATE SEQUENCE lab.hub_server_tags_id_seq INCREMENT 1 MINVALUE 1 START 1 CACHE 1;

CREATE TABLE lab.hub_server_tags
(
  id integer NOT NULL DEFAULT nextval('lab.hub_server_tags_id_seq'::regclass),
  "tag" character varying(64) NOT NULL,
  "hub_server" integer NOT NULL,

  CONSTRAINT pk_hub_server_tags PRIMARY KEY (id),
  CONSTRAINT fk_hub_server_tags_hub_server FOREIGN KEY ("hub_server")
      REFERENCES lab.hub_server (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
); 

CREATE TABLE lab.account_to_server (
    id integer NOT NULL DEFAULT nextval('lab.account_to_server_id_seq'::regclass),
    name character varying(100) NOT NULL,
    account integer NOT NULL,
    server_id integer NOT NULL,
    server_url character varying(200) NOT NULL,
    started_at timestamp without time zone DEFAULT now(),
    state character varying(64) NOT NULL,
    CONSTRAINT pk_account_to_server PRIMARY KEY (id),
    CONSTRAINT fk_account_to_server_account FOREIGN KEY (account)
      REFERENCES web.account (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
    CONSTRAINT fk_account_to_server_server_id FOREIGN KEY (server_id)
      REFERENCES lab.hub_server (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT uq_account_to_server UNIQUE (account, server_id)
);

CREATE SEQUENCE lab.account_white_list_id_seq INCREMENT 1 MINVALUE 1 START 1 CACHE 1;

CREATE TABLE lab.account_white_list
(
  id integer NOT NULL DEFAULT nextval('lab.account_white_list_id_seq'::regclass),
  username character varying(100),
  email character varying(64) NOT NULL,
  registered_on timestamp without time zone DEFAULT now(),
  firstname character varying(40),
  lastname character varying(70),
  CONSTRAINT pk_account_white_list PRIMARY KEY (id),
  CONSTRAINT uq_account_email UNIQUE ("email")
);


CREATE SEQUENCE lab.account_role_white_list_id_seq INCREMENT 1 MINVALUE 1 START 1 CACHE 1;

CREATE TABLE lab.account_role_white_list
(
  id integer NOT NULL DEFAULT nextval('lab.account_role_white_list_id_seq'::regclass),
  "role" character varying(64) NOT NULL,
  "wl_account" integer NOT NULL,
  "granted_at" timestamp DEFAULT now(),
  "granted_by" integer,
  CONSTRAINT pk_account_role_white_list PRIMARY KEY (id),
  CONSTRAINT fk_account_role_white_list_account FOREIGN KEY ("wl_account")
      REFERENCES lab.account_white_list (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT fk_account_role_white_list_granted_by FOREIGN KEY ("granted_by")
      REFERENCES web.account (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT uq_account_role_white_list UNIQUE ("wl_account", "role")
); 
