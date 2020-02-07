# 编译安装 Nginx

Nginx 是 LNMP 第一个要安装的软件包，关于 Nginx 的知识点请查阅 [Nginx 篇](./../../Nginx/README.md)

## 一、必备安装包准备

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

## 二、编译安装

### Nginx 构建指令

此次列出的构建选项，可运用于开发环境以及部署环境，具体如下：

```sh
$ cd /package/nginx-1.16.1
./configure --prefix=/server/nginx \
--builddir=/package/nginx-1.16.1/nginx_bulid \
--error-log-path=/server/logs/nginx/error.log \
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
--http-log-path=/server/logs/nginx/access.log \
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

2. 部署环境不建议添加的构建选项：

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

## 三、测试 Nginx

1. 启动 Nginx 守护进程

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

## 四、修改配置文件

Nginx 三个比较常用的配置文件示例：

| 配置文件                                          | 描述               | 具体操作     |
| ------------------------------------------------- | ------------------ | ------------ |
| [nginx.conf](./source/nginx/nginx.conf)           | nginx 主配置文件   | 替换         |
| [fastcgi-tp.conf](./source/nginx/fastcgi-tp.conf) | `tp6` 基本配置项   | 新增         |
| [sites.conf](./source/nginx/sites.conf)           | `tp6` 站点配置模版 | 按需新建多个 |

- 关于 Nginx 错误日志

  Nginx 错误日志基于 main 区块，所以在站点配置文件里不应该在设置 `error_log` 参数，这跟 httpd 有所区别

配置文件对应路径：

| 配置文件        | 路径                               |
| --------------- | ---------------------------------- |
| nginx.conf      | /server/nginx/conf/nginx.conf      |
| fastcgi-tp.conf | /server/nginx/conf/fastcgi-tp.conf |
| sites.conf      | `/server/sites/*.conf`             |

## 五、Nginx 的控制方法

| 操作         | 指令                               |
| ------------ | ---------------------------------- |
| 启动 nginx   | /server/nginx/sbin/nginx           |
| 正常关闭     | /server/nginx/sbin/nginx -s quit   |
| 快速关闭     | /server/nginx/sbin/nginx -s stop   |
| 重新载入     | /server/nginx/sbin/nginx -s reload |
| 重新打开日志 | /server/nginx/sbin/nginx -s reopen |
| 检测配置文件 | /server/nginx/sbin/nginx -t        |
| 显示帮助信息 | /server/nginx/sbin/nginx -h        |
| 列出配置信息 | /server/nginx/sbin/nginx -T        |

> 其他控制方式：

```sh
# 指定配置文件,启动 Nginx
$ /server/nginx/sbin/nginx -c /server/nginx/conf/nginx.conf

# 检测指定的 Nginx 配置文件
$ /server/nginx/sbin/nginx -t -c /server/nginx/conf/nginx.conf

# 强制停止 Nginx 进程
$ pkill -9 nginx
```

## 六、Systemd 单元(Unit)

用 Systemd 来管理守护进程更方便，建议为 Nginx 添加 Systemd 单元（Unit）

> 提示：单元文件配置详情，请查阅 [Systemd 实战篇](./../manual/06-systemd实战篇.md)

## 七、Nginx 跨域访问支持

Nginx 想要跨域只需要在 Nginx 的配置文件中配置以下参数即可：

```sh
location / {
    add_header Access-Control-Allow-Origin *;
    add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
    add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization';

    if ($request_method = 'OPTIONS') {
        return 204;
    }
}
```

关于跨域的更多内容，请参考：

| 序号 | 跨域参考                                         |
| ---- | ------------------------------------------------ |
| 01   | http://www.ruanyifeng.com/blog/2016/04/cors.html |
| 02   | https://segmentfault.com/a/1190000012550346      |
