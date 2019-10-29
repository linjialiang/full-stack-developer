# mariadb 配置文件

此 wamp 下的 mariadb 配置文件位于: `c:\wamp\base\mariadb\my.ini`

> my.ini 内容如下：

```ini
[client]
port = 3306
plugin-dir=c:/wamp/base/mariadb/lib/plugin

[mysqld]
port = 3306
datadir = "c:/wamp/web/data"
log_error=c:/wamp/web/logs/mariadb/err.log
log_warnings=9
log_bin=c:/wamp/web/logs/mariadb/bin-log
log_bin_index=c:/wamp/web/logs/mariadb/bin-log.index
expire_logs_days=30
server_id=2
binlog_format=MIXED
```
