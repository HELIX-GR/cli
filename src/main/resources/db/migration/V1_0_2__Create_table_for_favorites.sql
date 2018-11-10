--
-- Favorites
--

CREATE SEQUENCE web.favorite_id_seq INCREMENT 1 MINVALUE 1 START 1 CACHE 1;

CREATE TABLE web.favorite
(
  "id" integer NOT NULL DEFAULT nextval('web.favorite_id_seq'::regclass),
  "client_id" character varying(64) NULL,
  "email" character varying(64) NOT NULL,
  "catalog" character varying(20) NOT NULL,
  "handle" character varying NOT NULL,
  "url" character varying NULL,
  "created_on" timestamp DEFAULT now() NOT NULL,
  "title" character varying NOT NULL,
  "description" character varying NULL,
  CONSTRAINT pk_favorite PRIMARY KEY (id),
  CONSTRAINT uq_favorite_handle UNIQUE ("handle")
);