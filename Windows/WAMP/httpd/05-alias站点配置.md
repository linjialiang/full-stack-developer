# alias 站点配置

别名站点配置，需要开启 `mod_asis.so` 模块

> 下面以 adminer.php 为例：

```conf
Alias /adminer ${WAMP_ROOT}/base/adminer
<Directory ${WAMP_ROOT}/base/adminer>
    Options FollowSymLinks
    DirectoryIndex adminer.php
    <RequireAll>
        Require local
    </RequireAll>
</Directory>
```
