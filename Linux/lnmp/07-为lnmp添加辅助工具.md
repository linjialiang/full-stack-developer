# 为 LNMP 添加辅助工具

这里是 LNMP 善后工作，处理完这一步，下面我们就可以使用自己搭建的环境来开发项目了!

```text
- 对初学者的建议：
    在开发项目之前，建议大家先完全掌握本教程 Linux 区块内的所有内容浏览，只有这样才能在今后遇到问题时及时解决。
```

## 一、辅助工具之默认站点

我们在 lnmp 默认站点我们增加了几个实用工具!

> 默认站点信息：

| 序号 | 实用工具    | 描述                   |
| ---- | ----------- | ---------------------- |
| 01   | phpinfo.php | 用于查看 php 配置情况  |
| 02   | adminer.php | MariaDB 网页版管理系统 |
| 03   | phpMyAdmin  | MariaDB 网页版管理系统 |

### 默认站点 —— phpinfo

该工具使用了 php 自带的 phpinfo()指令，操作及其简单，具体如下：

1. 新建 phpinfo 脚本文件

   ```sh
   $ vim /server/default/index.php
   ```

2. phpinfo 文件添加内容：

   ```text
   <?php
   phpinfo();
   ```

### 默认站点 —— adminer

adminer 是 MariaDB 的管理系统，官方将其封装成了一个单独的文件，并且操作效率完爆 phpMyAdmin

1. 下载 adminer

   去 [adminer 官方](https://www.adminer.org/) 下载，如果只管理 `MySQL/MariaDB` ，请选择 MySQL 专版

2. 将 adminer 放置到默认站点根目录

   ```sh
   $ cp adminer.php /server/default/
   ```

### 默认站点 —— phpMyAdmin

adminer 是 MariaDB 的管理系统，是最经典的网页版管理系统，不过现在操作效率低下，期待改善

1. 下载 phpMyAdmin

   phpMyAdmin 官网地址如下：https://www.phpmyadmin.net/

2. 将 phpMyAdmin 压缩包解压到默认站点跟目录，并将其重命名为 pma

   ```sh
   $ mv pma/ /server/default/
   ```

3. 修改 phpmyadmin 配置文件

   pma 有一个默认配置文件，自定义配置文件需要自己创建，具体如下：

   ```sh
   $ cd /server/default/pma
   $ touch config.inc.php
   ```

   pma 自定义配置文件内容请查看 [config.inc.php](./source/config.inc.php)

4. phpmyadmin 设置目录的变量说明：

   | pma 变量            | 变量说明                               |
   | ------------------- | -------------------------------------- |
   | `$cfg['UploadDir']` | 上传文件的目录，web 用户需要查看权限   |
   | `$cfg['SaveDir']`   | 保存文件的目录，php-fpm 用户需要写权限 |
   | `$cfg['TempDir']`   | 缓存目录，php-fpm 用户需要有写权限     |

   说明：这 3 个目录我们重新指定了，其中部分需要我们自己创建并指明权限

5. 创建 phpmyadmin 的上传/保存目录

   ```sh
   $ mkdir -p /server/www/pma/upload
   $ mkdir /server/www/pma/save
   ```

6. phpmyadmin 目录权限说明

   | 目录                   | 所属用户 | 权限 | 是否自己创建 |
   | ---------------------- | -------- | ---- | ------------ |
   | /tmp/                  | root     | 777  | 系统自带     |
   | /server/www/pma        | root     | 550  | 自己创建     |
   | /server/www/pma/upload | www      | 750  | 自己创建     |
   | /server/www/pma/save   | www      | 770  | 自己创建     |

   ```sh
   $ chown root:root /server/www/pma/
   $ chown www:www /server/www/pma/save/
   $ chown www:www /server/www/pma/upload/
   $ chown chmod 550 /server/www/pma/
   $ chown chmod 750 /server/www/upload/
   $ chown chmod 770 /server/www/save/
   ```

### 默认站点 —— nginx 配置

Nginx 的默认站点的配置信息，请参考 [nginx.conf](./source/nginx/nginx.conf)

- 登陆地址列表：

  | 实用工具   | 登陆列表                          |
  | ---------- | --------------------------------- |
  | phpinfo    | http://192.168.10.251/            |
  | adminer    | http://192.168.10.251/adminer.php |
  | phpMyAdmin | http://192.168.10.251/pma/        |

## 二、辅助工具之 composer

php 开发必须完全掌握 composer，安装 composer 可以直接参考 [参考官方文档](https://getcomposer.org/download/)

1. 将 /server/php/bin 加入环境变量

   /server/php/bin 加入环境变量后，composer 操作就非常方便了，具体操作请参考 [为 php 安装 pecl 扩展](./04-为php安装pecl扩展.md)：

2. 下载 composer 执行文件

   ```sh
   $ cd ~
   $ php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
   $ php composer-setup.php
   $ php -r "unlink('composer-setup.php');"
   ```

   > 提示：这里随便了选择一个目录做为 composer 执行文件临时存放位置。

3. 移动 composer 执行文件

   ```sh
   $ mv ./composer.phar /server/php/bin/
   ```

   > 说明：将当前目录下的 composer.phar 文件移动至 php 执行文件的同级目录下

4. 重命名 composer 文件

   ```sh
   $ mv /server/php/bin/composer{.phar,}
   ```

   > 说明：我们通常是使用 composer 命令，而不是 composer.phar 命令。

5. 操作 composer

   为了安全起见，composer 应该以普通用户的身份执行，而不是 root 等特权用户，如：

   ```sh
   $ su emad
   ```

   > 说明：很多 composer 插件和脚本可以完全访问 `运行 Composer 的用户帐户`；出于这个原因，大部分 Linux 发行版都规定 root 用户无法运行 composer。

6. 切换全局 composer 镜像

   ```sh
   $ composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
   ```

   > 说明：国外的镜像总是很慢的，这里推荐大家使用 [阿里云 Composer 全量镜像](https://developer.aliyun.com/composer)
