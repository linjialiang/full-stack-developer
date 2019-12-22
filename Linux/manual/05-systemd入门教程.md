# Systemd 入门教程

Systemd 是一个 Linux 系统基础组件的集合，提供了一个系统和服务管理器，运行为 PID 1 并负责帮助其它程序启动守护进程。

## 一、Systemd 由来

历史上，Linux 的启动一直采用 init 进程。使用下面的命令用来启动服务：

```sh
$ /etc/init.d/nginx start
# 或者
$ service nginx start
```

这种方法有两个缺点：

| 缺点         | 缺点说明                                                                                    |
| ------------ | ------------------------------------------------------------------------------------------- |
| 启动时间长   | init 进程是串行启动，只有前一个进程启动完，才会启动下一个进程。                             |
| 启动脚本复杂 | init 进程只是执行启动脚本，不管其他事情。脚本需要自己处理各种情况，这往往使得脚本变得很长。 |

## 二、Systemd 概述

Systemd 就是为了解决上述问题而诞生的。它的设计目标是，为系统的启动和管理提供一套完整的解决方案。

1. Systemd 命名说明

   根据 Linux 惯例，字母 d 是守护进程（daemon）的缩写。 Systemd 这个名字的含义，就是它要守护整个系统。

2. Systemd 取代 init

   使用了 Systemd，就不需要再用 init 了。Systemd 取代了 initd，成为系统的第一个进程（PID 等于 1），其他进程都是它的子进程。

   ```sh
   # 查看 Systemd 的版本命令
   $ systemctl --version
   ```

## 三、Systemd 体系

支持 SysV 和 LSB 初始脚本，Systemd 的优点是功能强大，使用方便，缺点是体系庞大，非常复杂。具体包括：

| 序号 | Systemd 功能列表             |
| ---- | ---------------------------- |
| 01   | 替代 sysvinit                |
| 02   | 日志进程                     |
| 03   | 控制基础系统配置             |
| 04   | 维护登陆用户列表以及系统账户 |
| 05   | 运行时目录和设置             |
| 06   | 运行容器和虚拟机             |
| 07   | 简单的管理网络配置           |
| 08   | 网络时间同步                 |
| 09   | 日志转发                     |
| 10   | 名称解析                     |
| 11   | 其它更多功能                 |

## 四、systemd 基本工具

监视和控制 systemd 的主要命令是 systemctl。该命令可用于查看系统状态和管理系统及服务。

> 提示：在 systemctl 参数中添加 -H <用户名>@<主机名> 可以实现对其他机器的远程控制。该功能使用 SSH 连接。

1. 分析系统状态

   | 指令                                         | 描述                            |
   | -------------------------------------------- | ------------------------------- |
   | `$ systemctl status`                         | 显示系统状态                    |
   | `$ systemctl`                                | 输出激活的单元                  |
   | `$ systemctl list-units`                     | 输出运行失败的单元              |
   | `$ systemctl --failed`                       | 输出运行失败的单元              |
   | `$ systemctl list-unit-files`                | 查看所有已安装服务              |
   | `$ systemctl list-unit-files --type=service` | 列出指定类型的配置文件          |
   | `$ systemctl status pid`                     | 显示 cgroup slice, 内存和父 PID |

   > 提示：所有可用的单元文件存放在 `/usr/lib/systemd/system/` 和 `/etc/systemd/system/` 目录（后者优先级更高）。

2. 电源管理

   systemctl 是 Systemd 的主命令，用于管理系统。

   ```sh
   # 重启系统
   $ systemctl reboot

   # 关闭系统，切断电源
   $ systemctl poweroff

   # CPU停止工作
   $ systemctl halt

   # 暂停系统
   $ systemctl suspend

   # 让系统进入冬眠状态
   $ systemctl hibernate

   # 让系统进入交互式休眠状态
   $ systemctl hybrid-sleep

   # 启动进入救援状态（单用户状态）
   $ systemctl rescue
   ```

3. 查看启动耗时

   systemd-analyze 命令用于查看启动耗时。

   ```sh
   # 查看启动耗时
   $ systemd-analyze

   # 查看每个服务的启动耗时
   $ systemd-analyze blame

   # 显示瀑布状的启动过程流
   $ systemd-analyze critical-chain

   # 显示指定服务的启动流
   $ systemd-analyze critical-chain atd.service
   ```

4. 查看当前主机的信息

   hostnamectl 命令用于查看当前主机的信息。

   ```sh
   # 显示当前主机的信息
   $ hostnamectl

   # 设置主机名。
   $ hostnamectl set-hostname rhel7
   ```

5. 查看本地化设置

   localectl 命令用于查看本地化设置。

   ```sh
   # 查看本地化设置
   $ localectl

   # 设置本地化参数。
   $ localectl set-locale LANG=zh_CN.UTF-8
   $ localectl set-keymap zh_CN
   ```

6. 查看当前时区设置

   timedatectl 命令用于查看当前时区设置。

   ```sh
   # 查看当前时区设置
   $ timedatectl

   # 显示所有可用的时区
   $ timedatectl list-timezones

   # 设置当前时区
   $ timedatectl set-timezone America/New_York
   $ timedatectl set-time YYYY-MM-DD
   $ timedatectl set-time HH:MM:SS
   ```

7. 查看当前登录的用户

   ```sh
   # 列出当前session
   $ loginctl list-sessions

   # 列出当前登录用户
   $ loginctl list-users

   # 列出显示指定用户的信息
   $ loginctl show-user root
   ```

## 五、单元（Unit）管理

Systemd 可以管理所有系统资源。不同的资源统称为 Unit（单位）。

> 单元（Unit）类型一共分成 12 种:

```sh
-- Service unit：系统服务
-- Target unit：多个 Unit 构成的一个组
-- Device Unit：硬件设备
-- Mount Unit：文件系统的挂载点
-- Automount Unit：自动挂载点
-- Path Unit：文件或路径
-- Scope Unit：不是由 Systemd 启动的外部进程
-- Slice Unit：进程组
-- Snapshot Unit：Systemd 快照，可以切回某个快照
-- Socket Unit：进程间通信的 socket
-- Swap Unit：swap 文件
-- Timer Unit：定时器
```

> 一个单元（Unit）文件可以描述如下内容之一：

| 单元文件扩展  | 单元类型                     |
| ------------- | ---------------------------- |
| `*.service`   | 系统服务                     |
| `*.mount`     | 挂载点                       |
| `*.automount` | 自动挂载点                   |
| `*.slice`     | 进程组                       |
| `*.sockets`   | 进程间通信的 socket          |
| `*.device`    | 系统设备                     |
| `*.swap`      | 交换分区                     |
| `*.path`      | 文件或路径                   |
| `*.target`    | 多个单元（Unit）构成的一个组 |
| `*.timer`     | 由 systemd 管理的计时器      |

使用 systemctl 控制单元时，通常需要使用单元文件的全名，包括扩展名（例如 sshd.service ）。但是有些单元可以在 systemctl 中使用简写方式：

| 序号 | 单元名简写案例                                                                                 |
| ---- | ---------------------------------------------------------------------------------------------- |
| 01   | 如果无扩展名，systemctl 默认把扩展名当作 .service 。例如： `netcfg` 等价于 `netcfg.service` ； |
| 02   | 挂载点会自动转化为相应的 .mount 单元。例如： `/home` 等价于 `home.mount` ；                    |
| 03   | 设备会自动转化为相应的 .device 单元。所以： `/dev/sda2` 等价于 `dev-sda2.device` 。            |

1. 查看当前系统单元（Unit）

   ```sh
   # 列出正在运行的 Unit
   $ systemctl list-units

   # 列出所有Unit，包括没有找到配置文件的或者启动失败的
   $ systemctl list-units --all

   # 列出所有没有运行的 Unit
   $ systemctl list-units --all --state=inactive

   # 列出所有加载失败的 Unit
   $ systemctl list-units --failed

   # 列出所有正在运行的、类型为 service 的 Unit
   $ systemctl list-units --type=service
   ```

2. 查看单元（Unit）状态

   ```sh
   # 显示系统状态
   $ systemctl status

   # 显示单个 Unit 的状态
   $ systemctl status bluetooth.service

   # 显示远程主机的某个 Unit 的状态
   $ systemctl -H root@rhel7.example.com status httpd.service
   ```

   除了 status 命令，systemctl 还提供了三个查询状态的简单方法，主要供脚本内部的判断语句使用。

   ```sh
   # 显示某个 Unit 是否正在运行
   $ systemctl is-active application.service

   # 显示某个 Unit 是否处于启动失败状态
   $ systemctl is-failed application.service

   # 显示某个 Unit 服务是否建立了开机自动启动链接
   $ systemctl is-enabled application.service
   ```

   每个单元（Unit）配置文件的状态，一共有四种可能：

   | Unit 文件状态 | 描述                                                                    |
   | ------------- | ----------------------------------------------------------------------- |
   | enabled       | 已建立启动链接                                                          |
   | disabled      | 没建立启动链接                                                          |
   | static        | 该配置文件没有 `[Install]` 部分（无法执行），只能作为其他配置文件的依赖 |
   | masked        | 该配置文件被禁止建立启动链接                                            |

   > 提示：从配置文件的状态无法看出，该 Unit 是否正在运行。这必须执行如下命令：

   ```sh
   $ systemctl status bluetooth.service
   ```

   一旦修改配置文件，就要让 SystemD 重新加载配置文件，然后重新启动，否则修改不会生效：

   ```sh
   $ systemctl daemon-reload
   $ systemctl restart nginx.service
   ```

3. 单元（Unit）管理

   对于用户来说，最常用的是下面这些命令，用于启动和停止单元(Unit)，主要使用的是 `service`

   ```sh
   # 立即激活单元
   $ systemctl start <单元名/单元名简写>

   # 立即停止单元
   $ systemctl stop nginx.service

   # 重启单元
   $ systemctl restart nginx

   # 重新加载配置
   $ systemctl reload <单元>

   # 输出单元运行状态
   $ systemctl status <单元>

   # 杀死一个服务的所有子进程
   $ systemctl kill <单元>

   # 检查单元是否配置为自动启动
   $ systemctl is-enabled <单元>

   # 开机自动激活单元
   $ systemctl enable <单元>

   # 设置单元为自动启动并立即启动这个单元=
   $ systemctl enable --now unit

   # 取消开机自动激活单元
   $ systemctl disable <单元>

   # 禁用一个单元（禁用后，间接启动也是不可能的）
   $ systemctl mask <单元>

   # 取消禁用一个单元
   $ systemctl unmask <单元>

   # 显示单元的手册页（必须由单元文件提供）
   $ systemctl help <单元>

   # 重新载入 systemd 系统配置，扫描单元文件的变动。它不会重新加载变更的单元文件。重新加载变更的单元文件请参考上面的 reload 示例。
   $ systemctl daemon-reload

   # 显示某个 Unit 的所有底层参数
   $ systemctl show <单元>

   # 显示某个 Unit 的指定属性的值
   $ systemctl show -p CPUShares <单元>

   # 设置某个 Unit 的指定属性
   $ systemctl set-property <单元> CPUShares=500
   ```

4. 单元（Unit）依赖关系

   Unit 之间存在依赖关系：A 依赖于 B，就意味着 Systemd 在启动 A 的时候，同时会去启动 B。

   ```sh
   $ systemctl list-dependencies nginx.service
   ```

   > 上面命令的输出结果之中，有些依赖是 `Target` 类型（详见下文），默认不会展开显示。如果要展开 Target，就需要使用 `--all` 参数。

   ```sh
   $ systemctl list-dependencies --all nginx.service
   ```

5. 单元文件概述

   每一个单元(Unit)都有一个配置文件，告诉 Systemd 怎么启动这个单元(Unit) 。

6. 加载单元（Unit）文件

   单元文件可以从多个地方加载，使用如下指令可以按优先级 `从低到高` 显示加载目录：

   ```sh
   $ systemctl show --property=UnitPath
   UnitPath=/etc/systemd/system.control /run/systemd/system.control /run/systemd/transient /etc/systemd/system /run/systemd/system /run/systemd/generator /lib/systemd/system
   ```

   Systemd 默认从目录 `/etc/systemd/system/` 读取配置文件。但是，里面存放的大部分文件都是符号链接，指向配置文件真正的存放目录 `/usr/lib/systemd/system/`。

   | 单元（Unit）文件     | 单元（Unit）文件存放路径 |
   | -------------------- | ------------------------ |
   | 软件包安装的单元     | /usr/lib/systemd/system/ |
   | 系统管理员安装的单元 | /etc/systemd/system/     |

   `systemctl enable` 命令用于在上面两个目录之间，建立符号链接关系:

   ```sh
   $ systemctl enable nginx.service
   # 等同于
   $ ln -s '/usr/lib/systemd/system/nginx.service' '/usr/lib/systemd/system/nginx.service'
   ```

   > 如果单元（Unit）配置文件里面设置了开机启动，`systemctl enable` 命令相当于激活开机启动。

   ```sh
   $ systemctl disable clamd@scan.service
   ```

   与之对应的，`systemctl disable` 命令用于在两个目录之间，撤销符号链接关系，相当于撤销开机启动。

## 六、编写单元(Unit)文件

systemd 单元文件的语法来源于 XDG 桌面项配置文件 `.desktop` 文件，最初的源头则是 Microsoft Windows 的 `.ini` 文件。

### 单元文件的格式

配置文件就是普通的文本文件，可以用文本编辑器打开。

1. 使用如下命令可查看单元文件的内容：

   ```sh
   $ systemctl cat sshd.service
   [Unit]
   Description=OpenBSD Secure Shell server
   Documentation=man:sshd(8) man:sshd_config(5)
   After=network.target auditd.service
   ConditionPathExists=!/etc/ssh/sshd_not_to_be_run

   [Service]
   EnvironmentFile=-/etc/default/ssh
   ExecStartPre=/usr/sbin/sshd -t
   ExecStart=/usr/sbin/sshd -D $SSHD_OPTS
   ExecReload=/usr/sbin/sshd -t
   ExecReload=/bin/kill -HUP $MAINPID
   KillMode=process
   Restart=on-failure
   RestartPreventExitStatus=255
   Type=notify
   RuntimeDirectory=sshd
   RuntimeDirectoryMode=0755

   [Install]
   WantedBy=multi-user.target
   Alias=sshd.service
   ```

   从上面的输出可以看到：

   | 序号 | 单元文件特点                                         |
   | ---- | ---------------------------------------------------- |
   | 01   | 配置文件分成几个区块                                 |
   | 02   | 每个区块的第一行，是用方括号表示的区别名，比如[Unit] |
   | 03   | 配置文件的区块名和字段名，都是大小写敏感的           |
   | 04   | 每个区块内部是一些等号连接的键值对                   |
   | 05   | 键值对的等号两侧不能有空格                           |

### 单元文件的区块

单元文件由如下 3 个区块：

| 区块         | 描述                       |
| ------------ | -------------------------- |
| [Unit]       | 用来定义 Unit 的元数据     |
| [Install]    | 用来定义如何启动           |
| [Service]    | 用来 Service 的配置        |
| [Socket]     | 用来 Socket 的配置         |
| [Path]       | 用来 Path 的配置           |
| [<单元扩展>] | 用来处理对应类型的单元文件 |

1. [Unit] 区块

   [Unit] 区块通常是配置文件的第一个区块，用来定义 Unit 的元数据，以及配置与其他 Unit 的关系。它的主要字段如下：

   - Description：简短描述
   - Documentation：文档地址
   - Requires：当前 Unit 依赖的其他 Unit，如果它们没有运行，当前 Unit 会启动失败
   - Wants：与当前 Unit 配合的其他 Unit，如果它们没有运行，当前 Unit 不会启动失败
   - BindsTo：与 Requires 类似，它指定的 Unit 如果退出，会导致当前 Unit 停止运行
   - Before：如果该字段指定的 Unit 也要启动，那么必须在当前 Unit 之后启动
   - After：如果该字段指定的 Unit 也要启动，那么必须在当前 Unit 之前启动
   - Conflicts：这里指定的 Unit 不能与当前 Unit 同时运行
   - Condition...：当前 Unit 运行必须满足的条件，否则不会运行
   - Assert...：当前 Unit 运行必须满足的条件，否则会报启动失败

   更多内容请去[官方手册](https://www.freedesktop.org/software/systemd/man/systemd.unit.html)查看

2. [Install] 区块

   [Install]通常是配置文件的最后一个区块，用来定义如何启动，以及是否开机启动。它的主要字段如下：

   - WantedBy：它的值是一个或多个 Target，当前 Unit 激活时（enable）符号链接会放入 /etc/systemd/system 目录下面以 Target 名 + .wants 后缀构成的子目录中
   - RequiredBy：它的值是一个或多个 Target，当前 Unit 激活时，符号链接会放入 /etc/systemd/system 目录下面以 Target 名 + .required 后缀构成的子目录中
   - Alias：当前 Unit 可用于启动的别名
   - Also：当前 Unit 激活（enable）时，会被同时激活的其他 Unit

   更多内容请去[官方手册](https://www.freedesktop.org/software/systemd/man/systemd.unit.html)查看

3. [Service]

   [Service]区块用来 Service 的配置，只有 Service 类型的 Unit 才有这个区块。它的主要字段如下：

   - Type：定义启动时的进程行为。它有以下几种值。
   - Type=simple：默认值，执行 ExecStart 指定的命令，启动主进程
   - Type=forking：以 fork 方式从父进程创建子进程，创建后父进程会立即退出，建议配合 "PIDFile="
   - PIDFile=：该服务 PID 文件的路径，强烈建议在 Type=forking 的情况下明确设置此选项。
   - Type=oneshot：一次性进程，Systemd 会等当前服务退出，再继续往下执行
   - Type=dbus：当前服务通过 D-Bus 启动
   - Type=notify：当前服务启动完毕，会通知 Systemd，再继续往下执行
   - Type=idle：若有其他任务执行完毕，当前服务才会运行
   - ExecStart：启动当前服务的命令
   - ExecStartPre：启动当前服务之前执行的命令
   - ExecStartPost：启动当前服务之后执行的命令
   - ExecReload：重新加载当前服务配置时执行的命令
   - ExecStop：停止当前服务时执行的命令
   - ExecStopPost：停止当其服务之后执行的命令
   - RestartSec：自动重启当前服务间隔的秒数
   - Restart：定义何种情况 Systemd 会自动重启当前服务，可能的值包括 always（总是重启）、on-success、on-failure、on-abnormal、on-abort、on-watchdog
   - TimeoutSec：定义 Systemd 停止当前服务之前等待的秒数
   - Environment：指定环境变量

   更多内容请去[官方手册](https://www.freedesktop.org/software/systemd/man/systemd.service.html)查看

## 七、Target

启动计算机的时候，需要启动大量的单元(Unit) ，如果每一次启动都要一一写明本次启动需要哪些单元(Unit)，显然非常不方便。Systemd 的解决方案就是 Target。

1. Target 概述

   - 简单说，Target 就是一个 Unit 组，包含许多相关的 Unit 。
   - 启动某个 Target 的时候，Systemd 就会启动里面所有的 Unit。
   - 从这个意义上说，Target 这个概念类似于"状态点"，启动某个 Target 就好比启动到某种状态。
   - 传统的 init 启动模式里面，有 RunLevel 的概念，跟 Target 的作用很类似。不同的是，RunLevel 是互斥的，不可能多个 RunLevel 同时启动，但是多个 Target 可以同时启动。

2. Target 相关指令

   ```sh
   # 查看当前系统的所有 Target
   $ systemctl list-unit-files --type=target

   # 查看一个 Target 包含的所有 Unit
   $ systemctl list-dependencies multi-user.target

   # 查看启动时的默认 Target
   $ systemctl get-default

   # 设置启动时的默认 Target
   $ systemctl set-default multi-user.target

   # 切换 Target 时，默认不关闭前一个 Target 启动的进程，
   # systemctl isolate 命令改变这种行为，
   # 关闭前一个 Target 里面所有不属于后一个 Target 的进程
   $ systemctl isolate multi-user.target
   ```

## 八、Systemd 日志管理

Systemd 统一管理所有 Unit 的启动日志。带来的好处就是，可以只用 journalctl 一个命令，查看所有日志（内核日志和应用日志）。

1. Systemd 日志配置文件

   日志的配置文件是 `/etc/systemd/journald.conf`

2. journalctl 功能强大，用法非常多，常用指令如下：

   ```sh
   # 查看所有日志（默认情况下 ，只保存本次启动的日志）
   $ journalctl

   # 查看内核日志（不显示应用日志）
   $ journalctl -k

   # 查看系统本次启动的日志
   $ journalctl -b
   $ journalctl -b -0

   # 查看上一次启动的日志（需更改设置）
   $ journalctl -b -1

   # 查看指定时间的日志
   $ journalctl --since="2012-10-30 18:17:16"
   $ journalctl --since "20 min ago"
   $ journalctl --since yesterday
   $ journalctl --since "2015-01-10" --until "2015-01-11 03:00"
   $ journalctl --since 09:00 --until "1 hour ago"

   # 显示尾部的最新10行日志
   $ journalctl -n

   # 显示尾部指定行数的日志
   $ journalctl -n 20

   # 实时滚动显示最新日志
   $ journalctl -f

   # 查看指定服务的日志
   $ journalctl /usr/lib/systemd/systemd

   # 查看指定进程的日志
   $ journalctl _PID=1

   # 查看某个路径的脚本的日志
   $ journalctl /usr/bin/bash

   # 查看指定用户的日志
   $ journalctl _UID=33 --since today

   # 查看某个 Unit 的日志
   $ journalctl -u nginx.service
   $ journalctl -u nginx.service --since today

   # 实时滚动显示某个 Unit 的最新日志
   $ journalctl -u nginx.service -f

   # 合并显示多个 Unit 的日志
   $ journalctl -u nginx.service -u php-fpm.service --since today

   # 查看指定优先级（及其以上级别）的日志，共有8级
   # 0: emerg
   # 1: alert
   # 2: crit
   # 3: err
   # 4: warning
   # 5: notice
   # 6: info
   # 7: debug
   $ journalctl -p err -b

   # 日志默认分页输出，--no-pager 改为正常的标准输出
   $ journalctl --no-pager

   # 以 JSON 格式（单行）输出
   $ journalctl -b -u nginx.service -o json

   # 以 JSON 格式（多行）输出，可读性更好
   $ journalctl -b -u nginx.serviceqq
    -o json-pretty

   # 显示日志占据的硬盘空间
   $ journalctl --disk-usage

   # 指定日志文件占据的最大空间
   $ journalctl --vacuum-size=1G

   # 指定日志文件保存多久
   $ journalctl --vacuum-time=1years
   ```

## 参考来源

| 序号 | 参考来源                                                                            |
| ---- | ----------------------------------------------------------------------------------- |
| 01   | http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html               |
| 02   | https://wiki.archlinux.org/index.php/Systemd_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87) |
| 03   | https://www.freedesktop.org/software/systemd/man/systemd.unit.html                  |
