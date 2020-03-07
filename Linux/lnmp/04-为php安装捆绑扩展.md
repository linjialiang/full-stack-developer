# 为 PHP 安装捆绑扩展

PHP 捆绑扩展顾名思义，与 PHP 捆绑在一起，这类扩展部分被默认安装，但是有些需要添加编译选项，但编译它们通常不需要其它依赖包

| 扩展    | 描述                                                                                                                |
| ------- | ------------------------------------------------------------------------------------------------------------------- |
| GD      | 图像处理扩展，现在大多数人喜欢用 Imagick 来代替                                                                     |
| Sockets | Socket 扩展是基于流行的 BSD sockets，实现了和 socket 通讯功能的底层接口，它可以和客户端一样当做一个 socket 服务器。 |

## 安装 GD 扩展

1. 拷贝源码至 `/package/ext` 目录下

   ```sh
   $ cp -p -r /package/php-7.4.3/ext/gd /package/ext/
   ```

2. 使用 phpize 生成可编译源码

   ```SH
   $ cd /package/ext/gd
   $ phpize
   ```

3. 编译安装

   ```sh
   $ ./configure
   $ make -j4
   $ make test
   $ make install
   Installing shared extensions:     /server/php/lib/php/extensions/no-debug-non-zts-20190902/
   Installing header files:          /server/php/include/php/
   ```

4. 在 PHP 配置文件(php.ini)上，启用 gd 扩展

   ```sh
   $ vim /server/php/lib/php.ini
   ```

   `php.ini` 第 `950行` 左右添加以下内容：

   ```ini
   extension=gd
   ```

5. 查询 `gd` 扩展是否安装成功

   ```sh
   $ php -m
   ```

6. 查看 `gd` 是否可以正常运行：

   ```sh
   $ php --ri gd
   ```

## 安装 Sockets 扩展

安装 Sockets 扩展与安装 gd 扩展基本一致,指令如下：

```sh
# 拷贝源码至 `/package/ext` 目录下
$ cp -p -r /package/php-7.4.3/ext/sockets /package/ext/
# 使用 phpize 生成可编译源码
$ cd /package/ext/gd
$ phpize
# 编译安装
$ ./configure
$ make -j4
$ make test
$ make install
Installing shared extensions:     /server/php/lib/php/extensions/no-debug-non-zts-20190902/
Installing header files:          /server/php/include/php/
# 在 PHP 配置文件(php.ini)上，启用 gd 扩展
$ vim /server/php/lib/php.ini
# `php.ini` 第 `950行` 左右添加以下内容：
extension=sockets
# 查询 `sockets` 扩展是否安装成功
$ php -m
# 查看 `sockets` 是否可以正常运行：
$ php --ri gd
```
