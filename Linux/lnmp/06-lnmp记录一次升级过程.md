# LNMP 记录一次升级过程

此次 LNMP 升级并不全面，因为很多软件都没有更新，所以这里只更新了部分软件包。

## 更新 MariaDB

MariaDB 数据库是 apt 安装的，这次也没有跨大版本更新，所以是最简单的，具体操作如下：

```sh
$ apt update
$ apt upgrade
```

## 更新 Nginx

此次 Nginx 没有更新，不过为了帮助大家了解 Nginx 重新编译的过程，这里以禁用模块为例子：

1. 检测依赖包是否更新

   如果依赖包有更新，下载并解压它们，在编译时，将路径指定到新版依赖包根目录即可

2. 本次禁用模块说明

   下面两个模块在我的实际开发过程中并没有作用，这里选择禁用掉，它们

   | 模块                   | 模块说明                      | 编译指令      |
   | ---------------------- | ----------------------------- | ------------- |
   | ngx_mail_core_module   | 邮件代理服务                  | --with-mail   |
   | ngx_stream_core_module | 实现 TCP/UDP 代理以及负载均衡 | --with-stream |

3. Nginx 编译具体操作

   ```sh
   $ mkdir /package/lnmp/nginx-1.16.1-update
   $ tar -xzvf /package/lnmp/nginx-1.16.1.tar.gz -C /package/lnmp/nginx-1.16.1-update
   $ mkdir /package/lnmp/nginx-1.16.1-update/nginx-1.16.1/nginx_bulid
   $ cd /package/lnmp/nginx-1.16.1-update/nginx-1.16.1/
   ```

   > 构建 Nginx 指令

   ```sh
   ./configure --prefix=/server/nginx \
   --builddir=/package/lnmp/nginx-1.16.1-update/nginx-1.16.1/nginx_bulid \
   --with-threads \
   --with-file-aio \
   --with-http_ssl_module \
   --with-http_v2_module \
   --with-http_realip_module \
   --with-http_image_filter_module \
   --with-http_geoip_module \
   --with-http_dav_module \
   --with-http_gunzip_module \
   --with-http_gzip_static_module \
   --with-http_auth_request_module \
   --with-http_secure_link_module \
   --with-http_degradation_module \
   --with-http_slice_module \
   --with-http_stub_status_module \
   --without-http_ssi_module \
   --without-http_uwsgi_module \
   --without-http_scgi_module \
   --without-http_grpc_module \
   --with-pcre=/package/lnmp/pcre-8.43 \
   --with-pcre-jit \
   --with-zlib=/package/lnmp/zlib-1.2.11 \
   --with-openssl=/package/lnmp/openssl-1.1.1d \
   --with-debug
   ```

   > 重新编译 Nginx

   ```sh
   $ make -j4
   ```

4. 将 Nginx 替换成重新编译的版本

   将刚刚编译后产生的可执行文件，拷贝到 /server/nginx/sbin 下：

   ```sh
   $ cp -p -r /package/lnmp/nginx-1.16.1-update/nginx-1.16.1/nginx_bulid/nginx /server/nginx/sbin/
   ```

   > 提示：由于版本没有变化，所以必须先暂停 nginx，将可执行文件重命名后再执行以上代码！

5. 重新启动 Nginx

   ```sh
   $ /server/nginx/sbin/nginx -s stop
   $ /server/nginx/sbin/nginx
   ```

   > 提示：如果需要平滑升级，请查阅 [Nginx 平滑升级](https://gitee.com/linjialiang/programmer/blob/master/Debian/Nginx/03-Nginx%E5%B9%B3%E6%BB%91%E5%8D%87%E7%BA%A7.md)
