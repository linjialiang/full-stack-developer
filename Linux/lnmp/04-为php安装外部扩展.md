# 为 PHP 安装外部扩展

这些扩展已经包含在 PHP 中，但是需要编译它们才能使用，并且可能需要额外的依赖包。

| 扩展    | 描述                           |
| ------- | ------------------------------ |
| openssl | 让 php 支持 oepnssl 的部分功能 |
| curl    | 让 php 支持 curl 的各种协议    |

## 安装 openSSL

openSSL 扩展使用 [OpenSSL 库](http://www.openssl.org/) 来进行 `对称/非对称的加解密`，以及 PBKDF2、 PKCS7、 PKCS12、 X509 和其他加密操作。除此之外还提供了 TLS 流的实现。

1. 依赖项

   ```sh
   $ apt install libcurl4-openssl-dev libssl-dev
   ```

2. 开始安装

   ```sh
   $ cd /package/ext/openssl
   $ cp config0.m4 config.m4
   $ phpize
   $ ./configure
   $ make -j4
   $ make test
   $ make install
   Installing shared extensions:     /server/php/lib/php/extensions/no-debug-non-zts-20190902/
   ```

3. 在 PHP 配置文件(php.ini)上，启用 openssl 扩展

   ```sh
   $ vim /server/php/lib/php.ini
   ```

   `php.ini` 第 `950行` 左右添加以下内容：

   ```ini
   extension=openssl
   ```

4. 查询 `openssl` 扩展是否安装成功

   ```sh
   $ php -m
   ```

5. 查看 `openssl` 是否可以正常运行：

   ```sh
   $ php --ri openssl
   ```

## 安装 cURL 扩展

```text
PHP 支持 Daniel Stenberg 创建的 libcurl 库，能够连接通讯各种服务器、使用各种协议。
libcurl 目前支持的协议有 http、https、ftp、gopher、telnet、dict、file、ldap。
libcurl 同时支持 HTTPS 证书、HTTP POST、HTTP PUT、 FTP 上传(也能通过 PHP 的 FTP 扩展完成)、HTTP 基于表单的上传、代理、cookies、用户名+密码的认证。
```

1. 开始安装

   ```sh
   $ cd /package/ext/curl
   $ phpize
   $ ./configure
   $ make -j4
   $ make test
   $ make install
   Installing shared extensions:     /server/php/lib/php/extensions/no-debug-non-zts-20190902/
   ```

2. 在 PHP 配置文件(php.ini)上，启用 curl 扩展

   ```sh
   $ vim /server/php/lib/php.ini
   ```

   `php.ini` 第 `950行` 左右添加以下内容：

   ```ini
   extension=curl
   ```

3. 查询 `curl` 扩展是否安装成功

   ```sh
   $ php -m
   ```

4. 查看 `curl` 是否可以正常运行：

   ```sh
   $ php --ri curl
   ```
