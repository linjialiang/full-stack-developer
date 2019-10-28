# http 站点配置

http 协议的站点配置，就是我最常见的虚拟主机站点，需要开启 `mod_vhost_alias.so` 模块

> 最简洁虚拟主机配置

```conf
<VirtualHost *:${HTTP_PORT}>
    DocumentRoot "${HTDOCS}/www_test_com"
    ServerName www.test1.com
</VirtualHost>
```

> 常规虚拟主机站点配置：

```conf
<VirtualHost *:${HTTP_PORT}>
    ServerAdmin admin@example.com
    DocumentRoot "${HTDOCS}/www_test_com"
    ServerName www.test1.com
    ServerAlias www.test1.com test1.com www.test2.com test2.com
    ErrorDocument 404 /Error.html

    ErrorLog "${HTLOGS}/error/test.log"
    CustomLog "${HTLOGS}/access/test.log" common

    RewriteEngine on
    RewriteCond %{HTTP_HOST} ^test1.com$ [NC]
    RewriteRule ^(.*)$ http://www.%{HTTP_HOST}$1 [R=301,L]
    RewriteCond %{HTTP_HOST} ^test2.com$ [NC]
    RewriteRule ^(.*)$ http://www.%{HTTP_HOST}$1 [R=301,L]
</VirtualHost>
```

## 将域名绑定到本地

本地开发环境需要在 `hosts` 文件中，将指定的域名绑定到本地，具体如下：

```hosts
127.0.0.1 test.com www.test.com
127.0.0.1 test1.com www.test1.com
127.0.0.1 test2.com www.test2.com
```

> hosts 文件路径： `c:\Windows\System32\drivers\etc\hosts`
