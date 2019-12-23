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

`my.cnf` 文件修改的参数如下：

| 参数          | 参数值                          |
| ------------- | ------------------------------- |
| socket        | /server/run/mariadb/mysqld.sock |
| pid-file      | /server/run/mariadb/mysqld.pid  |
| datadir       | /server/data                    |
| log_bin       | /server/data/mariadb-bin        |
| log_bin_index | /server/data/mariadb-bin.index  |

> 注意：其中 socket 参数有 3 个，都需要修改！

### 修改 MariaDB 数据存放路径

这里只是最简单的操作，想家详细的内容请参阅 [MariaDB 数据初始化篇](./../../MariaDB/02-mariadb数据初始化篇.md)

2. 备份 MariaDB 配置文件

   ```sh
   $ cp -p -r /etc/mysql/my.cnf{,.bak}
   $ vim /etc/mysql/my.cnf
   ```

   提示：MariaDB 的主配置文件是 `/etc/mysql/my.cnf`

3. `my.cnf` 文件修改的内容如下：

   ```ini
   # datadir       = /var/lib/mysql
   datadir       = /server/data
   ```

4. 初始化数据目录

   使用 `mysql_install_db` 这个工具初始化数据目录：

   ```sh
   $ mysql_install_db --user=mysql --datadir=/server/data
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

2. 创建远程的超级管理员用户

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
