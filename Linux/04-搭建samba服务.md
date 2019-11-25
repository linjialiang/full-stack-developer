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
| pdbedit                   | 当下的 samba 数据管理工具（管理用户） |

1. smbpasswd 指令说明

   指令格式：`smbpasswd [选项] 用户名`

   | 选项 | 选项说明                        |
   | ---- | ------------------------------- |
   | `-a` | 添加系统用户为 smb 用户         |
   | `-d` | 禁用 smb 用户                   |
   | `-e` | 启用 smb 用户                   |
   | `-n` | 将指定用户的 smb 密码设置为空   |
   | `-x` | 将系统用户从 smb 用户列表中删除 |

   使用 `smbpasswd -h` 查看更多相关指令

2. pdbedit 指令说明

   指令格式：`pdbedit [选项] 用户名`

   | 选项          | 选项说明                                      |
   | ------------- | --------------------------------------------- |
   | `-a`          | 添加系统用户为 smb 用户                       |
   | `-r`          | 修改 smb 用户名（允许跟系统用户名不同）       |
   | `-x`          | 删除 smb 用户                                 |
   | `-L`          | 列出 smb 用户列表，读取 passdb.tdb 数据库文件 |
   | `-L -v`       | 列出 smb 用户列表，并附带详细信息             |
   | `-c "[D]" -u` | 暂停 smb 用户                                 |
   | `-c "[]" -u`  | 恢复 smb 用户                                 |

   使用 `pdbedit -h` 查看更多相关指令

> 提示： `smbpasswd` `pdbedit` 这两个管理工具对应着同一个数据库，所以两者可以混合使用。

## samba 配置文件

samba 虽然有多个守护进程，但是配置项都在 `/etc/samba/smb.conf` 文件里。

### 配置文件内容分类

samba 的配置文件内容主要分为以下 3 类：

| 内容分类         | 描述     |
| ---------------- | -------- |
| `[global]`       | 全局模块 |
| `[homes]`        | 默认模块 |
| `[自定义共享名]` | 共享模块 |

> 全局模块和默认模块不需要修改，主要修改 `自定义共享模块` 即可！

### 共享模块

samba 配置文件下，可以根据自己需要，配置多个共享分组，具体参数如下：

| `[共享分组]`参数                     | 参数说明                               |
| ------------------------------------ | -------------------------------------- |
| `[共享分组]`                         | 该共享分组名                           |
| `comment = message`                  | 该共享分组描述                         |
| `path = 路径`                        | 该共享分组路径                         |
| `browseable = yes/no`                | 指定该共享是否可以浏览                 |
| `read only = yes/no`                 | 指定该共享路径是否只读                 |
| `available = yes/no`                 | 指定该共享资源是否可用                 |
| `admin users = user1, @group1`       | 指定该共享的管理员（具有完全控制权限） |
| `valid users = user1, user2`         | 允许访问该共享的用户                   |
| `write list = user1, user2, @group1` | 允许写入该共享的用户                   |
| `guest ok = yes/no`                  | 指定该共享是否允许 guest 账户访问      |
| `create mask = 0640`                 | 上传文件权限                           |
| `directory mask = 0750`              | 上传目录权限                           |
| `directory mask = 0750`              | 上传目录权限                           |
| `directory mask = 0750`              | 上传目录权限                           |
| `force group = test`                 | 上传文件的所属用户                     |
| `force user = test`                  | 上传文件的所属用户组                   |
| ~~`invalid users = user1, user2`~~   | 禁止访问该共享的用户                   |
| ~~`writable = yes/no`~~              | ~~指定该共享路径是否可写~~             |
| ~~`public = yes/no`~~                | ~~指定该共享是否允许 guest 账户访问~~  |

> 提示：`writable` 和 `read only` 不能同时设置成 `yes`！

## 创建 samba 用户

## 局域网直接开发

1. 最简单的一个共享分组

   ```sh
   [test]
      	admin users = test
      	comment = this is my test samba
      	create mask = 0640
      	directory mask = 0750
      	force group = test
      	force user = test
      	path = /test
      	valid users = test
      	write list = test
   ```
