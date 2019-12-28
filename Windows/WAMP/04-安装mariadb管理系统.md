# 安裝 MariaDB 管理系統

WAMP 从 `v6.0.0` 开始，采用 composer 安装 MariaDB 管理系统。

## 管理系统一览表

WAMP 将自带以下两款 web 端数据库管理系统：

| DB 管理系统 | 网址                        |
| ----------- | --------------------------- |
| adminer     | https://www.adminer.org/    |
| phpmyadmin  | https://www.phpmyadmin.net/ |

> 附录：[phpmyadmin 中文手册](https://docs.phpmyadmin.net/zh_CN/latest/)

- 申明：本人已经放弃 phpmyadmin，因为它越来越卡了

## 安装 phpMyAdmin

phpMyAdmin 是 `MySQL/MariaDB` 最著名的管理系统，由 PHP 语言编写。

```sh
$ c:
$ cd C:\\wamp
$ composer create-project phpmyadmin/phpmyadmin pma
$ composer update
```

- httpd 配置：

  ```conf
  Alias /phpmyadmin ${WAMP_ROOT}/pma
  <Directory ${WAMP_ROOT}/pma>
      Options FollowSymLinks
      DirectoryIndex index.php
      <RequireAll>
          Require local
      </RequireAll>
  </Directory>
  <Directory ${WAMP_ROOT}/pma/libraries>
      Require all denied
  </Directory>
  <Directory ${WAMP_ROOT}/pma/setup/lib>
      Require all denied
  </Directory>
  ```

### 配置 phpmyadmin

使用 composer 安装成功后，我们还需要对 phpmyadmin 做一些简单的配置，具体如下：

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

    ```sh
    - 如果存在 phpmyadmin 数据库请先删除，刷新页面：
        1. 找到原因 “>”
        2. 接着点击 “Create” 自动创建)
    - phpMyAdmin 需要 php 开启 mysqli 扩展
    - cookie 登陆方式默认需要用户的密码不为空（空密码登陆需要另外配置）
    ```

6.  composer 安装 phpMyAdmin 注意事项：

    使用 composer 安装 phpMyAdmin，需要依赖多个 php 扩展，具体查看 `composer.json` 文件。

    > 案例： 如 `5.0.x-dev` 版本需要开启以下 php 扩展：

    | 序号 | 必需开启的 php 扩展 |
    | ---- | ------------------- |
    | 01   | php_mysqli          |
    | 02   | php_xml             |
    | 03   | php_pcre            |
    | 04   | php_json            |
    | 05   | php_iconv           |
    | 06   | php_hash            |

    | 序号 | 建议开启的 php 扩展 |
    | ---- | ------------------- |
    | 01   | php_openssl         |
    | 02   | php_curl            |
    | 03   | php_opcache         |
    | 04   | php_zlib            |
    | 05   | php_bz2             |
    | 06   | php_zip             |
    | 07   | php_gd2             |
    | 08   | php_mbstring        |

## 安装 adminer

adminer 是 PHP 语言编写，支持多种数据库系统，由于其出色的执行速度使得其大受程序员欢迎！

```sh
$ cd C:\\wamp
$ composer create-project vrana/adminer
$ composer update
```

> httpd 配置：

```conf
Alias /adminer ${WAMP_ROOT}/adminer/adminer
<Directory ${WAMP_ROOT}/adminer/adminer>
    Options FollowSymLinks
    DirectoryIndex index.php
    <RequireAll>
        Require local
    </RequireAll>
</Directory>
```

## 附录

1. 删除多余的 MariaDB 用户

   MariaDB 默认有多个用户，Windows 下只需保留 `root@localhost`，建议将其余的删除。

   > 提示：通过 phpMyAdmin 或 adminer 可以更加轻松的管理数据库！
