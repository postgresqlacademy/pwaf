# PWAF Key Things
## Schema: pwaf

### Three kinds of UI

* Pure HTML (with t__ lib to help)
* XSLT with views system
* REST API + JS frontend

### Esential layers

```

-----------------------------
|  UI  |  URLs  |  API      |
-----------------------------
|          Web app          |
-----------------------------


```


### Core Logic

| View             | Comment |
| ---------------- | ------- |
| `v_applications` |         |

### Routing

| Domain                      | Comment |
| --------------------------- | ------- |
| `http_response_status_code` |         |
| `html`                      |         |

| Type                         | Comment |
| ---------------------------- | ------- |
| `http_request`               |         |
| `http_request_method`        |         |
| `http_request_route`         |         |
| `http_response`              |         |
| `http_response_content_type` |         |

| Function                            | Comment |
| ----------------------------------- | ------- |
| `pub_http_request_handle`           |         |
| `pub_http_request_param_get`        |         |
| `pub_http_request_system_param_get` |         |
| `sys_controller_default`            |         |
| `sys_http_request_route`            |         |

| Table                 | Comment |
| --------------------- | ------- |
| `http_request_routes` |         |

### Assets

| Function               | Comment |
| ---------------------- | ------- |
| `pub_controller_asset` |         |

| Table    | Comment |
| -------- | ------- |
| `assets` |         |

### Security & session management

| Type           | Comment |
| -------------- | :------ |
| `user_details` |         |
| `user_info`    |         |



| Function                                 | Comment                                  |
| ---------------------------------------- | ---------------------------------------- |
| `pub_controller_security_login`          |                                          |
| `pub_controller_security_logout`         |                                          |
| `pub_controller_auth_security_oauth2_auth` |                                          |
| `pub_controller_auth_security_oauth2_token` |                                          |
| `sys_session_init`                       |                                          |
| `pub_auth_user_create`                   | `SELECT pwaf.pub_auth_user_create('username','pass');` |
| `pub_auth_security_oauth2_token_generate` |                                          |
| `pub_auth_security_user_credentials_validate` |                                          |

| Table           | Comment |
| --------------- | ------- |
| `auth_sessions` |         |
| `auth_types`    |         |
| `auth_users`    |         |

### HTML content: XSLT based

| Type                                     | Comment |
| ---------------------------------------- | ------- |
| `gui_views_layout_block_override_action` |         |

| Function                   | Comment |
| -------------------------- | ------- |
| `pub_html_render`          |         |
| `pub_view_render`          |         |
| `sys_gui_templates_export` |         |

| View                       | Comment |
| -------------------------- | ------- |
| `v_gui_views`              |         |
| `v_gui_views_layout_block` |         |

| Table                             | Comment |
| --------------------------------- | ------- |
| `gui_blocks`                      |         |
| `gui_layouts`                     |         |
| `gui_layouts_blocks`              |         |
| `gui_templates`                   |         |
| `gui_views`                       |         |
| `gui_views_layout_block_override` |         |

### HTML content: Easy templates

| Function                       | Comment |
| ------------------------------ | ------- |
| `t__`                          |         |
| `t_dropdown_with_autoredirect` |         |
| `t_wrapper`                    |         |

### API / REST

| Function                          | Comment |
| --------------------------------- | ------- |
| `pub_controller_api_rest_default` |         |
| ...                               |         |
| ...                               |         |

| Table                       | Comment |
| --------------------------- | ------- |
| `api_rest_endpoint_routes ` |         |

### Utils

| Domain      | Comment |
| ----------- | ------- |
| `g_serial`  |         |
| `code`      |         |
| `sql_query` |         |

| Type        | Comment |
| ----------- | ------- |
| `log_level` |         |

| Function                        | Comment          |
| ------------------------------- | ---------------- |
| `pub_util_tojson`               |                  |
| `sys_random_string`             | **to deprecate** |
| `random_string`                 | **to deprecate** |
| `pub_util_json_object_set_key`  |                  |
| `pub_util_json_object_set_path` |                  |
| `pub_util_random_string`        |                  |

| Table | Comment |
| ----- | ------- |
| `log` |         |


## Schema: pwaf_app_admin


## Schema: pwaf_app_base

## Schema: pwaf_extensions

## Schema: pwaf_web



#pwaf

