-- Create schema for objects specific to helix-core web application
CREATE SCHEMA IF NOT EXISTS "web"; 

--
-- Application Keys
--

CREATE TABLE web.application_key
(
  client_id character varying(64) NOT NULL,
  description character varying(256) NULL,
  api_key character varying(256) NOT NULL,
  created_on timestamp DEFAULT now(),
  revoked boolean DEFAULT false,
  CONSTRAINT pk_application_key PRIMARY KEY (client_id)
);
