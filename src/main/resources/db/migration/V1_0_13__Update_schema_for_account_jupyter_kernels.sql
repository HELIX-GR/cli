ALTER TABLE lab.account_server DROP COLUMN IF EXISTS hub_kernel;
ALTER TABLE lab.course DROP COLUMN IF EXISTS hub_kernel;

DROP TABLE IF EXISTS lab.white_list_hub_kernel;
DROP SEQUENCE IF EXISTS lab.white_list_hub_kernel_id_seq;

DROP TABLE IF EXISTS lab.account_hub_kernel;
DROP SEQUENCE IF EXISTS lab.account_hub_kernel_id_seq;

DROP TABLE IF EXISTS lab.hub_server_kernel;
DROP SEQUENCE IF EXISTS lab.hub_server_kernel_id_seq;

DROP TABLE IF EXISTS lab.hub_kernel;
DROP SEQUENCE IF EXISTS lab.hub_kernel_id_seq;

--
-- Add table for kernels
--

CREATE SEQUENCE lab.hub_kernel_id_seq INCREMENT 1 MINVALUE 1 START 1 CACHE 1;

CREATE TABLE lab.hub_kernel
(
  id              integer                NOT NULL DEFAULT nextval('lab.hub_kernel_id_seq'::regclass),
  "index"         integer                NOT NULL,
  "name"          character varying(40)  NOT NULL,
  "description"   character varying      NOT NULL,
  "tag"           character varying(40)  NOT NULL,
  "created_on"    timestamp              NOT NULL DEFAULT now(),
  "active"        boolean                NOT NULL,

  CONSTRAINT pk_hub_kernel PRIMARY KEY (id),
  CONSTRAINT uq_pk_hub_kernel_name UNIQUE (name)
);

--
-- Add table for hub supported kernels
--

CREATE SEQUENCE lab.hub_server_kernel_id_seq INCREMENT 1 MINVALUE 1 START 1 CACHE 1;

CREATE TABLE lab.hub_server_kernel
(
  id              integer                NOT NULL DEFAULT nextval('lab.hub_server_kernel_id_seq'::regclass),
  "hub_server"    integer                NOT NULL,
  "hub_kernel"    integer                NOT NULL,
  "created_on"    timestamp              NOT NULL DEFAULT now(),

  CONSTRAINT pk_hub_server_kernel PRIMARY KEY (id),
  CONSTRAINT fk_hub_server_kernel_hub FOREIGN KEY (hub_server)
      REFERENCES lab.hub_server (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT fk_hub_server_kernel_kernel FOREIGN KEY (hub_kernel)
      REFERENCES lab.hub_kernel (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT uq_pk_hub_server_hub_kernel UNIQUE (hub_server, hub_kernel)
);

--
-- Data initialization for kernels
--

insert into lab.hub_kernel ("index", name, tag, description, active) values
(2, 'obspy',        'Seismographic Data', 'Supports data analysis of seismographic data',                true),
(1, 'data-science', 'Data Science',       'Kernel for performing scientific data analysis using Python', true),
(3, 'dask',         'DASK',               'Supports data analysis using the Dask processing framework',  false),
(0, 'standard',     'Default',            'Default Python kernel',                                       true);

insert into lab.hub_server_kernel (hub_server, hub_kernel)
select      s.id, k.id
from        lab.hub_server s cross join lab.hub_kernel k
where       k.active = true;

--
-- Add field kernel to account server 
--

alter table lab.account_server add column hub_kernel integer;

--
-- Initialize kernel for existing servers
--

update lab.account_server set hub_kernel = (select id from lab.hub_kernel where name = 'standard');

--
-- Apply NOT NULL and foreign key constraint to new field
--

alter table lab.account_server alter column hub_kernel set NOT NULL;

alter table lab.account_server add constraint fk_account_server_hub_kernel FOREIGN KEY (hub_kernel)
   REFERENCES lab.hub_kernel (id) MATCH SIMPLE
   ON UPDATE NO ACTION ON DELETE NO ACTION;
   
--
-- Add account allowed kernels
--

CREATE SEQUENCE lab.account_hub_kernel_id_seq INCREMENT 1 MINVALUE 1 START 1 CACHE 1;

CREATE TABLE lab.account_hub_kernel
(
  id              integer                NOT NULL DEFAULT nextval('lab.account_hub_kernel_id_seq'::regclass),
  "account"       integer                NOT NULL,
  "hub_kernel"    integer                NOT NULL,
  "granted_by"    integer                NULL,
  "granted_at"    timestamp              NOT NULL DEFAULT now(),

  CONSTRAINT pk_account_hub_kernel PRIMARY KEY (id),
  CONSTRAINT fk_account_hub_kernel_account FOREIGN KEY (account)
      REFERENCES web.account (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT fk_account_hub_kernel_kernel FOREIGN KEY (hub_kernel)
      REFERENCES lab.hub_kernel (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT fk_account_hub_kernel_granted_by FOREIGN KEY (granted_by)
      REFERENCES web.account (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE SET NULL,
  CONSTRAINT uq_pk_account_hub_kernel_account_hub_kernel UNIQUE (account, hub_kernel)
);

--
-- Initialize account kernels
--

insert into lab.account_hub_kernel (account, hub_kernel)
select      a.id, k.id
from        web.account a cross join lab.hub_kernel k
where       k.active = true and name  = 'standard';


--
-- White-list account allowed kernels
--

CREATE SEQUENCE lab.white_list_hub_kernel_id_seq INCREMENT 1 MINVALUE 1 START 1 CACHE 1;

CREATE TABLE lab.white_list_hub_kernel
(
  id              integer                NOT NULL DEFAULT nextval('lab.white_list_hub_kernel_id_seq'::regclass),
  "white_list"    integer                NOT NULL,
  "hub_kernel"    integer                NOT NULL,
  "granted_by"    integer                NULL,
  "granted_at"    timestamp              NOT NULL DEFAULT now(),

  CONSTRAINT pk_white_list_hub_kernel PRIMARY KEY (id),
  CONSTRAINT fk_white_list_hub_kernel_white_list FOREIGN KEY (white_list)
      REFERENCES lab.white_list (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT fk_white_list_hub_kernel_hub_kernel FOREIGN KEY (hub_kernel)
      REFERENCES lab.hub_kernel (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT fk_white_list_hub_kernel_granted_by FOREIGN KEY (granted_by)
      REFERENCES web.account (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT uq_pk_white_list_hub_kernel UNIQUE (white_list, hub_kernel)
);

--
-- Initialize kernel for white list entries
--

insert into lab.white_list_hub_kernel (white_list, hub_kernel)
select      wl.id, k.id
from        lab.white_list wl cross join lab.hub_kernel k
where       k.active = true and name  = 'standard';

--
-- Add field kernel to course 
--

alter table lab.course add column hub_kernel integer;

--
-- Initialize kernel for existing courses to the 'standard' kernel
--

update lab.course set hub_kernel = (select id from lab.hub_kernel where name = 'standard');

--
-- Apply NOT NULL and foreign key contraint constraint to new field
--

alter table lab.course alter column hub_kernel set NOT NULL;

alter table lab.course add constraint  fk_course_hub_kernel FOREIGN KEY (hub_kernel)
   REFERENCES lab.hub_kernel (id) MATCH SIMPLE
   ON UPDATE NO ACTION ON DELETE NO ACTION;
