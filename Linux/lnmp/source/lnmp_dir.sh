#!/bin/bash

func_create(){
    mkdir $1
}

server_array=(
    "/server"
    "/server/nginx"
    "/server/php"
    "/server/sites"
    "/server/default"
    "/server/www"
    "/server/data"
    "/server/ImageMagick"
    "/server/run"
    "/server/run/nginx"
    "/server/run/mariadb"
    "/server/run/php"
    "/server/logs"
    "/server/logs/nginx"
    "/server/logs/mariadb"
    "/server/logs/php"
    "/server/logs/xdebug"
    "/server/vsftpd"
)

package_array=(
    "/package"
    "/package/ext"
    "/package/pkg"
)

echo "-----开始创建server目录-----"

for((i=0;i<${#server_array[*]};i++));
do
   echo ${server_array[i]}
   func_create ${server_array[i]}
done

echo "-----server目录创建结束 -----"
echo "-----开始创建package目录-----"

for((i=0;i<${#package_array[*]};i++));
do
   echo ${package_array[i]}
   func_create ${package_array[i]}
done

echo "-----package目录创建结束-----"
