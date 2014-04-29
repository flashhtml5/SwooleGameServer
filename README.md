# SwooleGameServer 安装说明

标签（空格分隔）： flashgameserver


---
**使用Swoole PHP 框架开发flash游戏的socket服务端**

系统环境:
1: centos 6.4  32位 
   参考:

> 镜像：
http://mirrors.163.com/centos/6.4/isos/i386/CentOS-6.4-i386-minimal.iso
备用：
http://mirrors.ustc.edu.cn/centos/6.4/isos/i386/CentOS-6.4-i386-minimal.iso
注：安装过程选择语言的时候直接选择英语即可，minimal模式选择了中文也不会出现中文界面。
市区选择上海，分区让安装盘自动分区，使用整个硬盘，不加干涉。


----------


>安装:


----------





>配置网卡:
ifconfig -a 看到网卡
vi /etc/sysconfig/network-scripts/ifcfg-eth0
BOOTPROTO=dhcp//启动类型 dhcp或static 自动和手动
ONBOOT=no //是否启动应用 改yes
注释掉mac地址
注：如果vhd文件迁移过，网卡可能是eth1并且mac地址也有变化 应该mv ifcfg-eth0 ifcfg-eth1，然后打开ifcfg-eth0修改网卡名字，并注释掉mac地址
重启网络service network restart
ifconfig 查看获取到的ip
在路由器中网络>DHCP|DNS 重新给他制定一个ip。
service network restart
ifconfig 查看新ip


----------


>主要工具:
安装wget 、screen等必需工具，并更新到最新版
yum -y install wget screen
yum update#差不多要更新50M
简单优化一下系统
chkconfig 查看都是有哪些服务


----------

>安装php5.4
更新源:
CentOS/RHEL 6.x:
rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm
CentOS/RHEL 5.x:
rpm -Uvh http://mirror.webtatic.com/yum/el5/latest.rpm
安装php5.4
yum install php54w
安装必要的插件
mysql redis pecl


----------
>编辑php.ini
打开报错提示
加入xdebug.so
加入redis.so


----------


>安装redis并测试

    PHP的Redis扩展安装后测试错误】
测试代码：
<?php
    $redis = new Redis();
    $redis->connect('127.0.0.1', 6379);
    $redis->set('test', 'hello world');
    echo $redis->get('test');
?>


> 1：去下面的网站下载EPEL对应的版本：（epel是fedora维护的yum源，里面软件众多）
http://fedoraproject.org/wiki/EPEL
2：我下载的是这个：
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
3：安装epel：
rpm -ivh epel-release-6-8.noarch.rpm 
warning: epel-release-6-8.noarch.rpm: Header V3 RSA/SHA256 Signature, key ID 0608b895: NOKEY
Preparing...                ########################################### [100%]
   1:epel-release           ########################################### [100%]

4：安装redis：
[root@CentOS6 ~]# yum install redis


    关于redis里的db

进入客户端，默认使用编号为0的数据库，可以通过命令切换，如：

lch@localhost:Desktop $ redis-cli
redis 127.0.0.1:6379> select 1
OK
redis 127.0.0.1:6379[1]> select 0
OK
redis 127.0.0.1:6379>
设置一对key-value

redis 127.0.0.1:6379> set name luchanghong
OK
redis 127.0.0.1:6379> set gender male
OK
redis 127.0.0.1:6379> set age 24
OK
匹配查找key

redis 127.0.0.1:6379> keys *
1) "age"
2) "gender"
3) "name"
redis 127.0.0.1:6379> keys name
1) "name"
redis 127.0.0.1:6379> keys nam
(empty list or set)
redis 127.0.0.1:6379> keys nam*
1) "name"
取出key对应的value

redis 127.0.0.1:6379> get name
"luchanghong"
redis 127.0.0.1:6379> get gender
"male"
redis 127.0.0.1:6379> get age
"24"
判断key是否存在

redis 127.0.0.1:6379> exists name
(integer) 1
redis 127.0.0.1:6379> exists names
(integer) 0
删除key

redis 127.0.0.1:6379> set test1 1
OK
redis 127.0.0.1:6379> set test2 2
OK
redis 127.0.0.1:6379> del test1
(integer) 1
redis 127.0.0.1:6379> exists test1
(integer) 0
redis 127.0.0.1:6379> exists test2
(integer) 1
设置/查询多个key

redis 127.0.0.1:6379> mset passwd 123 city beijing
OK
redis 127.0.0.1:6379> mget passwd city
1) "123"
2) "beijing"
list操作

redis 127.0.0.1:6379> lpush people lch
(integer) 1
redis 127.0.0.1:6379> lset people 0 luchanghong
OK
redis 127.0.0.1:6379> lpush people male
(integer) 2
redis 127.0.0.1:6379> llen people
(integer) 2

redis 127.0.0.1:6379> lrange people 0 1
1) "male"
2) "luchanghong"
redis 127.0.0.1:6379> lindex people 0
"male"
redis 127.0.0.1:6379> lindex people 1
"luchanghong"
set操作

redis 127.0.0.1:6379> sadd myset a
(integer) 1
redis 127.0.0.1:6379> sadd myset b c
(integer) 2
redis 127.0.0.1:6379> smembers myset
1) "c"
2) "a"
3) "b"
redis 127.0.0.1:6379> sismember myset d
(integer) 0
redis 127.0.0.1:6379> sismember myset a
(integer) 1