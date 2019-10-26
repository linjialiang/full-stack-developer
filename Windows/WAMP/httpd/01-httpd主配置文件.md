# httpd 主配置文件源码

| 文件名 | httpd.conf                           |
| ------ | ------------------------------------ |
| 路径   | `C:/wamp/base/httpd/conf/httpd.conf` |

> 源码：

```conf
Define WAMP_ROOT "c:/wamp"
Define SRVROOT "${WAMP_ROOT}/base/httpd"
Define HTDOCS "${WAMP_ROOT}/web/www"
Define HTLOGS "${WAMP_ROOT}/web/logs/httpd"
Define HTTP_PORT "80"
Define HTTPS_PORT "443"

ServerRoot "${SRVROOT}"

Listen ${HTTP_PORT}

LoadModule actions_module modules/mod_actions.so
LoadModule alias_module modules/mod_alias.so
LoadModule allowmethods_module modules/mod_allowmethods.so
LoadModule asis_module modules/mod_asis.so
LoadModule auth_basic_module modules/mod_auth_basic.so
LoadModule authn_core_module modules/mod_authn_core.so
LoadModule authn_file_module modules/mod_authn_file.so
LoadModule authz_core_module modules/mod_authz_core.so
LoadModule authz_groupfile_module modules/mod_authz_groupfile.so
LoadModule authz_host_module modules/mod_authz_host.so
LoadModule authz_user_module modules/mod_authz_user.so
LoadModule autoindex_module modules/mod_autoindex.so
LoadModule cgi_module modules/mod_cgi.so
LoadModule dir_module modules/mod_dir.so
LoadModule env_module modules/mod_env.so
LoadModule include_module modules/mod_include.so
LoadModule isapi_module modules/mod_isapi.so
LoadModule log_config_module modules/mod_log_config.so
LoadModule mime_module modules/mod_mime.so
LoadModule negotiation_module modules/mod_negotiation.so
LoadModule setenvif_module modules/mod_setenvif.so

<IfModule include_module>
    Include "${WAMP_ROOT}/base/conf/httpd.conf"
</IfModule>
```
