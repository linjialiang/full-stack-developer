#!/bin/bash

cd /package

for i in `ls *.gz`;
do
    echo "解压" $i
    tar -xzvf $i
done

cd /package/pkg

for i in `ls *.gz`;
do
    echo "解压" $i
    tar -xzvf $i
done

cd /package/ext

for i in `ls *.tgz`;
do
    echo "解压" $i
    tar -xzvf $i
done