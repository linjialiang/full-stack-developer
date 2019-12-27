# vsftpd 虚拟用户登陆认证

这里使用 PAM + MariaDB 认证方式来登陆 vsftpd，涉及如下内容：

| 依赖项       | 具体作用描述             |
| ------------ | ------------------------ |
| libpam-mysql | 让 PAM 支持 MariaDB 认证 |
| MariaDB      | 用于创建用户数据库       |

## 一、安装 libpam-mysql

1. 使用 apt 安装

   ```sh
   $ apt install libpam-mysql
   ```

   > 提示：安装后配置文件位于 `/etc/pam-mysql.conf`

2. 源码编译

   这里对源码编译安装不做讲解，源码包下载地址： https://github.com/NigelCunningham/pam-MySQL

## 二、MariaDB 相关操作

1. MariaDB 操作步骤分析：

   | 步骤 | 指令                                                             |
   | ---- | ---------------------------------------------------------------- |
   | 01   | 创建数据库(db_pam)，用于存放 pam 相关的数据                      |
   | 02   | 创建数据表(db_pam.pam_vsftpd)，记录 vsftpd 登陆相关的数据        |
   | 03   | 创建 MariaDB 用户(pam_vsftpd)，用来管理 vsftpd 与 pam 相关的数据 |
   | 04   | 为用户(pam_vsftpd)授予表(db_pam.pam_vsftpd)的查询(SELECT)权限    |
   | 05   | 刷新 MariaDB 权限表                                              |
   | 06   | 数据表(db_pam.pam_vsftpd)增加两条数据，用于测试                  |

   > 警告：由于数据库用户 pam_vsftpd 的密码会直接暴露在 pam 认证文件上，为了安全起见，最好只提供数据表的查询(SELECT)权限！

2. MariaDB 操作指令：

   ```text
   MariaDB [(none)]> CREATE DATABASE db_pam;
   MariaDB [(none)]> CREATE TABLE db_pam.pam_vsftpd (
      -> id    int AUTO_INCREMENT  NOT NULL    PRIMARY KEY,
      -> ftp_user  varchar(255)    BINARY  NOT NULL,
      -> ftp_passwd    char(41)    BINARY  NOT NULL,
      -> ftp_dir   varchar(255)    BINARY
      -> );
   MariaDB [(none)]> CREATE USER 'pam_vsftpd'@'localhost' IDENTIFIED BY '123456';
   MariaDB [(none)]> GRANT SELECT ON db_pam.pam_vsftpd TO 'pam_vsftpd'@'localhost';
   MariaDB [(none)]> FLUSH PRIVILEGES;
   MariaDB [(none)]> INSERT INTO db_pam.pam_vsftpd
      -> ( ftp_user, ftp_passwd )
      -> VALUES
      -> ( 'www', password('123456') );
   MariaDB [(none)]> INSERT INTO db_pam.pam_vsftpd
      -> ( ftp_user, ftp_passwd )
      -> VALUES
      -> ( 'qyadmin', password('123456') );
   ```

3. 表 `db_pam.pam_vsftpd` 的结构：

   ```text
   MariaDB [(none)]> DESCRIBE db_pam.pam_vsftpd;
   +------------+--------------+------+-----+---------+----------------+
   | Field      | Type         | Null | Key | Default | Extra          |
   +------------+--------------+------+-----+---------+----------------+
   | id         | int(11)      | NO   | PRI | NULL    | auto_increment |
   | ftp_user   | varchar(255) | NO   |     | NULL    |                |
   | ftp_passwd | char(41)     | NO   |     | NULL    |                |
   | ftp_dir    | varchar(255) | YES  |     | NULL    |                |
   +------------+--------------+------+-----+---------+----------------+
   4 rows in set (0.001 sec)
   ```

4. 表 `db_pam.pam_vsftpd` 的数据：

   ```text
   MariaDB [(none)]> select * from db_pam.pam_vsftpd;
   +----+----------+-------------------------------------------+---------+
   | id | ftp_user | ftp_passwd                                | ftp_dir |
   +----+----------+-------------------------------------------+---------+
   |  1 | www      | *6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9 | NULL    |
   |  2 | qyadmin  | *6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9 | NULL    |
   +----+----------+-------------------------------------------+---------+
   2 rows in set (0.001 sec)
   ```

## 三、pam-mysql 认证模块

`pam-mysql.so` 是 PAM 安全认证的一个模块，通过该模块可实现用 MariaDB 来管理相关服务的登陆验证。

1. 创建 vsftpd 的 PAM 配置文件

   ```sh
   $ vim /etc/pam.d/vsftpd-guest
   ```

   > 提示：PAM 配置文件请参考 [vsftpd-guest](./../source/vsftpd/vsftpd-guest)

2. pam 认证参数说明：

   | 参数                    | 描述                            |
   | ----------------------- | ------------------------------- |
   | user=pam_vsftpd         | 授权登陆 MariaDB 时的用户       |
   | passwd=123456           | MariaDB 用户密码                |
   | host=127.0.0.1          | 主机地址                        |
   | db=db_pam               | 存放 vsftpd 信息的数据库名      |
   | table=pam_vsftpd        | 存放 ftp 登陆信息的 table 名    |
   | usercolumn=ftp_user     | table 中代表 ftp 登陆用户的字段 |
   | passwdcolumn=ftp_passwd | table 中代表 ftp 登陆密码的字段 |
   | crypt=2                 | PAM 认证密码的加密方式编号      |

   > 警告：PAM 配置文件的 `host` 参数一律写成 ip(如：host=127.0.0.1)的形式，如果设置成字符串形式(如：host=localhost)就会出错！

3. pam-mysql 模块支持的加密方式

   pam-mysql 使用 crypt 参数来管理加密方式：

   | crypt 编号 | 加密方式说明                                    |
   | ---------- | ----------------------------------------------- |
   | crypt=0    | 不使用加密                                      |
   | crypt=1    | 使用 crypt(3) 加密                              |
   | crypt=2    | 直接通过当前 MariaDB 服务的函数 password() 认证 |
   | crypt=3    | md5 加密                                        |
   | crypt=4    | SHA1 加密                                       |

   > 警告：pam-mysql 的加密方式必须与 MariaDB 数据表下密码字段的加密方式一致，否则认证无法成功！

## 四、创建映射用户

vsftpd 虚拟用户需要映射到 Linux 用户上，否则就没有任何 linux 系统权限

1. 创建 Linux 普通用户 www

   ```sh
   $ useradd -c 'This Linux user is used to map VSFTPD virtual users' -u 2003 -s /usr/sbin/nologin -d /server/default -M -U www
   ```

> 提示：映射的 Linux 用户的家目录必须是存在的，并且映射的 Linux 用户需要允许访问家目录（进入目录的权限，`chmod +x`）

## 五、创建虚拟用户单独配置文件

在 `/server/vsftpd` 目录下，创建与虚拟用户同名的配置文件，并自定义根目录地址，具体操作如下：

1. 创建虚拟用户(www)的单独配置文件

   ```sh
   $ vim /server/vsftpd/www
   ```

   具体内容：

   ```conf
   local_root=/server/www
   ```

2. 创建虚拟用户(qyadmin)的单独配置文件

   ```sh
   $ vim /server/vsftpd/qyadmin
   ```

   具体内容：

   ```conf
   local_root=/server/www/qyadmin
   ```

3. 控制目录权限不可写

   设置了 `virtual_use_local_privs=yes` 以后，虚拟用户的权限与本地用户完全相同，所以家目录不能有写的权限：

   ```sh
   $ chown www:www /server/www
   $ chmod a-w /server/www
   ```

## 六、限制到家目录

设置了 `virtual_use_local_privs=yes` 以后，虚拟用户的权限与本地用户完全相同，所以同样需要使用 `chroot_local_user` 来限制家目录：

```conf
chroot_local_user=YES
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd/chroot_list
```

> 提示：虚拟用户登陆，最大的好处就是我们之后可以通过 web 后台来控制！
