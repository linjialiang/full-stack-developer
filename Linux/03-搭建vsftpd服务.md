# 搭建 vsftpd 服务

vsftpd 可能是类 unix 系统中最安全、最快的 FTP 服务器。

## 安装 vsfptd

```sh
$ apt install vsftpd
```

## 配置参数

vsftpd 有很多参数，下面列出我们必须掌握的参数选项：

| vsftpd 配置参数 | 描述 |
| --------------- | ---- |


> 关于 vsftpd 配置参数的详细讲解，请查阅 [vsfptd.conf 选项说明](./manual/03-vsftpd.conf选项说明.md)

## 配置文件

1. 输出有用的配置信息：

   ```sh
   $ cat /etc/vsftpd.conf |sed s/^" "*//g |sed /^$/d |sed /^#/d
   ```

   > 备注：`行首的空格、空行、备注行` 这 3 类都不会输出！

2. vsftpd 如何配置？

   | 选项模块        | 说明           |
   | --------------- | -------------- |
   | 匿名模块        | 关闭           |
   | sftp 模块       | 不需要开启     |
   | 日志模块        | 不需要特别关注 |
   | 权限模块        | 默认即可       |
   | vsftpd 用户模块 | 默认即可       |
   | 消息模块        | 默认即可       |

3. 真正需要关注的选项？

   | 关注选项               | 描述                                                                          |
   | ---------------------- | ----------------------------------------------------------------------------- |
   | `anonymous_enable`     | 是否允许匿名用户登陆                                                          |
   | `ascii_upload_enable`  | 是否接受 ASCII 模式的数据传输                                                 |
   | `chroot_list_enable`   | 是否开启 `chroot()` 监狱                                                      |
   | `chroot_local_user`    | 用户是否处于 `chroot()` 监狱中                                                |
   | `chroot_list_file`     | `chroot()` 用户列表                                                           |
   | `passwd_chroot_enable` | `chroot()` 监狱中，每个用户的根目录都是从 `/etc/passwd` 中派生                |
   | `listen`               | vsftpd 将侦听 IPv4 套接字                                                     |
   | `listen_ipv6`          | vsftpd 将侦听 IPv6 套接字                                                     |
   | `pasv_enable`          | 是否启用`被动模式`获取数据连接                                                |
   | `accept_timeout`       | 远程客户端与被动模式数据连接建立连接的超时时间                                |
   | `port_enable`          | 是否启用`主动模式`获取数据连接                                                |
   | `ssl_enable`           | 是否启用 SSL 的安全连接。                                                     |
   | `use_localtime`        | 是否显示当前时区中包含时间的目录列表（默认为显示 GMT）                        |
   | `userlist_enable`      | 是否拒绝用户登陆                                                              |
   | `userlist_deny`        | 是否拒绝用户登陆                                                              |
   | `userlist_file`        | 此选项是 userlist_enable=YES 时加载的文件的名称。                             |
   | `file_open_mode`       | 用于创建上传文件的权限。Umasks 应用于此值之上。                               |
   | `idle_session_timeout` | 远程客户端在 FTP 命令之间可能花费的最长时间。如果超时触发，则启动远程客户端。 |
   | `listen_port`          | 侦听传入 FTP 连接的端口号                                                     |
   | `local_max_rate`       | 本地认证登陆的用户，允许的最大数据传输速率                                    |
   | `local_umask`          | 为本地用户设置用于文件创建的 umask 的值                                       |
   | `max_clients`          | 可以连接的最大客户端数量                                                      |
   | `max_per_ip`           | 与服务器处于同一网络的不同 IP 地址最大客户端数。                              |
   | `max_login_fails`      | 多次登录失败后，会话将被终止                                                  |
   | `pasv_max_port`        | 被动模式数据连接分配的最大端口号。                                            |
   | `pasv_max_port`        | 被动模式数据连接分配的最大端口号。                                            |
   | `trans_chunk_size`     | 请尝试将其设置为 `8192`，以获得更加平滑的带宽限制器。                         |
   | `deny_file`            | 此选项可用于设置，让某些指定的文件名（包括目录名）无法访问；                  |
   | `hide_file`            | 此选项可用于设置文件名（包括目录名）从目录列表中隐藏。                        |
   | `local_enable`         | 必须启用此选项才能使任何非匿名登录（包括虚拟用户）正常工作。                  |

4. 参考配置文件

   文件路径： `/etc/vsftpd.conf`

   ```conf
   ssl_enable=NO
   anonymous_enable=NO
   local_enable=YES
   ascii_upload_enable=NO

   listen=NO
   listen_ipv6=YES
   listen_port=21

   port_enable=NO
   pasv_enable=YES
   pasv_max_port=21001
   pasv_min_port=21099

   accept_timeout=60
   use_localtime=YES
   file_open_mode=0666
   idle_session_timeout=300
   local_max_rate=8192
   local_umask=077

   max_per_ip=1
   max_clients=10
   max_login_fails=3

   trans_chunk_size=8192

   chroot_local_user=YES
   chroot_list_enable=YES
   passwd_chroot_enable=NO
   chroot_list_file=/etc/vsftpd.chroot_list

   userlist_deny=YES
   userlist_enable=NO
   userlist_file=/etc/vsftpd.user_list
   ```

## 创建本地用户，用于登陆 vsftpd

1. 创建用户组及用户

   ```sh
   $ groupadd -g 2001 www
   $ useradd -c 'Users of the vsftpd user' -u 2001 -s /usr/sbin/nologin -m -c /server/www -g www www
   ```

2. `/server/www` 目录权限

   > 需要保证 www 用户没有读取 `/server/www` 目录的权限

   ```sh
   $ chmod -x /server/www
   $ chmod -x /server/www
   ```
