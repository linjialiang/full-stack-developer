# 搭建 samba 服务

samba 主要用于局域网内的文件共享，支持 Windows 和 linux 相互共享！

> 提示：samba 只能在内网之间使用，而 ftp 同时支持外网和内网使用。

## 开发人员使用 samba 的好处

通常我们使用 windows 做开发环境，使用 Linux 作为服务器，由于系统的差异，在实际部署时可能会遇到各种问题，这个时候我们可以用 samba 来解决这个问题：

| 操作 | 详细说明                                                          |
| ---- | ----------------------------------------------------------------- |
| 01   | 在局域网搭建一台 linux 服务器                                     |
| 02   | 在 Linux 服务器下安装 samba server                                |
| 03   | 配置好 samba 用户即上传权限跟 ftp 用户权限一致                    |
| 04   | windows 本机通过资源管理器，连接到 samba 服务器                   |
| 05   | 通过以上 4 步后，我们就可以使用本机 IDE 直接操作 Linux 上的项目了 |

> 提示：由于 samba 连接后，可以操作远程整个项目，所以 IDE 提示与本地项目完全一致！

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

| 内容分类         | 描述                       |
| ---------------- | -------------------------- |
| `[global]`       | 全局模块                   |
| `[homes]`        | 默认共享模块（可直接删除） |
| `[自定义共享名]` | 共享模块                   |

> 这是一个 smb 配置文件案例点击 [smb.conf](./source/smb.conf) 查阅

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

`共享模块` 没有设置的参数，将自动获取该模块里的参数,参数与 `共享模块` 完全相同，我这里由于共享分组很少，就没有设置默认共享模块了！

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

### 共享目录权限说明

| 操作     | 权限                 |
| -------- | -------------------- |
| 浏览文件 | 登陆用户必须有读权限 |
| 下载文件 | 登陆用户必须有读权限 |
| 上传文件 | 登陆用户必须有写权限 |
| 修改文件 | 登陆用户必须有写权限 |

> 提示：samba 配置文件设定的权限和 linux 系统设置的权限必须同时具备，才能拥有对应操作权限！

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

## 附录一、windows 下切换已登录的共享资源

1. 打开 `运行` -> 输入 `cmd` -> 按回车 -> 输入 `net use \* /del /y`

2. 输入 `win+e` 打开资源管理器 -> 在任务管理器中重启资源管理器

3. 打开 `运行` -> 输入 `\\192.168.10.251` -> 之后就会提示重新登陆账号密码

4. 如果是选择了记住凭据，还需要去控制面板修改密码：

   ```sh
   -- 控制面板 -> 所有控制面板项 -> 凭据管理器 -> Windows 凭据
   -- 找到该凭据， 一般带有后面中括号里的字样 【\\192.168.10.251】
   -- 可以直接删除掉，也可以选择修改账户密码
   -- 最后，重启资源管理器
   ```

## 附录二、利用 samba 实现局域网开发注意事项

| 序号 | 注意事项                                                   |
| ---- | ---------------------------------------------------------- |
| 01   | 将 samba 用户及用户组设置为 www                            |
| 02   | 将 /server/www 目录设置为 smb 家目录                       |
| 03   | 将系统用户 www 设为 /bin/bash 方式登陆，方便 composer 操作 |
| 04   | /server/www 目录权限设为 750                               |
| 05   | 直接将服务器上的项目加入到编辑器上，即可实现局域网开发     |

```sh
$ usermod -s /bin/bash www
$ chown www:www /server/www
$ chmod 750 /server/www
$ chown www:www /server/default
$ chmod 755 /server/default
```
