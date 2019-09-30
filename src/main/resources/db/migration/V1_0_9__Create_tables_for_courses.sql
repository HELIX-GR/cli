DROP TABLE IF EXISTS lab.course_file;
DROP SEQUENCE IF EXISTS lab.course_file_id_seq;

DROP TABLE IF EXISTS lab.course_student;
DROP SEQUENCE IF EXISTS lab.course_student_id_seq;

DROP TABLE IF EXISTS lab.course;
DROP SEQUENCE IF EXISTS lab.course_id_seq;

--
-- Course
--

CREATE SEQUENCE lab.course_id_seq INCREMENT 1 MINVALUE 1 START 1 CACHE 1;

CREATE TABLE lab.course
(
  id              integer                NOT NULL DEFAULT nextval('lab.course_id_seq'::regclass),
  "professor"     integer                NOT NULL,
  "title"         character varying      NOT NULL,
  "description"   character varying,
  "year"          integer                NOT NULL,
  "semester"      character varying(20)  NOT NULL,
  "created_on"    timestamp              NOT NULL DEFAULT now(),
  "updated_on"    timestamp              NOT NULL DEFAULT now(),
  "active"        boolean                NOT NULL,
  "deleted"       boolean                NOT NULL,

  CONSTRAINT pk_course PRIMARY KEY (id),
  CONSTRAINT fk_course_professor FOREIGN KEY ("professor")
      REFERENCES web.account (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE SET NULL
);

--
-- Course student
--

CREATE SEQUENCE lab.course_student_id_seq INCREMENT 1 MINVALUE 1 START 1 CACHE 1;

CREATE TABLE lab.course_student
(
  id                 	integer   NOT NULL DEFAULT nextval('lab.course_student_id_seq'::regclass),
  "course"           	integer   NOT NULL,
  "white_list"       	integer   NOT NULL,
  "created_on"       	timestamp NOT NULL DEFAULT now(),
  "last_file_copy_on"	timestamp,

  CONSTRAINT pk_course_student PRIMARY KEY (id),
  CONSTRAINT fk_course_student_course FOREIGN KEY ("course")
      REFERENCES lab.course (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE SET NULL,
CONSTRAINT fk_ccourse_student_white_list FOREIGN KEY ("white_list")
      REFERENCES lab.white_list (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE SET NULL
);

--
-- Course file
--

CREATE SEQUENCE lab.course_file_id_seq INCREMENT 1 MINVALUE 1 START 1 CACHE 1;

CREATE TABLE lab.course_file
(
  id             integer            NOT NULL DEFAULT nextval('lab.course_file_id_seq'::regclass),
  "course"       integer            NOT NULL,
  "path"         character varying  NOT NULL,
  "created_on"   timestamp          NOT NULL DEFAULT now(),

  CONSTRAINT pk_course_file PRIMARY KEY (id),
  CONSTRAINT fk_course_file_course FOREIGN KEY ("course")
      REFERENCES lab.course (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE SET NULL
);
