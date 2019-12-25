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
   $ mkdir /package/php-7.4.1/php_bulid
   $ cd /package/php-7.4.1/php_bulid/
   $ ../configure --prefix=/server/php \
   --enable-fpm \
   --enable-mbstring \
   --with-openssl=/package/pkg/openssl-1.1.1d \
   --with-pcre-jit \
   --enable-mysqlnd \
   --with-mysqli \
   --with-pdo-mysql \
   --with-mysql-sock=/server/run/mariadb/mysqld.sock \
   --with-curl=/package/pkg/curl-7.67.0 \
   --without-sqlite3 \
   --without-pdo-sqlite
   $ make -j4
   $ make test
   $ make install
   ```

3. 配置 php.ini 文件

   ```sh
   $ mv /server/php/lib/php{,-v7.3.11}.ini
   $ cp -p -r /package/php-7.4.1/php.ini-development /server/php/lib/php.ini
   ```

4. 管理动态扩展

   跨不同版本的升级，动态扩展的处理方式是不一样的，具体请查看下文的 `附录一`。

5. 平滑升级 php-fpm

   使用 unix 信号来升级可执行文件 php-fpm

   ```sh
   $ kill -USR2 `cat /server/run/php/php-fpm.pid`
   ```

6. 平滑关闭旧版 Nginx 主进程

   使用 unix 信号，当进程没有访问者时，系统自动关闭当前进程

   ```sh
   $ kill -WINCH <旧版pid>
   ```

   > 提示：亲测发现，平滑升级指令并不好用！

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
