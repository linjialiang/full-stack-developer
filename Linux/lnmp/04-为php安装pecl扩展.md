# 为 PHP 安装 PRCL 扩展

安装扩展的方式大同小异，下面是需要安装的两个 prcl 扩展

| PRCL 扩展                                       | 描述                    |
| ----------------------------------------------- | ----------------------- |
| [imagick](https://pecl.php.net/package/imagick) | 处理图片的 PHP 扩展     |
| [xdebug](https://pecl.php.net/package/xdebug)   | 用于显示 PHP 错误的扩展 |

## phpize 程序

`phpize` 可以将 PECL 扩展源码构建为可用 `./configure` 编译的源码，使用 `phpize --help` 可以查看帮助。

1. 配置环境变量:

   将 `php 可执行程序目录` 的路径加入环境变量中，可以方便 `phpize` 操作

   > 修改控制环境变量的文件

   ```sh
   $ cp /etc/profile{,.bak}
   $ vim /etc/profile
   ```

   > `/etc/profile` 底部增加一行内容：

   ```sh
   export PATH=$PATH:/server/php/bin:/server/php/sbin
   ```

   > 使用 `source` 指令重新激活文件：

   ```sh
   $ source /etc/profile
   ```

2. 指定 php 配置文件

   使用 `phpize` 前，必须正确配置 `php.ini` 文件

   | 指令                                           | 描述                          |
   | ---------------------------------------------- | ----------------------------- |
   | `php --ini`                                    | 查询 php 配置文件信息         |
   | `/package/lnmp/php-7.3.11/php.ini-development` | php 配置文件模版 - 开发环境   |
   | `/package/lnmp/php-7.3.11/php.ini-production`  | php 配置文件模版 - 开部署环境 |

   > 具体操作如下：

   ```sh
   $ cp -p -r /package/lnmp/php-7.3.11/php.ini-development /server/php/lib/php.ini
   ```

3. 创建 PRCL 扩展源码目录

   ```sh
   $ mkdir -p /package/lnmp/php-ext
   ```

   > PRCL 扩展的默认安装路径为 `/server/php/lib/php/extensions/no-debug-non-zts-20180731/`

## 安装 PRCL 扩展 —— `xdebug`

1. xdebug 目录列表

   | xdebug 目录 | 路径                                                    |
   | ----------- | ------------------------------------------------------- |
   | 源码路径    | `/package/lnmp/php-ext/xdebug-2.8.0`                    |
   | 构建路径    | `mkdir /package/lnmp/php-ext/xdebug-2.8.0/xdebug_bulid` |

2. 编译安装

   ```sh
   $ cd /package/lnmp/php-ext/xdebug-2.8.0
   $ phpize
   $ cd xdebug_bulid
   $ ../configure
   $ make -j4
   $ make test
   $ make install
   ```

3. php.ini 文件添加扩展配置

   ```sh
   $ cp /server/php/lib/php.ini{,.bak}
   $ vim /server/php/lib/php.ini
   ```

   `php.ini` 底部增加如下如下：

   ```ini
   [Xdebug]
   zend_extension=xdebug
   xdebug.profiler_append = 0
   xdebug.profiler_enable = 1
   xdebug.profiler_enable_trigger = 0
   xdebug.profiler_output_dir ="/logs/php/xdebug"
   xdebug.trace_output_dir ="/logs/php/xdebug"
   xdebug.profiler_output_name = "cache.out.%t-%s"
   xdebug.remote_enable = 1
   xdebug.remote_autostart = 1
   xdebug.remote_handler = "dbgp"
   xdebug.remote_host = "127.0.0.1"
   xdebug.idekey= PHPSTROM
   ```

   配置文件指定的日志路径必须存在：

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
