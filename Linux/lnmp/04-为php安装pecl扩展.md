# 为 PHP 安装 PECL 扩展

PECL 扩展是非常多的，我们需要在 [PECL 官网](https://pecl.php.net/) 获得这些扩展的源码包。很多 PECL 扩展在 PHP 手册中尚未对其进行记录。

| PECL 扩展                                       | 描述                    |
| ----------------------------------------------- | ----------------------- |
| [imagick](https://pecl.php.net/package/imagick) | 处理图片的 PHP 扩展     |
| [xdebug](https://pecl.php.net/package/xdebug)   | 用于显示 PHP 错误的扩展 |

## 一、 创建 PECL 扩展存放目录

由于 PECL 扩展的源码，PHP 本身没有提供，所以我们就为所有 PECL 扩展源码包创建一个根目录

```sh
$ mkdir -p /package/ext
```

## 二、安装 PECL 扩展 —— `Xdebug`

1. 创建构建目录

   ```sh
   $ cd /package/ext/xdebug-2.9.2
   $ mkdir xdebug_bulid
   ```

2. 编译并安装 Xdebug 扩展

   ```sh
   $ phpize
   $ cd xdebug_bulid
   $ ../configure
   $ make -j4
   $ make test
   $ make install
   ```

   > 说明：如果 /server/php/bin 没有加入环境变量，构建时需要加上 `--with-php-config` 选项：

   ```sh
   $ ../configure --with-php-config=/server/php/bin/php-config
   ```

3. 备份 php.ini 文件

   ```sh
   $ cp /server/php/lib/php.ini{,.bak}
   $ vim /server/php/lib/php.ini
   ```

4. php.ini 文件底部增加如下如下：

   ```ini
   [Xdebug]
   zend_extension=xdebug

   xdebug.collect_params = 4
   xdebug.dump_globals = 1
   xdebug.dump_undefined = 1
   xdebug.trace_output_dir = "/server/logs/xdebug"
   xdebug.gc_stats_enable = 1
   xdebug.gc_stats_output_dir = "/server/logs/xdebug"
   xdebug.profiler_enable = 1
   xdebug.profiler_output_dir = "/server/logs/xdebug"

   xdebug.remote_enable = 1
   xdebug.remote_autostart = 1
   xdebug.idekey = qywl
   xdebug.remote_host = localhost
   xdebug.remote_port = 9000
   ```

5. 创建 xdebug 日志存放路径：

   ```sh
   $ mkdir -p /logs/php/xdebug
   ```

## 三、安装 PECL 扩展 —— `imagick`

安装 `imagick` 扩展之前，需要先编译安装它的运行库 `ImageMagick`

1. 与 WAMP 环境的区别

   | 版本 | 区别                                                                            |
   | ---- | ------------------------------------------------------------------------------- |
   | wamp | `imagick.dll` 是预先编译出来的，所以 `ImageMagick` 版本必须与预先编译的版本一致 |
   | lnmp | `imagick.so` 是我们自己编译安装的，所以我们通常选择最新版的 `ImageMagick`       |

2. 软件包列表

   | imagick 必备包                                                   | 必备包说明           |
   | ---------------------------------------------------------------- | -------------------- |
   | [imagick](https://pecl.php.net/get/imagick-3.4.4.tgz)            | PHP 图片处理扩展     |
   | [ImageMagick-7.0.9-27.tar.gz](https://imagemagick.org/download/) | php_imagick 的运行库 |

### 编译安装 ImageMagick（运行库）

对于 ImageMagick 我们没有特别的需求，就采用最简单的方式编译了

1. 创建构建目录

   ```sh
   $ cd /package/pkg/ImageMagick-7.0.9-27/
   $ mkdir ImageMagick_bulid
   $ cd ImageMagick_bulid/
   ```

2. 编译并安装

   ```sh
   $ ../configure --prefix=/server/ImageMagick
   $ make -j4
   $ make install
   ```

> 提示：如果不需要最新版的运行库，也可以使用 `$ apt install imagemagick` 指令安装！

### 编译安装 php_imagick（扩展）

1. 创建构建目录

   ```sh
   $ cd /package/ext/imagick-3.4.4
   $ mkdir imagick_bulid
   ```

2. 编译并安装 imagick 扩展

   ```sh
   $ cd /package/ext/imagick-3.4.4
   $ phpize
   $ cd imagick_bulid
   $ ../configure --with-imagick=/server/ImageMagick
   $ make -j4
   $ make test
   $ make install
   Installing shared extensions:     /server/php/lib/php/extensions/no-debug-non-zts-20190902/
   Installing header files:          /server/php/include/php/
   ```

   如果 `/server/php/bin` 没有加入环境变量，构建时需要加上 `--with-php-config` 选项：

   ```sh
   $ ../configure \
   --with-php-config=/server/php/bin/php-config \
   --with-imagick=/server/ImageMagick
   ```

3. 在 PHP 配置文件(php.ini)上，启用 imagick 扩展

   ```sh
   $ vim /server/php/lib/php.ini
   ```

   `php.ini` 第 `950行` 左右添加以下内容：

   ```ini
   extension=imagick
   ```

4. 查询 `imagick` 扩展是否安装成功

   ```sh
   $ php -m
   ```

5. 查看 `imagick` 是否可以正常运行：

   ```sh
   $ php --ri imagick
   ```

   | 输出内容                                    | 输出说明                                        |
   | ------------------------------------------- | ----------------------------------------------- |
   | `Imagick compiled with ImageMagick version` | 编译 imagick 这个 php 扩展的 ImageMagick 版本号 |
   | `Imagick using ImageMagick library version` | 服务器上 ImageMagick 作为依赖库的版本号         |

   > 提示：如果两者的版本号不一致，imagick 扩展就不能正常运行！
