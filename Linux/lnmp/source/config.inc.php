<?php
declare(strict_types=1);

# 短语密码, cookie认证时不能为空，官方建议大于32
$cfg['blowfish_secret'] = 'fvNqC4^HR8WELJ7$C5UD2a&xk6w@Rfr4M(MBU';
$i = 0;
$i++;

# 设置登陆方式为 cookie
$cfg['Servers'][$i]['auth_type'] = 'cookie';
# MariaDB-server 主机地址
$cfg['Servers'][$i]['host'] = 'localhost';
# 是否使用压缩协议来连接 MariaDB-server
$cfg['Servers'][$i]['compress'] = false;
# 是否允许空密码登陆
$cfg['Servers'][$i]['AllowNoPassword'] = false;

$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';
# 默认语言
$cfg['DefaultLang'] = 'zh';
# 设置主题
$cfg['ThemeDefault'] = 'original';
# 缓存目录，主要用于缓存模板文件提升访问速度，注意目录权限
$cfg['TempDir'] = '/tmp'
