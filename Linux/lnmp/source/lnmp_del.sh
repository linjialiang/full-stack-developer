#!/bin/bash

func_uninstall(){
    rm -rf $1
}

del_array=(
    "/server"
    "/package"
)

echo "-----开始移除LNMP环境-----"

for((i=0;i<${#del_array[*]};i++));
do
   echo ${del_array[i]}
   func_uninstall ${del_array[i]}
done

echo "-----LNMP环境移除完毕-----"
