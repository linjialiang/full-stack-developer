# httpd 操作篇

Apache24 是当前最流行的 web 服务器软件之一，我们通常简写为 httpd。

> 注意： 即时是在 Windows 下， httpd 配置文件也只支持斜杆 `/` 作为目录分隔符（出现反斜杠 `\` 就会报错）

## httpd 配置文件

httpd 配置文件分为 `主配置文件` 和 `自定义配置文件` ，它们之间的具体说明如下：

> 主配置文件说明：

| 主配置文件 | 描述                                 |
| ---------- | ------------------------------------ |
| 路径       | `C:/wamp/base/httpd/conf/httpd.conf` |
| 数量       | 有且仅有 1 个                        |

> 自定义配置文件说明：

| 自定义配置文件说明 | 描述                                |
| ------------------ | ----------------------------------- |
| 路径               | 通过主配置文件中 `Include` 语句加载 |
| 数量               | 允许多个文件，如：站点配置文件      |

> 警告：由于 `Include` 需要模块 `mod_include.so` 支持，所以我们需要在模块定义之后添加！

## 配置文件操作

httpd 配置文件所涉及到的知识点都在这里了！

### httpd 设置变量

对于 httpd 配置文件中经常使用路径或端口，我们可以为它们设置变量：

| http 变量 | 内容                   |
| --------- | ---------------------- |
| 格式      | `Define 变量名 变量值` |
| 使用      | `${变量名}`            |

> 此次 wamp 定义的变量列表及其作用说明：

| 变量定义                                   | 变量输出        | 变量说明                  |
| ------------------------------------------ | --------------- | ------------------------- |
| `Define WAMP_ROOT "c:/wamp"`               | `${WAMP_ROOT}`  | wamp 目录                 |
| `Define SRVROOT "${WAMP_ROOT}/base/httpd"` | `${SRVROOT}`    | httpd 自带变量            |
| `Define HTDOCS "${WAMP_ROOT}/web/www"`     | `${HTDOCS}`     | httpd 站点目录            |
| `Define HTTP_PORT "80"`                    | `${HTTP_PORT}`  | 虚拟主机 http 协议端口号  |
| `Define HTTPS_PORT "443"`                  | `${HTTPS_PORT}` | 虚拟主机 https 协议端口号 |

> 警告：尽量少定义变量，这会增加 httpd 的负荷！

### 变量 `SRVROOT`

SRVROOT 是 httpd 主配置文件里自带的变量，用于确定 httpd 所在位置，默认值为 `c:/Apache24`。

| 默认值                         | 需要的值                                   |
| ------------------------------ | ------------------------------------------ |
| `Define SRVROOT "c:/Apache24"` | `Define SRVROOT "${WAMP_ROOT}/base/httpd"` |

### 增加自定义配置文件

自定义配置文件通过主配置文件中 `Include` 语句加载，支持相对路径和绝对路径，具体代码如下：

```shell
<IfModule include_module>
    Include "${WAMP_ROOT}/base/conf/httpd.conf"
</IfModule>
```

> 提示：在此 wamp 设计中， `C:/wamp/base/conf/httpd.conf` 自定义配置文件是必备的！

### 清理多余配置项目

主配置文件里有很多注释和多余的内容，我们这里可以将其移除掉，具体如下：

| 序号 | 允许移除的内容                                                                     |
| ---- | ---------------------------------------------------------------------------------- |
| 01   | 所有注释内容，都可以移除                                                           |
| 02   | 除了加载 `mod_include.so` 模块必须在主配置文件定义外，其余都可以在自配置文件里定义 |

## 源码参考

下面列出供大家参考的配置文件源码：

| 序号 | 源码列表                                            |
| ---- | --------------------------------------------------- |
| 01   | [主配置文件](./httpd/01-httpd主配置文件.md)         |
| 02   | [自定义配置文件](./httpd/02-httpd自定义配置文件.md) |
| 03   | [http 站点配置](./httpd/03-http站点配置.md)         |
| 04   | [https 站点配置](./httpd/04-https站点配置.md)       |
| 05   | [alias 站点配置](./httpd/05-alias站点配置.md)       |

## 修改配置文件

这里讲解是配置文件中我们可能需要改变的内容。

### 加载必要模块

下面是我经常使用的两个模块

| 模块名        | 加载模块                                                   |
| ------------- | ---------------------------------------------------------- |
| `mod_alias`   | `LoadModule vhost_alias_module modules/mod_vhost_alias.so` |
| `mod_rewrite` | `LoadModule rewrite_module modules/mod_rewrite.so`         |

> 加载模块格式 `LoadModule 模块标识符 模块路径（支持相对路径和绝对路径）`

### 绑定 php

我们这里采用了模块的方式绑定 php：

| 绑定 php 步骤 | 描述                       |
| ------------- | -------------------------- |
| 01            | 加载 httpd 自带的 php 模块 |
| 02            | 获取 php.ini 目录          |

1. 加载 php 模块

   ```conf
   LoadModule php7_module ${WAMP_ROOT}/base/php/php7apache2_4.dll
   ```

2. 获取 php 配置文件所在目录（php.ini）

   ```conf
   <IfModule php7_module>
     PHPINIDir "${WAMP_ROOT}/base/php"
   </IfModule>
   ```

3. 题外话： `mod_unixd` 模块

   mod_unixd 是 类 unix 平台的基本安全性模块，属于必须配置项（windows 不需要这个）

   | 属性             | 描述                     |
   | ---------------- | ------------------------ |
   | `User 用户名`    | 指定 apache24 的用户     |
   | `Group 用户组名` | 指定 apache24 的用户群组 |

   > 代码示例：

   ```conf
   <IfModule unixd_module>
       User www
       Group www
   </IfModule>
   ```

### httpd 缺省设置

这些值会为稍后在文件中定义的任何虚拟主机容器提供缺省值。

1. 设置默认邮箱地址

   ```shell
   ServerAdmin admin@example.com
   ```

2. 设置全局主机名

   ```shell
   # ServerName www.example.com:80
   ```

3. 拒绝访问整个服务器的文件系统

   ```shell
   <Directory />
     AllowOverride none
     Require all denied
   </Directory>
   ```

   > 这个必须配置，否则服务器根目录都将对外开放！

### 单站点模式

如果服务器只有一个站点的话，就没必要开启 `mod_vhost_alias.so` 模块， 这时候 `DocumentRoot` 就是站点根目录了。

1. 通过 `DocumentRoot` 的参数来指定单站点的路径：

```shell
DocumentRoot "${WAMP_ROOT}/base/default"
```

2. 站点缺省路径

在多站点模式中，任何没有单独指定 `DocumentRoot` 参数的虚拟主机都会缺省指向该路径

3. 站点缺省路径访问权限

   默认情况下，httpd 禁止访问所有路径（继承于 `<Directory />` 的配置），添加站点缺省路径权限具体操作如下：

   ```shell
   <Directory "${WAMP_ROOT}/base/default">
      Options FollowSymLinks
      AllowOverride None
      Require all granted
   </Directory>
   ```

### 多站点模式

通常服务器会有多个站点，这时就需要加载 `mod_vhost_alias.so` 模块来创建多个虚拟主机了。

1. 缺省虚拟主机

   httpd 的 `mod_vhost_alias.so` 模块规则定义，第一条满足条件的虚拟站点为缺省站点，具体定义如下：

   ```conf
   <VirtualHost *:${HTTP_PORT}>
       DocumentRoot "${WAMP_ROOT}/base/default"
   </VirtualHost>
   ```

   > 提示：任何解析到当前服务器的域名，只要没有配置虚拟主机，都会指定到改缺省虚拟主机下；

   | 缺省值       | 描述                                   |
   | ------------ | -------------------------------------- |
   | 缺省虚拟主机 | 未定义虚拟主机的域名指向的虚拟主机配置 |
   | 站点缺省路径 | 未定义路径的虚拟主机指向的站点根目录   |

2. 站点访问权限

   我们可以为每个站点的各种目录设置访问权限，站点总目录权限设置如下：

   ```conf
   <Directory "${HTDOCS}">
       Options Indexes FollowSymLinks
       AllowOverride All
       Require all granted
   </Directory>
   ```

   > 提示：为了便于管理，所有站点我们都会放在一个路径下面，这个路径就是 `站点总目录` 。

3. `Options` 部分属性值

   | Options 属性值   | 描述               | 服务器建议 |
   | ---------------- | ------------------ | ---------- |
   | `Indexes`        | 允许展示目录式列表 | 关闭       |
   | `FollowSymLinks` | 允许访问 url 链接  | 开启       |

4. `AllowOverride` 部分属性值

   | AllowOverride 属性值 | 描述                      | 考虑与建议           |
   | -------------------- | ------------------------- | -------------------- |
   | `None`               | 完全忽略 `.htaccess` 文件 | 更安全，性能消耗降低 |
   | `All`                | 加载 `.htaccess` 文件     | 更方便，性能消耗增加 |

### 默认读取文件

`mod_dir.so` 模块允许通过 `DirectoryIndex` 参数设置默认文件，具体设置如下：

```conf
<IfModule dir_module>
DirectoryIndex index.html index.htm index.php
</IfModule>
```

> 提示：配置多个默认文件，会从左往右索引文件，直到找到为止。无法找到页面将无法显示或输出文件列表

### 阻止客户端查看特殊文件

httpd 可以让某些固定格式的文件不被浏览者访问，如：会禁用 `.htaccess` 和 `.htpasswd` 文件被 Web 客户端查看

```conf
<Files ".ht*">
Require all denied
</Files>
```

### 其他设置

1. 这几组都是默认配置，如果没有特别需要，可以直接移除掉了：

   ```conf
   <IfModule alias_module>
       ScriptAlias /cgi-bin/ "${SRVROOT}/cgi-bin/"
   </IfModule>

   <Directory "${SRVROOT}/cgi-bin">
       AllowOverride None
       Options None
       Require all granted
   </Directory>

   <IfModule headers_module>
       RequestHeader unset Proxy early
   </IfModule>
   ```

2. 关联 php 扩展名

   > httpd 允许处理静态页面和 php 动态页面，但默认没有指定 php 文件类型，这样 httpd 只能把所有的页面都往 php 解释器跑一遍，大大提高了服务器负荷。
   > 操作：在 `<IfModule mime_module>` 内新增一行代码

   ```shell
   <IfModule mime_module>
       TypesConfig conf/mime.types

       AddType application/x-compress .Z
       AddType application/x-gzip .gz .tgz
       AddType application/x-httpd-php .php
   </IfModule>
   ```

   > 格式： `AddType application/x-httpd-php [.扩展名1] [.扩展名2] ...`

3. 两组组不需要特别修改的默认配置

   ```shell
   <IfModule proxy_html_module>
       Include conf/extra/proxy-html.conf
   </IfModule>

   <IfModule ssl_module>
       SSLRandomSeed startup builtin
       SSLRandomSeed connect builtin
   </IfModule>
   ```

4. 为 apache24 虚拟主机配置文件指定存放目录

   > 说明：虚拟主机配置文件其实就是，apache24 的子孙配置文件

   ```shell
   <IfModule include_module>
       Include "${WEB_ROOT}/sites/*.conf"
   </IfModule>
   ```

   > 提示：Include 支持简单的正则表达式

## apache24.conf 内容

> 兼容版和推荐版用的都是同一个 [apache24.conf](./soure/apache24.conf) 配置文件

## httpd 日志

> 点击查看详情 [httpd 日志](./info/httpd日志.md)

## httpd 访问控制

> 点击查看详情 [httpd 访问控制](./info/httpd访问控制.md)
