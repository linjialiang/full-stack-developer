# Systemd 实战篇

上一篇文章，介绍了 Systemd 的主要命令，今天介绍如何使用它完成一些基本的任务。

## 一、开机启动

对于那些支持 Systemd 的软件，安装的时候，会自动在 `/usr/lib/systemd/system` 目录添加一个配置文件。

### 支持 Systemd 的软件

如果你想让这类软件开机启动，就执行下面的命令:

```sh
$ systemctl enable nginx
```

重新加载 `Systemd` 配置文件

```sh
$ systemctl daemon-reload
```

### 不支持 Systemd 的软件

1. 这类软件需要直接编写 Systemd 单元(Unit)文件，如：

   Nginx 单元文件请参考：[nginx.service](./../lnmp/source/nginx/nginx.service)

2. 将单元文件移动至 /usr/lib/systemd/system 目录：

   ```sh
   $ cp nginx.service /usr/lib/systemd/system/
   ```

3. 使用类似如下指令加入开机启动：

   ```sh
   $ systemctl enable nginx
   ```

4. 重新加载 `Systemd` 配置文件

   ```sh
   $ systemctl daemon-reload
   ```

> 提示：编写的单元文件必须要支持开机启动，否则无效，具体方法将下面讲解！

## 二、读懂单元(Unit)文件

只有了解了单元文件各种字段的实际意义，我们才能更好的编写它，这里只讲常用的内容。

### [Unit] 区块

[Unit] 区块通常是配置文件的第一个区块，用来定义 Unit 的元数据，以及配置与其他 Unit 的关系。

| 字段        | 描述                               |
| ----------- | ---------------------------------- |
| Description | 当前单元的简单描述                 |
| Wants       | 这些单元没有运行，当前单元允许启动 |
| Requires    | 这些单元没有运行，当前单元无法启动 |
| Conflicts   | 不允许同时启动的单元               |

Nginx [Unit] 区块案例：

```sh
[Unit]
Description=Nginx 1.16.1
Wants=mariadb.service php-fpm.service
```

### [Service] 区块

[Service]区块用来 Service 的配置，只有 Service 类型的 Unit 才有这个区块。

| 字段       | 描述                                                     |
| ---------- | -------------------------------------------------------- |
| Type       | 定义启动时的进程行为，通常设为：Type=forking             |
| PIDFile    | PID 文件路径，在 Type=forking 的情况下需要明确设置此选项 |
| ExecStart  | 启动当前服务的命令，仅一条                               |
| ExecReload | 重启当前服务时执行的命令，允许多条                       |
| Restart    | 定义自动重启当前服务的情况，通常设为：on-failure         |

Nginx 的 [Service] 区块案例：

```sh
[Service]
Type=forking
PIDFile=/server/run/nginx/nginx.pid
ExecStart=/server/nginx/sbin/nginx
ExecReload=/server/nginx/sbin/nginx -s reload
Restart=on-failure
```

> 说明：systemd 本身就会停止和重启守护进程，如果没有其它依赖这 5 个配置项足够用了

### [Install] 区块

[Install]通常是配置文件的最后一个区块，用来定义如何启动，以及是否开机启动。

| 字段     | 描述                                                       |
| -------- | ---------------------------------------------------------- |
| WantedBy | 定义是否允许开机启动，通常设为：WantedBy=multi-user.target |
| Alias    | 当前 Unit 可用于启动的别名                                 |

MariaDB 的 [Install] 区块案例：

```sh
[Install]
WantedBy=multi-user.target
Alias=mysql mysqld
```

> 提示： `multi-user.target` 这个 target 通常总是开机启动的

### 附录：修改开机默认运行的 `target`

Debian 10.x 采用加载 `target` 的方式来替代之前的启动级别

1. Linux 下 7 种运行级别，分别是：

   | 级别编号 | 级别描述                                                                 |
   | -------- | ------------------------------------------------------------------------ |
   | 0        | 关机                                                                     |
   | 1        | 单用户（找回丢失密码）此模式下所有用户不需要密码即可登录，可用于重置密码 |
   | 2        | 多用户状态没有网络服务                                                   |
   | 3        | 多用户状态有网络服务 ★                                                   |
   | 4        | 系统未使用保留给用户                                                     |
   | 5        | 图形界面 ★                                                               |
   | 6        | 系统重启                                                                 |

2. 重要的运行级别

   | 级别编号 | 对应的 target     |
   | -------- | ----------------- |
   | 3        | multi-user.target |
   | 5        | graphical.target  |

   > 提示：`graphical.target` 包含 `multi-user.target`，所以发行版默认启动的只要是其中任何一个就可以了

3. `target` 相关指令

   ```sh
   # 查看当前默认启动的 target：
   $ systemctl get-default
   # 修改默认启动的 target 为 multi-user.target
   $ systemctl set-default multi-user.target
   ```

## 三、单元(Unit)文件案例

这里列出了自己编写的 Unit 文件：

| 程序  | Unit 文件路径                                         |
| ----- | ----------------------------------------------------- |
| nginx | [nginx.service](./../lnmp/source/nginx/nginx.service) |
