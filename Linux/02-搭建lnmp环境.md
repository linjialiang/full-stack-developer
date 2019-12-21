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
└─ lnmp_dir.sh                               LNMP 目录一键生成
```

| LNMP 脚本         | 脚本路径                            |
| ----------------- | ----------------------------------- |
| LNMP 目录一键生成 | [lnmp_dir.sh](./source/lnmp_dir.sh) |
| LNMP 环境一键移除 | [lnmp_del.sh](./source/lnmp_del.sh) |

## 章节导航

| 序号 | LNMP 章节导航                                              |
| ---- | ---------------------------------------------------------- |
| 01   | [编译安装 Nginx](./lnmp/01-编译安装nginx.md)               |
| 02   | [编译安装 MariaDB](./lnmp/02-编译安装mariadb.md)           |
| 03   | [编译安装 PHP](./lnmp/03-编译安装php.md)                   |
| 04   | [为 PHP 安装 PECL 扩展](./lnmp/04-为php安装pecl扩展.md)    |
| 05   | [LNMP 维护篇](./lnmp/05-lnmp维护篇.md)                     |
| 06   | [LNMP 记录一次升级过程](./lnmp/06-lnmp记录一次升级过程.md) |
