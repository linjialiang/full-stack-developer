# Debian 基础配置

Debian 系统刚刚安装成功非常干净，我们需要对其进行适当的配置，并且添加一些常用软件包。

## 配置网络

网络是第一要解决的，一个终端界面如果没有网络支持，我们很难有所作为！

### 网络相关配置文件：

| 配置文件                  | 描述         |
| ------------------------- | ------------ |
| `/etc/network/interfaces` | 配置 ip 地址 |
| `/etc/resolv.conf`        | 配置 dns     |

1. 配置 ip 地址

    ```sh
    $ cp /etc/network/interfaces{,.bak}
    $ nano /etc/network/interfaces
    ```

    配置静态地址：

    ```sh
    source /etc/network/interfaces.d/*

    # The loopback network interface
    auto lo
    iface lo inet loopback

    # The primary nerwork interfaces
    allow-hotplug enp0s3
    iface enp0s3 inet static
            address 192.168.10.252
            netmask 255.255.255.0
            gateway 192.168.10.1
    ```

    配置动态地址(默认就是这个)：

    ```sh
    source /etc/network/interfaces.d/*

    # The loopback network interface
    auto lo
    iface lo inet loopback

    # The primary nerwork interfaces
    allow-hotplug enp0s3
    iface enp0s3 inet dhcp
    ```

2. 配置 DNS

    ```sh
    $ cp /etc/resolv.conf{,.bak}
    $ vi /etc/resolv.conf
    ```

    测试服务器案例如下：

    ```conf
    nameserver 192.168.10.1
    nameserver 0.0.0.0
    ```

### 网络相关指令

这里介绍几个常用的网络相关指令，具体请查阅 [ip 指令集](./manual/01-ip指令集.md)

| ip 指令                   | 描述                                                     |
| ------------------------- | -------------------------------------------------------- |
| `ip addr show`            | 查看全部网卡信息                                         |
| `ip addr show enp2s0`     | 查看指定网卡信息                                         |
| `ip link set enp2s0 up`   | 启用网卡（重启系统生效）                                 |
| `ip link set enp2s0 down` | 禁用网卡（重启系统生效）                                 |
| `ip route show`           | 查看网络路由信息                                         |
| `ip neigh`                | 查看 ARP 缓存中的记录（即连接到局域网中设备的 MAC 地址） |

Debian 通过 `network` 这个软件来管理网络

1. 重启加载网络配置

    ```sh
    $ service networking restart
    $ systemctl restart networking
    $ /etc/init.d/networking restart
    ```

2. 停止网络

    ```sh
    $ /etc/init.d/networking stop
    ```

3. 启动网络

    ```sh
    $ /etc/init.d/networking start
    ```

> 提示：禁用网卡是操作硬件，禁用网络是操作管理网络的软件包！

## 设置语言环境

本次测试环境安装的是中文环境，使用 `locales包` 可以设置其他语言环境（默认是英文环境）

1. 安装 `locales` 软件包

    ```sh
    $ apt install locales
    ```

2. 设置语言环境

    ```sh
    $ dpkg-reconfigure locales
    ```

    | 语言选项      | 选项说明 |
    | ------------- | -------- |
    | `C.UTF-8`     | 英文界面 |
    | `zh_CN.UTF-8` | 中文界面 |

## 安装帮助手册

Debian 下有三类手册相关的包，以下列出的软件包可以安装：

| 手册包        | 描述                 |
| ------------- | -------------------- |
| `manpages`    | Linux 手册           |
| `manpages-zh` | Linux 中文手册       |
| `help2man`    | 输出一份简单的手册页 |
| `helpman`     | 快速获取 Debian 教程 |

```sh
$ apt install manpages manpages-zh helpman help2man
```

> 关于手册的详细讲解请查阅 [Debian 帮助手册](./manual/02-Debian帮助指令.md)

## 安装 ssh 包

服务器都是远程操控，所以 ssh 必然要安装

```sh
$ apt install ssh
```

-   允许 ssh 使用远程 root 连接：

    ```sh
    $ cp /etc/ssh/sshd_config{,.bak}
    $ vi /etc/ssh/sshd_config
    ```

    > 修改 `PermitRootLogin` 参数值，并去掉前面的注释 `#`

    ```conf
    PermitRootLogin yes
    ```

-   重新加载 ssh 配置，让修改生效

    ```sh
    $ /etc/init.d/ssh reload
    ```

## 配置源镜像

默认的源镜像是有问题，我们需要进行修改

```sh
$ cp /etc/apt/sources.list{,.bak}
$ vi /etc/apt/sources.list
```

1. 完整的 `sources.list` 案例：

    ```conf
    ## 安全更新（重要）
    deb http://mirrors.ustc.edu.cn/debian-security/ buster/updates main contrib non-free
    deb-src http://mirrors.ustc.edu.cn/debian-security/ buster/updates main contrib non-free

    ## Debian 软件包镜像
    # 基础仓库
    deb http://mirrors.ustc.edu.cn/debian/ buster main contrib non-free
    deb-src http://mirrors.ustc.edu.cn/debian/ buster main contrib non-free
    # 更新仓库
    deb http://mirrors.ustc.edu.cn/debian/ buster-updates main contrib non-free
    deb-src http://mirrors.ustc.edu.cn/debian/ buster-updates main contrib non-free
    # 后移植版本仓库
    deb http://mirrors.ustc.edu.cn/debian/ buster-backports main contrib non-free
    deb-src http://mirrors.ustc.edu.cn/debian/ buster-backports main contrib non-free

    ```

2. 常规 `sources.list` 案例：

    通常并不需要 `non-free` 和 `contrib` 区块，具体如下：

    ```conf
    ## 安全更新（重要）
    deb http://mirrors.ustc.edu.cn/debian-security/ buster/updates main
    deb-src http://mirrors.ustc.edu.cn/debian-security/ buster/updates main

    ## Debian 软件包镜像
    # 基础仓库
    deb http://mirrors.ustc.edu.cn/debian/ buster main
    deb-src http://mirrors.ustc.edu.cn/debian/ buster main
    # 更新仓库
    deb http://mirrors.ustc.edu.cn/debian/ buster-updates main
    deb-src http://mirrors.ustc.edu.cn/debian/ buster-updates main
    # 后移植版本仓库
    deb http://mirrors.ustc.edu.cn/debian/ buster-backports main
    deb-src http://mirrors.ustc.edu.cn/debian/ buster-backports main
    ```

    > 163 源镜像，应该是浙江地区最快的镜像了吧：

    ```conf
    ## 安全更新（重要）
    deb http://mirrors.163.com/debian-security/ buster/updates main
    deb-src http://mirrors.163.com/debian-security/ buster/updates main

    ## Debian 软件包镜像
    # 基础仓库
    deb http://mirrors.163.com/debian/ buster main
    deb-src http://mirrors.163.com/debian/ buster main
    # 更新仓库
    deb http://mirrors.163.com/debian/ buster-updates main
    deb-src http://mirrors.163.com/debian/ buster-updates main
    # 后移植版本仓库
    deb http://mirrors.163.com/debian/ buster-backports main
    deb-src http://mirrors.163.com/debian/ buster-backports main
    ```

3. 操作源镜像

    | 指令               | 描述                 |
    | ------------------ | -------------------- |
    | `apt update`       | 更新本地源文件到最新 |
    | `apt upgrade`      | 更新软件包           |
    | `apt dist-upgrade` | 跨大版本更新软件包   |

4. 镜像区块说明

    | 镜像区块 | 描述                                                        |
    | -------- | ----------------------------------------------------------- |
    | main     | 遵从 Debian 自由软件指导方针（DFSG），并且不依赖于 non-free |
    | non-free | 不遵从 Debian 自由软件指导方针（DFSG）                      |
    | contrib  | 遵从 Debian 自由软件指导方针（DFSG），但依赖于 non-free     |

    > 事实上收录到 `non-free` 和 `contrib` 仓库上的包是非常少的，而 `main` 仓库就有 5 万多个包！

## 美化 bash 终端

修改用户根目录下的 `.bashrc` 可以美化 bash 控制台，具体如下：

```sh
$ cp ~/.bashrc{,.bak}
$ vi ~/.bashrc
```

1. `.bashrc` 示例：

    ```sh
    PS1='[${debian_chroot:+($debian_chroot)}\u@Debian10 \W]\$ '
    export LS_OPTIONS='--color=auto'
    eval "`dircolors`"
    alias ls='ls $LS_OPTIONS -F'
    alias ll='ls $LS_OPTIONS -lF'
    alias lla='ls $LS_OPTIONS -laF'
    ```

2. 使用 `source` 更新终端界面：

    ```sh
    $ source ~/.bashrc
    ```

## 为 Debian 安装常用工具包

以下几个常用工具包，我们可以一键安装：

```sh
$ apt install lrzsz tar bzip2 gzip curl wget
```

| 工具包    | 描述                                |
| --------- | ----------------------------------- |
| `lrzsz`   | linux 里可代替 ftp 上传和下载的程序 |
| `tar`     | 打包、解包工具                      |
| `tar.gz`  | 让 tar 支持 gz 格式的压缩和解压缩   |
| `tar.bz2` | 让 tar 支持 bz2 格式的压缩和解压缩  |
| `curl`    | 功能丰富的网络命令行工具            |

## 安装 NeoVim

NeoVim 用于替代 Vim，具体查看 [SpaceVim 操作指南](../Editor/vim/01-SpaceVim操作指南.md)

## ~~安装 vim~~

vim 编辑器非常适合终端操作，具体安装代码如下：

```sh
$ apt install vim ctags vim-scripts
```

1. 修改 vim 配置文件

    基础配置文件 `vimrc` 加载了一个空配置文件 `vimrc.local`，所以我们直接修改 `vimrc.local`

    ```sh
    $ touch /etc/vim/vimrc.local
    $ vim /etc/vim/vimrc.local
    ```

    具体代码见 [vimrc.local](./source/vimrc.local)

    > 提示：远程终端想要复制 vim 编辑器的内容，需要每次设置 `:set mouse=c`!

2. vim 安装中文帮助手册

    ```sh
    $ mkdir -p /package/vim
    $ cd /package/vim
    $ wget https://github.com/yianwillis/vimcdoc/releases/download/v2.3.0/vimcdoc-2.3.0.tar.gz
    $ tar -xzvf vimcdoc-2.3.0.tar.gz
    $ cd vimcdoc-2.3.0
    $ ./vimcdoc.sh -I
    ```

3. vim 卸载中文帮助手册

    ```sh
    $ ./vimcdoc -u
    ```
