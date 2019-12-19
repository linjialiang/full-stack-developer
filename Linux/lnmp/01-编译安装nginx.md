# 编译安装 Nginx

Nginx 是 LNMP 第一个要安装的软件包，关于 Nginx 的知识点请查阅 [Nginx 篇](./../../Nginx/README.md)

## 必备安装包准备

编译 Nginx 需要的准备好的软件包：

| 必备         | 操作                                                                          |
| ------------ | ----------------------------------------------------------------------------- |
| libgd 开发库 | `apt install libgd-dev`                                                       |
| geoip 开发库 | `apt install libgeoip-dev`                                                    |
| openssl 库   | [openssl-1.1.1d.tar.gz](https://www.openssl.org/source/openssl-1.1.1d.tar.gz) |
| pcre 库      | [pcre-8.43.tar.gz](https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz)            |
| zlib 库      | [zlib-1.2.11.tar.gz](http://zlib.net/zlib-1.2.11.tar.gz)                      |
| nginx 源码包 | [nginx-1.16.1.tar.gz](http://nginx.org/download/nginx-1.16.1.tar.gz)          |

软件包根目录为 `/package/lnmp` ，处理软件包过程如下指令：

| 过程 | 指令                 |
| ---- | -------------------- |
| 下载 | `$ wget <下载地址>`  |
| 解包 | `$ tar -xzvf <包名>` |

> 提示：使用 `./configure` 指令构建会提示缺失的依赖包！

## 编译 Nginx 需要的目录

| 目录                   | 指令                                           |
| ---------------------- | ---------------------------------------------- |
| Nginx 编译（安装）路径 | `mkdir -p /server/nginx`                       |
| Nginx 源码路径         | `mkdir /package/lnmp/nginx-1.16.1`             |
| Nginx 构建路径         | `mkdir /package/lnmp/nginx-1.16.1/nginx_bulid` |

## 构建指令

该构建指令完全可用于部署环境，其中 `mail模块` 和 `stream模块` 按需选择

1. 进入 `Nginx源码` 根目录

   ```sh
   $ cd /package/lnmp/nginx-1.16.1
   ```

2. 输入构建指令（开发环境 `mail` 、`stream` 模块不必选择）

   > 提示：使用 `./configure -h` 可获取当前软件的所有构建选项

   ```sh
   ./configure --prefix=/server/nginx \
   --builddir=/package/lnmp/nginx-1.16.1/nginx_bulid \
   --with-threads \
   --with-file-aio \
   --with-http_ssl_module \
   --with-http_v2_module \
   --with-http_realip_module \
   --with-http_image_filter_module \
   --with-http_geoip_module \
   --with-http_dav_module \
   --with-http_gunzip_module \
   --with-http_gzip_static_ module \
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

   > 上述各种指令的具体作用，请查阅 [从源代码构建 Nginx](./../../Nginx/01-从源代码构建nginx.md)

3. 编译并安装

   编译安装并不需要切换到 `--builddir` 目录

   ```sh
   $ make -j4
   $ make install
   ```

   > `-j4` 使用 `cat /proc/cpuinfo| grep "processor"| wc -l` 查看 `逻辑核心数` 来指定

## 测试 Nginx

使用 curl 可以很便捷地测试 Nginx 是否安装成功，具体指令如下：

```sh
$ cd /server/nginx/sbin
$ ./nginx
$ curl -I 127.0.0.1
```

1. 成功信号

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

2. 失败输出

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
