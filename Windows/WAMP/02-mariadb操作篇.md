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
| 01   | 将 data 目录内容复制到指定的 mariadb 数据库存放目录                    |
| 02   | 打开 cmd（需管理员权限）                                               |
| 03   | cmd 进入 mariadb 的 bin 目录                                           |
| 04   | 查找 mariadb 配置文件 my.ini                                           |
| 05   | 获取 mariadb 数据存放目录（一般都是命名 data）所在位置                 |
| 06   | 开始执行初始化操作                                                     |
| 07   | 数据存放目录的数据会被初始化                                           |
| 08   | 使用`mysqld --initialize`指令，root 用户会生成随机密码，日志中查看密码 |
| 09   | 使用`mysqld --initialize-insecure`指令，root 用户空密码                |

> 初始化 `mariadb数据库存放目录的数据` 相关说明

| 序号 | 初始化相关问题                                    | 描述                                             |
| ---- | ------------------------------------------------- | ------------------------------------------------ |
| 1    | my.ini 中的数据库存放目录不是默认目录，会怎么办？ | my.ini 下自定的数据库存放目录优先                |
| 2    | my.ini 中指定的数据库存放目录没有找到，会怎么办？ | mariadb 根目录下的数据库存放目录`data`会被初始化 |
| 3    | 没有找到 my.ini，会怎么办？                       | mariadb 根目录下的数据库存放目录`data`会被初始化 |

### 创建 `datadir` 目录数据

从 MariaDB 10.4 开始 datadir 目录需要开发人员自己生成。

1. 生成 `datadir` 目录

   > 可执行程序 `mysql_install_db.exe` 用于生成 MariaDB 的 `datadir` 目录，并初始化基础数据

   ```shell
   > cd c:\wamp\base\mariadb\bin
   > mysql_install_db.exe --datadir=c:/wamp/web/data --password=123456
   ```

   | 便捷操作                                        |
   | ----------------------------------------------- |
   | 双击 `mysql_install_db.exe` 生成 `datadir` 目录 |
   | 默认路径：`c:\wamp\base\mariadb\data`           |

2. 移除 `datadir` 文件

   | 不需要文件        | 描述                                   |
   | ----------------- | -------------------------------------- |
   | `${hostname}.err` | 错误日志，由 my.ini 重新指定           |
   | `my.ini`          | 配置文件已经存在于 MariaDB 根目录中    |
   | `test` 目录       | 一个测试用的数据库，部署环境建议移除掉 |

### 必备文件说明：

| 必备数据                    | 描述                                       |
| --------------------------- | ------------------------------------------ |
| `mysql` 目录                | 专门用于管理 MariaDB 的数据库              |
| `performance_schema`目录    | 用于收集数据库服务器性能参数               |
| `aria_log.%`                | Aria 存储引擎的日志文件                    |
| `aria_log_control`          | Aria 存储引擎的日志控制文件                |
| `ib_logfile1` `ib_logfile2` | InnoDB 的`重做日志文件`                    |
| `ib_buffer_pool`            | InnoDB 存取内存热数据的文件                |
| `ibdata1`                   | InnoDB 的共享表空间                        |
| `multi-master.info`         | 多源复制相关文件，包含所有正在使用的主连接 |
| `bin-log%`                  | 二进制日志文件（自动生成）                 |
| `bin-log.index`             | 二进制日志文件索引（自动生成）             |
| `multi-master.info`         | 多源复制相关文件，包含所有正在使用的主连接 |

> 热数据：是需要被计算节点频繁访问的在线类数据。

1. `ib_buffer_pool` 文件详解

   | 关闭 MariaDB 时 | 把内存中的热数据保存在 `ib_buffer_pool` 文件中;              |
   | --------------- | ------------------------------------------------------------ |
   | 启动 MariaDB 后 | `ib_buffer_pool` 文件内容自动加载到 `Buffer_Pool` 缓冲池里。 |

2. `重做日志文件` 详解

   重做日志文件其实就是`innodb`存储引擎产生的日志，默认在 `innodb_data_home_dir` 下面有两个文件 `ib_logfile0` 和 `ib_logfile1`

   | 原理 | `innodb` 存储引擎，先将操作写入 `重做日志文件` 中，再进行数据库操作。              |
   | ---- | ---------------------------------------------------------------------------------- |
   | 作用 | 当发生故障 `innodb` 存储引擎就会使用 `重做日志文件` 进行恢复，保证数据库的完整性。 |

3. 存储引擎

   | 存储引擎 | 描述                                                           |
   | -------- | -------------------------------------------------------------- |
   | `innodb` | MariaDB 默认存储引擎                                           |
   | `Aria`   | MariaDB 强制启动的存储引擎，用于替代 MySQL 的`MyISAM` 存储引擎 |

   > 指令：使用 `show engines;` 可以查询 MariaDB 所有存储引擎

4. `innodb` 的共享表空间

   `ibdata1` 文件是`innodb` 的共享表空间文件，一般存储下表数据：

   | 数据                                                               |
   | ------------------------------------------------------------------ |
   | 数据字典（也就是 InnoDB 表的元数据）                               |
   | 变更缓冲区                                                         |
   | 双写缓冲区                                                         |
   | 撤销日志                                                           |
   | 所有使用 InnoDB 引擎的数据库的表数据（开启独立表空间后，不再存储） |

   > 指令：使用 `show variables like 'innodb_file_per_table';` 查看是否开启独立表空间。

## 指定 pid 文件

> pid 文件默认会在`datadir`目录自动生成，为了便于管理，我们可以单独指定：

```ini
[mysqld]
pid-file="c:/wamp/base/conf/mariadb.pid"
```

> 提示：需要保证目录存在，并且 `mariadb.pid` 文件不能创建！

## ~~配置 phpmyadmin~~

~~phpmyadmin 是一款非常优秀的 web 端数据库管理平台，使用语言 php，支持 mysql 和 mariadb（当前已经移除，需要可自行添加）~~

1.  phpmyadmin 默认配置文件

    `libraries/config.default.php` 是 phpmyadmin 的默认配置文件，建议不要修改

2.  创建 phpmyadmin 配置文件

    所有自己配置的内容都放在 `config.inc.php` 文件内（phpmyadmin 根目录，如果不存在就需要手动新建一个）！

3.  `config.sample.inc.php` 文件

    这是让我们参考的文件，我们也可以直接复制一份黏贴到 `config.inc.php` 文件

    > 简洁的 config.inc.php 案例：

    ```php
    <?php
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
    ?>
    ```

4.  提示部分功能未启用的解决方法

    | 删除数据库        | 将 `phpmyadmin` 数据库删除                               |
    | ----------------- | -------------------------------------------------------- |
    | 登陆 `phpMyAdmin` | 首页找到原因那里，进入原因页面                           |
    | 创建数据库        | 点击 `Create` 会自动创建 `phpmyadmin` 数据库，这样即可！ |

5.  phpMyAdmin 一些注意事项

    |                                                                                 |
    | ------------------------------------------------------------------------------- |
    | 删除`phpmyadmin`数据库，高级功能将无法使用(找到原因 `>` 点击 `Create` 自动创建) |
    | phpMyAdmin 需要 php 开启 mysqli 扩展                                            |
    | cookie 登陆方式默认需要用户的密码不为空（空密码登陆需要另外配置）               |

## 附录一：

`InnoDB` 索引的 mariadb 如何拷贝数据库到另一台服务器上？

1. 复制数据库需要先复制 `ibdata1` 文件，再复制想要的数据库目录；
2. 这里建议大家使用 `adminer` 等数据库管理系统将需要的数据库导出到 sql 文件，再用相同的数据库管理系统文件导入。

> 到此 wamp 的 mariadb 操作篇讲解完毕，更多内容请查阅 [关系型数据库-MariaDB 篇](./../../MariaDB/README.md)
