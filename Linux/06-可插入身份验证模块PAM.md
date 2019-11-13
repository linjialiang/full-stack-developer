# Linux 下可插入身份验证模块 `Linux-PAM`

`Linux-PAM` 中文名 “”，简称，`PAM`。

[Linux-PAM 官方链接](http://www.linux-pam.org/)

| `Linux-PAM`  | 概念描述                                                                     |
| ------------ | ---------------------------------------------------------------------------- |
| 缩写         | `PAM`                                                                        |
| 全称         | `Pluggable Authentication Modules`                                           |
| 中文名       | `Linux 可插入身份验证模块`                                                   |
| 具体效果     | 将程序开发与认证方式进行分离，程序在运行时调用附加的“认证”模块完成自己的工作 |
| 优势         | 使本地系统管理员通过配置，自由选择要使用哪些认证模块                         |
| 配置文件路径 | `/etc/pam.d/` 目录下的一系列配置文件                                         |
| 模块路径     | `/usr/lib/x86_64-linux-gnu/security`                                         |
| 官方地址     | http://www.linux-pam.org/                                                    |

> 提示：上文指的是 `Debian10.x` 下的 PAM 模块路径，其他发行版路径可能不一样！
