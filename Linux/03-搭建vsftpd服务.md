# 搭建 vsftpd 服务

vsftpd 可能是类 unix 系统中最安全、最快的 FTP 服务器。

## 安装 vsfptd

```sh
$ apt install vsftpd
```

## 必要知识点

想要完全掌握 vsftpd，我们有必要深入了解以下内容：

| 知识点               | 链接                                                       |
| -------------------- | ---------------------------------------------------------- |
| vsftpd 配置选项      | [vsfptd.conf 选项说明](./manual/03-vsftpd.conf选项说明.md) |
| 可插入式授权管理模块 | [Linux-PAM](./06-PAM.md)                                   |

## 配置文件

配置文件参考源码:

| 登陆方式     | 配置文件                                        |
| ------------ | ----------------------------------------------- |
| 系统用户登陆 | [vsftpd.conf](./source/vsftpd.conf)             |
| 虚拟用户登陆 | [vsftpd.guest.conf](./source/vsftpd.guest.conf) |

### 配置参数

涉及到的配置参数详情如下：

| vsftpd 参数                    | 参数描述                                                |
| ------------------------------ | ------------------------------------------------------- |
| anonymous_enable=NO            | 禁用匿名用户登陆                                        |
| local_enable=YES               | 启用本地用户登陆                                        |
| ssl_enable=NO                  | 禁用 ftps                                               |
| download_enable=YES            | 允许 ftp 客户端下载文件                                 |
| write_enable=YES               | 允许 ftp 客户端写操作                                   |
| file_open_mode=0666            | 上传文件的权限                                          |
| local_umask=022                | 本地用户权限                                            |
| listen=NO                      | 禁用 ipv4 监听方式                                      |
| listen_ipv6=YES                | 启用 ipv6 监听方式                                      |
| listen_port=21                 | 监听端口                                                |
| port_enable=NO                 | 禁用主动模式                                            |
| pasv_enable=YES                | 启用被动模式                                            |
| pasv_max_port=21001            | 被动模式，端口号区间最小值                              |
| pasv_min_port=21099            | 被动模式，端口号区间最大值                              |
| accept_timeout=60              | 被动模式，60 秒无法连接成功就主动断开连接               |
| idle_session_timeout=600       | 600 秒内，vsftpd 没有收到该客户端的操作指令，则断开链接 |
| data_connection_timeout=500    | 文件传输时，超过 500 秒没有完成就断开传输               |
| local_max_rate=8192            | 本地用户最大数据传输速率                                |
| local_root=/server/www/default | 设置本地用户的缺省目录                                  |
| max_per_ip=3                   | 最多可连接 ip 数量                                      |
| max_clients=10                 | 最多可连接的客户端数量                                  |
| max_login_fails=3              | 登陆失败 3 次，禁止登陆                                 |
| trans_chunk_size=8192          | 获得更加平滑的带宽限制器                                |

| 系统用户登陆参数                         | 参数描述                                       |
| ---------------------------------------- | ---------------------------------------------- |
| pam_service_name=vsftpd                  | 设置 PAM 认证服务所使用的配置文件名            |
| chroot_local_user=YES                    | 将用户绑定到家目录，chroot_list 列出的用户除外 |
| chroot_list_enable=YES                   | 将用户绑定到家目录，chroot_list 列出的用户除外 |
| chroot_list_file=/etc/vsftpd/chroot_list | 将用户绑定到家目录，chroot_list 列出的用户除外 |
| userlist_enable=YES                      | 仅允许 user_list 列出的用户，登陆 vsftpd       |
| userlist_deny=NO                         | 仅允许 user_list 列出的用户，登陆 vsftpd       |
| userlist_file=/etc/vsftpd/user_list      | 仅允许 user_list 列出的用户，登陆 vsftpd       |

| 虚拟用户登陆参数              | 参数描述                            |
| ----------------------------- | ----------------------------------- |
| pam_service_name=vsftpd_guest | 设置 PAM 认证服务所使用的配置文件名 |
| virtual_use_local_privs=yes   | 虚拟用户将使用与本地用户相同的权限  |
| guest_enable=yes              | 开启虚拟用户登陆                    |
| guest_username=www            | 虚拟用户映射的系统用户              |

> 提示：关于 vsftpd 更多的配置参数，请参考 [vsfptd.conf 选项说明](./manual/03-vsftpd.conf选项说明.md)

### 系统用户登陆相关

1. 修改 vsftpd 的 PAM 配置文件

   | 配置文件路径 | `/etc/pam.d/vsftpd`             |
   | ------------ | ------------------------------- |
   | 注释掉 1 行  | `# auth required pam_shells.so` |

2. 创建系统用户组及系统用户

   创建本地系统用户，用于登陆 vsftpd

   ```sh
   $ mkdir /server/www
   $ groupadd -g 2001 www
   $ useradd -c 'Users of the vsftpd user' -u 2001 -s /usr/sbin/nologin -d /server/www -g www www
   ```

   > 注意：将用户限制在家目录，用户对家目录不能拥有写的权限，否则 vsftpd 会拒绝登陆，具体操作如下：

   ```sh
   $ chmod -w /server/www
   ```

3. 创建更多的系统用户

   创建更多的系统用户，用于登陆 vsftpd，并指定不同的家目录

   ```sh
   $ mkdir /server/www/qyadmin
   $ useradd -c 'Users of the vsfptd user' -u 2002 -s /usr/sbin/nologin -d /server/www/qyadmin -g www qyadmin
   ```

   设置目录权限，具体操作如下：

   ```sh
   $ chown www:www /server/www/qyadmin
   ```

4. 指定允许登陆的系统用户

   将系统用户加入 `/etc/vsfptd/user_list` 文件下，才能正常访问，`user_list` 文件具体内容如下：

   ```conf
   www
   qyadmin
   ```
