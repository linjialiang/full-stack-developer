# SSH 密钥对

通常我们会使用密码的方式来登录 linux，但是这很容易被暴力破解，对服务器的安全造成隐患，为此先辈们想到了一个更好的办法来保证安全，而且让你可以放心地用 root 账户从远程登录——那就是通过密钥方式登陆！

## 密钥对登陆原理

密钥形式登录的原理是：

1. 利用密钥生成器制作一对密钥——一只公钥和一只私钥；
2. 将公钥添加到服务器的某个账户上，然后在客户端利用私钥即可完成认证并登录；
3. 这样一来，没有私钥，任何人都无法通过 SSH 暴力破解你的密码来远程登录到系统；
4. 此外，如果将公钥复制到其他账户甚至主机，利用私钥也可以登录。

## 一、制作密钥对

首先在服务器上制作一个密钥对。首先用密码登录到你打算使用密钥登录的账户，然后执行以下命令：

```text
$ su tmproot
$ cd ~
$ ssh-keygen    <- 建立密钥对指令
Generating public/private rsa key pair. <- 生成公钥/私钥对
Enter file in which to save the key (/home/tmproot/.ssh/id_rsa): rsa   <- 输入保存密钥的文件名(包含路径)
Created directory '/home/tmproot/.ssh'. <- 创建了一个目录
Enter passphrase (empty for no passphrase): <-输入密钥锁码（空为不设置密码）
Enter same passphrase again:    <- 再次输入密钥锁码
Your identification has been saved in rsa.  <- 私钥文件
Your public key has been saved in rsa.pub.  <- 公钥文件
The key fingerprint is: <- 关键指纹
SHA256:WxJFl5ZZLHEeBXzwNkGVcBvS5sQ1LLjY6iLhoSkjang tmproot@主机名
The key's randomart image is:   <- 密钥随机图形
+---[RSA 2048]----+
|         .o +@%XB|
|         . o*+=X*|
|        . o...*+o|
|         o o   o.|
|        S o      |
|     o   =       |
|.   + o o        |
|o+Eo o . .       |
|=.o   . .        |
+----[SHA256]-----+
```

> 说明：

```text
- 密钥锁码在使用私钥时必须输入，这样就可以保护私钥不被盗用。当然，也可以留空，实现无密码登录。
- 如果我们自己设置现在，在 root 用户的家目录中生成了一个 .ssh 的隐藏目录，内含两个密钥文件。id_rsa 为私钥，id_rsa.pub 为公钥。 
