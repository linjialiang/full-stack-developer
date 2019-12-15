# Composer 快速手册

> 该文档是基于 composer 官方手册的精简版本！

| 指令                    | 描述                               |
| ----------------------- | ---------------------------------- |
| composer init           | 初始化 composer                    |
| composer install        | 安装 composer 包                   |
| composer update         | 更新 composer 包                   |
| composer require        | 申明并安装当前 composer 包的依赖项 |
| composer remove         | 移除当前 composer 包的依赖项       |
| composer create-project | 创建 composer 项目                 |

> 次要指令

| 指令                 | 描述                                               |
| -------------------- | -------------------------------------------------- |
| composer global      | COMPOSER_HOME 目录下执行其它命令                   |
| composer search      | 为当前项目搜索依赖包                               |
| composer show        | 列出所有可用的软件包                               |
| composer depends     | 查出已安装的某个包，是否被其它包所依赖，并列出他们 |
| composer validate    | 检测 composer.json 文件是否有效                    |
| composer status      | 依赖包状态检测                                     |
| composer self-update | 将 Composer 自身升级到最新版本                     |
| composer config      | 编辑 Composer 的一些基本设置                       |

## 操作 composer 指令

我们通过脚本程序，将 composer 操作简化了，完整的操作应该是下面这样的：

| 系统    | 指令                                                                      |
| ------- | ------------------------------------------------------------------------- |
| Windows | `<php根目录路径>\php.exe <composer文件路径>\composer.phar <composer指令>` |
| Linux   | `<php执行程序路径>/php <composer文件路径>/composer.phar <composer指令>`   |

1. 将 `php执行程序路径` 加入到环境变量中，可简化成：

   | 系统    | 指令                                                      |
   | ------- | --------------------------------------------------------- |
   | Windows | `php.exe <composer文件路径>\composer.phar <composer指令>` |
   | Linux   | `<composer文件路径>/composer.phar <composer指令>`         |

   > 提示：Linux 下 `php执行程序` 一旦加入加入环境变量就可以省略！

2. 再将 `composer文件路径` 加入到环境变量中，可简化成：

   | 系统    | 指令                                   |
   | ------- | -------------------------------------- |
   | Windows | `php.exe composer.phar <composer指令>` |
   | Linux   | `composer.phar <composer指令>`         |

3. Windows 通过 bat 脚本将指令简化为：

   ```sh
   $ composer <composer指令>
   ```

4. Linux 通过软连接或重命名将脚本简化为：

   ```sh
   $ composer <composer指令>
   ```

## 重要指令解释

这里我们只讲解了个别重要的指令，其它指令请[查看手册](https://docs.phpcomposer.com)

### 初始化指令

初始化其实就是创建 composer.json 的过程，分为手动创建和 `init` 指令两种！

1. init 指令创建

   init 指令非常简单的，就是按照终端提示，一步步完成

2. 手动创建

   手动创建也不困难，这两个前提都要求我们对 composer.json 文件内的属性有清晰的了解，这个在后面会详细讲解

### 安装指令

`composer install` 命令从当前目录读取 composer.json 文件，处理了依赖关系，并把其安装到 vendor 目录下。

1. 存在 composer.lock 文件

   如果当前目录下存在 composer.lock 文件，它会从此文件读取依赖版本，而不是根据 composer.json 文件去获取依赖。这确保了该库的每个使用者都能得到相同的依赖版本。

2. 不存在 composer.lock 文件

   如果没有 composer.lock 文件，composer 将在处理完依赖关系后创建它。

> `composer install` 的参数说明请查看[官方手册](https://docs.phpcomposer.com/03-cli.html#install)

### 更新指令

为了获取依赖的最新版本，并且升级 composer.lock 文件，你应该使用 `composer update` 命令。

1. 更新全部

   这将解决项目的所有依赖，并将确切的版本号写入 composer.lock

   ```sh
   $ composer update
   ```

2. 更新个别包

   如果你只是想更新几个包，你可以像这样分别列出它们：

   ```sh
   $ composer update composer_username/package_name [...]
   ```

   更新指定 `composer 包` 案例:

   ```sh
   $ composer update topthink/framework linjialiang/hash
   ```

3. 批量更新

   你还可以使用通配符进行批量更新：

   ```sh
   $ composer update composer_username1/*
   ```

   批量更新 `composer 包` 案例:

   ```sh
   $ composer update topthink/*
   ```

> `composer update` 的参数说明请查看[官方手册](https://docs.phpcomposer.com/03-cli.html#update)

### 申明依赖

`composer require` 命令增加新的依赖包到当前目录的 composer.json 文件中。并且在添加或改变依赖时， 修改后的依赖关系将被安装或者更新。

```sh
$ composer require
```

1. 如果你不希望通过交互来指定依赖包，你可以在这条令中直接指明依赖包。

   ```sh
   $ composer require composer_username/package_name:version [...]
   ```

2. 申明依赖举例:

   ```sh
   $ composer require topthink/framework:6.0.x-dev linjialiang/hash:0.0.6
   ```

> 注意：`:version` 缺省为最新版本，也可以自己指定一个固定版本号，支持使用通配符指定次版本号

### 创建 composer 项目

你可以使用 Composer 从现有的包中创建一个新的项目：

| 序号 | create-project 流程                        |
| ---- | ------------------------------------------ |
| 01   | 执行了一个 git clone 命令后                |
| 02   | 并将这个包的依赖安装到它自己的 vendor 目录 |

1. 如果该目录目前不存在，则会在安装过程中自动创建

   ```sh
   $ composer create-project composer_username/project_name path version
   ```

2. 创建 composer 项目举例

   ```sh
   $ composer create-project topthink/think /www/tp6 6.0.*-dev
   ```

## composer.json 架构

下面我们来讲解 composer 中 最重要的文件 composer.json

### `Root 包` 概念

`root 包` 是指由 composer.json 定义的在你项目根目录的包。这是 composer.json 定义你项目所需的主要条件。（简单的说，你自己的项目就是一个 root 包）

1. 如果你克隆了其中的一个依赖包，直接在其上开始工作，那么它就变成了“root 包”。与作为他人的依赖包时使用相同的 composer.json 文件，但上下文发生了变化。
2. 注意： 一个资源包是不是“root 包”，取决于它的上下文。 例：如果你的项目依赖 monolog 库，那么你的项目就是“root 包”。 但是，如果你从 GitHub 上克隆了 monolog 为它修复 bug， 那么此时 monolog 就是“root 包”。

### 属性

> 这里列出了 composer.json 部分属性名，详情[查看手册](https://docs.phpcomposer.com/04-schema.html)

| 属性名       | 别名         | 描述                                              |
| ------------ | ------------ | ------------------------------------------------- |
| name         | 包名         | 包的名称，它包括供应商名称和项目名称，使用 / 分隔 |
| description  | 描述         | 一个包的简短描述                                  |
| version      | 版本         | 版本号不是必须的，并且建议忽略                    |
| type         | 安装类型     | 包的安装类型，默认为 library                      |
| keywords     | 关键字       | 该包相关的关键词的数组。这些可用于搜索和过滤。    |
| homepage     | 项目主页     | 该项目网站的 URL 地址。                           |
| time         | 版本发布时间 | YYYY-MM-DD 或 YYYY-MM-DD HH:MM:SS 格式            |
| license      | 许可协议     | 如：Apache-2.0                                    |
| authors      | 作者         | 包的作者。这是一个对象数组。                      |
| support      | 支持         | 获取项目支持的向相关信息对象。                    |
| require      | 软件包列表   | 除非这些依赖被满足，否则不会完成安装。            |
| require-dev  | 仅 root 包   | 这个列表是为开发或测试等目的                      |
| conflict     | 冲突包列表   | 此列表中的包与当前包的这个版本冲突。              |
| replace      | 替代包列表   | 这个列表中的包将被当前包取代                      |
| suggest      | 建议安装的包 | 它们增强或能够与当前包良好的工作。                |
| autoload     | 自动加载     | PHP autoloader 的自动加载映射                     |
| PSR-4        | 自动加载规则 | psr-4 自动加载规则                                |
| PSR-0        | 自动加载规则 | psr-0 自动加载规则                                |
| Classmap     | 引用组合     | 存储到 vendor/composer/autoload_classmap.php 中   |
| Files        | 自动加载规则 | 在每次请求时都要载入某些文件，通常是函数库        |
| autoload-dev | 仅 root 包   | 本节允许为开发目的定义 autoload 规则              |
| include-path | include 加载 | 一个追加到 PHP include_path 中的列表              |
| target-dir   | ...          | 定义当前包安装的目标文件夹                        |
| config       | 仅 root 包   | 定义项目级的 composer 基础配置                    |
| scripts      | 仅 root 包   | 允许在安装过程中的各个阶段挂接脚本。              |
| extra        | ...          | 供 scripts 使用的额外数据                         |
| bin          | ...          | 该属性用于标注一组应被视为二进制脚本的文件        |
| archive      | ...          | 这些选项在创建包存档时使用                        |

## 安装 composer

composer 在不同平台安装基本一致，[访问官方](https://getcomposer.org/download/)查看教程，这里简单讲解下：

### composer 依赖：

| composer 依赖 | 描述               |
| ------------- | ------------------ |
| PHP 版本      | `PHP 5.3.2+`       |
| PHP 扩展      | `openssl 扩展开启` |

### 具体安装步骤：

1. `php 可执行程序目录` 的路径加入环境变量中

   | 系统    | php 执行文件路径   | 主程序名  |
   | ------- | ------------------ | --------- |
   | Windows | `c:\wamp\base\php` | `php.exe` |
   | Linux   | `/server/php/bin`  | `php`     |

   > 提示：如果没加入系统环境变量中，安装时就需要指定 `php可执行文件` 的全路径。

2. 任意目录下，下载 composer 安装脚本：

   ```sh
   $ php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
   ```

3. 检测文件是否被篡改

   ```sh
   $ php -r "if (hash_file('sha384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
   ```

   > 提示：`composer-setup.php` 官方会更新，所以 hash 值需要去[官网查看](https://getcomposer.org/download/)

4. 执行 composer 安装脚本：

   ```sh
   $ php ./composer-setup.php
   ```

5. `compser.phar` 安装成功，移除安装脚本：

   ```sh
   $ php -r "unlink('composer-setup.php');"
   ```

6. 移动 composer.phar 文件到可执行目录中：

   ```sh
   $ mv composer.phar /server/php/bin/
   ```

   > 提示：建议 `composer 文件` 与 `php 执行程序` 处于同一目录！

### 执行脚本选项说明：

| 选项            | 作用         | 案例                                            |
| --------------- | ------------ | ----------------------------------------------- |
| `--install-dir` | 指定目标目录 | `php composer-setup.php --install-dir=bin`      |
| `--filename`    | 指定文件名   | `php composer-setup.php --filename=composer`    |
| `--version`     | 指定特定版本 | `php composer-setup.php --version=1.0.0-alpha8` |

### Linux 下全局调用 `composer.phar`

1. 将 `composer.phar` 移动到 `php 可执行程序目录` 中：

   ```sh
   $ mv composer.phar /server/php/bin/
   ```

2. 将 php 的 `php 可执行程序目录` 的路径加入到环境变量中：

   > `/etc/profile` 用于定义 Linux 系统环境变量

   ```sh
   $ cp /etc/profile{,.bak}
   $ vim /etc/profile
   ```

   > 在 /etc/profile 底部加入 1 行内容

   ```sh
   export PATH=$PATH:/server/php/bin:/server/php/sbin
   ```

   > 使用 `source` 指令重载 profile 文件内容到环境变量：

   ```sh
   $ source /etc/profile
   ```

### Windows 下全局调用 `composer.phar`

| 步骤 | 操作说明                                         |
| ---- | ------------------------------------------------ |
| 01   | 将 `composer.phar` 移动到 php 跟目录             |
| 02   | 打开 cmd，进入 php 根目录，并执行第 3 步骤指令   |
| 03   | `echo @php "%~dp0composer.phar" %*>composer.bat` |
| 04   | 将 `php 根目录` 的路径加入到系统环境变量中       |

### 切换 composer 镜像

如果 composer 镜像不能正常访问，我们可以更换成阿里云镜像：

1. 全局切换镜像源：

   ```sh
   $ composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
   ```

   > 取消配置

   ```sh
   $ composer config -g --unset repos.packagist
   ```

2. 仅限当前工程使用镜像，全局操作中 `去掉 -g` 即可：

   ```sh
   $ composer config repo.packagist composer https://mirrors.aliyun.com/composer/
   ```

   > 取消配置

   ```sh
   $ composer config --unset repos.packagist
   ```

3. 恢复官方镜像：

   ```sh
   $ composer config -g repo.packagist composer https://packagist.org
   ```

4. 调试

   ```sh
   $ composer -vvv require alibabacloud/sdk
   ```

5. 清除缓存

   ```sh
   $ composer clear
   ```

6. 若项目之前已通过其他源安装，则需要更新 composer.lock 文件，执行命令：

   ```sh
   $ composer update --lock
   ```

7. 执行诊断命令：

   ```sh
   $ composer diagnose
   ```

## 附录一：Linux 操作 composer 须知

| 操作须知                                    |
| ------------------------------------------- |
| 允许使用 root 用户 `升级 composer 程序本身` |
| 不允许使用 root 用户 `操作 composer`        |
