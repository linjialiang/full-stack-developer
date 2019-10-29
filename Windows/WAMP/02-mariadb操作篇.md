# mariadb 操作篇

mariadb 这里只做最简单的配置，帮助新手快速搭建，更加高级的内容我们放在了运维部分。

## 创建 my.ini 文件

my.ini 是 mariadb 配置文件，我们在 mariadb 根目录上创建 my.ini，并输入以下内容

```ini
[client]
port = 3306
plugin-dir=c:/wamp/base/mariadb/lib/plugin

[mysqld]
port = 3306
datadir = "c:/wamp/web/data"
```

> 注意：my.ini 文件除了这些最基本配置以外，还需要开启一些日志功能，具体请查阅[MariaDB 日志篇](./../../MariaDB/01-MariaDB日志篇.md)

### 其他说明

| 序号 | 描述                                                       |
| ---- | ---------------------------------------------------------- |
| 01   | `innodb` 索引扩展默认会跟 `datadir` 同级，如无必要不用配置 |
| 02   | data 目录复制到`datadir`参数指定的路径下                   |

## 配置文件路径

默认情况下 mariadb 可读取如下文件的配置信息：

| 文件路径                  | 描述                                       |
| ------------------------- | ------------------------------------------ |
| `c:\my.ini`               | 全局，所有的 mysqld.exe 被启动时都可以读取 |
| `c:\wamp\mariadb\my.ini`  | 对应的 mysqld.exe 服务被启动时可读取       |
| `c:\wamp\web\data\my.ini` | 对应的 mysqld.exe 服务被启动时可读取       |

### 配置文件的读取顺序

| 优先级 | 描述                                                                |
| ------ | ------------------------------------------------------------------- |
| 01     | `--defaults-file="path"` 具有最高优先权（初始化时必须指定正确路径） |
| 02     | 系统盘更目录下的文件， `c:\my.ini`                                  |
| 03     | mariadb 安装目录下的文件, `c:\wamp\mariadb\my.ini`                  |
| 04     | mariadb 数据目录下的文件, `c:\wamp\web\data\my.ini`                 |

> 提示：mysqld.exe 服务器只会读取一个默认配置文件，所以大家有必要了解配置文件的优先级！

## 初始化 mariadb 数据

> 初始化 `mariadb数据库存放目录的数据` 需要如下几个步骤：

| 序号 | 初始化步骤内容                                                         |
| ---- | ---------------------------------------------------------------------- |
| 1    | 将 data 目录内容复制到指定的 mariadb 数据库存放目录                    |
| 2    | 打开 cmd（需管理员权限）                                               |
| 3    | cmd 进入 mariadb 的 bin 目录                                           |
| 4    | 查找 mariadb 配置文件 my.ini                                           |
| 5    | 获取 mariadb 数据存放目录（一般都是命名 data）所在位置                 |
| 6    | 开始执行初始化操作                                                     |
| 7    | 数据存放目录的数据会被初始化                                           |
| 8-1  | 使用`mysqld --initialize`指令，root 用户会生成随机密码，日志中查看密码 |
| 8-2  | 使用`mysqld --initialize-insecure`指令，root 用户空密码                |

> 初始化 `mariadb数据库存放目录的数据` 相关说明

| 序号 | 初始化相关问题                                    | 描述                                             |
| ---- | ------------------------------------------------- | ------------------------------------------------ |
| 1    | my.ini 中的数据库存放目录不是默认目录，会怎么办？ | my.ini 下自定的数据库存放目录优先                |
| 2    | my.ini 中指定的数据库存放目录没有找到，会怎么办？ | mariadb 根目录下的数据库存放目录`data`会被初始化 |
| 3    | 没有找到 my.ini，会怎么办？                       | mariadb 根目录下的数据库存放目录`data`会被初始化 |

### 创建 data 目录数据

从 mariadb 10.4 开始 data 目录默认为空，需要通过 `mysql_install_db.exe` 来生成 mariadb
.基本数据！

1. 使用 `mysql_install_db.exe` 生成 mariadb 基础数据

   ```shell
   > cd c:\wamp\base\mariadb\bin
   > mysql_install_db.exe --datadir=c:/wamp/web/data --password=123456
   ```

   > 便捷：双击 `mysql_install_db.exe` 即可生成 mariadb 基础数据（默认路径为：`c:\wamp\base\mariadb\data`）

2. 移除 `c:\wamp\web\data\php.ini` 文件

## 配置 phpmyadmin

> phpmyadmin 是一款非常优秀的 web 端数据库管理平台，使用语言 php，支持 mysql 和 mariadb

### phpmyadmin 默认配置文件

`libraries/config.default.php` 是 phpmyadmin 的默认配置文件，建议不要修改

### 创建 phpmyadmin 配置文件

所有自己配置的内容都放在 `config.inc.php` 文件内（phpmyadmin 根目录，如果不存在就需要手动新建一个）！

### `config.sample.inc.php` 文件

这是让我们参考的文件，我们也可以直接复制一份黏贴到 `config.inc.php` 文件

### 一个简洁的 config.inc.php 配置内容：

```php
# 短语密码,cookie认证时不能为空，大于32为佳
$cfg['blowfish_secret'] = 'fvNqC4^HR8WELJ7$C5UD2a&xk6w@Rfr4M(MBU';
$i = 0;
$i++;
# 设置登陆方式为cookie
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['host'] = 'localhost';
$cfg['Servers'][$i]['compress'] = false;
$cfg['Servers'][$i]['AllowNoPassword'] = false;
$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';
# 设置主题
$cfg['ThemeDefault'] = 'original';
```

### 提示部分功能未启用的解决方法

1.  删除数据库： 将 phpmyadmin 数据库删除
2.  登陆 phpMyAdmin:首页找到原因那里，进入原因页面
3.  创建数据库：进入原因页面后，点击 Create 会自动创建 phpmyadmin 数据库，这样即可！

### phpMyAdmin 一些注意事项

1. 数据库提供 phpmyadmin 的高级功能，如果删除，高级功能将无法使用 – 如果未安装或已经删除，可以在找到原因那里，点击 Create 自动创建
2. phpMyAdmin 连接数据库使用的是 php 的 mysqli 扩展，所以 php 必须安装 mysqli 扩展包
3. phpMyAdmin cookie 登陆方式默认要求账户需要带密码登陆（当然也可以开放空密码登陆），所以我们要为 mariadb 创建一个带密码的账户

## 附录一：

`InnoDB` 索引的 mariadb 如何拷贝数据库到另一台服务器上？

1. `InnoDB` 索引的数据全部记录在 `ibdata1` 、`ibdata2` 等文件上
2. 如果想直接复制数据库就必须要将 `InnoDB` 索引数据文件 `ibdata*` 跟着全部复制过来；
3. 并且，如果 `InnoDB` 版本不一致，也可能导致数据库加载失败
4. 因此这里推荐大家使用 phpmyadmin 或 adminer 等工具导出 sql 文件，再通过相同文件导入。
