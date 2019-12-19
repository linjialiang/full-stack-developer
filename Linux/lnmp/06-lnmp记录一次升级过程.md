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
