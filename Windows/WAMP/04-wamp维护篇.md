# wamp 维护篇

本篇涉及 httpd 和 mariadb 两个软件的 `安装、卸载、启动、关闭、开机启动项` 等设置

## 维护 httpd

1. 将 httpd 安装进系统服务中

   以管理员的身份打开 cmd，具体操作如下：

   ```shell
   cd c:\wamp\base\httpd\bin
   httpd.exe -k install -n <service-httpd>
   ```

   > 安装多个 httpd 服务时，httpd 服务名称不能一样

2. 将 httpd 从系统服务中卸载

   | 卸载方法   | 代码                                        |
   | ---------- | ------------------------------------------- |
   | httpd 卸载 | `httpd.exe -k uninstall -n <service-httpd>` |
   | sc 卸载    | `sc delete <service-httpd>`                 |

3. httpd 服务启停

   | 服务 | 代码                        |
   | ---- | --------------------------- |
   | 启动 | `net start <service-httpd>` |
   | 停止 | `net stop <service-httpd>`  |

## 维护 mariadb

1. 安装 mariadb 到系统服务

   以管理员的身份打开 cmd，具体操作如下：

   ```shell
   cd c:\wamp\base\mariadb\bin
   mysqld.exe --install <service-mariadb>
   ```

2. 卸载 mariadb 系统服务

   | 卸载方法     | 代码                                    |
   | ------------ | --------------------------------------- |
   | mariadb 卸载 | `mysqld.exe --remove <service-mariadb>` |
   | sc 卸载      | `sc <server> delete <service-mariadb>`  |

3. mariadb 启停

   | 服务 | 代码                          |
   | ---- | ----------------------------- |
   | 启动 | `net start <service-mariadb>` |
   | 停止 | `net stop <service-mariadb>`  |

## 修改系统服务启动类型

Windows 系统服务项的启动类型分为如下三种：

| `<set-value>` | 类型 | miaoshu      |
| ------------- | ---- | ------------ |
| auto          | 自动 | 开机自动启动 |
| demand        | 手动 | 需要手动启动 |
| disabled      | 禁用 | 无法启动     |

以管理员的身份打开 cmd，具体操作如下：

```shell
sc config <service-name> start=<set-value>
```

## 附录：wamp 使用说明书

| 步骤 | 说明                                                                   |
| ---- | ---------------------------------------------------------------------- |
| 01   | 将 `wamp.7z` 解压到 C 盘根目录                                         |
| 02   | 将 `C:\wamp\base\ImageMagick\bin` 加入系统变量(启动 `magick` 扩展必备) |
| 03   | 使用 `C:\wamp\install.bat` 脚本安装系统服务                            |
| 04   | 使用 `C:\wamp\便捷指令.bat` 脚本管理服务启动                           |
| 05   | `C:\wamp\web\sites\*.conf` 存放所有虚拟站点配置文件                    |
| 06   | `http://localhost/adminer` 可以进入网页版 MariaDB 管理系统             |
| 07   | MariaDB 的 root 密码默认为 `123456`                                    |

> 如果想要更换目录，需修改以下几个文件的内容：

| 步骤 | 修改内容                                              |
| ---- | ----------------------------------------------------- |
| 01   | `httpd.conf` 第 1 行 `WAMP_ROOT` 的变量值             |
| 02   | `my.ini` 下所有与路径相关的参数值                     |
| 03   | 修改 `php.ini` 下 `extension_dir` 参数值              |
| 04   | 修改 `php.ini` 下 `xdebug.profiler_output_dir` 参数值 |
| 05   | 修改 `php.ini` 下 `xdebug.trace_output_dir` 参数值    |
