# LNMP 第三次升级记录

此次 LNMP 升级并不全面，因为很多软件都没有更新，所以这里只更新了部分软件包。

## 升级 MariaDB

MariaDB 是使用 apt 安装的，没有大版本升级都不需要特别处理：

```sh
$ apt update
$ apt upgrade
```

## 升级 PHP

本次 PHP 升级的地方比较多，具体如下：

| 包名        | 当前版本  | 欲升级版本 | 包地址                            |
| ----------- | --------- | ---------- | --------------------------------- |
| PHP         | 7.4.5     | 7.4.6      | https://www.php.net/downloads.php |
| ImageMagick | 7.0.10-10 | 7.0.10-14  | https://imagemagick.org/download/ |

### php 升级操作计划

| 序号 | php 升级操作              |
| ---- | ------------------------- |
| 01   | 编译 php7.4.6             |
| 02   | 无缝升级 php              |
| 03   | 重新编译安装 php 动态扩展 |

> 由于本次是小版本升级，之前的动态扩展通常都能正常使用，除非对扩展有 bug 修复，一般不重新编译。

1. 编译安装新版 php

    如果有需要保存的配置文件，就应该要先保存好，再编译安装：

    ```sh
    $ mkdir /package/php-7.4.6/php_bulid
    $ cd /package/php-7.4.6/php_bulid/
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
    $ mv /server/php/lib/php{,-v7.4.5}.ini
    # 开发环境
    $ cp -p -r /package/php-7.4.6/php.ini-development /server/php/lib/php.ini
    # 部署环境
    $ cp -p -r /package/php-7.4.6/php.ini-production /server/php/lib/php.ini
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
    $ cd /package/pkg/ImageMagick-7.0.10-14/
    $ mkdir ImageMagick_bulid
    $ cd ImageMagick_bulid/

    # 4. 编译并安装 ImageMagick 运行库
    $ ../configure --prefix=/server/ImageMagick
    $ make -j4
    $ make install

    # 5. 创建构建目录
    $ cd /package/ext/imagick-3.4.4
    $ rm -rf imagick_bulid
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
