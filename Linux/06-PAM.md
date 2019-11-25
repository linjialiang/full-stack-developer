# Linux 下可插入身份验证模块 `Linux-PAM`

| `Linux-PAM`  | 概念描述                                                                     |
| ------------ | ---------------------------------------------------------------------------- |
| 简称         | `PAM`                                                                        |
| 全称         | `Pluggable Authentication Modules`                                           |
| 中文名       | `Linux 可插入身份验证模块`                                                   |
| 具体效果     | 将程序开发与认证方式进行分离，程序在运行时调用附加的“认证”模块完成自己的工作 |
| 优势         | 使本地系统管理员通过配置，自由选择要使用哪些认证模块                         |
| 模块路径     | `/usr/lib/x86_64-linux-gnu/security`                                         |
| 配置文件路径 | `/etc/pam.d/` 目录下的一系列配置文件                                         |
| 官方地址     | http://www.linux-pam.org/                                                    |
| 中文手册     | https://www.docs4dev.com/docs/zh/linux-pam/1.1.2/reference                   |

> 提示：上文指的是 `Debian10.x` 下的 PAM 模块路径，其他发行版路径可能不一样！

## 一个案例带你了解 `Linux-PAM` 是什么？

`su` 是一个很常用的 Linux 命令，可以让我们从一个用户切换到另一个用户。

1. `su` 功能

   | 登陆用户 | `su` 操作       | 密码认证 |
   | -------- | --------------- | -------- |
   | root     | `su` 到别的用户 | 不需要   |
   | 其它用户 | `su` 到别的用户 | 需要密码 |

2. `su` 命令切换用户的过程:

   | 过程 | 描述                                         |
   | ---- | -------------------------------------------- |
   | 01   | 认证登陆用户是 `root`，不需要目标用户的密码  |
   | 02   | 认证登陆用户不是 `root` ，需要目标用户的密码 |
   | 03   | 认证成功，启动相应的 `Shell`                 |

   > 提示：`bash` `zsh` 等都是 Linux 的 Shell

3. `su` 的认证功能

   正常逻辑下，`su` 开发人员可能会写出的认证功能：

   1. 先判断是否 root 用户登陆；
   2. 如果是 root 用户登陆，则认证直接通过；
   3. 否则，需要输入目标用户的密码来验证，验证密码匹配成功，认证通过，否则也无法通过；
   4. 如果有其它需求，开发人员就要不断的添加规则；
   5. 比如 1：让 `yunwei` 用户组下的用户，使用 `su` 切换用户，不需要输入密码；
   6. 比如 2：考虑到安全问题，运维临时决定：使用 `su` 切换用户时，需该用户绑定的手机号短信验证码验证通过才允许切换；
   7. 如果客户不断提出各种安全认证问题，开发人员就需要不断的修改程序源码，而且还需要测试各种 bug，这极为繁琐，更加不利于项目的开发！

   Linux-PAM 的出现，解决了上述的问题：

   1. 开发人员，全力开发项目的功能，而认证的事情完全交给 `Linux-PAM`;
   2. `Linux-PAM` 有大量的插件来支持各种认证方式；
   3. `Linux-PAM` 开放扩展开发接口，开发者可以根据自己的需求，自行开发扩展；
   4. 有了 `Linux-PAM` 以后， `su` 开发人员可以专注地为用户启动 Shell 服务，而不需要关心用户认证的细节！

| 参考来源 | 详情                                   |
| -------- | -------------------------------------- |
| 链接     | https://www.jianshu.com/p/760f239be916 |

## `Linux-PAM` 模块综述

| `Linux-PAM`    | 描述                                 |
| -------------- | ------------------------------------ |
| 模块路径       | `/usr/lib/x86_64-linux-gnu/security` |
| 模块文件名     | `pam_*.so`                           |
| 单文件         | `/etc/pam.conf`                      |
| 多文件（推荐） | `/etc/pam.d/*`                       |

> 注意：如果 `/etc/pam.d/` 这个文件夹存在，`Linux-PAM` 将自动忽略 `/etc/pam.conf`！

1. `/etc/pam.conf` 单配置文件的格式如下：

   ```sh
   service    type        control     module-path     module-arguments
   服务名称    模块类型      控制模式     模块路径         模块参数
   ```

2. `/etc/pam.d/*` 多配置文件的格式如下：

   ```sh
   type      control    module-path     module-arguments
   模块类型   控制模式     模块路径         模块参数
   ```

   > 提示：多配置文件的 `服务名` 就是 `配置文件名`，所以不需要填写服务名！

### `Linux-PAM` 模块类型

`type(模块类型)` 是规则所对应的管理组，它用于指定后续模块将与哪个管理组相关联。有效的类型包括:

| 模块类型   | 描述                                                                       |
| ---------- | -------------------------------------------------------------------------- |
| `account`  | 帐户类模块，将执行 `访问`、`帐户/凭证有效期`、`密码限制/规则` 等有关的操作 |
| `auth`     | 验证类模块， 验证用户或 `设置/销毁` 凭证                                   |
| `password` | 密码类模块，将执行 `密码更改/更新` 相关的操作                              |
| `session`  | 会话类模块，用于 `初始化/终止` 会话                                        |

### `Linux-PAM` 控制模式

`control` 字段是 `Linux-PAM` 的控制模式，用于表示，如果模块无法成功完成其身份验证任务，则 `PAM-API` 下一步的行为。`control` 字段有两种语法：

| `control` 语法 | 描述                               |
| -------------- | ---------------------------------- |
| 简单语法       | 单个关键字                         |
| 复杂语法       | 涉及 `value=action` 对的方括号选择 |

1. 对于简单语法，有效的控制值为：

   | 简单语法     | 返回成功                                   | 返回失败                                                   |
   | ------------ | ------------------------------------------ | ---------------------------------------------------------- |
   | `required`   | 带有该标记的模块必须认证成功               | 出现认证失败，也需等待其它条目全部认证一遍，再统一返回消息 |
   | `requisite`  | 带有该标记的模块必须认证成功               | 一旦出现认证失败，立即结束认证，并返回错误消息             |
   | `sufficient` | 该标记的模块只要有 1 行认证成功            | 认证失败，就会将其当作 `optional` 控制来处理               |
   | `optional`   | 认证失败，也允许用户享受应用程序提供的服务 | 如果只有 `optional` 认证 ，并且全部认证不成功              |
   | `include`    | 表示在验证过程中调用其他的 PAM 配置文件。  | 载入文件的每一行验证与当前文件验证相同                     |
   | `substack`   | 类似 `include` 验证                        | 但 `参数值=done/die` 是只跳过载入文件，其余照常验证        |

2. 对于更复杂的语法，有效的控制值具有以下形式：

   ```sh
   [value1=action1 value2=action2 ...]
   ```

   > `valueN` 具体值如下（valueN 具体值的具体意义，暂时未知）：

   | ValueN 值         | ValueN 值             | ValueN 值           |
   | ----------------- | --------------------- | ------------------- |
   | success           | authtok_lock_busy     | maxtries            |
   | open_err          | authtok_disable_aging | new_authtok_reqd    |
   | symbol_err        | try_again             | acct_expired        |
   | service_err       | ignore                | session_err         |
   | system_err        | abort                 | cred_unavail        |
   | buf_err           | authtok_expired       | cred_expired        |
   | perm_denied       | module_unknown        | cred_err            |
   | auth_err          | bad_item              | no_module_data      |
   | cred_insufficient | conv_again            | conv_err            |
   | authinfo_unavail  | incomplete            | authtok_err         |
   | user_unknown      | default               | authtok_recover_err |

   > `actionN` 包括下面几种值：

   | actionN 值  | 描述                                                               |
   | ----------- | ------------------------------------------------------------------ |
   | ignore      | 如果使用层叠模块，那么这个模块的返回值将被忽略，不会被应用程序知道 |
   | bad         | 此操作表示这个返回码应该被看作是模块验证失败的标志                 |
   | die         | 终止层叠模块验证过程，立刻返回到应用程序                           |
   | ok          | 告诉 PAM 这个模块的返回值将直接作为所有层叠模块的返回值。          |
   | done        | 终止后续层叠模块的验证，把控制权立刻交回应用程序                   |
   | N(非负整数) | 就表示需要忽略后面 N 个同样类型的模块。                            |
   | reset       | 清除所有层叠模块的返回状态，从下一个层叠模块重新开始验证           |

3. 简单语法 vs 复杂语法

   事实上，简单语法也是通过复杂语法组合起来的，具体如下：

   | 简单语法   | 对应的复杂语法                                               |
   | ---------- | ------------------------------------------------------------ |
   | required   | `[success=ok new_authtok_reqd=ok ignore=ignore default=bad]` |
   | requisite  | `[success=ok new_authtok_reqd=ok ignore=ignore default=die]` |
   | sufficient | `[success=done new_authtok_reqd=done default=ignore]`        |
   | optional   | `[success=ok new_authtok_reqd=ok default=ignore]`            |

### `Linux-PAM` 模块路径

模块路径即要调用模块的位置，路径写法支持绝对路径和动态路径。

| 路径写法 | 具体说明                                |
| -------- | --------------------------------------- |
| 绝对路径 | 如：`/server/pam_module/pam_mariadb.so` |
| 相对路径 | 如：`pam_nologin.so`                    |

> 相对路径写法，需要将模块存放在 `Linux-PAM` 模块的默认路径下！

| 操作系统       | `Linux-PAM` 模块的默认路径           |
| -------------- | ------------------------------------ |
| `Debian10.x`   | `/usr/lib/x86_64-linux-gnu/security` |
| 一般 64 位系统 | `/lib64/security`                    |
| 一般 32 为系统 | `/lib/security`                      |

> 提示： 同一个模块，可以出现在不同的类型中，并且在不同的类型中所执行的操作都不相同。这是由于每个模块，针对不同的模块类型，编制了不同的执行函数。

### `Linux-PAM` 模块参数

模块参数可用于修改给定 PAM 的特定行为。参数可以有多个,参数之间用空格分隔开（如果参数中包含空格，则该参数应该使用 `方括号` 括起来）

1. 使用支持 MariaDB 数据库认证的模块，可能需要类似如下的参数：

   ```sh
   pam_vsftpd auth required pam_mariadb.so user=www passwd=wwwpasswd \
         db=vsftpd [query=select user_name from internet_service \
         where user_name='%u' and password=PASSWORD('%p') and \
         service='web_proxy']
   ```
