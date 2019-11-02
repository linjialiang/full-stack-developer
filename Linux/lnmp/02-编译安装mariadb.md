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

> 提示：`mysql` `mysqld` `mariadb` 三者启动的是同一个服务（控制 mysql、mysqld 指令的脚本皆拷贝于 mariadb）！

```sh
Created symlink /etc/systemd/system/mysql.service → /lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/mysqld.service → /lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/multi-user.target.wants/mariadb.service → /lib/systemd/system/mariadb.service.
```

## `init.d` 下创建一键启动脚本

如果习惯了 `init.d` 操作，也可以自己制作个一键启动脚本

1. `init.d` 目录下创建一个 `控制 MariaDB 启动的文件`

   ```sh
   $ touch /etc/init.d/mysql
   $ chmod +x /etc/init.d/mysql
   ```

   > 文件内容查看 [MariaDB 一键启动](./source/mariadb一键启动文件.md)

2. 将一键启动脚本加入开机自动启动

   | 非本地服务    | 指令                                              |
   | ------------- | ------------------------------------------------- |
   | 启用-开机启动 | `/lib/systemd/systemd-sysv-install enable mysql`  |
   | 禁用-开机启动 | `/lib/systemd/systemd-sysv-install disable mysql` |

   > 提示，必须先卸载默认已经启用的本地服务开机启动程序（名字冲突）：

   ```sh
   $ systemctl disable mysql
   ```

3. 一键启动脚本涉及的指令：

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
      MYADMIN="/usr/bin/mysqladmin --defaults-file=/etc/mysql/my.cnf" -uroot -p正确的密码
      ```

## 配置 MariaDB

mariadb 官方的安装方式，非常的经典，所以我们只需要进行简单的设置即可，复杂的东西留给专业的运维吧！

| 　序号 | 具体操作            |
| ------ | ------------------- |
| 01     | 修改 `datadir` 路径 |
| 02     | 允许远程链接        |

### 修改 `datadir` 路径

修改 `datadir` 路径有很多种方式，这里讲解最方便的，更高级的方式请参阅 [MariaDB 数据初始化篇](./../../MariaDB/01-mariadb数据初始化篇.md)

1. 停止 MariaDB 服务

   ```sh
   $ service mariadb stop
   ```

2. 修改 MariaDB 配置文件的 datadir 参数值

   ```sh
   $ cp -p -r /etc/mysql/my.cnf{,.bak}
   $ vim /etc/mysql/my.cnf
   ```

   ```ini
   ...
   # datadir       = /var/lib/mysql
   datadir       = /server/mysql
   ...
   ```

3. 拷贝数据到指定路径：

   ```sh
   $ cd /var/lib
   $ tar -czvf /server/mysql_data.tar.gz mysql/
   $ mv mysql{,.bak}
   $ tar -xzvf /server/mysql_data.tar.gz -C /server/
   ```

### 远程连接

默认情况下 MariaDB 只能通过本地管理数据，为了方便管理我们需要开启远程管理（这对数据库安全构成很大威胁）

1. 修改 MariaDB 配置文件里的 `bind-address` 参数即可：

   | bind-address 参数值 | 描述                                         |
   | ------------------- | -------------------------------------------- |
   | 0.0.0.0             | 允许所有 IP 远程链接                         |
   | 127.0.0.1           | 只允许本地链接                               |
   | 192.168.66.103      | 只允许 IP 为 `192.168.66.103` 的用户远程链接 |

   > 备注：`bind-address` 不允许设置 ip 段，不允许设置多 ip

   ```ini
   ...
   # bind-address        = 127.0.0.1
   bind-address        = 0.0.0.0
   ...

   ```

2. 创建远程超级管理员用户

   ```sh
   $ service mariadb start
   $ mysql
   MariaDB [(none)]> create user 'root'@'192.168.10.9' identified by '123456';
   MariaDB [(none)]> grant all privileges on *.* to 'root'@'192.168.10.9' WITH GRANT OPTION;
   MariaDB [(none)]> flush privileges;
   ```

   > 关于 sql 指令的具体含义，请参阅 [MariaDB 下的 sql 指令](./../../MariaDB/02-mariadb下的sql指令.md)

   | 设备           | ip 地址        |
   | -------------- | -------------- |
   | MariaDB 服务器 | 192.168.10.251 |
   | 客户机路由器   | 192.168.10.9   |
   | 客户机         | 192.168.66.103 |

   > 上表告诉我们多网段的局域网中，服务器只能识别与其处于同一网段的主设备，下级设备只能通过主设备来操作（这是网络的知识点了）！
