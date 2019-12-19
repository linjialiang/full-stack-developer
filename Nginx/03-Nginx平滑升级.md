# Nginx 平滑升级

nginx 支持在不影响客户端正常访问的情况下，升级 nginx 版本，下面我们就来具体操作下：

## 准备工作

在升级 Nginx 前，我们需要作如下准备：

| 准备工作                  | 描述                                                                   |
| ------------------------- | ---------------------------------------------------------------------- |
| 备份旧版 Nginx 可执行文件 | 如果升级出了状况，我们可以回滚到就版本                                 |
| 旧版 Nginx 的构建选项     | `nginx -V` 通常新版与旧版的构建选项一致即可                            |
| 下载 Nginx 新版本         | [`nginx-1.16.1.tar.gz`](http://nginx.org/download/nginx-1.16.1.tar.gz) |

### 几点注意事项：

| 序号 | 详细说明                                                                |
| ---- | ----------------------------------------------------------------------- |
| 01   | 新版的构建选项与旧版基本保持一致，部分路径需要重新指定                  |
| 02   | 平滑升级，要求新版本处理到编译（make -j4），就停止                      |
| 03   | 平滑升级，切记不能安装新版本的编译内容（make install）,否则配置会被覆盖 |

### 准备工作具体内容

1. 备份旧版 Nginx 可执行文件

   由于在 lnmp 说明书中我们将 Nginx 升级了到最新开发板 `1.17.6`，这里就准备将其降级最新稳定版

   ```sehll
   $ mv /server/nginx/sbin/nginx{,-v1.17.6}
   ```

   > 提示：`/server/nginx/sbin/nginx` 可执行文件在启动后，重命名该文件，并不影响已经运行的 nginx 程序！

2. 查看旧版 Nginx 的构建选项

   ```sh
   $ /server/nginx/sbin/nginx -V
   nginx version: nginx/1.17.6
   built by gcc 8.3.0 (Debian 8.3.0-6)
   built with OpenSSL 1.1.1d  10 Sep 2019
   TLS SNI support enabled
   configure arguments: --prefix=/server/nginx --builddir=/package/lnmp/nginx-1.17.6/nginx_bulid --with-threads --with-file-aio --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_image_filter_module --with-http_geoip_module --with-http_dav_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_secure_link_module --with-http_degradation_module --with-http_slice_module --with-http_stub_status_module --without-http_ssi_module --without-http_uwsgi_module --without-http_scgi_module --without-http_grpc_module --with-pcre=/package/lnmp/pcre-8.43 --with-pcre-jit --with-zlib=/package/lnmp/zlib-1.2.11 --with-openssl=/package/lnmp/openssl-1.1.1d --with-debug
   ```

   > 提示：以下选项需要指定路径：

   | 选项            | 正确路径                               |
   | --------------- | -------------------------------------- |
   | --prefix=       | 通常与旧版一致即可                     |
   | --builddir=     | /package/lnmp/nginx-1.16.1/nginx_bulid |
   | --with-pcre=    | 如果有更新，指定到最新版根路径         |
   | --with-zlib=    | 如果有更新，指定到最新版根路径         |
   | --with-openssl= | 如果有更新，指定到最新版根路径         |

3. 下载并解压新版 Nginx

   ```sh
   $ cd /package/lnmp/
   $ wget http://nginx.org/download/nginx-1.16.1.tar.gz
   $ tar -xzvf nginx-1.16.1.tar.gz
   ```

## 编译新版本

平滑升级要求 `只编译，不安装` ，下面是具体操作：

```sh
$ mkdir /package/lnmp/nginx-1.16.1/nginx_bulid
$ cd /package/lnmp/nginx-1.16.1
```

1. 新版 Nginx 构建选项：

   第一次安装还没确定日志与 pid 文件的路径，所以采用默认安装，此次升级可以直接指定日志和 pid 文件路径了！

   ```sh
   ./configure --prefix=/server/nginx \
   --builddir=/package/lnmp/nginx-1.16.1/nginx_bulid \
   --error-log-path=/server/logs/nginx_error/error.log \
   --pid-path=/server/run/nginx/nginx.pid \
   --http-log-path=/server/logs/nginx_access/access.log \
   --with-threads \
   --with-file-aio \
   --with-http_ssl_module \
   --with-http_v2_module \
   --with-http_realip_module \
   --with-http_image_filter_module \
   --with-http_geoip_module \
   --with-http_dav_module \
   --with-http_gunzip_module \
   --with-http_gzip_static_module \
   --with-http_auth_request_module \
   --with-http_secure_link_module \
   --with-http_degradation_module \
   --with-http_slice_module \
   --with-http_stub_status_module \
   --without-http_ssi_module \
   --without-http_uwsgi_module \
   --without-http_scgi_module \
   --without-http_grpc_module \
   --with-mail \
   --with-mail_ssl_module \
   --with-stream \
   --with-stream_ssl_module \
   --with-stream_realip_module \
   --with-stream_geoip_module \
   --with-stream_ssl_preread_module \
   --with-pcre=/package/lnmp/pcre-8.43 \
   --with-pcre-jit \
   --with-zlib=/package/lnmp/zlib-1.2.11 \
   --with-openssl=/package/lnmp/openssl-1.1.1d \
   --with-debug
   ```

   > 提示：其中有两个模块通常可以不用编译：

   | 模块                   | 模块说明                                 | 编译指令      |
   | ---------------------- | ---------------------------------------- | ------------- |
   | ngx_mail_core_module   | 邮件代理服务                             | --with-mail   |
   | ngx_stream_core_module | 实现 TCP/UDP 网络层的 `代理以及负载均衡` | --with-stream |

   > 可以移除的部分构建选项：

   ```sh
   --with-mail \
   --with-mail_ssl_module \
   --with-stream \
   --with-stream_ssl_module \
   --with-stream_realip_module \
   --with-stream_geoip_module \
   --with-stream_ssl_preread_module \
   ```

   > 本次增加了 3 条构建选项：

   ```sh
   --error-log-path=/server/logs/nginx_error/error.log \
   --pid-path=/server/run/nginx/nginx.pid \
   --http-log-path=/server/logs/nginx_access/access.log \
   ```

2. 编译新版 Nginx

   ```sh
   $ make -j4
   ```

## 平滑升级 Nginx 版本

将刚刚编译后产生的文件，拷贝到 `/server/nginx/sbin` 下：

```sh
$ cp -p -r /package/lnmp/nginx-1.16.1/nginx_bulid/nginx /server/nginx/sbin/
```

### 查看当前的 Nginx 版本

```sh
$ /server/nginx/sbin/nginx -V
nginx version: nginx/1.16.1
built by gcc 8.3.0 (Debian 8.3.0-6)
built with OpenSSL 1.1.1d  10 Sep 2019
TLS SNI support enabled
configure arguments: --prefix=/server/nginx --builddir=/package/lnmp/nginx-1.16.1/nginx_bulid --error-log-path=/server/logs/nginx_error/error.log --pid-path=/server/run/nginx/nginx.pid --http-log-path=/server/logs/nginx_access/access.log --with-threads --with-file-aio --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_image_filter_module --with-http_geoip_module --with-http_dav_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_secure_link_module --with-http_degradation_module --with-http_slice_module --with-http_stub_status_module --without-http_ssi_module --without-http_uwsgi_module --without-http_scgi_module --without-http_grpc_module --with-mail --with-mail_ssl_module --with-stream --with-stream_ssl_module --with-stream_realip_module --with-stream_geoip_module --with-stream_ssl_preread_module --with-pcre=/package/lnmp/pcre-8.43 --with-pcre-jit --with-zlib=/package/lnmp/zlib-1.2.11 --with-openssl=/package/lnmp/openssl-1.1.1d --with-debug
```

### 修改配置文件

由于本次构建，加入了日志文件和 pid 路径，所以 `nginx.conf` 下 pid 和日志的路径配置可以移除！

### 平滑升级可执行文件

1. 使用 ps 查看旧版 Nginx 的主进程 id：

   ```sh
   $ ps -ef|grep nginx
   root      3442     1  0 12月18 ?      00:00:00 nginx: master process /server/nginx/sbin/nginx
   nginx     3443  3442  0 12月18 ?      00:00:00 nginx: worker process
   nginx     3444  3442  0 12月18 ?      00:00:00 nginx: worker process
   nginx     3445  3442  0 12月18 ?      00:00:00 nginx: worker process
   nginx     3446  3442  0 12月18 ?      00:00:00 nginx: worker process
   root     10745  3943  0 10:17 pts/0    00:00:00 grep nginx
   root     20623  3442  0 09:14 ?        00:00:00 nginx: master process /server/nginx/sbin/nginx
   nginx    20624 20623  0 09:14 ?        00:00:00 nginx: worker process
   nginx    20625 20623  0 09:14 ?        00:00:00 nginx: worker process
   nginx    20626 20623  0 09:14 ?        00:00:00 nginx: worker process
   nginx    20627 20623  0 09:14 ?        00:00:00 nginx: worker process
   ```

   > 由于 lnmp 升级 nginx 时没有处理，现在就变成 2 个了：

2. 使用 `cat` 指令来查看，当前 `nginx.pid` 值

   ```sh
   $ cat /server/run/nginx/nginx.pid
   20623
   ```

   > 提示：由此判定，3442 是 lnmp 升级 nginx 时遗留的主进程

3. 使用 `kill -WINCH <pid>` 正常关闭遗留的 Nginx 的进程

   ```sh
   $ kill -WINCH 3442
   ```

4. 使用 kill -USR2 <pid> 来平滑升级 Nginx 可执行文件

   ```sh
   $ kill -USR2 `cat /server/run/nginx/nginx.pid`
   ```

5. 使用 `kill -WINCH <pid>` 正常关闭旧版的 Nginx 的进程

   ```sh
   $ kill -WINCH 20624
   ```

## 信号控制平滑升级全解

### Nginx 进程信号支持的 Linux 信号

1. Nginx 主进程（master）支持的 kill 信号：

   | 信号      | 描述                                                                             |
   | --------- | -------------------------------------------------------------------------------- |
   | TERM, INT | 快速关机                                                                         |
   | QUIT      | 优雅的关机                                                                       |
   | HUP       | 更改配置，跟上更改的时区，使用新配置启动新的 worker 进程，正常关闭旧 worker 进程 |
   | USR1      | 重新打开日志文件                                                                 |
   | USR2      | 升级可执行文件                                                                   |
   | WINCH     | 正常关闭 Nginx 主进程                                                            |

2. Nginx 工作进程（worker）支持的 kill 信号：

   | 信号      | 描述                 |
   | --------- | -------------------- |
   | TERM, INT | 快速关机             |
   | QUIT      | 优雅的关机           |
   | USR1      | 重新打开日志文件     |
   | WINCH     | 正常关闭 worker 进程 |

3. 案例：升级 Nginx 可执行文件

   ```sh
   $ kill -USR2 `cat /server/run/nginx/nginx.pid`
   ```

### 升级可执行文件

> 使用 `kill -USR2 <pid>` 来升级 Nginx 可执行文件

1. 直接使用 cat 读取 nginx.pid 的值

   ```sh
   $ kill -USR2 `cat /server/nginx/logs/nginx.pid`
   ```

2. 使用 ps 查看 Nginx 的主进程 id：

   ```sh
   $ ps -ef|grep nginx
   root      4337     1  0 14:12 ?        00:00:00 nginx: master process /server/nginx/sbin/nginx
   nobody    4338  4337  0 14:12 ?        00:00:00 nginx: worker process
   root     21404   622  0 15:54 pts/0    00:00:00 grep nginx
   $ kill -USR2 4337
   ```

3. 升级可执行文件后的效果：

   > 发下现在有两个 Nginx 主进程，旧版 Nginx 主进程依然还在：

   ```sh
   $ ps -ef|grep nginx
   root      4337     1  0 14:12 ?        00:00:00 nginx: master process /server/nginx/sbin/nginx
   nobody    4338  4337  0 14:12 ?        00:00:00 nginx: worker process
   root     21409  4337  0 16:05 ?        00:00:00 nginx: master process /server/nginx/sbin/nginx
   nobody   21410 21409  0 16:05 ?        00:00:00 nginx: worker process
   root     21412   622  0 16:05 pts/0    00:00:00 grep nginx
   ```

   > 查看下 nginx.pid 下记录的 pid 值：

   ```sh
   $ cat /server/nginx/logs/nginx.pid
   21409
   ```

   > 这里可以清晰的告诉我们，主进程的 pid 已经是新版 Nginx 的了

### 关闭旧的主进程

> 使用 `kill -WINCH <pid>` 来正常关闭旧版 Nginx 的主进程

```sh
$ kill -WINCH 4337
```
