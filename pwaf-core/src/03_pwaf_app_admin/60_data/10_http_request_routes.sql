--
DELETE FROM pwaf_app_admin.http_request_routes WHERE path = '/pwaf_app_admin';
INSERT INTO pwaf_app_admin.http_request_routes (path,controller,require_valid_user) VALUES ('/pwaf_app_admin','pwaf_app_admin.pub_controller_main',True);

DELETE FROM pwaf_app_admin.http_request_routes WHERE path = '/pwaf_app_admin/editor';
INSERT INTO pwaf_app_admin.http_request_routes (path,controller,require_valid_user) VALUES ('/pwaf_app_admin/editor','pwaf_app_admin.pub_controller_editor',True);

DELETE FROM pwaf_app_admin.http_request_routes WHERE path = '/pwaf_app_admin/editor_post';
INSERT INTO pwaf_app_admin.http_request_routes (path,controller,require_valid_user) VALUES ('/pwaf_app_admin/editor_post','pwaf_app_admin.pub_controller_editor_post',True);

DELETE FROM pwaf_app_admin.http_request_routes WHERE path = '/pwaf_app_admin/editor2';
INSERT INTO pwaf_app_admin.http_request_routes (path,controller,require_valid_user) VALUES ('/pwaf_app_admin/editor2','pwaf_app_admin.pub_controller_editor2',True);
--


