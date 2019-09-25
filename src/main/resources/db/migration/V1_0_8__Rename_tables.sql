--
-- Rename tables
--

ALTER TABLE IF EXISTS lab.account_white_list RENAME TO white_list;
ALTER TABLE IF EXISTS lab.account_role_white_list RENAME TO white_list_role;

ALTER TABLE IF EXISTS lab.hub_server_tags RENAME TO hub_server_tag;

ALTER TABLE IF EXISTS lab.account_to_server RENAME TO account_server;