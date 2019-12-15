# 安裝 MariaDB 管理系統

WAMP 从 `v6.0.0` 开始，采用 composer 安装 MariaDB 管理系统。

## 管理系统一览表

WAMP 将自带以下两款 web 端数据库管理系统：

| DB 管理系统 | 网址                        |
| ----------- | --------------------------- |
| adminer     | https://www.adminer.org/    |
| phpmyadmin  | https://www.phpmyadmin.net/ |

> 附录：[phpmyadmin 中文手册](https://docs.phpmyadmin.net/zh_CN/latest/)

## 安装 phpMyAdmin

phpMyAdmin 是 `MySQL/MariaDB` 最著名的管理系统，由 PHP 语言编写。

```sh
$ c:
$ cd C:\\wamp
$ composer create-project phpmyadmin/phpmyadmin pma
$ composer update
```

## 安装 adminer

adminer 是 PHP 语言编写，支持多种数据库系统，由于其出色的执行速度使得其大受程序员欢迎！

```sh
$ cd C:\\wamp
$ composer create-project vrana/adminer
$ composer update
```
