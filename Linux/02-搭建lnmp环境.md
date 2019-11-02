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

```shell
$ apt install gcc g++ autotools-dev make cmake autoconf automake m4 libtool
```

## 章节导航

| LNMP 章节导航                                    |
| ------------------------------------------------ |
| [编译安装 Nginx](./lnmp/01-编译安装nginx.md)     |
| [编译安装 MariaDB](./lnmp/02-编译安装mariadb.md) |
| [编译安装 PHP](./lnmp/03-编译安装php.md)         |
