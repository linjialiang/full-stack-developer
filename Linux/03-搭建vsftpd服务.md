# 搭建 vsftpd 服务

vsftpd 可能是类 unix 系统中最安全、最快的 FTP 服务器。

## 安装 vsftpd

```sh
$ apt install vsftpd
```

## 必要知识点

想要完全掌握 vsftpd，我们有必要深入了解以下内容：

| 知识点               | 链接                                                       |
| -------------------- | ---------------------------------------------------------- |
| vsftpd 配置选项      | [vsftpd.conf 选项说明](./manual/03-vsftpd.conf选项说明.md) |
| 可插入式授权管理模块 | [Linux-PAM](./06-PAM.md)                                   |

## 配置文件

配置文件参考源码:

| 登陆方式     | 配置文件                                               |
| ------------ | ------------------------------------------------------ |
| 系统用户登陆 | [vsftpd.conf](./source/vsftpd/vsftpd.conf)             |
| 虚拟用户登陆 | [vsftpd.guest.conf](./source/vsftpd/vsftpd.guest.conf) |

### 配置参数

涉及到的配置参数详情如下：

| vsftpd 参数                              | 参数描述                                                |
| ---------------------------------------- | ------------------------------------------------------- |
| anonymous_enable=NO                      | 禁用匿名用户登陆                                        |
| local_enable=YES                         | 启用本地用户登陆                                        |
| ssl_enable=NO                            | 禁用 ftps                                               |
| download_enable=YES                      | 允许 ftp 客户端下载文件                                 |
| write_enable=YES                         | 允许 ftp 客户端写操作                                   |
| file_open_mode=0666                      | 上传文件的权限                                          |
| local_umask=022                          | 本地用户权限                                            |
| listen=NO                                | 禁用 ipv4 监听方式                                      |
| listen_ipv6=YES                          | 启用 ipv6 监听方式                                      |
| listen_port=21                           | 监听端口                                                |
| port_enable=NO                           | 禁用主动模式                                            |
| pasv_enable=YES                          | 启用被动模式                                            |
| pasv_max_port=21001                      | 被动模式，端口号区间最小值                              |
| pasv_min_port=21099                      | 被动模式，端口号区间最大值                              |
| accept_timeout=60                        | 被动模式，60 秒无法连接成功就主动断开连接               |
| idle_session_timeout=600                 | 600 秒内，vsftpd 没有收到该客户端的操作指令，则断开链接 |
| data_connection_timeout=500              | 文件传输时，超过 500 秒没有完成就断开传输               |
| local_max_rate=8192                      | 本地用户最大数据传输速率                                |
| max_per_ip=3                             | 最多可连接 ip 数量                                      |
| max_clients=10                           | 最多可连接的客户端数量                                  |
| max_login_fails=3                        | 登陆失败 3 次，禁止登陆                                 |
| trans_chunk_size=8192                    | 获得更加平滑的带宽限制器                                |
| chroot_local_user=YES                    | 将用户绑定到家目录，chroot_list 列出的用户除外          |
| chroot_list_enable=YES                   | 将用户绑定到家目录，chroot_list 列出的用户除外          |
| chroot_list_file=/etc/vsftpd/chroot_list | 将用户绑定到家目录，chroot_list 列出的用户除外          |

| 系统用户登陆参数                    | 参数描述                                 |
| ----------------------------------- | ---------------------------------------- |
| pam_service_name=vsftpd             | 设置 PAM 认证服务所使用的配置文件名      |
| userlist_enable=YES                 | 仅允许 user_list 列出的用户，登陆 vsftpd |
| userlist_deny=NO                    | 仅允许 user_list 列出的用户，登陆 vsftpd |
| userlist_file=/etc/vsftpd/user_list | 仅允许 user_list 列出的用户，登陆 vsftpd |

| 虚拟用户登陆参数               | 参数描述                            |
| ------------------------------ | ----------------------------------- |
| pam_service_name=vsftpd_guest  | 设置 PAM 认证服务所使用的配置文件名 |
| guest_enable=yes               | 开启虚拟用户登陆                    |
| guest_username=www             | 虚拟用户映射的系统用户              |
| local_root=/server/default     | 设置用户登陆时的默认根目录          |
| user_config_dir=/server/vsftpd | 虚拟用户单独配置文件存放目录        |
| virtual_use_local_privs=yes    | 虚拟用户将使用与本地用户相同的权限  |

> 提示：关于 vsftpd 更多的配置参数，请参考 [vsftpd.conf 选项说明](./manual/03-vsftpd.conf选项说明.md)

## 系统用户登陆相关

1. 修改 vsftpd 的 PAM 配置文件

   | 配置文件路径 | `/etc/pam.d/vsftpd`             |
   | ------------ | ------------------------------- |
   | 注释掉 1 行  | `# auth required pam_shells.so` |

   > 提示： `pam_shells.so` 用于认证用户是否支持 shell 登陆

2. 创建系统用户组及系统用户

   创建本地系统用户，用于登陆 vsftpd

   ```sh
   $ mkdir /server/www
   $ useradd -c 'Users of the vsftpd user' -u 2003 -s /usr/sbin/nologin -d /server/www -U www
   ```

   > 注意：将用户限制在家目录，用户对家目录不能拥有写的权限，否则 vsftpd 会拒绝登陆，具体操作如下：

   ```sh
   $ chown www:www /server/www
   $ chmod a-w server/www
   ```

3. 创建更多的系统用户

   创建更多的系统用户，用于登陆 vsftpd，并指定不同的家目录

   ```sh
   $ mkdir /server/www/qyadmin
   $ useradd -c 'Users of the vsftpd user' -u 2004 -s /usr/sbin/nologin -d /server/www/qyadmin -g www qyadmin
   ```

   设置目录权限，具体操作如下：

   ```sh
   $ chown www:www /server/www/qyadmin
   $ chmod 750 /server/www/qyadmin
   ```

4. 指定允许登陆的系统用户

   将系统用户加入 `/etc/vsftpd/user_list` 文件下，才能正常访问，`user_list` 文件具体内容如下：

   ```conf
   www
   qyadmin
   ```

## 虚拟用户登陆相关

这里使用 PAM + MariaDB 认证方式来登陆 vsftpd，涉及如下内容：

| 依赖项       | 具体作用描述             |
| ------------ | ------------------------ |
| libpam-mysql | 让 PAM 支持 MariaDB 认证 |
| MariaDB      | 用于创建用户数据库       |

1. 安装 libpam-mysql

   ```sh
   $ apt install libpam-mysql
   ```

2. MariaDB 相关操作

   | 步骤 | 指令                                                                          | 描述                             |
   | ---- | ----------------------------------------------------------------------------- | -------------------------------- |
   | 01   | `CREATE DATABASE vsftpd;`                                                     | 创建数据库                       |
   | 02   | `CREATE USER 'vsftpd'@'localhost' IDENTIFIED BY '123456';`                    | 创建数据库管理用户               |
   | 02   | `GRANT ALL PRIVILEGES ON vsftpd.* TO 'vsftpd'@'localhost' WITH GRANT OPTION;` | 授予用户操作 vsftpd 数据库的权限 |
   | 03   | `FLUSH PRIVILEGES;`                                                           | 刷新 MariaDB 权限表              |
   | 04   | 见 `指令详情`                                                                 | 创建 user_pam 表                 |
   | 05   | 见 `指令详情`                                                                 | 创建用户                         |

3. MariaDB 指令详情

   ```sh
   $ mysql
   MariaDB [(none)]> CREATE DATABASE vsftpd;
   MariaDB [(none)]> CREATE USER 'vsftpd'@'localhost' IDENTIFIED BY '123456';
   MariaDB [(none)]> GRANT ALL PRIVILEGES ON vsftpd.* TO 'vsftpd'@'localhost' WITH GRANT OPTION;
   MariaDB [(none)]> FLUSH PRIVILEGES;
   MariaDB [(none)]> use vsftpd;
   MariaDB [(none)]> CREATE TABLE user_pam (id int AUTO_INCREMENT NOT NULL PRIMARY KEY, name varchar(30) NOT NULL, password char(41) binary NOT NULL);
   MariaDB [(none)]> INSERT INTO user_pam(name,password) VALUES ('www',password('123456'));
   MariaDB [(none)]> INSERT INTO user_pam(name,password) VALUES ('qyadmin',password('123456'));
   ```

   > `pam-mysql.so` 模块支持的加密方式，与 mariadb 加密方式 `不兼容` 时，需要更换其它加密方式，或者不使用加密

4. 创建 pam 认证的配置文件

   案例参考 [vsftpd_guest](./source/vsftpd/vsftpd_guest)

   ```sh
   $ vim /etc/pam.d/vsftpd_guest
   ```

   > 提示：`pam-mysql.so` 模块不支持 `host=localhost` 的写法，需要一律写成 IP 地址,如： `host=127.0.0.1`

5. pam 认证参数说明

   | 参数                  | 描述                      |
   | --------------------- | ------------------------- |
   | user=vsftpd           | 授权登陆 mariadb 时的用户 |
   | passwd=123456         | mariadb 用户免密          |
   | host=localhost        | 主机地址                  |
   | db=vsftpd             | 存放虚拟用户的数据库名    |
   | table=user_pam        | 存放虚拟用户的 table 名   |
   | usercolumn=name       | table 中代表用户的字段    |
   | passwdcolumn=password | table 中代表密码的字段    |
   | crypt=2               | 密码加密方式代号          |

   | crypt 值 | 描述                         |
   | -------- | ---------------------------- |
   | crypt=0  | 不加密                       |
   | crypt=1  | 使用 crypt(3)加密            |
   | crypt=2  | mariadb 函数加密 password(); |
   | crypt=3  | md5 加密                     |
   | crypt=4  | SHA1 加密                    |

6. 创建映射用户

   创建一个 `Linux用户`，所有 vsftpd 虚拟用户都映射到该用户上

   ```sh
   $ useradd -c 'This Linux user is used to map VSFTPD virtual users' -u 2003 -s /usr/sbin/nologin -d /server/default -M -U www
   $ mkdir /server/default
   ```

   > 提示：映射的 Linux 用户的家目录必须是存在的，并且映射的 Linux 用户需要允许访问家目录（进入目录的权限，`chmod +x`）

### 创建虚拟用户单独配置文件

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

### 限制到家目录

设置了 `virtual_use_local_privs=yes` 以后，虚拟用户的权限与本地用户完全相同，所以同样需要使用 `chroot_local_user` 来限制家目录：

```conf
chroot_local_user=YES
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd/chroot_list
```

> 提示：虚拟用户登陆，最大的好处就是我们之后可以通过 web 后台来控制！

## vsftpd 附录

1. vsftpd 权限设置

   ```sh
   任何linux服务权限都需要考虑到Linux权限问题，即：
       1. chmod chown 设置的权限
       2. vsftpd 服务设置的权限
            file_open_mode=0666
            local_umask=026
   ```

2. vsftpd 站点根目录权限

   根目录权限允许设置成对应用户有执行权限，其它用户不可见，即：

   ```sh
   $ chown www:www /server/www
   $ chmod 100 /server/www
   $ chown www:www /server/www/qyadmin
   $ chmod 010 /server/www/qyadmin
   ```

3. vsftpd 站点文件权限设置

   通常处理 web 的用户与 ftp 用户是不同的，所以我们一般保证：

   | 文件分类 | web 和 php-fpm 用户权限 | ftp 用户权限      |
   | -------- | ----------------------- | ----------------- |
   | 目录     | 读+执行（5-rx）         | 执行+读+写(5-rwx) |
   | 文件     | 可读（4-r）             | 读+写（6-rw）     |

4. web 用户对目录权限说明

   为了保证站点内容只允许 `ftp用户` 、`web用户` 和 `php-fpm用户` 操作，我们可以将 `web用户` 和 `php-fpm用户` 加入到 `ftp用户组` 中，即：

   ```sh
   $ usermod -G www nginx
   ```

   接着按如下表设置文件权限即可：

   | 文件分类 | 用户权限          | 用户组权限    | 其他用户权限 |
   | -------- | ----------------- | ------------- | ------------ |
   | 目录     | 执行+读+写(5-rwx) | 读+执行(5-rx) | 空(0)        |
   | 文件     | 读+写(4-rw)       | 读(4-r)       | 空(0)        |

   `vsftpd.conf` 参数修改：

   | 参数                | 描述                               |
   | ------------------- | ---------------------------------- |
   | file_open_mode=0640 | ftp 上传的文件权限为 `640`         |
   | local_umask=027     | 修改了 linux 本地用户的权限为`750` |

   `/server/php/etc/php-fpm.d/www.conf` 参数修改：

   | 参数          | 描述                                    |
   | ------------- | --------------------------------------- |
   | user=nobody   | 必须修改为： `user=nginx` 或 `user=www` |
   | group=nogroup | 不需要修改                              |

> 提示：如果 web 用户需要更多的，权限就增加用户组权限即可！
