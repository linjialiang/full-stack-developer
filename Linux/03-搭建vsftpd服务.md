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

配置文件源码参考 [vsftpd.conf](./source/vsftpd.conf)

1. 输出有用的配置信息：

   ```sh
   $ cat /etc/vsftpd.conf |sed s/^" "*//g |sed /^$/d |sed /^#/d
   ```

   > 备注：`行首的空格、空行、备注行` 这 3 类都不会输出！

2. 相关配置参数讲解：

   | vsftpd 参数                              | 参数描述                                       |
   | ---------------------------------------- | ---------------------------------------------- |
   | anonymous_enable=NO                      | 禁用匿名用户登陆                               |
   | local_enable=YES                         | 启用本地用户登陆                               |
   | ssl_enable=NO                            | 禁用 ftps                                      |
   | write_enable=YES                         | 允许 ftp 客户端写操作                          |
   | listen=NO                                | 禁用 ipv4 监听方式                             |
   | listen_ipv6=YES                          | 启用 ipv6 监听方式                             |
   | listen_port=21                           | 监听端口                                       |
   | port_enable=NO                           | 禁用主动模式                                   |
   | pasv_enable=YES                          | 启用被动模式                                   |
   | pasv_max_port=21001                      | 被动模式，端口号区间最小值                     |
   | pasv_min_port=21099                      | 被动模式，端口号区间最大值                     |
   | accept_timeout=60                        | ftp 连接的最长响应时间                         |
   | file_open_mode=0666                      | 上传文件的权限                                 |
   | idle_session_timeout=300                 | ftp 命令发出的最长响应时间                     |
   | local_max_rate=8192                      | 本地用户最大数据传输速率                       |
   | local_umask=022                          | 本地用户权限                                   |
   | max_per_ip=3                             | 最多可连接 ip 数量                             |
   | max_clients=10                           | 最多可连接的客户端数量                         |
   | max_login_fails=3                        | 登陆失败 3 次，禁止登陆                        |
   | trans_chunk_size=8192                    | 获得更加平滑的带宽限制器                       |
   | chroot_local_user=YES                    | 将用户绑定到家目录，chroot_list 列出的用户除外 |
   | chroot_list_enable=YES                   | 将用户绑定到家目录，chroot_list 列出的用户除外 |
   | chroot_list_file=/etc/vsftpd/chroot_list | 将用户绑定到家目录，chroot_list 列出的用户除外 |
   | userlist_enable=YES                      | 仅允许 user_list 列出的用户，登陆 vsftpd       |
   | userlist_deny=NO                         | 仅允许 user_list 列出的用户，登陆 vsftpd       |
   | userlist_file=/etc/vsftpd/user_list      | 仅允许 user_list 列出的用户，登陆 vsftpd       |
   | pam_service_name=vsftpd                  | 此字符串是 vsftpd 将使用的 PAM 服务的名称      |

   > 提示：关于 vsftpd 配置参数的详细讲解，请到 [vsfptd.conf 选项说明](./manual/03-vsftpd.conf选项说明.md) 查阅

3. 修改 vsftpd 的 PAM 配置文件

   | 配置文件路径 | `/etc/pam.d/vsftpd`             |
   | ------------ | ------------------------------- |
   | 注释掉 1 行  | `# auth required pam_shells.so` |

## 创建本地用户，用于登陆 vsftpd

1.  创建用户组及用户

    ```sh
    $ mkdir /server/www
    $ groupadd -g 2001 www
    $ useradd -c 'Users of the vsftpd user' -u 2001 -s /usr/sbin/nologin -d /server/www -g www www
    ```

    我们将用户绑定到家目录，这就需要保证用户对家目录没有写的权限，具体操作如下：

    ```sh
    $ chmod -w /server/www
    ```

2.  创建其他用户

    ```sh
    $ mkdir /server/www/qyadmin
    $ useradd -c 'Users of the vsfptd user' -u 2002 -s /usr/sbin/nologin -d /server/www/qyadmin -g www qyadmin
    ```

    设置目录权限，具体操作如下：

    ```sh
    $ chown www:www /server/www/qyadmin
    ```

3.  开放用户登陆 ftp

    将用户加入 `/etc/vsfptd/user_list` 文件下，才能正常访问。
