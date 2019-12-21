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

2. 使用单元

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
