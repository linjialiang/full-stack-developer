# httpd 访问控制

> 我们常用到的主要集中于 `Require` `<RequireAll>` `<RequireAny>` `<RequireNone>` 这四种指令的相互结合

| command         | 所属                   | 描述                                                               |
| --------------- | ---------------------- | ------------------------------------------------------------------ |
| `Require`       | 访问授权指令           | 写入授权容器内的规则                                               |
| `<RequireAll>`  | 访问授权指令组合的容器 | 用于包含一组授权指令，并且必须全部是否定的，                       |
| `<RequireAny>`  | 访问授权指令组合的容器 | 用于包含一组授权指令，其中一个必须成功才能使`<requireany>`指令成功 |
| `<RequireNone>` | 访问授权指令组合的容器 | 在此元素中包含的规则，所有规则取反                                 |

## 访问授权指令 `Require`

> 指令格式：`Require [not] entity-name [entity-name] ...`

| 访问授权指令  | 功能             |
| ------------- | ---------------- |
| `Require`     | 允许访问授权指令 |
| `Require not` | 拒绝访问授权指令 |

> `Require not` 是 `Require` 的反操作指令，`Require` 是允许访问授权 `Require not` 就是拒绝访问授权，因此 `Require not` 不再举例！下面是 Require 的使用区块：

| 数量 | 使用区块                                                                                   |
| ---- | ------------------------------------------------------------------------------------------ |
| 单条 | 允许现在 `<Directory>` `<Files>` `<Location>` 3 个区块以及 `.htaccess` 文件内              |
| 组合 | 组合指令必须写入 `<RequireAll>` `<RequireAny>` `<RequireNone>` 这 3 个授权指令组合的容器中 |

> 常用的 `Require` 访问授权指令列表：

| Require command                                   | 描述                                                                        |
| ------------------------------------------------- | --------------------------------------------------------------------------- |
| `Require all granted`                             | 无条件允许访问                                                              |
| `Require all denied`                              | 无条件拒绝访问                                                              |
| `Require local`                                   | 允许匹配源自本地主机的连接                                                  |
| `Require method {method1 [method2] [method3]...}` | 仅允许对给定的 HTTP 方法进行访问                                            |
| `Require env env-var [env-var] ...`               | 仅当设置了一个给定的环境变量时才允许访问                                    |
| `Require expr expression`                         | 如果 expression 的计算结果为 true，则允许访问                               |
| `Require user userid [userid] ...`                | 只有指定的用户才能访问该资源                                                |
| `Require group group-name [group-name] ...`       | 只有命名组中的用户才能访问该资源                                            |
| `Require valid-user`                              | 所有有效用户都可以访问该资源                                                |
| `Require host .net example.edu`                   | 顶级域名是 `.net` 的所有域名， `example.edu` 自身及子孙域名都可以访问该资源 |
| `Require forward-dns host-name`                   | 根据主机名来判断该 ip 是否允许访问资源（这个有点复杂）                      |

> `Require ip` 访问授权指令列表：

| Require ip command                         | 描述                                     |
| ------------------------------------------ | ---------------------------------------- |
| `Require ip ip-address1 [ip-address2] ...` | Require ip 指令格式                      |
| `Require ip 1.2.3.0`                       | 指定 IP 地址范围内的客户端可以访问该资源 |
| `Require ip 1.2.3.10 1.2.3.11`             | 指定多个 ip 地址对应的客户端访问该资源   |
| `Require ip 10 172.20 192.168.2`           | 指定部分 ip 地址对应的客户端访问该资源   |
| `Require ip 10.1.0.0/255.255.0.0`          | 指定网络/网络掩码对的客户端访问该资源。  |
| `Require ip 10.1.0.0/16`                   | 指定 IP 段内的客户端访问该资源。         |
| `Require ip 2001:db8::a00:20ff:fea7:ccea`  | 可以指定 IPv6 地址和 IPv6 子网           |
| `Require ip 2001:db8:1:1::a`               | 可以指定 IPv6 地址和 IPv6 子网           |
| `Require ip 2001:db8:2:1::/64`             | 可以指定 IPv6 地址和 IPv6 子网           |
| `Require ip 2001:db8:3::/48`               | 可以指定 IPv6 地址和 IPv6 子网           |

## 访问授权指令组合的容器

> 访问授权指令组合的容器格式

```shell
## 基本格式，支持容器嵌套
<RequireAll>
    ...
    <RequireAny>
        <RequireNone>
            ...
        </RequireNone>
        ...
    </RequireAny>
</RequireAll>

## <VirtualHost> 区块下需要封装进 `<Location>` 容器
<Location>
    <RequireAll>
        ...
    </RequireAll>
</Location>
```

> 访问授权指令组合的容器使用区块

| 容器            | 使用区块             |
| --------------- | -------------------- |
| `<RequireAll>`  | directory, .htaccess |
| `<RequireAny>`  | directory, .htaccess |
| `<RequireNone>` | directory, .htaccess |

> 访问授权指令组合的存放容器有 3 个： `<RequireAll>` `<RequireAny>` `<RequireNone>` ，允许彼此结合并通过 `Require` 访问授权指令来表达复杂的授权逻辑。

| 访问授权指令组合的容器 | `Require not`支持情况 | 优先 | 允许访问                            | 拒绝访问                            | 无效                   |
| ---------------------- | --------------------- | ---- | ----------------------------------- | ----------------------------------- | ---------------------- |
| `<RequireAll>`         | 支持                  | 拒绝 | 没有匹配到拒绝，至少匹配到 1 条允许 | 至少匹配到 1 条拒绝                 | 拒绝和允许都没有匹配到 |
| `<RequireAny>`         | 不支持                | 成功 | 匹配到 1 条允许                     | 没有匹配到允许，至少匹配到 1 条拒绝 | 拒绝和允许都没有匹配到 |
| `<RequireNone>`        | 不支持                | 拒绝 | 全部条件允许                        | 全部条件只要一条没有匹配到          | 只有拒绝访问，没有无效 |

## apache24 附录表：

> apache24 指令合法区块说明

| 区块（Context） | 说明                                                                                                          |
| --------------- | ------------------------------------------------------------------------------------------------------------- |
| `server config` | 只支持配置在主配置文件和子孙配置文件内！不允许： 1） `<VirtualHost> <Directory>` 区域内；2） `.htaccess` 文件 |
| `virtual host`  | 指令可以出现在 `<VirtualHost>` 容器中                                                                         |
| `directory`     | 指令允许出现在后面这些容器中： `<Directory> <Location> <Files> <If> <Proxy>`                                  |
| `.htaccess`     | 指令允许出现在每个站点目录下的 `.htaccess` 文件                                                               |

> 常用容器的合法区块汇总列表：

| 容器               | 区块（Context）                                   |
| ------------------ | ------------------------------------------------- |
| `<Directory>`      | server config, virtual host                       |
| `<DirectoryMatch>` | server config, virtual host                       |
| `<Files>`          | server config, virtual host, directory, .htaccess |
| `<FilesMatch>`     | server config, virtual host, directory, .htaccess |
| `<If>`             | server config, virtual host, directory, .htaccess |
| `<IfDefine>`       | server config, virtual host, directory, .htaccess |
| `<IfModule>`       | server config, virtual host, directory, .htaccess |
| `<IfVersion>`      | server config, virtual host, directory, .htaccess |
| `<Location>`       | server config, virtual host                       |
| `<LocationMatch>`  | server config, virtual host                       |
| `<MDomainSet>`     | server config                                     |
| `<Proxy>`          | server config, virtual host                       |
| `<ProxyMatch>`     | server config, virtual host                       |
| `<VirtualHost>`    | server config                                     |
