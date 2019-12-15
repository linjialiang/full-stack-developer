# alias 站点配置

别名站点配置，需要开启 `mod_asis.so` 模块

> 下面以 phpmyadmin 和 adminer 为例：

```conf
Alias /phpmyadmin ${WAMP_ROOT}/pma
<Directory ${WAMP_ROOT}/pma>
    Options FollowSymLinks
    DirectoryIndex index.php
    <RequireAll>
        Require local
    </RequireAll>
</Directory>
<Directory ${WAMP_ROOT}/pma/libraries>
    Require all denied
</Directory>
<Directory ${WAMP_ROOT}/pma/setup/lib>
    Require all denied
</Directory>

Alias /adminer ${WAMP_ROOT}/adminer/adminer
<Directory ${WAMP_ROOT}/adminer/adminer>
    Options FollowSymLinks
    DirectoryIndex index.php
    <RequireAll>
        Require local
    </RequireAll>
</Directory>
```
