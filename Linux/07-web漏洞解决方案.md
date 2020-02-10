# WEB 漏洞解决方案

## 漏洞列表

| 序号 | 漏洞                                 |
| ---- | ------------------------------------ |
| 01   | [允许 TRACE 方法](#01)               |
| 02   | [X-Frame-Options Header 未配置](#02) |

## <span id="01">允许 TRACE 方法</span>

### 一、概述

```text
- 如果一台 web Server 支持 Trace 或 Track，那么它一定存在跨站脚本漏洞，将有可能受到跨站攻击（通常 Trace/Track 是用来调试 Web 服务器连接的 HTTP 方法）。
- 我们通常在描述各种浏览器缺陷的时候，把“Cross-Site-Tracing”（跨站攻击）简称为XST。
- 攻击者可以利用此漏洞欺骗合法用户并得到他们的私人信息。
```

### 二、httpd 解决方案：禁用 Trace 和 Track 这两类 HTTP 方法

1. httpd <=2.0.55, 只能则通过 rewrite_module 模块配置：

   确认 rewrite_module 模块激活（httpd.conf，下面一行前面没有#）：

   ```sh
   LoadModule rewrite_module modules/mod_rewrite.so
   ```

   在各虚拟主机的配置文件里添加如下语句：

   ```sh
   <IfModule rewrite_module>
       RewriteEngine On
       RewriteCond %{REQUEST_METHOD} ^(TRACE|TRACK)
       RewriteRule .* - [F]
   </IfModule>
   ```

   > 注：可以在 httpd.conf 里搜索 VirtualHost 确定虚拟主机的配置文件。

2. httpd > 2.0.55，还可以在 httpd.conf 的尾部添加：

   ```sh
   TraceEnable off
   ```

### 三、Nginx 解决方案：禁用 Trace 和 Track 这两类 HTTP 方法

在 server 区块下加入如下代码：

```text
server {
    if ($request_method !~* GET|POST) {
        return 403;
    }
}
```

重启 nginx，这样就屏蔽 GET、POST 之外的 HTTP 方法!

## <span id="02">X-Frame-Options Header 未配置</span>

X-Frame-Options Header 未配置会造成点击劫持漏洞。

### 一、概述

```text
- X-Frame-Options HTTP 响应头是用来给浏览器指示允许一个页面可否在 <frame>, <iframe>, <embed> 或者 <object> 中展现的标记。
- 网站可以使用此功能，来确保自己网站的内容没有被嵌到别人的网站中去，从而避免点击劫持（clickjacking）攻击。
```

1. X-Frame-Options 有三个值：

   | 值               | 描述                                                                    |
   | ---------------- | ----------------------------------------------------------------------- |
   | DENY             | 表示该页面不允许在 frame 中展示，即便是在相同域名的页面中嵌套也不允许。 |
   | SAMEORIGIN       | 表示该页面可以在相同域名页面的 frame 中展示。                           |
   | ALLOW-FROM <uri> | 表示该页面可以在指定来源的 frame 中展示。                               |

2. 如果设置为 `DENY`，不光在别人的网站 frame 嵌入时会无法加载，在同域名页面中同样会无法加载。

3. 如果设置为 `SAMEORIGIN`，那么页面就可以在同域名页面的 frame 中嵌套。正常情况下我们通常使用 `SAMEORIGIN` 参数。

### 二、攻击方式

```text
- 攻击者可以使用一个透明的、不可见的iframe，覆盖在目标网页上，然后诱使用户在该网页上进行操作，此时用户将在不知情的情况下点击透明的iframe页面。
- 通过调整iframe页面的位置，可以诱使用户恰好点击iframe页面的一些功能性按钮上，导致被劫持。
- 也就是说网站内容可能被其他站点引用，可能遭受到点击劫持攻击。
```

### 三、解决方法

1. httpd 配置

   httpd.conf 底部加入如下内容：

   ```sh
   <IfModule headers_module>
    Header always append X-Frame-Options SAMEORIGIN
   </IfModule>
   ```

   > 提示：httpd 必须启用 headers_module 模块

2. nginx 配置

   在 `http`、`server` 、`location` 区块中加入如下内容：

   ```sh
   # http：所有站点统一设置
   http {
       add_header X-Frame-Options SAMEORIGIN always;
   }
   # server：当前站点设置
   server {
       add_header X-Frame-Options SAMEORIGIN always;
   }
   # location：当前请求路径设置
   location {
       add_header X-Frame-Options SAMEORIGIN always;
   }
   ```

3. php 配置

   ```sh
   header('X-Frame-Options:SAMEORIGIN');
   ```
