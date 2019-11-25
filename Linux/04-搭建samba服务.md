# 搭建 samba 服务

samba 主要用于局域网内的文件共享，支持 Windows 和 linux 相互共享！

> 提示：samba 只能在内网之间使用，而 ftp 同时支持外网和内网使用。

## 安装 samba

`Debian10.x` 安装很简单，只需要一条命令即可：

```sh
$ apt install samba
```

## samba 守护进程

samba 有三个守护进程，分别为：

| 守护进程启动脚本 | 描述                                   |
| ---------------- | -------------------------------------- |
| smbd             | 处理，`文件和打印服务`、`授权与被授权` |
| nmbd             | 处理，名字解析、浏览服务               |
| samba-ad-dc      | 处理，域控制器                         |

## samba 指令

| shell 指令                | 描述                                  |
| ------------------------- | ------------------------------------- |
| service smbd start        | 开启 smbd 守护进程                    |
| service nmbd start        | 开启 nmbd 守护进程                    |
| service samba-ad-dc start | 开启 nmbd 守护进程                    |
| testparms                 | 测试 samba.conf 配置文件正确性        |
| smbstatus                 | 列出当前 smbd 服务器上的连接          |
| smbpasswd                 | samba 的用户密码管理工具              |
| pdtedit                   | 当下的 samba 数据管理工具（管理用户） |

1. smbpasswd 指令说明

   | smbpasswd 指令 | 指令说明 |
   | -------------- | -------- |


## samba 配置文件

samba 虽然有多个守护进程，但是配置项都在 `/etc/samba/smb.conf` 文件里。

### 配置文件内容分类

samba 的配置文件内容主要分为以下 3 类：

| 内容分类         | 描述     |
| ---------------- | -------- |
| `[global]`       | 全局模块 |
| `[homes]`        | 默认模块 |
| `[自定义共享名]` | 共享模块 |

### 全局模块

### 共享模块

samba 配置文件下，可以根据自己需要，配置多个共享分组，具体参数如下：

| `[共享分组]`参数                     | 参数说明                               |
| ------------------------------------ | -------------------------------------- |
| `[共享分组]`                         | 该共享分组名                           |
| `comment = message`                  | 该共享分组描述                         |
| `path = 路径`                        | 该共享分组路径                         |
| `browseable = yes/no`                | 指定该共享是否可以浏览                 |
| `writable = yes/no`                  | 指定该共享路径是否可写                 |
| `read only = yes/no`                 | 指定该共享路径是否只读                 |
| `available = yes/no`                 | 指定该共享资源是否可用                 |
| `admin users = user1, @group1`       | 指定该共享的管理员（具有完全控制权限） |
| `valid users = user1, user2`         | 允许访问该共享的用户                   |
| `invalid users = user1, user2`       | 禁止访问该共享的用户                   |
| `write list = user1, user2, @group1` | 允许写入该共享的用户                   |
| `public = yes/no`                    | 指定该共享是否允许 guest 账户访问      |
| `guest ok = yes/no`                  | 与 `public` 相同                       |
| `create mask = 0640`                 | 上传文件权限                           |
| `directory mask = 0750`              | 上传目录权限                           |

> 提示：`writable` 和 `read only` 不能同时设置成 `yes`！

## 创建 samba 用户

## 局域网直接开发

1. 最简单的一个共享分组

   ```sh
   ...
   [www]
   comment = www
   path = /server/www
   browseable = yes
   writable = yes
   read only = no
   available = yes
   admin users = www
   valid users = @www
   write list = @www
   public = no
   create mask = 0644
   directory mask = 0755
   ```
