# php-fpm 工作进程配置详解

```ini
[www]
;FPM 子进程运行的Unix用户，必须设置
user = nobody
;FPM 子进程运行的Unix用户组，必须设置。
group = nogroup

;默认是以 TCP 端口监听的
;listen = 127.0.0.1:9000
;我们修改成为，在unix套接字上监听
listen = /server/run/php73-fpm.sock
listen.backlog = 511
listen.owner = nginx
listen.group = nginx
listen.mode = 0660
listen.allowed_clients = 127.0.0.1

;设置进程管理器以 static 管理子进程。
pm = static
;开启 100 个子进程
pm.max_children = 100
;每个进程处理 500 个请求后自动重启
pm.max_requests = 500

;设置进程管理器以 dynamic 管理子进程。
;pm = dynamic
;最多开启 300 个子进程
;pm.max_children = 300
;启动时自动开机30个子进程
;pm.start_servers = 30
;最小空闲子进程是20个
;pm.min_spare_servers = 20
;最大空闲子进程是50个
;pm.max_spare_servers = 50
;每个进程处理 500 个请求后自动重启
;pm.max_requests = 500
```
