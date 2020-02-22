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
