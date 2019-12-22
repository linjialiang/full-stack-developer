# 编译安装 Nginx

Nginx 是 LNMP 第一个要安装的软件包，关于 Nginx 的知识点请查阅 [Nginx 篇](./../../Nginx/README.md)

## 必备安装包准备

编译 Nginx 需要的准备好的软件包：

| 必备           | 操作                                                     |
| -------------- | -------------------------------------------------------- |
| libgd 开发库   | libgd-dev                                                |
| geoip 开发库   | libgeoip-dev                                             |
| Nginx 源码包   | [nginx-1.16.1.tar.gz](http://nginx.org/en/download.html) |
| openssl 依赖库 | [openssl-1.1.1d.tar.gz](https://www.openssl.org/source/) |
| pcre 依赖库    | [pcre-8.43.tar.gz](ftp://ftp.pcre.org/pub/pcre/)         |
| zlib 依赖库    | [zlib-1.2.11.tar.gz](http://zlib.net/zlib-1.2.11.tar.gz) |

1. 安装 Nginx 必备开发库

   ```sh
   $ apt install libgd-dev libgeoip-dev
   ```

   > 提示：使用 `./configure` 指令构建时，会提示缺失的依赖包相关信息！

2. 创建 Nginx 构建目录

   ```sh
   $ mkdir /package/nginx-1.16.1/nginx_bulid
   ```

## 构建指令

此次列出的构建选项，可运用于开发环境以及部署环境，具体如下：

```sh
$ cd /package/nginx-1.16.1
./configure --prefix=/server/nginx \
--builddir=/package/nginx-1.16.1/nginx_bulid \
--pid-path=/server/run/nginx/nginx.pid \
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
--with-pcre=/package/pkg/pcre-8.43 \
--with-pcre-jit \
--with-zlib=/package/pkg/zlib-1.2.11 \
--with-openssl=/package/pkg/openssl-1.1.1d \
--with-debug
```

> 提示：添加了 `--pid-path=` 构建选项后，`nginx.conf` 文件下的 pid 参数就可有可无了！

1. `mail模块` 和 `stream模块` 按需选择：

   ```sh
   --with-mail \
   --with-mail_ssl_module \
   --with-stream \
   --with-stream_ssl_module \
   --with-stream_realip_module \
   --with-stream_geoip_module \
   --with-stream_ssl_preread_module \
   ```

2. 用于部署环境则不需要如下构建选项：

   ```sh
   --with-debug
   ```

> 提示：使用 `./configure -h` 可获取所有构建选项，上述各种指令的具体介绍，请查阅 [从源代码构建 Nginx](./../../Nginx/01-从源代码构建nginx.md)

### 编译并安装

```sh
$ make -j4
$ make install
```

> 提示：编译选项 `-j4` ，可通过 `cat /proc/cpuinfo| grep "processor"| wc -l` 指令查看 `逻辑核心数` 来确定。

## 测试 Nginx

1. 启动 Nginx 自带的守护进程

   ```sh
   $ cd /server/nginx/sbin
   $ ./nginx
   ```

2. 使用 curl 测试 Nginx 守护进程是否启动成功

   ```sh
   $ curl -I 127.0.0.1
   ```

3. 成功信号

   ```sh
   HTTP/1.1 200 OK
   Server: nginx/1.16.1
   Date: Sat, 02 Nov 2019 05:04:24 GMT
   Content-Type: text/html
   Content-Length: 612
   Last-Modified: Sat, 02 Nov 2019 04:58:32 GMT
   Connection: keep-alive
   ETag: "5dbd0cf8-264"
   Accept-Ranges: bytes
   ```

4. 失败输出

   ```sh
   curl: (7) Failed to connect to 127.0.0.1 port 80: 拒绝连接
   ```

## 开机启动

使用 `systemctl` 可以引导 nginx 在系统开启时自动启动

1. `init.d` 目录下创建一个 `控制 Nginx 启动的文件`

   ```sh
   $ touch /etc/init.d/nginx
   $ chmod +x /etc/init.d/nginx
   ```

   > 文件内容查看 [nginx 一键启动](./source/nginx一键启动文件.md)

2. 将一键启动脚本加入开机自动启动

   | 非本地服务   | 指令                                              |
   | ------------ | ------------------------------------------------- |
   | 启用开机启动 | `/lib/systemd/systemd-sysv-install enable nginx`  |
   | 禁用开机启动 | `/lib/systemd/systemd-sysv-install disable nginx` |

   > 本地服务加入开启启动方法为 `systemctl enable nginx`

3. nginx 一键启动文件常用指令：

   | 操作                      | 指令                           |
   | ------------------------- | ------------------------------ |
   | 启动 Nginx                | `/etc/init.d/nginx start`      |
   | 停止 Nginx                | `/etc/init.d/nginx stop`       |
   | 重新加载 Nginx            | `/etc/init.d/nginx reload`     |
   | 验证 Nginx 配置文件正确性 | `/etc/init.d/nginx configtest` |

## 附录：Nginx 配置文件

| 配置文件                                    | 描述                 |
| ------------------------------------------- | -------------------- |
| [fastcgi-tp.conf](./source/fastcgi-tp.conf) | `tp6` 基本配置项     |
| [nginx.conf](./source/nginx.conf)           | nginx 主配置文件案例 |
| [sites.conf](./source/sites.conf)           | `tp6` 站点配置模版   |
