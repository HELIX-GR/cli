ALTER TABLE lab.course_student ADD CONSTRAINT uq_pk_course_white_list UNIQUE(course, white_list);
ALTER TABLE lab.course_file ADD CONSTRAINT uq_pk_course_path UNIQUE(course, path);
