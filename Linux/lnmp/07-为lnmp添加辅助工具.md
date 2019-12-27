# 为 LNMP 添加辅助工具

这里是 LNMP 善后工作，处理完这一步，下面我们就可以使用自己搭建的环境来开发项目了!

## 一、对初学者的建议

在开发项目之前，建议大家先完全掌握本教程 Linux 区块内的所有内容浏览，只有这样才能在今后遇到问题时及时解决。

## 二、辅助工具之 phpinfo

该辅助工具只是为了让我们直观的观察 php 配置情况，操作非常简单，具体如下：

1. 在默认站点根目录(/server/default)下新建 phpinfo.php

   ```sh
   $ vim /server/default/phpinfo.php
   ```

2. 打开 phpinfo.php 文件，添加内容

   ```php
   <?php
   phpinfo();
   ```

保存文件，到此安装完成！

## 三、辅助工具之 composer

最为 php 开发者，必须完全掌握 composer，安装 composer 可以直接参考 [参考官方文档](https://getcomposer.org/download/)

### 将 /server/php/bin 加入环境变量

加入环境变量后操作就非常方便了，如果不加入环境变了后期操作也会非常繁琐，这里就不对齐做过多说明

1. 修改控制环境变量的文件

   ```sh
   $ cp /etc/profile{,.bak}
   $ vim /etc/profile
   ```

2. `/etc/profile` 底部增加一行内容：

   ```text
   export PATH=$PATH:/server/php/bin:/server/php/sbin
   ```

3. 使用 `source` 指令重新激活文件：

   ```sh
   $ source /etc/profile
   ```

### 开始安装 composer

1. 为了方便操作，这里我们在 /root 目录下安装它

   ```sh
   $ cd ~
   $ php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
   $ php composer-setup.php
   $ php -r "unlink('composer-setup.php');"
   ```

2. 将安装好的 `composer.phar` 文件移动至 php 执行文件的同级目录下：

   ```sh
   $ mv ./composer.phar /server/php/bin/composer
   ```

3. 切换普通用户登陆界面操作

   很多 composer 插件和脚本可以完全访问运行 Composer 的用户帐户。出于这个原因，官方强烈建议避免将 Composer 作为超级用户(root)运行。

   ```sh
   $ su emad
   ```

4. 全局切换 composer 镜像

   ```sh
   $ composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
   ```

## 三、安装 MariaDB 的管理系统 —— adminer

这里使用 composer 安装，具体如下：

1. 对 /server/default 目录设置 777 权限，并进入普通帐号

   ```sh
   $ chmod 777 /server/default
   $ cd /server/default
   $ su emad
   ```

2. 使用 composer 直接安装 adminer

   ```sh
   $ composer create-project vrana/adminer adminer
   ```

3. 使用 composer 更新

   ```sh
   $ cd /server/default/adminer
   $ composer update
   ```

4. 回到 root 用户，将 adminer 用户设置为 www

   ```sh
   $ chown www:www -R /server/default/adminer
   ```

## 四、安装 MariaDB 的管理系统 —— phpMyAdmin

安装方式基本与 adminer 一样，具体如下：

```sh
$ composer create-project phpmyadmin/phpmyadmin pma
$ cd /server/default/pma
$ composer update
```

> phpMyAdmin 安装成功，还有一些简单的配置，请查看 WAMP 下的 [安装 mariadb 管理系统](./../../Windows/WAMP/04-安装mariadb管理系统.md)
