# 搭建 vsftpd 服务

vsftpd 可能是类 unix 系统中最安全、最快的 FTP 服务器。

## 安装 vsfptd

```sh
$ apt install vsftpd
```

## 必要知识点

想要完全掌握 vsftpd，我们有必要深入了解以下内容：

| 知识点               | 链接                                                            |
| -------------------- | --------------------------------------------------------------- |
| vsftpd 配置选项      | [vsfptd.conf 选项说明](./manual/03-vsftpd.conf选项说明.md)      |
| 可插入式授权管理模块 | [Linux 下可插入身份验证模块 PAM](./06-可插入身份验证模块PAM.md) |

## 配置参数

vsftpd 有很多参数，下面列出我们必须掌握的参数选项：

| vsftpd 配置参数 | 描述 |
| --------------- | ---- |


> 关于 vsftpd 配置参数的详细讲解，请查阅

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

3. 参考配置文件

   文件路径： `/etc/vsftpd.conf`

   ```conf
   anonymous_enable=NO
   local_enable=YES
   ssl_enable=YES
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

````

## 创建本地用户，用于登陆 vsftpd

1. 创建用户组及用户

```sh
$ groupadd -g 2001 www
$ useradd -c 'Users of the vsftpd user' -u 2001 -s /usr/sbin/nologin -M -g www www
````

2. `/server/www` 目录权限

   > 需要保证 www 用户没有读取 `/server/www` 目录的权限

   ```sh
   $ chmod -x /server/www
   $ chmod -x /server/www
   ```
