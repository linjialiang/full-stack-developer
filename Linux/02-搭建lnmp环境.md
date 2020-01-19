# 搭建 LNMP 环境

Linux 下推荐大家都使用 LNMP 作为开发环境，毕竟部署环境 LNMP 才是最佳选择。

## httpd 与 nginx 比较

| 对比项目      | httpd      | nginx             |
| ------------- | ---------- | ----------------- |
| 对于初学者    | 掌握容易   | 掌握困难          |
| 资源占用      | 普通       | 极低              |
| 抗高并发      | 较差       | 极强              |
| 稳定性        | 超稳       | 一般              |
| 处理请求      | 同步多进程 | 异步多线程        |
| 处理 php 脚本 | 模块处理   | 转发 php-fpm 处理 |

## LNMP 概念

本教程所说的 LNMP 指的是： `Debian + Nginx + MariaDB + PHP`

## 编译环境

Linux 下编译安装软件包，需要先安装编译工具，具体代码如下：

```sh
$ apt install gcc g++ autotools-dev make cmake autoconf automake m4 libtool
```

### LNMP 安装目录规划

```sh
================================================================================
LNMP 开发环境目录
================================================================================
├─ /server                                   LNMP 环境根目录
|   |
|   ├─ nginx                                 Nginx 编译安装路径
|   |
|   ├─ mariadb                               mariadb 编译安装路径
|   |
|   ├─ php                                   php 编译安装路径
|   |
|   ├─ sites                                 站点配置文件目录
|   |
|   ├─ data                                  mariadb 数据库系统数据存放目录
|   |
|   ├─ run                                   LNMP 存放 pid、socket文件 的根目录
|   |   ├─ nginx                             存放 Nginx 进程的 pid文件
|   |   ├─ mariadb                           存放 MariaDB 进程的 pid、socket文件
|   |   ├─ php                               存放 php-fpm 进程的 pid文件
|   |
|   ├─ default                               nginx 站点缺省位置
|   |   ├─ pma                               phpMyAdmin 数据库管理系统
|   |   ├─ adminer                           adminer 数据库管理系统
|   |   ├─ index.php                         关于 PHP 配置的信息
|   |   ├─ index.html                        LNMP 开发环境说明
|   |
|   ├─ logs                                  服务器相关日志文件目录
|   |  ├─ nginx                              nginx 日志目录
|   |  ├─ xdebug                             xdebug 日志目录
|   |  ├─ mariadb                            MariaDB 日志目录
|   |  ├─ php                                php 日志目录
|   |
├─ /package                                  LNMP 源码包根目录
|   |
|   ├─ pkg                                   运行库源码包存放目录
|   |
|   ├─ ext                                   php 扩展源码包存放目录
|   |
|
├─ lnmp_del.sh                               LNMP 环境一键移除
|
├─ lnmp_tar.sh                               LNMP 环境一键解压 .tar.gz 包
|
└─ lnmp_dir.sh                               LNMP 目录一键生成
```

### LNMP 脚本列表

| LNMP 脚本         | 脚本路径                                 |
| ----------------- | ---------------------------------------- |
| LNMP 目录一键生成 | [lnmp_dir.sh](./lnmp/source/lnmp_dir.sh) |
| LNMP 环境一键移除 | [lnmp_del.sh](./lnmp/source/lnmp_del.sh) |
| LNMP 环境批量解压 | [lnmp_tar.sh](./lnmp/source/lnmp_tar.sh) |

### LNMP 包文件列表

| 包文件               | 包链接                                                           |
| -------------------- | ---------------------------------------------------------------- |
| Nginx 源码包         | [nginx-1.16.1.tar.gz](http://nginx.org/en/download.html)         |
| PHP 源码包           | [php-7.4.1.tar.gz](https://www.php.net/downloads.php)            |
| ~~PHP 错误提示扩展~~ | ~~[xdebug-2.9.0.tgz](https://pecl.php.net/package/xdebug)~~      |
| PHP 图片处理扩展     | [imagick-3.4.4.tgz](https://pecl.php.net/get/imagick-3.4.4.tgz)  |
| openssl 依赖库       | [openssl-1.1.1d.tar.gz](https://www.openssl.org/source/)         |
| pcre 依赖库          | [pcre-8.43.tar.gz](ftp://ftp.pcre.org/pub/pcre/)                 |
| zlib 依赖库          | [zlib-1.2.11.tar.gz](http://zlib.net/zlib-1.2.11.tar.gz)         |
| curl 依赖库          | [curl-7.68.0.tar.gz](https://curl.haxx.se/download.html)         |
| ImageMagick 依赖库   | [ImageMagick-7.0.9-16.tar.gz](https://imagemagick.org/download/) |

### 进行编译安装之前，请进行如下操作：

| 步骤 | 具体操作说明                          |
| ---- | ------------------------------------- |
| 01   | 使用 `lnmp_dir.sh` 脚本文件生成；     |
| 02   | 将所需软件包全部下载到对应位置；      |
| 03   | 使用 `lnmp_tar.sh` 脚本批量解压它们。 |

其中 lnmp_dir.sh 脚本生成的部分目录需要特殊权限，列表如下：

| 序号 | 权限                                |
| ---- | ----------------------------------- |
| 01   | # chown mysql /server/data/         |
| 02   | # chown mysql /server/run/mariadb/  |
| 03   | # chown mysql /server/logs/mariadb/ |

## 章节导航

| 序号 | LNMP 章节导航                                              |
| ---- | ---------------------------------------------------------- |
| 01   | [编译安装 Nginx](./lnmp/01-编译安装nginx.md)               |
| 02   | [存储库安装 MariaDB](./lnmp/02-存储库安装mariadb.md)       |
| 03   | [编译安装 PHP](./lnmp/03-编译安装php.md)                   |
| 04   | [为 PHP 安装 PECL 扩展](./lnmp/04-为php安装pecl扩展.md)    |
| 05   | [LNMP 维护篇](./lnmp/05-lnmp维护篇.md)                     |
| 06   | [LNMP 记录一次升级过程](./lnmp/06-lnmp记录一次升级过程.md) |
| 07   | [为 LNMP 添加辅助工具](./lnmp/07-为lnmp添加辅助工具.md)    |
