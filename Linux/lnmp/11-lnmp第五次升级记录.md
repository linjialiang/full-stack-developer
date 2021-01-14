# LNMP 第三次升级记录

此次 LNMP 升级并不全面，因为很多软件都没有更新，所以这里只更新了部分软件包。

## 升级 MariaDB

MariaDB 是使用 apt 安装的，没有大版本升级都不需要特别处理：

```sh
$ apt update
$ apt upgrade
```

## 升级 Nginx

虽然 Nginx 没有更新，但是 openssl 库更新了，为了使用最新的 openssl 库，需要重新编译 Nginx

| 包名    | 当前版本 | 升级版本 | 包地址                          |
| ------- | -------- | -------- | ------------------------------- |
| openssl | 1.1.1g   | 1.1.1i   | https://www.openssl.org/source/ |

> 移除 `package` 下的旧版 nginx 目录和 openssl 目录，并重新解压它们

### 构建选项

```sh
$ mv /server/nginx/sbin/nginx{,-v1.18.0-old}
$ mkdir /package/nginx-1.18.0/nginx_bulid
$ cd /package/nginx-1.18.0/
$ ./configure 构建选项（详情见下） ...
$ make -j4
$ cp -p -r /package/nginx-1.18.0/nginx_bulid/nginx /server/nginx/sbin/
$ server ngixn restart
```

> 部署环境下使用这些构建选项即可：

```sh
$ ./configure --prefix=/server/nginx \
--builddir=/package/nginx-1.18.0/nginx_bulid \
--error-log-path=/server/logs/nginx/error.log \
--pid-path=/server/run/nginx/nginx.pid \
--with-threads --with-file-aio \
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
--with-pcre=/package/pcre-8.44 \
--with-pcre-jit \
--with-zlib=/package/zlib-1.2.11 \
--with-openssl=/package/openssl-1.1.1i
```

> 提示：这里没有使用平滑升级，如有需要请参考 [Nginx 平滑升级](../../Nginx/03-Nginx平滑升级.md)

## 升级 PHP

本次 PHP 升级的地方比较多，具体如下：

| 包名 | 当前版本 | 欲升级版本 | 包地址                            |
| ---- | -------- | ---------- | --------------------------------- |
| PHP  | 7.4.10   | 8.0.1      | https://www.php.net/downloads.php |

### php 升级操作计划

| 序号 | php 升级操作              |
| ---- | ------------------------- |
| 01   | 编译 php8.0.1             |
| 02   | 无缝升级 php              |
| 03   | 重新编译安装 php 动态扩展 |

> 本次是大版本升级，之前的动态扩展通常都能无法正常使用，本次会涉及 PHP 扩展重新编译。

0. 查看上次编译选项

    在上次编译选项的基础上，做一下增、删、改，本次不需要修改

    ```sh
    $ php-config --configure-options
    ```

1. 编译安装新版 php

    如果有需要保存的配置文件，就应该要先保存好，再编译安装：

    ```sh
    $ mkdir /package/php-8.0.1/php_bulid

    $ cd /package/php-8.0.1/php_bulid/

    $ ../configure --prefix=/server/php \
    --enable-fpm \
    --enable-mbstring \
    --with-zlib \
    --with-pcre-jit \
    --enable-mysqlnd \
    --with-mysqli \
    --with-pdo-mysql \
    --with-mysql-sock=/server/run/mariadb/mysqld.sock \
    --without-sqlite3 \
    --without-pdo-sqlite
    $ make -j4
    $ make test
    $ make install
    ```

2. 配置 php.ini 文件

    ```sh
    $ mv /server/php/lib/php{,-v7.4.10}.ini
    # 开发环境
    $ cp -p -r /package/php-8.0.1/php.ini-development /server/php/lib/php.ini

    # 部署环境
    $ cp -p -r /package/php-8.0.1/php.ini-production /server/php/lib/php.ini

    ```

3. 管理动态扩展

    跨不同版本的升级，动态扩展的处理方式是不一样的，具体请查看下文的 `附录一`。

4. 平滑升级 php-fpm

    使用 unix 信号来升级可执行文件 php-fpm

    ```sh
    $ kill -USR2 `cat /server/run/php/php-fpm.pid`
    ```

5. 平滑关闭旧版 Nginx 主进程

    使用 unix 信号，当进程没有访问者时，系统自动关闭当前进程

    ```sh
    $ kill -WINCH <旧版pid>
    ```

    > 提示：亲测发现，平滑升级指令并不好用，直接重启省事！

## 附录一、管理 php 动态扩展

首先确定 PHP 是否是大版本间的升级：

| php 升级版本 | 操作说明                                       |
| ------------ | ---------------------------------------------- |
| 大版本升级   | 之前动态扩展无法使用，只能重新安装这些扩展     |
| 小版本更新   | 之前动态扩展依然可用，将其移动到正确路径下即可 |

1. 重新安装动态扩展

    重新安装扩展请查看 [为 php 安装 pecl 扩展](./04-为php安装pecl扩展.md)

2. 移动扩展到正确路径

    通过 php-config 工具，可以查看 php 动态扩展的存放路径是否发生改变：

    | 动态扩展存放路径 | 操作说明                                 |
    | ---------------- | ---------------------------------------- |
    | 发生改变         | 将之前的扩展移动到当下动态扩展存放路径中 |
    | 没有改变         | 恭喜你，可以不用做任何操作了             |
