# Linux 磁盘挂载

本小节讲解会涉及到 Linux 磁盘挂载、分区、扩容等操作

## 一、基本概念

在操作前，首先要了解一些基本概念：

| 序号 | 基本概念 |
| ---- | -------- |
| 01   | 磁盘     |
| 02   | 分区     |
| 03   | 文件系统 |
| 04   | 格式化   |
| 05   | 挂载     |
| 06   | 卸载     |

1. 磁盘

   ```text
   - 在 Linux 系统中所有的设备都会以文件的形式存储；
   - 设备一般保存在 `/dev` 目录下面，现在的设备一般都是 sd 命名，如：`sda、sda1、sda2 、sdb、sdb1`，很老的硬盘是以 ha 命名；
   - sda：第一块硬盘，如果对磁盘进行了分区会有 sda1(第一个分区)，sda2 等；
   - sdb：第二个硬盘，同样对硬盘分区后有 sdb1,sdb2 等。
   ```

2. 分区

   ```text
   - 分区的目的就是便于管理，比如在Windows系统我们一般会分C盘，D盘，E盘等。
   - Linux只能创建4个主分区，如果需要创建更多的分区那么就必须创建逻辑分区，其中逻辑分区需要占用一个主分区。
   ```

3. 文件系统

   Linux 中的文件系统也就是分区类型：

   ```text
   - 在Windows中有NTEF,FAT32等，
   - linux中常见的有Ext2、Ext3、Ext4、Linux swap、proc、sysfs、tmpfs等，可以通过mount命名查看当前已挂载的文件系统。
   ```

4. 格式化

   创建完分区后有一步是要对分区进行格式化，其实在 Windows 系统中也是一样，在创建好一个分区后也需要将分区格式化，只有格式化成具体的文件类型才能使用。

5. 挂载

   在 Windows 中分区格式化后就可以使用，但是在 Linux 系统中必须将分区挂载到具体的路径下才可以。

6. 卸载

   顾名思义，卸载就是将挂载好的分区 `虚拟的拆卸` 下来，对应挂载点上的数据就会消失（当然磁盘上的数据依然保留着，只是系统读取不了而已）。

## 二、磁盘挂载必备知识

挂载磁盘前，下表的概念需要先记住：

| 命令          | 格式                                                 | 作用                    |
| ------------- | ---------------------------------------------------- | ----------------------- |
| fdisk         | fdisk /dev/sdb                                       | 物理硬盘--分出逻辑硬盘  |
| pvcreate      | pvcrate /dev/sdb1                                    | 对物理卷进行初始化      |
| vgcreate      | vgcreate lsvg /dev/sdb1                              | 物理卷--并成卷组        |
| lvcreate      | lvcreate -L 10G -n lslvm lsvg                        | 卷组--分出逻辑卷        |
| mkfs.ext4     | mkfs.ext4 /dev/mapper/lsvg-lslvm                     | 格式化逻辑卷            |
| mount         | mount /dev/mapper/lsvg-lslvm /your/point             | 挂载逻缉卷              |
| vi /etc/fstab | /dev/mapper/lsvg-lslvm /your/point ext4 defaults 0 0 | 写入开机挂载文件        |
| umount        | umount /your/point                                   | 卸载新挂载磁盘          |
| mount         | mount -a                                             | 测试 fstab 书写是否有误 |

## 三、逻辑卷管理

Debian10 使用 LVM2 工具执行卷的构建和管理、建立备份快照等各种功能

1. 安装 lvm2 包

   Debian10 默认并没有安装 LVM2 ，需要我们自己安装：

   ```sh
   $ apt install lvm2
   ```

2. LVM 的结构

   LVM 被组织为三种元素：

   | LVM 元素                    | 元素描述             |
   | --------------------------- | -------------------- |
   | 卷（Volume）                | 物理卷、逻辑卷和卷组 |
   | 区段（Extent）              | 物理区段和逻辑区段   |
   | 设备映射器（Device mapper） | Linux 内核模块       |

3. 卷

   Linux LVM 由物理卷（PV）、卷组（VG）和逻辑卷（LV）组成。

   | LVM 类型 | 类型说明                                                |
   | -------- | ------------------------------------------------------- |
   | 物理卷   | 物理磁盘或物理磁盘分区（比如：`/dev/sdb`、`/dev/sdb1`） |
   | 卷组     | 物理卷的集合                                            |
   | 逻辑卷   | 每个卷组在逻辑上可以划分成多个逻辑卷                    |

4. 区段

   区段是卷管理中最小单元，类似于磁盘分区中的扇区大小，不可再分。

   ```text
   - 为了实现物理卷到逻辑卷的映射，PV 和 VG 的基本块必须具有相同的大小；
        - 即：物理区段（PE）= 逻辑区段（LE）
   - 这些基本块称为物理区段（PE）和逻辑区段（LE）；
   - 尽管 n 个物理卷映射到 m 个逻辑卷，但是 物理区段（PE） 和 逻辑区段（LE） 总是一对一映射的。
   ```

   关于区段大小的说明：

   ```text
   - 在使用 LVM2 时，对于每个 PV/LV 的最大区段数量并没有限制。
   - 默认的区段大小是 4MB，对于大多数配置不需要修改这个设置，因为区段的大小并不影响 I/O 性能。
   - 但是，区段数量太多会降低 LVM 工具的效率，所以可以使用比较大的区段，从而降低区段数量。
   - 注意：在一个 VG 中不能混用不同的区段大小，而且用 LVM 修改区段大小是一种不安全的操作，会破坏数据。
   - 建议：在初始设置时选择一个区段大小，以后不再修改。
   ```

   > 提示：不同的区段大小意味着不同的 VG 粒度。例如，如果选择的区段大小是 4GB，那么只能以 4GB 的整数倍缩小或扩展 LV。

5. 设备映射器

   设备映射器（也称为 dm_mod）是一个 Linux 内核模块，它的作用是对设备进行映射 —— LVM2 必须使用这个模块。

   - 在 Debian10 中设备映射器会被默认安装；

   - 如果没有启用这个模块，那么对 dm_mod 执行 modprobe 命令：

     ```sh
     $ modprobe dm_mod
     ```

   - 检测是否装载了这个模块

     ```sh
     $ lsmod | grep dm_mod
     ```

6. 启动 LVM2 的基本命令

   如果 LVM2 不能自动启动，挂载也差不多废了

   ```sh
   # 加载设备映射器模块
   $ modprobe dm_mod

   # 找到物理磁盘中的所有pv
   $ pvscan

   # 激活所有卷组
   $ vgchange -ay
   ```

## 四、实战操作

本次实例使用 LVM2 工具执行卷的构建和管理分区

```text
假设我们有两个虚拟盘，接下来我们需要操作：
    - 将 data1 和 data2 两个虚拟盘合并到一个逻辑卷中；
    - 将这个逻辑卷挂载到 /data 目录。
```

### 4.1 删除分区

先将这两个数据盘的分区全部删除操作如下：

```sh
$ fdisk /dev/sdb 或 /dev/sdc
d
一路回车，直到出现如下红色警告文字
No partition is defined yet!
w
```

### 4.2 创建 LVM 分区

为虚拟盘创建 LVM 分区

```sh
$ fdisk -l
$ fdisk /dev/sdb 或 /dev/sdc
n
e
按回车键3次
t
8e
w
```

> 说明：`8e` 是 lvm 分区类型的 `标识`

### 4.3 创建 LVM 物理卷

将 /dev/sdb1 和 /dev/sdc1 转化成 `LVM 物理卷`

```sh
$ pvcreate /dev/sd{b,c}1
y
```

查看 LVM 物理卷的方法：

```sh
$ pvs
$ pvscan
$ pvdisplay
```

### 4.4 创建 LVM 卷组

1. 将 `物理卷 /dev/sd{b,c}1` 加入 `LVM卷组 vg_data`

   ```sh
   $ vgcreate vg_data /dev/sd{b,c}1
   $ vgs
   $ vgscan
   $ vgdisplay
   $ pvdisplay
   ```

2. 将 `物理卷（2个数据盘）` 的容量都给 `LVM逻辑卷 lv_data`

   ```sh
   $ lvcreate -l 100%VG -n lv_data vg_data
   $ lvs
   $ lvscan
   $ lvdisplay
   ```

### 4.5 格式化逻辑卷

1. 方法一：速度慢，带 -c 会检测是否坏轨

   ```sh
   $ mkfs -V -t ext4 -c /dev/vg_data/lv_data
   ```

2. 方法二：速度快

   ```sh
   $ mkfs -V -t ext4 /dev/vg_data/lv_data
   ```

### 4.6 挂载分区

1. 创建 `/data` 这个挂载目录

   ```sh
   $ mkdir /data
   ```

2. 挂载 lvm 逻辑分区到指定目录

   ```sh
   $ lvdisplay
   $ mount /dev/vg_data/lv_data /data
   $ df -Th
   ```

3. 开机自动挂载

   ```sh
   $ lvdisplay # 获取lv_data 的 LV Path
   $ cp /etc/fstab{,.bak}
   $ vi /etc/fstab
   ```

   在 /etc/fstab 文件底部增加如下两行：

   ```text
   # /data was on /dev/vg_data/lv_data during installation
   /dev/mapper/vg_data-lv_data /data       ext4    defaults        0       0
   # 或者使用下面的方式
   # /data was on /dev/vg_data/lv_data during installation
   /dev/vg_data/lv_data /data       ext4    defaults        0       0
   ```

### 4.7 卸载分区

```sh
$ umount /data
```

## 五、挂载普通分区

挂载普通分区非常简单，这里给大家一个思路

| 步骤         | 描述                          |
| ------------ | ----------------------------- |
| 磁盘分区     | 使用 fdisk 分区               |
| 格式化分区   | 将分区格式化成 ext4 格式      |
| 挂载         | 使用 mount 指令挂载到指定目录 |
| 卸载         | 使用 umount 指令将分区卸载    |
| 开启自动挂载 | 修改 `/etc/fstab` 文件        |

```sh
$ vi /etc/fstab
```

在 /etc/fstab 文件底部增加如下两行：

```text
# /data was on /dev/sdb1 during installation
/dev/sdb1 /data       ext4    defaults        0       0
```

## 六、LVM 逻辑卷管理命令

LVM 逻辑卷管理一般涉及到 `fdisk` 、 `mkfs` 以及 `lvm2自带的指令`

### 6.1 fdisk 指令

fdisk 指令用于磁盘的分区操作，fdisk 没有什么好说的，就是分区操作，按照说明来就可以了！

### 6.2 mkfs 指令

mkfs 指令用于格式化分区

```text
【语法】
    mkfs [选项] [参数]
【选项】
    fs：指定建立文件系统时的参数；
    -t<文件系统类型>：指定要建立何种文件系统；
    -v：显示版本信息与详细的使用方法；
    -V：显示简要的使用方法；
    -c：在制做档案系统前，检查该partition是否有坏轨。
【参数】
    文件系统：指定要创建的文件系统对应的设备文件名；
    块数：指定文件系统的磁盘块数。
```

案例说明：

```sh
$ mkfs -V -t ext3 /dev/sdb1
$ mkfs -V -t ext4 /dev/vg_data/lv_data
```

### 6.3 PV 指令

PV 是处理物理卷的相关指令

1. 物理硬盘格式化为物理卷(PV):

   ```sh
   $ pvcreate /dev/sd{b,c}1
   ```

2. 显示物理卷(PV)信息:

   ```sh
   $ pvs
   $ pvscan
   $ pvdisplay
   ```

3. 删除物理卷(PV):

   ```sh
   $ pvremove /dev/sd{b,c}1
   ```

### 6.4 VG 指令

VG 是处理 lvm 卷组的相关指令

1. 创建卷组(VG),并将物理卷(PV)加入到卷组中:

   ```sh
   $ vgcreate vg_data /dev/sd{b,c}1
   ```

2. 将物理卷(PV)从指定卷组(VG)中移除(使用中的 PV 不能移除)：

   ```sh
   $ vgreduce vg_data /dev/sdb1
   ```

3. 从卷组(VG)中移除缺失物理硬盘：

   ```sh
   $ vgreduce --removemissing vg_data
   ```

4. 显示卷组(VG)信息：

   ```sh
   $ vgs
   $ vgscan
   $ vgdisplay
   ```

5. 增加卷组(VG)空间：

   ```sh
   $ vgextend vg_data /dev/sdd1
   ```

6. 删除卷组(VG):

   ```sh
   $ vgremove vg_data
   ```

### 6.5 LV 指令

LV 是处理 lvm 逻辑卷的相关指令

1. 基于卷组(VG)创建逻辑卷(LV)

   ```text
   【语法】
       lvcreate [选项] [参数]
   【功能介绍】
       用于创建LVM的逻辑卷。
   【主要参数】
       -L 指定逻辑卷大小，单位为“bBsSkKmMgGtTpPeE”字节
       -l 指定逻辑扩展数，单位“VG|FREE|ORIGIN”
       -n 后面跟逻辑卷名
       -s 创建快照
   ```

   举例说明：

   ```sh
   $ lvcreate -L 10G -n lv_001 vg_data
   $ lvcreate -l 20%VG -n lv_002 vg_data
   $ lvcreate -l 100%FREE -n lv_003 vg_data
   ```

2. 显示逻辑卷(LV)信息:

   ```sh
   $ lvs
   $ lvscan
   $ lvdisplay
   ```

3. 删除逻辑卷(LV):

   ```sh
   $ lvremove /dev/vg_data/lv_data
   ```

4. 激活修复后的逻辑卷(LV):

   ```sh
   $ lvchange -ay /dev/vg_data/lv_data
   ```

5. 增加逻辑卷(LV)空间:

   ```sh
   $ lvextend -L +3G /dev/vg_data/lv_data
   ```

### 6.6 lvm 其它指令

1. 更新逻辑卷(LV):

   ```sh
   $ resize2fs /dev/vg_data/lv_data
   ```

2. 检查逻辑卷(LV)文件系统:

   ```sh
   $ e2fsck -f /dev/vg_data/lv_data
   ```

3. 减少逻辑卷(LV)空间:

   ```sh
   $ resize2fs /dev/vg_data/lv_data 4G
   $ lvreduce -L -1G /dev/vg_data/lv_data
   ```
