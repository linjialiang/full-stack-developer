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

其它原生的操作

## 统一路径

默认情况下 3 个服务项的 `pid 和 socket` 路径是不同的，这里我们建议保持在统一路径上。

1. 创建 `pid 和 socket` 路径

   > `pid 和 socket` 统一存入 `service/run` 路径下

2. 修改 MariaDB 的 `pid 和 socket` 文件路径

   > 先关闭 mariadb 服务，否则遗留的 `pid 和 socket` 文件需要手动删除

   ```sh
   $ service mariadb stop
   $ cp /etc/mysql/my.cnf{,.bak}
   $ vim /etc/mysql/my.cnf
   ```

   > `my.cnf` 有多个 `pid、socket` ，都需要修改

   | 指令     | 路径                               |
   | -------- | ---------------------------------- |
   | `pid`    | `/server/run/mariadb/mariadb.pid`  |
   | `socket` | `/server/run/mariadb/mariadb.sock` |

   > 创建目录（`pid、socket` 由 MariaDB 用户（mysql）管理 ，所以必须更改用户权限，否则无法创建文件）：

   ```sh
   $ mkdir -p /server/run/mariadb
   $ chown mysql /server/run/mariadb/
   ```

3. 修改 Nginx 的 `pid` 文件路径

   ```sh
   $ service nginx stop
   $ cp /server/nginx/conf/nginx.conf{,.bak}
   $ vim /server/nginx/conf/nginx.conf
   ```

   | 配置文件指令 | 路径                          |
   | ------------ | ----------------------------- |
   | `pid`        | `/server/run/nginx/nginx.pid` |

   > 创建目录（由于 nginx 是 root 管理 pid，所以不必更改用户）：

   ```sh
   $ mkdir /server/run/nginx
   $ chown nginx /server/run/nginx/
   ```

4. 修改 php-fpm 的 `pid 和 socket` 文件路径

   `pid` 在 `php-fpm.conf` 里修改：

   ```sh
   $ vim /server/php/etc/php-fpm.conf
   ```

   `socket` 在 `php-fpm.d/www.conf` 里修改：

   ```sh
   $ vim /server/php/etc/php-fpm.d/www.conf
   ```

   | 配置文件参数 | 参数值（路径）                   |
   | ------------ | -------------------------------- |
   | `pid`        | `/server/run/php/php73-fpm.pid`  |
   | `socket`     | `/server/run/php/php73-fpm.sock` |

   > 提示： `pid` 由 root 用户管理；`socket` 由工作进程用户（nginx）管理：

5. 修改了 `pid` 路径后，两个启动文件里的 `pid` 值也需要修改，具体操作如下：

   | 启动文件    | 路径                                      | 对应的参数名  |
   | ----------- | ----------------------------------------- | ------------- |
   | `init.d`    | `/etc/init.d/php-fpm`                     | `php_fpm_PID` |
   | `systemctl` | `/usr/lib/systemd/system/php-fpm.service` | `PIDFile`     |

   > 提示：如果 `systemctl` 启动文件做了修改，需要使用以下指令，重新加载：

   ```sh
   $ systemctl daemon-reload
   ```

## 用户说明

lnmp 环境下我们需要关注下面几个用户：

| 用户    | 描述                             | 是否创建                |
| ------- | -------------------------------- | ----------------------- |
| nobody  | 权限最低的用户                   | 系统自动创建            |
| nofroup | 权限最低的用户组                 | 系统自动创建            |
| mysql   | MariaDB 用户/用户组              | 安装 MariaDB 时自动创建 |
| nginx   | Nginx 和 php-fpm 监听用户/用户组 | 自己创建                |
| www     | 站点、FTP/SFTP 用户/用户组       | 自己创建                |

1. php-fpm 工作池配置文件下的两种用户说明：

   | 配置文件指令   | 描述                                 |
   | -------------- | ------------------------------------ |
   | `user`         | 进程用户，`nobody` 即可              |
   | `group`        | 进程用户组，`nogroup` 即可           |
   | `listen.owner` | socket 监听用户，与 nginx 相同即可   |
   | `listen.group` | socket 监听用户组，与 nginx 相同即可 |

2. 创建 nginx 用户：

   ```sh
   # 创建一个名为nginx，id号为2000的用户组
   $ groupadd -g 2000 nginx
   # 创建一个名为nginx，id号为2000的用户，所属用户组为nginx，并且不创建家目录（-M 不创建家目录）
   $ useradd -c 'Users of the Nginx service and php-fpm service' -u 2000 -s /usr/sbin/nologin -M -g nginx nginx
   ```

3. 创建 www 用户：

   ```sh
   $ groupadd -g 2001 www
   $ useradd -c 'Users of the FTP and sites' -u 2001 -s /usr/sbin/nologin -d /server/www -m -g www www
   ```

## 附录一：为什么 PHP 无法使用 PDO 操作 MariaDB ？

| 步骤 | 说明                                                                           |
| ---- | ------------------------------------------------------------------------------ |
| 01   | `pdo_mysql.default_socket` 默认值为 `/tmp/mysql.sock`                          |
| 02   | `MariaDB` 的 `socket` 路径为 `/server/run/mariadb/mariadb.sock`                |
| 03   | `php.ini` 下修改： `pdo_mysql.default_socket=/server/run/mariadb/mariadb.sock` |
| 04   | 重启 `php-fpm` 即可                                                            |

> 提示：`php.ini` 跟 `php执行文件 和 php-fpm` 息息相关，`Nginx` 只接收 php-fpm 转发的数据，实际并未参与，所以不必重启 `Nginx`。

## 附录二：`init.d` `systemctl` 启动操作混用，导致项目无法停止怎么办？

| 步骤 | 描述                                                                                     |
| ---- | ---------------------------------------------------------------------------------------- |
| 01   | `init.d` `systemctl`由两个不同程序控制，所以不能混用                                     |
| 02   | 通过 `/lib/systemd/systemd-sysv-install` 方式让 `systemctl` 代理执行 `init.d` 时支持混用 |
| 03   | 使用 `pkill -9 <进程名>` 或 `kill -9 <pid>` 来强制停止                                   |
| 04   | 混用非常糟糕，这里推荐使用 `service` 指令控制                                            |
