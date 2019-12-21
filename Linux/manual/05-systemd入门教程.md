# Systemd 入门教程

Systemd 是一个 Linux 系统基础组件的集合，提供了一个系统和服务管理器，运行为 PID 1 并负责帮助其它程序启动守护进程。

## 一、Systemd 由来

历史上，Linux 的启动一直采用 init 进程。使用下面的命令用来启动服务：

```sh
$ sudo /etc/init.d/nginx start
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
   $ systemctl --version
   ```

   > 上面的命令查看 Systemd 的版本

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

### systemd 基本工具

监视和控制 systemd 的主要命令是 systemctl。该命令可用于查看系统状态和管理系统及服务。

> 提示：在 systemctl 参数中添加 -H <用户名>@<主机名> 可以实现对其他机器的远程控制。该功能使用 SSH 连接。

1. 分析系统状态

   | 指令                          | 描述                            |
   | ----------------------------- | ------------------------------- |
   | `$ systemctl status`          | 显示系统状态                    |
   | `$ systemctl`                 | 输出激活的单元                  |
   | `$ systemctl list-units`      | 输出运行失败的单元              |
   | `$ systemctl --failed`        | 输出运行失败的单元              |
   | `$ systemctl list-unit-files` | 查看所有已安装服务              |
   | `$ systemctl status pid`      | 显示 cgroup slice, 内存和父 PID |

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
   $ sudo hostnamectl set-hostname rhel7
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

### 单元（Unit）管理

Systemd 可以管理所有系统资源。不同的资源统称为 Unit（单位）。

> Unit 一共分成 12 种:

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

1. 使用单元

   一个单元配置文件可以描述如下内容之一：

   | 单元内容                | 单元配置文件格式 |
   | ----------------------- | ---------------- |
   | 系统服务                | `*.service`      |
   | 挂载点                  | `*.mount`        |
   | sockets                 | `*.sockets`      |
   | 系统设备                | `*.device`       |
   | 交换分区                | `*.swap`         |
   | 文件路径                | `*.path`         |
   | 启动目标                | `*.target`       |
   | 由 systemd 管理的计时器 | `*.timer`        |

   使用 systemctl 控制单元时，通常需要使用单元文件的全名，包括扩展名（例如 sshd.service ）。但是有些单元可以在 systemctl 中使用简写方式：

   ```sh
   1. 如果无扩展名，systemctl 默认把扩展名当作 .service 。例如： netcfg 和 netcfg.service 是等价的 ；
   2. 挂载点会自动转化为相应的 .mount 单元。例如： /home 等价于 home.mount ；
   3. 设备会自动转化为相应的 .device 单元，所以： /dev/sda2 等价于 dev-sda2.device 。
   ```

2. 查看当前系统单元（Unit）

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

3. 查看单元（Unit）状态

   ```sh
   # 显示系统状态
   $ systemctl status

   # 显示单个 Unit 的状态
   $ systemctl status bluetooth.service

   # 显示远程主机的某个 Unit 的状态
   $ systemctl -H root@rhel7.example.com status httpd.service
   ```

   > 除了 status 命令，systemctl 还提供了三个查询状态的简单方法，主要供脚本内部的判断语句使用。

   ```sh
   # 显示某个 Unit 是否正在运行
   $ systemctl is-active application.service

   # 显示某个 Unit 是否处于启动失败状态
   $ systemctl is-failed application.service

   # 显示某个 Unit 服务是否建立了开机自动启动链接
   $ systemctl is-enabled application.service
   ```

4. 单元（Unit）管理

   对于用户来说，最常用的是下面这些命令，用于启动和停止 Unit（主要是 service）。

   ```sh
   # 立即激活单元
   $ systemctl start <单元>

   # 立即停止单元
   $ systemctl stop <单元>

   # 重启单元
   $ systemctl restart <单元>

   # 重新加载配置
   $ systemctl reload <单元>

   # 输出单元运行状态
   $ systemctl status <单元>

   # 杀死一个服务的所有子进程
   $ sudo systemctl kill <单元>

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
   $ sudo systemctl set-property <单元> CPUShares=500
   ```
