# LNMP 维护篇

操作完前面 4 个小节，lnmp 环境已经搭建完成，并且也有基本操作，本篇会系统全面的讲解 lnmp 环境的维护！

## 一、管理 lnmp 相关进程

建议统一使用 systemd 来管理进程：

| 管理 Unit      | systemd 指令            |
| -------------- | ----------------------- |
| 启动 MariaDB   | service mysql start     |
| 关闭 nginx     | systemctl nginx stop    |
| 重启 php-fpm   | service php-fpm restart |
| 查看 Unit 状态 | service <Unit> status   |
| 重载 Unti 配置 | systemctl reload <Unit> |

程序自带方式测试配置文件：

| 管理守护进程      | 对应的指令                  |
| ----------------- | --------------------------- |
| 测试 nginx 配置   | /server/nginx/sbin/nginx -t |
| 测试 php-fpm 配置 | /server/php/sbin/php-fpm -t |

## 二、统一 pid 和 socket 路径

我们将所有涉及到的 pid 和 socket 文件存放于同一个路径下，具体如下表：

| 服务    | 类型   | 路径                            |
| ------- | ------ | ------------------------------- |
| nginx   | pid    | /server/run/nginx/nginx.pid     |
| MariaDB | pid    | /server/run/mariadb/mysqld.pid  |
| MariaDB | socket | /server/run/mariadb/mysqld.sock |
| php-fpm | pid    | /server/run/php/php-fpm.pid     |
| php-fpm | socket | /server/run/php/php-fpm.sock    |

## 三、关于 LNMP 相关进程的用户说明

在 Linux 系统中，用户权限是非常重要，对于 LNMP 环境的用户权限，我们也应该做到完全理解所有涉及到的用户及其意义！

### LNMP 涉及到的用户列表

| 用户    | 描述                  | 是否创建                |
| ------- | --------------------- | ----------------------- |
| nobody  | 权限最低的用户        | 系统默认创建            |
| nogroup | 权限最低的用户组      | 系统默认创建            |
| nginx   | Nginx 的用户/用户组   | 用户自行创建            |
| mysql   | MariaDB 用户/用户组   | 安装 MariaDB 时默认创建 |
| php-fpm | php-fpm 的用户/用户组 | 用户自行创建            |
| www     | vsftpd 的用户/用户组  | 用户自行创建            |

### MariaDB 用户

MariaDB 用 apt 安装好后，自动创建了 mysql 用户及对应用户组，用它就行了，不需要特别注意的！

### Web 相关用户

与 Web 相关的用户，我们通常需要考虑 `FTP 服务进程`、`web 服务进程`、`后端处理进程` 这 3 类守护进程。当前服务器具体如下：

| 服务类型     | 守护进程 |
| ------------ | -------- |
| web 服务进程 | nginx    |
| 后端处理进程 | php-fpm  |
| FTP 服务进程 | vsftpd   |

1. Nginx 主进程用户

   Nginx 主进程用户为登陆用户（一般都是 root 用户执行），这里不做过多讲解！

2. Nginx 工作进程用户

   nginx 工作进程的默认用户是 `nobody` 用户，修改成自行创建的 `nginx` 非特权用户和用户组

   ```sh
   $ useradd -c 'Users of the Nginx service' -u 2001 -s /usr/sbin/nologin -d /server/default -M -U nginx
   ```

3. php-fpm 主进程用户

   php-fpm 主进程用户为登录用户（一般都是 root 用户执行），这里不做过多讲解！

4. php-fpm 工作进程用户

   php-fpm 工作进程的默认用户是 `nobody` 用户，修改成自行创建的 `php-fpm` 非特权用户和用户组

   ```sh
   $ useradd -c 'Users of the php-fpm service' -u 2002 -s /usr/sbin/nologin -d /server/default -M -U php-fpm
   ```

5. vsftpd 用户

   vsftpd 的默认用户是系统默认创建 `www-data` 用户，为了是其权限更加单一，这里修改成自行创建的 `www` 非特权用户和用户组

   ```sh
   $ useradd -c 'This Linux user is used to map VSFTPD virtual users' -u 2003 -s /usr/sbin/nologin -d /server/default -M -U www
   ```

   > 提示：关于 vsfptd 的更多介绍，请参考 [搭建 vsfptd 服务](./../03-搭建vsftpd服务.md)

## 四、LNMP 各种用户关联说明

除了 MariaDB 用户没有特殊关联外，其他几个用户或多或少有关联关系

1. nginx 工作进程用户与 php-fpm 工作进程的关系

   php-fpm 工作进程是需要监听 web 服务进程才能正常工作的，通常设置为 web 服务进程的用户

   | php-fpm 子配置文件参数 | 具体描述                            |
   | ---------------------- | ----------------------------------- |
   | listen.owner = nginx   | 设置用于监听 web 服务进程的用户名   |
   | listen.group = ningx   | 设置用于监听 web 服务进程的用户组名 |

2. FTP 用户与 nginx、php-fpm 的关系

   修改网页文件是使用 FTP 来传输的，但是 nginx 和 php-fpm 可能会因为对文件或目录的权限不足，导致网页访问失败

## 五、设置用户权限

1. FTP 上传文件权限设置

   为了安全起见，FTP 上传用户的权限应设置为：

   | 文件类型 | 权限 |
   | -------- | ---- |
   | 目录     | 750  |
   | 文件     | 640  |

   > 关于 vsftpd 用户权限的详细知识，请查阅 [搭建 vsfptd 服务](./../03-搭建vsftpd服务.md)

2. 为 Nginx 和 php-fpm 用户设置权限

   由于文件不对其它用户和用户组开放，所以 Nginx 和 php-fpm 都不能正常访问网页文件，为它们加入 FTP 用户组可以解决：

   ```sh
   $ usermod -G www nginx
   $ usermod -G www php-fpm
   ```

3. 特殊文件权限

   如果 nginx 或 php-fpm 用户需要对文件或目录具有写的权限，就应该修改权限为：

   | 文件类型 | 权限 | 指令                 |
   | -------- | ---- | -------------------- |
   | 目录     | 770  | `$ chmod 770 <dir>`  |
   | 文件     | 660  | `$ chmod 770 <file>` |

4. 遗留的安全问题

   操作到这里确实比设置 nobody 安全多了，但是还有如下问题需要解决：

   | 序号 | 安全隐患                                                                     |
   | ---- | ---------------------------------------------------------------------------- |
   | 01   | php-fpm 进程和 nginx 进程只要其中 1 个需要写的权限，另一个也需要给予写的权限 |

## 附录一：为什么 PHP 无法使用链接 MariaDB ？

- 原因分析：

  ```text
  - pdo_mysql.default_socket 通常默认值为 /tmp/mysql.sock
  - mysqli.default_socket 通常默认值为 /tmp/mysql.sock
  - 而当前的 MariaDB 的 socket 路径为 /server/run/mariadb/mysqld.sock
  ```

- 解决方法：

  ```text
  - 修改php.ini ：pdo_mysql.default_socket=/server/run/mariadb/mariadb.sock
  - 修改php.ini ：mysqli.default_socket=/server/run/mariadb/mariadb.sock
  - 重启 php-fpm
  ```
