

---
DELETE FROM pwaf_app_demobox.data_item_type;
INSERT INTO pwaf_app_demobox.data_item_type(name) VALUES ('Food');
INSERT INTO pwaf_app_demobox.data_item_type(name) VALUES ('Stationery');
--------
DELETE FROM pwaf_app_demobox.data_room;
INSERT INTO pwaf_app_demobox.data_room(name, location) VALUES ('Room 1', 'Basement');
INSERT INTO pwaf_app_demobox.data_room(name, location) VALUES ('Room 2', 'Garage');
INSERT INTO pwaf_app_demobox.data_room(name, location) VALUES ('Room 3', 'Shed');
--------
DELETE FROM pwaf_app_demobox.data_box;
INSERT INTO pwaf_app_demobox.data_box(name, room) SELECT 'Box 1', id FROM pwaf_app_demobox.data_room WHERE name = 'Room 1';
INSERT INTO pwaf_app_demobox.data_box(name, room) SELECT 'Box 2', id FROM pwaf_app_demobox.data_room WHERE name = 'Room 1';
--------
DELETE FROM pwaf_app_demobox.data_item;
INSERT INTO pwaf_app_demobox.data_item(name, box_id, type_id)
WITH
  t1 AS (
    SELECT id FROM pwaf_app_demobox.data_box WHERE name = 'Box 1'
  ),
  t2 AS (
    SELECT id FROM pwaf_app_demobox.data_item_type WHERE name = 'Food'
  )
  select 'Apple', t1.id, t2.id
  from t1,t2;
INSERT INTO pwaf_app_demobox.data_item(name, box_id, type_id)
WITH
  t1 AS (
    SELECT id FROM pwaf_app_demobox.data_box WHERE name = 'Box 1'
  ),
  t2 AS (
    SELECT id FROM pwaf_app_demobox.data_item_type WHERE name = 'Food'
  )
  select 'Banana', t1.id, t2.id
  from t1,t2;
----------
DELETE FROM pwaf_app_demobox.api_rest_endpoint_routes;
INSERT INTO pwaf_app_demobox.api_rest_endpoint_routes 
(path,controller,rest_resource_name,supported_methods,default_data_endpoint,custom_ordering) 
VALUES
('/pwaf_demobox/api/v1/room','pwaf.pub_controller_api_rest_default','room','{GET,POST,DELETE,PUT,PATCH}','pwaf_app_demobox.data_room','id DESC'),
('/pwaf_demobox/api/v1/box','pwaf.pub_controller_api_rest_default','box','{GET,POST,DELETE,PUT,PATCH}','pwaf_app_demobox.data_box','id DESC');

----------




