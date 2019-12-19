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

为此我专门将 Nginx 升级了到最新的开发版本 `1.17.6`，这里将其降级到最新稳定版 `1.16.1`

1. 备份旧版 Nginx 主执行文件

   只要保证在拷贝新版 Nginx 主执行文件之前，对其重命名即可，具体如下：

   ```sehll
   $ mv /server/nginx/sbin/nginx{,-v1.17.6}
   ```

   > 提示：Nginx 主执行文件在启动后，对其进行重命名并不影响 Nginx 的正常运作！

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
   root     13080  3943  0 12:02 pts/0    00:00:00 grep nginx
   root     28576     1  0 11:56 ?        00:00:00 nginx: master process /server/nginx/sbin/nginx
   nginx    28577 28576  0 11:56 ?        00:00:00 nginx: worker process
   nginx    28578 28576  0 11:56 ?        00:00:00 nginx: worker process
   nginx    28579 28576  0 11:56 ?        00:00:00 nginx: worker process
   nginx    28580 28576  0 11:56 ?        00:00:00 nginx: worker process
   ```

   > 使用 `cat` 指令来查看，当前 `nginx.pid` 值（旧版 pid 值）：

   ```sh
   $ cat /server/run/nginx/nginx.pid
   28576
   ```

2. 平滑升级 Nginx 进程

   > 使用 `kill -USR2 <pid>` 升级 Nginx 可执行文件

   ```sh
   $ kill -USR2 `cat /server/run/nginx/nginx.pid`
   ```

   > 使用 `cat` 指令来查看，当前 `nginx.pid` 值（新版 pid 值）：

   ```sh
   $ cat /server/run/nginx/nginx.pid
   13170
   ```

3. 使用 ps 查看当前 Nginx 的进程 id：

   ```sh
   root     13170 28576  0 12:04 ?        00:00:00 nginx: master process /server/nginx/sbin/nginx
   nginx    13171 13170  0 12:04 ?        00:00:00 nginx: worker process
   nginx    13172 13170  0 12:04 ?        00:00:00 nginx: worker process
   nginx    13173 13170  0 12:04 ?        00:00:00 nginx: worker process
   nginx    13174 13170  0 12:04 ?        00:00:00 nginx: worker process
   root     13177  3943  0 12:04 pts/0    00:00:00 grep nginx
   root     28576     1  0 11:56 ?        00:00:00 nginx: master process /server/nginx/sbin/nginx
   nginx    28577 28576  0 11:56 ?        00:00:00 nginx: worker process
   nginx    28578 28576  0 11:56 ?        00:00:00 nginx: worker process
   nginx    28579 28576  0 11:56 ?        00:00:00 nginx: worker process
   nginx    28580 28576  0 11:56 ?        00:00:00 nginx: worker process
   ```

   > 当前信息说明了平滑升级成功：

   | 序号 | 信息说明                                                     |
   | ---- | ------------------------------------------------------------ |
   | 01   | Nginx 新版进程与旧版进程同时运行                             |
   | 02   | Nginx 新版主进程是旧版主进程的一个子进程                     |
   | 03   | 旧版进程依然运行着，表示之前浏览页面的客户端页面响应没有丢失 |

4. 平滑关闭旧版 Nginx 主进程

   > 使用 `kill -WINCH <pid>` 指令实现：当进程没有访问者时，系统自动关闭当前进程

   ```sh
   $ kill -WINCH 28576
   ```

## 附录一：Nginx 进程支持的 Linux 信号

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

## 附录二：Nginx 平滑升级后如何控制启动？

平滑升级后，不能直接使用 `service` 方式控制 Nginx，必须先使用如下方式关闭后才行：

| 平滑升级后     | 控制 Nginx 关闭的指令            |
| -------------- | -------------------------------- |
| 快速关闭 Nginx | /server/nginx/sbin/nginx -s stop |
| 正常关闭 Nginx | /server/nginx/sbin/nginx -s quit |
| 强制关闭 Nginx | pkill -9 nginx                   |
