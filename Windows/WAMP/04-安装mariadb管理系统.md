# 安裝 MariaDB 管理系統

WAMP 从 `v6.0.0` 开始，采用 composer 安装 MariaDB 管理系统。

## 管理系统一览表

WAMP 将自带以下两款 web 端数据库管理系统：

| DB 管理系统 | 网址                        |
| ----------- | --------------------------- |
| adminer     | https://www.adminer.org/    |
| phpmyadmin  | https://www.phpmyadmin.net/ |

> 附录：[phpmyadmin 中文手册](https://docs.phpmyadmin.net/zh_CN/latest/)

## 安装 phpMyAdmin

phpMyAdmin 是 `MySQL/MariaDB` 最著名的管理系统，由 PHP 语言编写。

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

    pma 根目录下的 config.inc.php 文件是我们自定义配置的内容，具体内容如下：

    ```text
    <?php
    declare(strict_types=1);

    # 短语密码, cookie认证时不能为空，官方建议大于32
    $cfg['blowfish_secret'] = 'fvNqC4^HR8WELJ7$C5UD2a&xk6w@Rfr4M(MBU';
    $i = 0;
    $i++;

    # 设置登陆方式为 cookie
    $cfg['Servers'][$i]['auth_type'] = 'cookie';
    # MariaDB-server 主机地址
    $cfg['Servers'][$i]['host'] = 'localhost';
    # 是否使用压缩协议来连接 MariaDB-server
    $cfg['Servers'][$i]['compress'] = false;
    # 是否允许空密码登陆
    $cfg['Servers'][$i]['AllowNoPassword'] = false;

    $cfg['UploadDir'] = '';
    $cfg['SaveDir'] = '';
    # 默认语言
    $cfg['DefaultLang'] = 'zh';
    # 设置主题
    $cfg['ThemeDefault'] = 'original';
    ```

    > 提示：Linux 下我们重新指定了缓存目录变量(`$cfg['TempDir']`)，而 windows 下没有权限限制，不必重新指定。

3.  `config.sample.inc.php` 文件

    这是让我们参考的文件，通常直接拷贝一份命名为 `config.inc.php` 就能配置成功。

4.  提示部分功能未启用的解决方法

    | 删除数据库        | 将 `phpmyadmin` 数据库删除                               |
    | ----------------- | -------------------------------------------------------- |
    | 登陆 `phpMyAdmin` | 首页找到原因那里，进入原因页面                           |
    | 创建数据库        | 点击 `Create` 会自动创建 `phpmyadmin` 数据库，这样即可！ |

5.  phpMyAdmin 一些注意事项

    ```text
    - 如果存在 phpmyadmin 数据库请先删除，刷新页面：
        1. 找到原因 “>”
        2. 接着点击 “Create” 自动创建)
    - phpMyAdmin 需要 php 开启 mysqli 扩展
    - cookie 登陆方式默认需要用户的密码不为空（空密码登陆需要另外配置）
    ```

## 安装 adminer

adminer 是 PHP 语言编写，支持多种数据库系统，由于其出色的执行速度使得其大受程序员欢迎！

- httpd 配置：

  ```conf
  Alias /adminer ${WAMP_ROOT}
  <Directory ${WAMP_ROOT}>
      Options FollowSymLinks
      DirectoryIndex adminer.php
      <RequireAll>
          Require local
      </RequireAll>
  </Directory>
  ```
