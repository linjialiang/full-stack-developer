# LNMP 第二次升级记录

此次 LNMP 升级并不全面，因为很多软件都没有更新，所以这里只更新了部分软件包。

## 更新 MariaDB

MariaDB 数据库是 apt 安装的，这次也没有跨大版本更新，所以是最简单的，具体操作如下：

```sh
$ apt update
$ apt upgrade
```

## 更新 Nginx

本次 Nginx 本身并没有升级，更新的只是 Nginx 依赖包。

| 包名 | 当前版本 | 升级版本 | 包地址                       |
| ---- | -------- | -------- | ---------------------------- |
| pcre | 8.43     | 8.44     | ftp://ftp.pcre.org/pub/pcre/ |

> 更新 Nginx 的具体教程，请参考 [Nginx 平滑升级](../../Nginx/03-Nginx平滑升级.md)

### 构建选项

部署环境下使用这些构建选项即可：

```sh
./configure --prefix=/server/nginx \
--builddir=/package/nginx-1.16.1/nginx_bulid \
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
--with-pcre=/package/pkg/pcre-8.44 \
--with-pcre-jit \
--with-zlib=/package/pkg/zlib-1.2.11 \
--with-openssl=/package/pkg/openssl-1.1.1d
```

## 升级 PHP

本次 PHP 升级的地方比较多，具体如下：

| 包名        | 当前版本 | 欲升级版本 | 包地址                             |
| ----------- | -------- | ---------- | ---------------------------------- |
| PHP         | 7.4.1    | 7.4.3      | https://www.php.net/downloads.php  |
| curl        | 7.68.0   | 7.69.0     | https://curl.haxx.se/download.html |
| ImageMagick | 7.0.9-16 | 7.0.9-27   | https://imagemagick.org/download/  |

### php 升级操作计划

| 序号 | php 升级操作              |
| ---- | ------------------------- |
| 01   | curl 依赖包升级至 7.69.0  |
| 02   | 编译 php7.4.3             |
| 03   | 无缝升级 php              |
| 04   | 重新编译安装 php 动态扩展 |

> 由于本次跨次要版本升级，之前的动态扩展都失效，这些都需要重新编译安装。

1. 编译安装新版 php

   如果有需要保存的配置文件，就应该要先保存好，再编译安装：

   ```sh
   $ mkdir /package/php-7.4.3/php_bulid
   $ cd /package/php-7.4.3/php_bulid/
   $ ../configure --prefix=/server/php \
   --enable-fpm \
   --enable-mbstring \
   --with-openssl=/package/pkg/openssl-1.1.1d \
   --with-pcre-jit \
   --enable-mysqlnd \
   --with-mysqli \
   --with-pdo-mysql \
   --with-mysql-sock=/server/run/mariadb/mysqld.sock \
   --with-curl=/package/pkg/curl-7.69.0 \
   --with-zlib=/package/pkg/zlib-1.2.11 \
   --without-sqlite3 \
   --without-pdo-sqlite
   $ make -j4
   $ make test
   $ make install
   ```

   > 提示：测试 `--with-curl=/package/pkg/curl-7.69.0` 无效

2. 配置 php.ini 文件

   ```sh
   $ mv /server/php/lib/php{,-v7.4.1}.ini
   # 开发环境
   $ cp -p -r /package/php-7.4.3/php.ini-development /server/php/lib/php.ini
   # 部署环境
   $ cp -p -r /package/php-7.4.3/php.ini-production /server/php/lib/php.ini
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

### 升级 php_Imagick 扩展

1. 首先将旧版的 `imagick.so` 删除

   ```sh
   # 查找扩展路径
   $ php-config --extension-dir
   # 删除旧版的 `imagick.so` 扩展
   $ cd /server/php/lib/php/extensions/no-debug-non-zts-20190902
   $ rm imagick.so*
   ```

2. 编译安装 ImageMagick

   ```sh
   # 1. 移除旧版 ImageMagick
   $ rm -rf /server/ImageMagick

   # 2. 创建 ImageMagick 目录
   $ mkdir /server/ImageMagick

   # 3. 创建构建目录
   $ cd /package/pkg/ImageMagick-7.0.9-27/
   $ mkdir ImageMagick_bulid
   $ cd ImageMagick_bulid/

   # 4. 编译并安装 ImageMagick 运行库
   $ ../configure --prefix=/server/ImageMagick
   $ make -j4
   $ make install

   # 5. 创建构建目录
   $ cd /package/ext/imagick-3.4.4
   $ rm -rf imagick_buli
   $ mkdir imagick_bulid

   # 6. 编译并安装 imagick 扩展
   $ cd /package/ext/imagick-3.4.4
   $ phpize
   $ cd imagick_bulid
   $ ../configure --with-imagick=/server/ImageMagick
   $ make -j4
   $ make test
   $ make install
   ```

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
