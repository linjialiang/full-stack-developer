# 搭建 vsftpd 服务

vsftpd 可能是类 unix 系统中最安全、最快的 FTP 服务器。

## 一、安装 vsftpd

```sh
$ apt install vsftpd
```

## 二、必要知识点

想要完全掌握 vsftpd，我们有必要深入了解以下内容：

| 知识点               | 链接                                                       |
| -------------------- | ---------------------------------------------------------- |
| vsftpd 配置选项      | [vsftpd.conf 选项说明](./manual/03-vsftpd.conf选项说明.md) |
| 可插入式授权管理模块 | [Linux-PAM](./06-PAM.md)                                   |

## 三、配置文件参考源码

| 登陆方式     | 配置文件                                                                     |
| ------------ | ---------------------------------------------------------------------------- |
| 系统用户登陆 | [vsftpd(本地用户登陆版).conf](<./source/vsftpd/vsftpd(本地用户登陆版).conf>) |
| 虚拟用户登陆 | [vsftpd(虚拟用户登陆版).conf](<./source/vsftpd/vsftpd(虚拟用户登陆版).conf>) |

## 四、配置参数

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
| pasv_min_port=21010                      | 被动模式，端口号区间最大值                              |
| accept_timeout=30                        | 被动模式，30 秒无法连接成功就主动断开连接               |
| idle_session_timeout=300                 | 300 秒内，vsftpd 没有收到该客户端的操作指令，则断开链接 |
| data_connection_timeout=600              | 文件传输时，超过 600 秒没有完成就断开传输               |
| local_max_rate=8192                      | 本地用户最大数据传输速率                                |
| max_per_ip=3                             | 最多可连接 ip 数量                                      |
| max_clients=10                           | 最多可连接的客户端数量                                  |
| max_login_fails=3                        | 登陆失败 3 次，禁止登陆                                 |
| trans_chunk_size=8192                    | 获得更加平滑的带宽限制器                                |
| chroot_local_user=YES                    | 将 ftp 登陆用户限制在家目录，chroot_list 列出的用户除外 |
| chroot_list_enable=YES                   | 将 ftp 登陆用户限制在家目录，chroot_list 列出的用户除外 |
| chroot_list_file=/etc/vsftpd/chroot_list | 将 ftp 登陆用户限制在家目录，chroot_list 列出的用户除外 |

| 系统用户登陆特定参数                | 参数描述                                    |
| ----------------------------------- | ------------------------------------------- |
| pam_service_name=vsftpd             | 设置 PAM 认证服务所使用的配置文件名         |
| userlist_enable=YES                 | 仅允许 user_list 文件列出的用户名，登陆 ftp |
| userlist_deny=NO                    | 仅允许 user_list 文件列出的用户名，登陆 ftp |
| userlist_file=/etc/vsftpd/user_list | 仅允许 user_list 文件列出的用户名，登陆 ftp |

| 虚拟用户登陆特定参数                | 参数描述                                 |
| ----------------------------------- | ---------------------------------------- |
| pam_service_name=vsftpd-guest       | 设置 PAM 认证服务所使用的配置文件名      |
| virtual_use_local_privs=yes         | 虚拟用户将使用与本地用户相同的权限       |
| guest_enable=yes                    | 开启虚拟用户登陆                         |
| guest_username=www                  | 虚拟用户映射的系统用户                   |
| local_root=/server/default          | 设置用户登陆时的默认根目录               |
| user_config_dir=/server/vsftpd      | 虚拟用户单独配置文件存放目录             |
| userlist_enable=YES                 | user_list 文件列出的用户名，禁止登陆 ftp |
| userlist_deny=YES                   | user_list 文件列出的用户名，禁止登陆 ftp |
| userlist_file=/etc/vsftpd/user_list | user_list 文件列出的用户名，禁止登陆 ftp |

> 提示：关于 vsftpd 更多的配置参数，请参考 [vsftpd.conf 选项说明](./manual/03-vsftpd.conf选项说明.md)

## 五、系统用户登陆相关

1. 修改 vsftpd 的 PAM 配置文件

   配置文件路径 /etc/pam.d/vsftpd 具体操作如下：

   ```sh
   # 注释如下内容
   auth required pam_shells.so
   ```

   > 说明： PAM 的 pam_shells.so 模块用于认证用户是否支持 shell 登陆

2. 创建系统用户组及系统用户

   创建本地系统用户，用于登陆 vsftpd

   ```sh
   $ useradd -c 'Users of the vsftpd user' -u 2003 -s /usr/sbin/nologin -d /server/www -M -U www
   ```

3. 修改家目录权限

   将用户限制在家目录，需要保证登陆用户对家目录不具备写权限，否则 PAM 认证无法通过，具体操作如下：

   ```sh
   $ chmod 550 /server/www
   ```

4. 创建更多的系统用户

   创建更多的系统用户，用于登陆 vsftpd，并指定不同的家目录

   ```sh
   $ useradd -c 'Users of the vsftpd user' -u 2004 -s /usr/sbin/nologin -d /server/www/qyadmin -M -g www qyadmin
   $ chmod 750 /server/www/qyadmin
   ```

5. 指定允许登陆的系统用户

   必须将用户名加入到 /etc/vsftpd/user_list 文件列表内，否则 PAM 认证依然无法通过，具体操作如下：

   ```text
   www
   qyadmin
   ```

## 六、虚拟用户登陆相关

关于 vsftpd 虚拟用户登陆相关信息，请参考[vsftpd 虚拟用户登陆认证](./manual/07-vsftpd虚拟用户登陆认证.md)

## 七、附录：vsftpd 问题汇总

1. 问：为什么虚拟用户要使用与本地用户相同的权限？

   答：为了保证 web 安全性，文件的权限要求是不同的，如果虚拟用户使用匿名用户的权限，就不能直接操作这些文件的权限，而需要通过终端来解决。

   ```text
   - vsftpd 的初衷就是为了方便；
   - 如果使用匿名用户权限就改变了这个初衷；
   - 而使用本地用户映射，不仅安全性没有太大降低，而且也大大的提升了方便性；
   ```

2. 问：虚拟用户登陆 ftp 总是不能操作根目录，有没有解决办法？

   答：这是硬伤，只要满足了以下两个要求，根目录就不能有写的权限：

   | 序号 | 权限要求                     |
   | ---- | ---------------------------- |
   | 01   | ftp 登陆用户具有本地用户权限 |
   | 02   | ftp 登陆用户限制在家目录     |

   ```text
   - 这也是网上很多教程都将虚拟用户权限设置为匿名用户的原因之一
   ```
