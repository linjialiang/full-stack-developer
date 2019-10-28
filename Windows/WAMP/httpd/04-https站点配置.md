# https 站点配置

https 协议的站点配置，就是带 ssl 的默认端口 443，示例代码如下：

```conf
<VirtualHost *:${HTTP_PORT}>
    ServerName www.test.com
    ServerAlias test.com www.test.com
    DocumentRoot "${HTDOCS}/www_test_com"

    RewriteEngine on
    RewriteCond %{SERVER_PORT} 80 [NC]
    RewriteRule ^(.*)$ https://%{HTTP_HOST}$1 [R=301,L]
</VirtualHost>

<virtualhost *:${HTTPS_PORT}>
    ServerName www.test.com
    ServerAlias test.com www.test.com
    DocumentRoot "${HTDOCS}/www_test_com"

    RewriteEngine on
    RewriteCond %{HTTP_HOST} ^test.com$ [NC]
    RewriteRule ^(.*)$ https://www.%{HTTP_HOST}$1 [R=301,L]

    SSLEngine on
    SSLCertificateFile 路径/2_www.test.com.crt
    SSLCertificateKeyFile 路径/3_www.test.com.key
    SSLCertificateChainFile 路径/1_root_bundle.crt
</virtualhost>
```
