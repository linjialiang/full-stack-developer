# 存储库安装 MariaDB

LNMP 第二个要安装的是 MariaDB， 由于 MariaDB 官方对编译安装的文档并没有足够的详细，编译安装确实存在很多问题，因此这里采取了官方存储库的方式来安装。

## 一、添加 MariaDB 源

存储库安装，是使用 apt 源来安装和管理 MariaDB。可通过下面地址获取 apt 源：

    https://downloads.mariadb.org/mariadb/repositories

### 生成自定义存储库配置

打开前面给的网址，通过如下 4 步可以生成存储库配置信息

| 步骤 | 选项             | 选项值             |
| ---- | ---------------- | ------------------ |
| 01   | Choose a Distro  | Debian             |
| 02   | Choose a Release | Debian 10 "buster" |
| 03   | Choose a Version | 10.4 [Stable]      |
| 04   | Choose a Mirror  | 清华大学           |

### 具体操作方法如下：

1. 安装必备的依赖包

   ```sh
   $ apt install software-properties-common dirmngr
   ```

2. 导入 MariaDB 源的公钥：

   ```sh
   $ apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xF1656F24C74CD1D8
   ```

3. 为 MariaDB 创建专属 apt 源文件：

   ```sh
   $ touch /etc/apt/sources.list.d/mariadb.list
   $ vim /etc/apt/sources.list.d/mariadb.list
   ```

4. `mariadb.list` 源码：

   ```text
   # MariaDB 10.4 repository list - created 2019-12-23 05:59 UTC
   # http://downloads.mariadb.org/mariadb/repositories/
   deb http://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.4/debian buster main
   deb-src http://mirrors.tuna.tsinghua.edu.cn/mariadb/repo/10.4/debian buster main
   ```

5. 更新 apt 源

   ```sh
   $ apt update
   ```

## 二、安装 MariaDB

进行了上面操作后，我们使用 apt 来正常安装即可：

```sh
$ apt install mariadb-server
```

### 三、Systemd Unit(单元)文件

`mariadb-server` 安装信息的最后一段话，展示如下信息：

```sh
正在设置 rsync (3.1.3-6) ...
Created symlink /etc/systemd/system/multi-user.target.wants/rsync.service → /lib/systemd/system/rsync.service.
正在设置 libhttp-date-perl (6.02-1) ...
正在设置 mariadb-server-core-10.4 (1:10.4.11+maria~buster) ...
正在设置 mariadb-server-10.4 (1:10.4.11+maria~buster) ...
Failed to stop mysql.service: Unit mysql.service not loaded.
Created symlink /etc/systemd/system/mysql.service → /lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/mysqld.service → /lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/multi-user.target.wants/mariadb.service → /lib/systemd/system/mariadb.service.
```

这段话告诉我们如下信息：

| 序号 | 信息                                                                                  |
| ---- | ------------------------------------------------------------------------------------- |
| 01   | rsync 是 MariaDB 的依赖项，当然小项目完全不必理会                                     |
| 02   | 将 rsync Unit 加入了 `multi-user.target` target 组                                    |
| 03   | 将 mariadb Unit 以别名 mysql 的方式成为系统 Unit                                      |
| 04   | 将 mariadb Unit 以别名 mysql 的方式成为系统 Unit                                      |
| 05   | 将 mariadb Unit 加入了 `multi-user.target` target 组                                  |
| 06   | 如想马上使用 Systemd 控制 mariadb，请使用 `systemctl daemon-reload` 重载 Systemd 配置 |

## 四、操作 MariaDB

由上可知 MariaDB 是支持 `systemd` 管理的，具体请查阅 [systemd 实战篇](./../manual/06-systemd实战篇.md)

## 五、配置 MariaDB

单间修改下 MariaDB，是它更加适合我们的个人需求，操作列表如下：

| 　序号 | 需要修改的配置项                |
| ------ | ------------------------------- |
| 01     | 修改 MariaDB 的 PID 文件路径    |
| 02     | 修改 MariaDB 的 socket 文件路径 |
| 03     | 修改 MariaDB 的 socket 文件路径 |
| 04     | 修改 MariaDB 索引日志存放路径   |
| 05     | 允许远程链接                    |
| 06     | 创建 MariaDB 远程用户           |

### 首先，停止 MariaDB 服务

```sh
$ service mariadb stop
# 或者
$ systemctl stop mariadb
```

### 修改配置文件

```sh
$ cp -p -r /etc/mysql/my.cnf{,.bak}
$ vim /etc/mysql/my.cnf
```

> my.cnf 文件修改的参数如下：

| 属性                   | my.cnf 对应参数及参数值                             |
| ---------------------- | --------------------------------------------------- |
| 套接字                 | socket = /server/run/mariadb/mariadb.sock           |
| pid 文件               | pid-file = /server/run/mariadb/mariadb.pid          |
| 数据目录               | datadir = /server/data                              |
| 二进制日志记录格式     | binlog_format = mixed                               |
| 二进制日志文件过期时间 | expire_logs_days = 30                               |
| 二进制日志每个文件容量 | max_binlog_size = 100M                              |
| 二进制日志路径         | log_bin = /server/logs/mariadb/bin_log              |
| 二进制日志索引文件路径 | log_bin_index = /server/logs/mariadb/bin_log.index  |
| 关闭慢查询日志         | slow_query_log = 0                                  |
| 慢查询日志路径         | slow_query_log_file = /server/logs/mariadb/slow.log |
| 关闭通用日志           | general_log = 0                                     |
| 通用日志文件           | general_log_file = /server/logs/mariadb/general.log |
| 错误日志记录级别       | log_warnings = 0                                    |
| 错误日志文件           | log_error = /server/logs/mariadb/err.log            |

> 修改后的配置文件请参考 [my.cnf](./source/mariadb/my.cnf)

### 创建必要目录

创建必要目录，并设置用户权限为 MariaDB 用户

```sh
$ mkdir /server/data
$ chown mysql /server/data/
$ mkdir /server/logs/mariadb
$ chown mysql /server/logs/mariadb/
$ mkdir /server/run/mariadb
$ chown mysql /server/run/mariadb/
```

### 初始化数据目录

使用 `mysql_install_db` 这个工具初始化数据目录：

```sh
$ /usr/bin/mysql_install_db --user=mysql \
--datadir=/server/data \
--skip-test-db
```

## 六、启动 MariaDB

MariaDB 自带了守护进程启动方式，但是使用 Systemd 控制更加优秀

1. 使用 MariaDB 自带的程序操作方法：

   | 操作类型     | 指令                    |
   | ------------ | ----------------------- |
   | 启用 MariaDB | `$ mysqld_safe &`       |
   | 停止 MariaDB | `$ mysqladmin shutdwon` |

2. 使用 Systemd 单元(Unit)文件操作 MariaDB

   经过修改的 MariaDB 已经无法通过之前 Unit 文件来管理，需要如下修改：

   | Unit 文件        | 路径                                                          |
   | ---------------- | ------------------------------------------------------------- |
   | 自带的 Unit 文件 | /usr/lib/systemd/system/mariadb.service                       |
   | 可用的 Unit 文件 | 源码请查看 [mariadb.server](./source/mariadb/mariadb.service) |

   修改 MariaDB 自带的 Unit 文件，然后使用重新加载 systemd 配置：

   ```sh
   $ systemctl daemon-reload
   ```

   Systemd 常用的操作 MariaDB 指令：

   | 操作类型     | 指令                    |
   | ------------ | ----------------------- |
   | 启动 MariaDB | systemctl start mysqld  |
   | 关闭 MariaDB | systemctl stop mariadb  |
   | 重启 MariaDB | systemctl restart mysql |

### 允许客户端远程连接

默认情况下 MariaDB 只能通过 shell 终端或本地客户端管理数据，为了方便管理我们需要开启远程管理（开启远程是有风险的）

1. 修改 MariaDB 配置文件里的 `bind-address` 参数即可：

   bind-address 只有 2 个参数值：

   | 参数值    | 描述                               |
   | --------- | ---------------------------------- |
   | 0.0.0.0   | MariaDB 服务对所有 IP 的客户端开放 |
   | 127.0.0.1 | MariaDB 服务对只对本地客户端开放   |

   > 注意：bind-address 无论怎么设置，shell 终端都可以登陆 MariaDB，两者无关！

2. 创建远程客户端的超级管理员用户

   ```sh
   $ service mariadb start
   $ mysql
   MariaDB [(none)]> create user 'root'@'192.168.10.9' identified by '123456';
   MariaDB [(none)]> grant all privileges on *.* to 'root'@'192.168.10.9' WITH GRANT OPTION;
   MariaDB [(none)]> flush privileges;
   ```

   > 关于 sql 指令的具体含义，请参阅 [MariaDB 下的 sql 指令](./../../MariaDB/03-mariadb下的sql指令.md)

   | 设备           | ip 地址        |
   | -------------- | -------------- |
   | MariaDB 服务器 | 192.168.10.251 |
   | 客户机路由器   | 192.168.10.9   |
   | 客户机         | 192.168.66.103 |

   > 上表告诉我们多网段的局域网中，服务器只能识别与其处于同一网段的主设备，下级设备只能通过主设备来操作（这是网络的知识点了）！
