# 为 PHP 安装 PRCL 扩展

安装扩展的方式大同小异，下面是需要安装的两个 prcl 扩展

| PRCL 扩展                                       | 描述                    |
| ----------------------------------------------- | ----------------------- |
| [imagick](https://pecl.php.net/package/imagick) | 处理图片的 PHP 扩展     |
| [xdebug](https://pecl.php.net/package/xdebug)   | 用于显示 PHP 错误的扩展 |

## phpize 程序

`phpize` 可以将 PECL 扩展源码构建为可用 `./configure` 编译的源码，使用 `phpize --help` 可以查看帮助。

### 配置环境变量:

将 php 可执行程序目录的路径加入环境变量中，可以方便后续操作

1. 修改控制环境变量的文件

   ```sh
   $ cp /etc/profile{,.bak}
   $ vim /etc/profile
   ```

2. `/etc/profile` 底部增加一行内容：

   ```sh
   export PATH=$PATH:/server/php/bin:/server/php/sbin
   ```

3. 使用 `source` 指令重新激活文件：

   ```sh
   $ source /etc/profile
   ```

### 安装配置文件前的准备工作

1. 检查 PHP 配置文件是否正确加载

   使用 phpize 前，需要先正确加载 PHP 配置文件（php.ini）

   ```sh
   $ php --ini
   # 如出现如下内容则配置文件正确加载
   Loaded Configuration File:         /server/php/lib/php.ini
   # 如出现如下内容则配置文件未加载
   Loaded Configuration File: (none)
   ```

   > 说明：加载 php 配置文件，请参考 [编译安装 php](./03-编译安装php.md)

2. 创建 PRCL 扩展源码目录

   ```sh
   $ mkdir -p /package/ext
   ```

## 安装 PRCL 扩展 —— `Xdebug`

1. 创建构建目录

   ```sh
   $ cd /package/ext/xdebug-2.9.0
   $ mkdir xdebug_bulid
   ```

2. 编译并安装

   ```sh
   $ phpize
   $ cd xdebug_bulid
   $ ../configure
   $ make -j4
   $ make test
   $ make install
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
   xdebug.dump_globals
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

## 安装 PRCL 扩展 —— `imagick`

安装 `imagick` 扩展之前，必须安装它的编译环境和运行库 `ImageMagick`

1. 与 WAMP 环境的区别

   | 版本 | 区别                                                                                  |
   | ---- | ------------------------------------------------------------------------------------- |
   | wamp | `imagick.dll` 是预先编译出来的，所以 `ImageMagick` 版本必须与预先编译的版本一致       |
   | lnmp | `imagick.so` 是我们自己编译安装的，所以编译库和运行库都是我们编译安装的 `ImageMagick` |

2. 软件包列表

   | imagick 必备包                                                                   | 必备包说明                   |
   | -------------------------------------------------------------------------------- | ---------------------------- |
   | [ImageMagick](https://github.com/ImageMagick/ImageMagick/archive/7.0.9-2.tar.gz) | 扩展的编译库、运行库的源码包 |
   | [imagick](https://pecl.php.net/get/imagick-3.4.4.tgz)                            | 扩展源码包                   |

3. 编译 `ImageMagick`

   | `ImageMagick` 路径                                    | 路径说明     |
   | ----------------------------------------------------- | ------------ |
   | `/server/ImageMagick`                                 | 编译安装路径 |
   | `/package/lnmp/ImageMagick-7.0.9-2`                   | 源码路径     |
   | `/package/lnmp/ImageMagick-7.0.9-2/ImageMagick_bulid` | 构建路径     |

   具体操作如下：

   ```sh
   $ tar -xzvf ImageMagick-7.0.9-2.tar.gz
   $ mkdir /server/ImageMagick
   $ mkdir /package/lnmp/ImageMagick-7.0.9-2/ImageMagick_bulid
   $ cd /package/lnmp/ImageMagick-7.0.9-2/ImageMagick_bulid
   ```

   编译并安装：

   ```sh
   $ ../configure --prefix=/server/ImageMagick
   $ make -j4
   $ make install
   ```

4. 编译 php 扩展 `imagick`

   | `imagick` 路径                                      | 路径说明           |
   | --------------------------------------------------- | ------------------ |
   | `/package/lnmp/php-ext/imagick-3.4.4`               | 源码路径           |
   | `/package/lnmp/php-ext/imagick-3.4.4/imagick_bulid` | 构建路径           |
   | `/server/ImageMagick`                               | 编译库、运行库路径 |

   具体操作如下：

   ```sh
   $ cd /package/lnmp/php-ext/imagick-3.4.4
   $ phpize
   $ mkdir imagick_bulid
   $ cd imagick_bulid
   ```

   编译并安装：

   ```sh
   $ ../configure --with-imagick=/server/ImageMagick
   $ make -j4
   $ make test
   $ make install
   ```

   | 文件       | 路径                                                        |
   | ---------- | ----------------------------------------------------------- |
   | 扩展文件   | `/server/php/lib/php/extensions/no-debug-non-zts-20180731/` |
   | 扩展头文件 | `/server/php/include/php/`                                  |

5. php.ini 文件添加扩展配置

   ```sh
   $ vim /server/php/lib/php.ini
   ```

   `php.ini` 第 `941行` 左右添加以下内容：

   ```ini
   extension=imagick
   ```

6. 查询 `imagick` 扩展是否安装成功

   > 查看 php 是否正确加载 `imagick` 扩展

   ```sh
   $ php -m
   ```

   查看 `imagick` 是否可以正常运行：

   ```sh
   $ php --ri imagick
   ```

   | 输出内容                                    | 输出说明                   |
   | ------------------------------------------- | -------------------------- |
   | `Imagick compiled with ImageMagick version` | imagick 扩展编译库的版本号 |
   | `Imagick using ImageMagick library version` | imagick 扩展运行库的版本号 |

   > 提示：如果编译库和运行库的版本号不一致，imagick 扩展就不能正常运行！
