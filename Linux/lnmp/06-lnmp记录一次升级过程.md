# LNMP 记录一次升级过程

此次 LNMP 升级并不全面，因为很多软件都没有更新，所以这里只更新了部分软件包。

## 更新 MariaDB

MariaDB 数据库是 apt 安装的，这次也没有跨大版本更新，所以是最简单的，具体操作如下：

```sh
$ apt update
$ apt upgrade
```

## 更新 Nginx

更新 Nginx 的具体教程，请查阅 [Nginx 平滑升级](../../Nginx/03-Nginx平滑升级.md)

## 升级 PHP

本次 PHP 升级的地方比较多，具体如下：

| 包名        | 当前版本 | 欲升级版本 | 包地址                             |
| ----------- | -------- | ---------- | ---------------------------------- |
| PHP         | 7.3.11   | 7.4.1      | https://www.php.net/downloads.php  |
| curl        | 7.66.0   | 7.67.0     | https://curl.haxx.se/download.html |
| ImageMagick | 7.0.9-2  | 7.0.9-9    | https://imagemagick.org/download/  |

### php 升级操作计划

| 序号 | php 升级操作              |
| ---- | ------------------------- |
| 01   | curl 依赖包升级至 7.67.0  |
| 02   | 编译 php7.4.1             |
| 03   | 无缝升级 php              |
| 04   | 重新编译安装 php 动态扩展 |

> 由于本次跨次要版本升级，之前的动态扩展都失效，这些都需要重新编译安装。

1. 安装必备依赖项

   `php 7.4` 比 `php 7.3` 多 2 个依赖包：

   ```sh
   $ apt install libonig-dev libcurl4-openssl-dev
   ```

2. 编译安装新版 php

   如果有需要保存的配置文件，就应该要先保存好，再编译安装：

   ```sh
   $ mkdir /package/lnmp/php-7.4.1/php_bulid
   $ cd /package/lnmp/php-7.4.1/php_bulid/
   $ ../configure --prefix=/server/php \
   --enable-fpm \
   --enable-mbstring \
   --with-openssl=/package/lnmp/openssl-1.1.1d \
   --with-pcre-jit \
   --enable-mysqlnd \
   --with-pdo-mysql \
   --with-curl=/package/lnmp/curl-7.67.0 \
   --without-cdb \
   --without-sqlite3 \
   --without-pdo-sqlite
   $ make -j4
   $ make test
   $ make install
   ```

3. 配置 php.ini 文件

   ```sh
   $ mv /server/php/lib/php{,-v7.3.11}.ini
   $ cp -p -r /package/lnmp/php-7.4.1/php.ini-development /server/php/lib/php.ini
   ```

4. 安装 pecl 扩展

   php 跨大版本，所有 pecl 扩展库都应该重新编译，具体请查看 [为 php 安装 pecl 扩展](./04-为php安装pecl扩展.md)
