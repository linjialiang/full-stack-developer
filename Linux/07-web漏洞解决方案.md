# WEB 漏洞解决方案

## 漏洞列表

| 序号 | 漏洞                                 |
| ---- | ------------------------------------ |
| 01   | [允许 TRACE 方法](#01)               |
| 02   | [X-Frame-Options Header 未配置](#02) |

## <span id="01">允许 TRACE 方法</span>

### 一、概述

```text
- 如果一台 web Server 支持 Trace 方式，那么它一定存在跨站脚本漏洞，将有可能受到跨站攻击（通常 Trace 是用来调试 Web 服务器连接的 HTTP 方式。）。
- 我们通常在描述各种浏览器缺陷的时候，把“Cross-Site-Tracing”（跨站攻击）简称为XST。
- 攻击者可以利用此漏洞欺骗合法用户并得到他们的私人信息。
```

### 二、httpd 解决方案：禁用 Trace 方式

1. httpd > 2.0.55，可以在 httpd.conf 的尾部添加：

   ```sh
   TraceEnable off
   ```

2. httpd <=2.0.55, 则通过 rewrite_module 模块配置：

   确认 rewrite_module 模块激活（httpd.conf，下面一行前面没有#）：

   ```sh
   LoadModule rewrite_module modules/mod_rewrite.so
   ```

   在各虚拟主机的配置文件里添加如下语句：

   ```sh
   <IfModule rewrite_module>
       RewriteEngine On
       RewriteCond %{REQUEST_METHOD} ^TRACE
       RewriteRule .* - [F]
   </IfModule>
   ```

   > 注：可以在 httpd.conf 里搜索 VirtualHost 确定虚拟主机的配置文件。

### 三、Nginx 解决方案：禁用 Trace 方式

## <span id="02">X-Frame-Options Header 未配置</span>
