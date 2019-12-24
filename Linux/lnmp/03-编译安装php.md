# 编译安装 PHP

PHP 是处理 php 脚本的解释器，服务器安装了 MariaDB 后就可以开始安装 PHP。

## 一、必备安装包准备

编译 PHP 需要的准备好的软件包：

| 必备            | 操作                                                     |
| --------------- | -------------------------------------------------------- |
| libxml2 依赖库  | libxml2-dev                                              |
| libssl 依赖库   | libssl-dev                                               |
| libonig 依赖库  | libonig-dev                                              |
| libcurl4 依赖库 | libcurl4-openssl-dev                                     |
| PHP 源码包      | [php-7.4.1.tar.gz](https://www.php.net/downloads.php)    |
| openssl 依赖库  | [openssl-1.1.1d.tar.gz](https://www.openssl.org/source/) |
| curl 依赖库     | [curl-7.67.0.tar.gz](https://curl.haxx.se/download.html) |

1. 安装 Nginx 必备开发库

   ```sh
   $ apt install libxml2-dev libssl-dev libonig-dev libcurl4-openssl-dev
   ```

   > 提示：使用 `./configure` 指令构建时，会提示缺失的依赖包相关信息！

2. 创建 Nginx 构建目录

   ```sh
   $ mkdir /package/php-7.4.1/php_bulid
   ```

## 二、编译安装

1. 进入构建路径

   ```sh
   $ cd /package/php-7.4.1/php_bulid
   ```

2. php 构建选项：

   ```sh
   $ ../configure --prefix=/server/php \
   --enable-fpm \
   --enable-mbstring \
   --with-openssl=/package/pkg/openssl-1.1.1d \
   --with-pcre-jit \
   --enable-mysqlnd \
   --with-pdo-mysql \
   --with-curl=/package/pkg/curl-7.67.0 \
   --without-cdb \
   --without-sqlite3 \
   --without-pdo-sqlite
   ```

3. 构建选项说明

   | 构建选项             | 描述                                             |
   | -------------------- | ------------------------------------------------ |
   | --prefix=            | 指定 php 安装路径                                |
   | --enable-fpm         | 构建 php-fpm 服务                                |
   | --enable-mbstring    | 构建 mbstring 扩展                               |
   | --with-openssl=      | 构建 openssl 扩展，`composer` 需要使用此扩展     |
   | --with-pcre-jit      | 正则支持 jit 编译器                              |
   | --enable-mysqlnd     | 构建 mysqlnd 扩展（php 官方写的 mysql 驱动）     |
   | --with-pdo-mysql     | 构建 pdo-mysql 扩展（默认使用 mysqlnd 驱动）     |
   | --with-curl=         | 构建 curl 扩展                                   |
   | --without-cdb        | 禁止构建 cdb 扩展（1 种数据库系统的扩展）        |
   | --without-sqlite3    | 禁止构建 sqlite3 扩展（1 种数据库系统的扩展）    |
   | --without-pdo-sqlite | 禁止构建 pdo-sqlite 扩展（1 种数据库系统的扩展） |

4. 编译并安装

   ```sh
   $ make -j4
   $ make test
   $ make install
   ```

## 三、PHP 命令行工具

`php-config` 是一个简单的命令行脚本用于获取所安装的 PHP 配置的信息。使用 -h 来查看：

```sh
$ cd /server/php/bin
./php-config -h
```

> 提示：在编译 php 扩展时，如果有多个 PHP 版本，可以使用 `--with-php-config` 选项来指定用于编译的 php 版本，该选项指定了 `php-config` 脚本的路径。

## 扩展库操作

PHP 动态扩展库的具体安装方法请查阅[为 PHP 安装 PECL 扩展](./04-为php安装pecl扩展.md)

1. PHP 扩展分类：

   | 扩展类型 | 扩展类型说明                       | 操作方式                    |
   | -------- | ---------------------------------- | --------------------------- |
   | 静态扩展 | 编译安装 PHP 时，一起安装的扩展    | 只能通过重新编译 PHP 来修改 |
   | 动态扩展 | 使用 `phpize` 编译安装的 PECL 扩展 | 通过操作 `php.ini` 来控制   |

   > 提示：php 源码自带的扩展库，支持静态安装和动态安装，如果两个都安装了，默认以静态扩展方式优先!

2. 动态库操作：

   | 操作       | 案例                                               |
   | ---------- | -------------------------------------------------- |
   | 开启动态库 | `php.ini` 文件里添加 `extension=<库名>`            |
   | 禁用动态库 | `php.ini` 文件里删除指定的 `extension=<库名>` 内容 |

   > 提示：有些动态库是 `zend` 扩展库，需要使用 `zend_extension=<库名>` 开启，才能生效！

## `php-fpm` 服务

想 Nginx 这类 web 服务，只能处理静态页面，如果想要处理 php 脚本，就必须借助类似 `php-fpm` 的服务！

### 配置 php-fpm

`php-fpm` 配置文件默认是在 `/server/php/etc` 下面：

| 所属进程                    | 对应配置文件       | 数量     |
| --------------------------- | ------------------ | -------- |
| 主进程                      | `php-fpm.conf`     | 1        |
| pool 进程（即：工作池进程） | `php-fpm.d/*.conf` | 没有限制 |

配置文件默认模块：

| 所属进程  | 对应配置文件模块             |
| --------- | ---------------------------- |
| 主进程    | `php-fpm.conf.default`       |
| pool 进程 | `php-fpm.d/www.conf.default` |

### 创建主进程配置文件

php-fpm 的主进程配置文件必须创建，使用默认模版的即可：

```sh
$ cd /server/php/etc
$ cp php-fpm.conf{.default,}
```

### 创建工作进程配置文件

php-fpm 的工作进程配置文件必须创建，允许多个：

```sh
$ cd /server/php/etc/php-fpm.d
$ cp www.conf{.default,}
```

> 说明：默认的配置有些不满足要求，参考模版我们自定义一个配置文件。

1. 工作池用户

   与 nginx 的用户保持一致即可：

   ```sh
   # 创建一个名为nginx，id号为2000的用户组
   $ groupadd -g 2000 nginx
   # 创建一个名为nginx，id号为2000的用户，所属用户组为nginx，并且不创建家目录（-M 不创建家目录）
   $ useradd -c 'Users of the Nginx service and php-fpm service' -u 2000 -s /usr/sbin/nologin -M -g nginx nginx
   ```

   > 提示：自己创建的用户权限与 nobody 差不多，好处是跟 nobody 区分开，这样就不允许 web 以外的用户操作，具体讲解见 `搭建vsftpd服务`

2. 创建 unix 套接字监听文件所在目录：

   ```sh
   $ mkdir /var/run/php/
   ```

3. 创建 php-pfm 工作进程配置文件：

   ```sh
   $ vim /server/php/etc/php-fpm.d/www.conf
   ```

   > 提示：具体配置请查阅 [php-fpm 工作进程配置详解](./source/php-fpm工作进程配置详解.md)

### 简单控制 `php-fpm`：

| 操作                    | 指令                           |
| ----------------------- | ------------------------------ |
| 启动 `php-fpm`          | `/server/php/sbin/php-fpm`     |
| 关闭 `php-fpm`          | `pkill -9 php-fpm`             |
| 关闭 `php-fpm`          | `kill -9 /var/run/php-fpm.pid` |
| 测试 `php-fpm` 配置文件 | `/server/php/sbin/php-fpm -t`  |
| `php-fpm` 操作帮助选项  | `/server/php/sbin/php-fpm -h`  |

### 引导 `php-fpm` 开机启动

编译 php 时如果加上了 `--enable-fpm` 选项就会自动生成两个启动脚本具体如下：

| 启动项      | 文件源码参考(pid 值做了修正)                  |
| ----------- | --------------------------------------------- |
| `systemctl` | [`php-fpm.service`](./source/php-fpm.service) |
| `init.d`    | [`init.d.php-fpm`](./source/init.d.php-fpm)   |

> 编译源码的路径： `/package/lnmp/php-7.3.11/php_bulid/sapi/fpm`

1. init 启动脚本

   > 拷贝到 init.d 目录

   ```sh
   $ cp init.d.php-fpm /etc/init.d/php-fpm
   ```

   > 杀死之前打开的 nginx 进程，init 的才能正常使用，否则 pid 冲突

   ```sh
   $ ps -ef | grep php-fpm
   $ kill -9 pid
   # 或者
   $ pkill -9 php-fpm
   ```

   > 接着使用 init 启动 php-fpm

   | 操作           | 指令                         |
   | -------------- | ---------------------------- |
   | 启动 `php-fpm` | `/etc/init.d/php-fpm start`  |
   | 关闭 `php-fpm` | `/etc/init.d/php-fpm stop`   |
   | 重载 `php-fpm` | `/etc/init.d/php-fpm reload` |
   | 测试 `php-fpm` | `/etc/init.d/php-fpm status` |

2. systemctl 开机启动脚本

   > 将启动脚本拷贝到 systemctl 系统目录下：

   ```sh
   $ cp /package/lnmp/php-7.3.11/php_bulid/sapi/fpm/php-fpm.service /usr/lib/systemd/system/php-fpm.service
   ```

   > 使用 `systemctl` 加入开机启动：

   ```sh
   systemctl enable php-fpm.service
   ```
