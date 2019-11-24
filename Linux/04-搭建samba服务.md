# 搭建 samba 服务

samba 服务可以让局域网的 Windows 和 linux 的文件共享，便于我们后期开发使用！

## 安装 samba

安装很简单，只需要下面一条命令即可：

```sh
$ apt install samba
```

## samba 配置文件

`/etc/samba/smb.conf` 是 samba 的配置文件。

### 配置文件内容分类

samba 的配置文件内容主要分为以下 3 类：

| 内容分类     | 描述                    |
| ------------ | ----------------------- |
| `[global]`   | 全局设置，              |
| `[homes]`    | 共享-默认设置           |
| `[共享分组]` | 共享-每个子类的具体设置 |

1. `[globale]` 中需要注意的是 `workgroup = WORKGROUP` 要跟 Windows 的用户组名一致
2. `[homes]` 基本上没特殊需求不用修改
3. `[共享分组]` 根据我们需要自定义设置

### `[共享分组]`

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
| `create mask = 0644`                 | 操作文件权限                           |
| `directory mask = 0755`              | 操作目录权限                           |

> 提示：`writable` 和 `read only` 不能同时设置成 `yes`！

## 创建samba用户



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
