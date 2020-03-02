# Debian 常用指令

## find 指令

1. /server/www 目录下的所有子目录都设置成 750 权限

   ```sh
   $ find /server/www/* -type d -exec chmod 750 {} \;
   ```

2. /server/www 目录下的所有文件都设置成 640 权限

   ```sh
   $ find /server/www/* -type f -exec chmod 640 {} \;
   ```

## find 与 tar 组合

概要：搜索 `cnrhyy` 目录下的所有 `zt` 目录，并将其打包到 cnrhyy_zt.tar.gz 压缩文件下

1. find 自带的 `-exec` 指令

   `-exec` 会多次执行 `tar` 指令，应该采用增量打包（压缩不支持增量操作）

   ```sh
   $ cd /alidata/www/jjz_aji/zj_wz
   $ find cnrhyy -type d -name "zt" -exec tar -rvf cnrhyy_zt.tar {} \;
   $ tar -czvf cnrhyy_zt.tar.gz cnrhyy_zt.tar
   ```

2. 使用 `xargs` 指令

   使用 `xargs` 指令，`tar` 指令只会执行，`xargs` 会将打印出来的 `换行/空白` 转成空格

   ```sh
   $ cd /alidata/www/jjz_aji/zj_wz
   $ find cnrhyy -type d -name "zt" | xargs tar -czvf cnrhyy_zt.tar.gz
   ```
