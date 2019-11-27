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

   | 选项    | 选项说明                                      |
   | ------- | --------------------------------------------- |
   | `-a`    | 添加系统用户为 smb 用户                       |
   | `-x`    | 删除 smb 用户                                 |
   | `-L`    | 列出 smb 用户列表，读取 passdb.tdb 数据库文件 |
   | `-L -v` | 列出 smb 用户列表，并附带详细信息             |

   使用 `pdbedit -h` 查看更多相关指令

> 提示： `smbpasswd` `pdbedit` 这两个管理工具对应着同一个数据库，所以两者可以混合使用。

## samba 配置文件

samba 虽然有多个守护进程，但是配置项都在 `/etc/samba/smb.conf` 文件里。

### 配置文件内容分类

samba 的配置文件内容主要分为以下 3 类：

| 内容分类         | 描述         |
| ---------------- | ------------ |
| `[global]`       | 全局模块     |
| `[homes]`        | 默认共享模块 |
| `[自定义共享名]` | 共享模块     |

> 全局模块和默认模块不需要修改，主要修改 `自定义共享模块` 即可！

### 全局模块

有几个参数需要设置，具体如下：

1. security 参数

   security 有 4 个值，分别如下：

   | 参数值              | 描述                                                                        |
   | ------------------- | --------------------------------------------------------------------------- |
   | `security = user`   | 共享目录只能被授权的用户访问,账号和密码需要通过 pdbedit 或 smbpasswd 建立。 |
   | `security = domain` | 基本用不到                                                                  |
   | `security = share`  | `samba 4.x` 后删除该值                                                      |
   | `security = server` | `samba 4.x` 后删除该值                                                      |

   > 提示：当前版本以 `security = user` 为默认值

2. `map to guest = bad user`

   如果登陆的用户名密码错误，自动转换成 guest 登陆。

3. `usershare allow guests` 参数

   是否允许 `guest` 登陆(匿名登陆)，`guest` 默认映射到 `nobody` 用户

   | 参数值                         | 描述               |
   | ------------------------------ | ------------------ |
   | `usershare allow guests = yes` | 允许匿名用户登陆   |
   | `usershare allow guests = no`  | 不允许你们用户登陆 |

4. 全局模块几种组合说明：

   允许匿名用户登陆共享：

   ```conf
   security = user
   usershare allow guests = yes
   ```

   允许登陆失败的用户，转成匿名用户登陆共享：

   ```conf
   security = user
   usershare allow guests = yes
   map to guest = bad user
   ```

### 默认共享模块

`共享模块` 没有设置的参数，将自动获取该模块里的参数,参数与 `共享模块` 完全相同！

### 共享模块

samba 配置文件下，可以根据自己需要，配置多个共享分组，具体参数如下：

| `[共享分组]`参数                     | 参数说明                                  |
| ------------------------------------ | ----------------------------------------- |
| `[共享分组]`                         | 该共享分组名                              |
| `browseable = yes/no`                | 指定该共享是否可以浏览                    |
| `create mask = 0640`                 | 上传文件权限                              |
| `directory mask = 0750`              | 上传目录权限                              |
| `comment = message`                  | 该共享分组描述                            |
| `path = 路径`                        | 该共享分组路径                            |
| `valid users = user1, user2`         | 允许访问该共享的用户                      |
| `write list = user1, user2, @group1` | 允许写入该共享的用户                      |
| `force group = test`                 | 指定上传文件的所属用户为 test             |
| `force user = test`                  | 指定上传文件的所属用户组为 test           |
| `read only = yes/no`                 | 指定该共享路径是否只读                    |
| `admin users = user1, @group1`       | 此列表的用户将映射为 `系统用户 root` 登陆 |
| `guest ok = yes/no`                  | 指定该共享是否允许 guest 账户访问         |
| `invalid users = user1, user2`       | 禁止访问该共享的用户                      |

> 提示：`writable` 和 `read only` 不能同时设置成 `yes`！

## 创建 samba 用户

我们推荐使用 `pdbedit` 工具将 `Linux用户` 变成 samba 用户，使用 `smbpasswd` 来修改用户的 samba 密码

1. 创建 Linux 系统用户

   ```sh
   $ groupadd test
   $ useradd -c 'this is samba user' -u 3001 -M -g test test
   ```

2. 将 Linux 用户变成 smb 用户

   ```sh
   $ pdbedit -a test
   # 或者
   $ pdbedit -a -u test
   ```

3. 删除 smb 用户

   ```sh
   $ pdbedit -x test
   ```

4. 查看 smb 用户

   ```sh
   $ pdbedit -L
   # 或者
   $ pdbedit -Lv
   ```

> 这是一个 smb 配置文件案例点击 [smb.conf](./source/smb.conf) 查阅
