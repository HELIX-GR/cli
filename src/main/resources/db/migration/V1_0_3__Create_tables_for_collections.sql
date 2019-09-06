--
-- Favorite collections
--

DROP TABLE IF EXISTS web.favorite_collection_item;
DROP TABLE IF EXISTS web.favorite_collection;

DROP SEQUENCE IF EXISTS web.favorite_collection_item_id_seq;
DROP SEQUENCE IF EXISTS web.favorite_collection_id_seq;

CREATE SEQUENCE web.favorite_collection_id_seq INCREMENT 1 MINVALUE 1 START 1 CACHE 1;
CREATE SEQUENCE web.favorite_collection_item_id_seq INCREMENT 1 MINVALUE 1 START 1 CACHE 1;

CREATE TABLE web.favorite_collection
(
  "id"         integer NOT NULL DEFAULT nextval('web.favorite_collection_id_seq'::regclass),
  "email"      character varying(64) NOT NULL,
  "created_on" timestamp DEFAULT now() NOT NULL,
  "updated_on" timestamp DEFAULT now() NOT NULL,
  "title"      character varying NOT NULL,
  "data_count" integer NOT NULL DEFAULT 0,
  "pubs_count" integer NOT NULL DEFAULT 0,
  "lab_count"  integer NOT NULL DEFAULT 0,
  CONSTRAINT pk_favorite_collection PRIMARY KEY (id),
  CONSTRAINT uq_favorite_collection_email_title UNIQUE ("email", "title")
);

CREATE TABLE web.favorite_collection_item
(
  "id"         integer NOT NULL DEFAULT nextval('web.favorite_collection_item_id_seq'::regclass),
  "collection" integer NOT NULL,
  "favorite"   integer NOT NULL,
  "created_on" timestamp DEFAULT now() NOT NULL,
  CONSTRAINT pk_favorite_collection_item PRIMARY KEY (id),
  CONSTRAINT fk_favorite_collection_item_collection FOREIGN KEY ("collection")
      REFERENCES web.favorite_collection (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT fk_favorite_collection_item_favorite FOREIGN KEY ("favorite")
      REFERENCES web.favorite (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);
