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

phpMyAdmin 是 `MySQL/MariaDB` 最著名的管理系统，有 PHP 语言编写。

```sh
$ c:
$ cd C:\wamp\base\default
$ composer create-project phpmyadmin/phpmyadmin pma
$ composer update
```

> 提示：浏览器输入 `localhost/phpmyadmin` 网址，即可访问！

## 安装 adminer

adminer 是一个单文件、简洁的数据库管理系统，高效的执行效率使得其大受程序员欢迎！
