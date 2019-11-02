# 编译安装 MariaDB

我们第二个需要安装的是 MariaDB， 这里我们采用官方针对 Debian 的[快捷安装方式](https://downloads.mariadb.org/mariadb/repositories)

## 添加 MariaDB 源

这里我们添加 MariaDB 10.4.x 的源（当下最新正式版）

1. 安装必备软件包：

   ```sh
   $ apt install software-properties-common dirmngr
   ```

2. 导入 MariaDB 源的公钥：

   ```sh
   $ apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xF1656F24C74CD1D8
   ```

3. 创建 `mariadb.list` 镜像文件：

   ```sh
   $ touch /etc/apt/sources.list.d/mariadb.list
   ```

   `mariadb.list` 文件源码：

   ```apt
   # MariaDB 10.4 repository list - created 2019-11-02 05:46 UTC
   # http://downloads.mariadb.org/mariadb/repositories/
   deb [arch=amd64] http://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.4/debian buster main
   deb-src http://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.4/debian buster main
   ```

## 安装 MariaDB

新源版本号会成为 apt 默认安装的 MariaDB 版本，具体指令如下：

```shell
$ apt update
$ apt upgrade
$ apt install mariadb-server
```

## 操作 MariaDB

apt 安装默认开机自动启动 MariaDB，支持使用 `systemd` 管理。

1. `systemctl` 指令控制：

   | 操作 | 指令                              |
   | ---- | --------------------------------- |
   | 启动 | systemctl start `mysql`           |
   | 关闭 | systemctl stop `mysqld`           |
   | 重启 | systemctl restart `mariadb`       |
   | 重载 | systemctl reload `mariadb.server` |

2. `service` 指令控制：

   | 操作 | 指令                      |
   | ---- | ------------------------- |
   | 启动 | service `mysql` start     |
   | 关闭 | service `mysqld` stop     |
   | 重启 | service `mariadb` restart |
   | 重载 | service `mariadb` reload  |

> 提示：`mysql` `mysqld` `mariadb` 三者启动的是同一个 mariadb 服务！

## `init.d` 下创建一键启动脚本

如果我们熟悉了 `init.d` 操作，可以自己制作一个一键启动脚本

1. `init.d` 目录下创建一个 `控制 MariaDB 启动的文件`

   ```sh
   $ touch /etc/init.d/mysql
   $ chmod +x /etc/init.d/mysql
   ```

   > 文件内容查看 [MariaDB 一键启动](./source/mariadb一键启动文件.md)

2. 将一键启动脚本加入开机自动启动

   | 操作步骤     | 指令                                              |
   | ------------ | ------------------------------------------------- |
   | 启用开机启动 | `/lib/systemd/systemd-sysv-install enable mysql`  |
   | 禁用开机启动 | `/lib/systemd/systemd-sysv-install disable mysql` |

   > 提示，必须先卸载默认的自启动程序：

   ```sh
   $ systemctl disable mysql
   ```

3. MariaDB 一键启动文件常用指令：

   | 操作     | 指令                      |
   | -------- | ------------------------- |
   | 启动服务 | /etc/init.d/mysql start   |
   | 关闭服务 | /etc/init.d/mysql stop    |
   | 重新加载 | /etc/init.d/mysql reload  |
   | 重启服务 | /etc/init.d/mysql restart |

4. MariaDB 的 root 用户密码问题

   默认 MariaDB 的 root 密码的免密本地特殊账户才能登陆的，这也是最安全的方式，但是如果我们设置了密码就需要调整 `/etc/mysql` 脚本文件的内容。

   > `/etc/mysql` 脚本中 MYADMIN 的变量值需要修改，具体如下：

   ```sh
   MYADMIN="/usr/bin/mysqladmin --defaults-file=/etc/mysql/my.cnf" -uroot -p正确的密码"
   ```
