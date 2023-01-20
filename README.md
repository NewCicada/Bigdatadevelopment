## 1.环境搭建前的准备
### 1.1虚拟机的安装
采用的是虚拟机，使用了三台虚拟机， 虚拟机操作系统版本CentOS 7， 本地主机是Window11 64位。
**简要配置说明**
* JDK: Hadoop和Spark依赖的配置
* Scala： Spark依赖的配置，版本不要低
* Spark版本: 分布式计算框架
* Hadoop： 分布式系统基础架构
* Spark： 分布式计算框架
* zookeeper: 分布式应用程序协调服务， HBase集群需要
* HBase: 结构化数据的分布式存储系统
* Hive: 基于Hadoop的数据仓库工具， 默认的元数据库mysql
* Kafka: 分布式消息队列
> 如果涉及的大数据框架比较多，并且选择不慎的话， 有可能出现版本不兼容的问题， 上面这些框架版本是兼容的， 如果不想用这些的话， 也可以自己选择，但一定要注意版本匹配，这里也提供一个社区版本，就是大名鼎鼎的CDH开源社区，Cloudera Distributed Hadoop
* 通过统一的CDH版本来避免兼容性问题
* Cloudera 在社区版的基础上做了一些修改, 可以解决掉一些兼容性问题
* http://archive.cloudera.com/cdh5/cdh/5/
> 我们选择各个框架的时候， 就看后面的这个cdh， 后面这个版本号一样的话，基本上不会出现兼容性问题， 比如hadoop-2.6.0-cdh-5.7.0 和 Flume-cdh5.7.0 是兼容的。
### 1.2集群的相关配置
#### 配置网络
* vi /etc/sysconfig/network-scripts/ifcfg-eno16777736
* vi /etc/sysconfig/network-scripts/ifcfg-ens33

**不同的机子使用的不同(网卡接口不同)**
```
TYPE=Ethernet
BOOTPROTO=static
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
IPV6_FAILURE_FATAL=no
NAME=eno16777736
UUID=4dbd335c-3093-4e28-b6ac-2c4e2e2e3c05
DEVICE=eno16777736
ONBOOT=yes
IPADDR=192.168.44.140
GATEWAY=192.168.44.2
NETMASK=255.255.255.0
DNS1=8.8.8.8
DNS2=1.1.1.1
```
> 找到BOOTPROTO-设置-static
> 追加内容:
> IP设置：IPADDR=192.168.10.100
> 网关：GATEWAY=192.168.10.2
> 域名解析器：DNS1=192.168.10.2
**ESC：wq-回车**
* 刷新网络
> systemctl restart network
#### 主机名称修改
> 输入代码-vim /etc/hostname
修改为 master，如果为master就不用任何操作了
 如果还是hadoopESC- :q！-回车 退出
 如果不是hadoop ，修改为hadoop 100 
> ESC- :wq 回车 退出
#### 主机名称映射(三台机制都需要)
为了在防止后续升级配置后 IP地址的更改 导致我们需要到处找 原先的IP地址修改需要我们一个一个去更改。故设置主机名称映射
> 192.168.44.140 master(相当于全局变量)
**终端代码:vim /etc/hosts**

插入:
192.168.44.140 master

192.168.44.141 salver1

192.168.44.142 salver2

安装xshell

连接xshell

### 防火墙关闭

> 这里给大家一个概念，防火墙是每台电脑都会有的一套保护程序，虚拟机（服务器都不例外，当然不排除一些安装完成后特意阉割掉防火墙的服务器或者虚拟机），在我们开发[大数据](https://so.csdn.net/so/search?q=大数据&spm=1001.2101.3001.7020)项目的时候，分为两种情况;1.按照公司需求逐台安装防火墙保护每个服务器安全。2.在所有服务器集群的外部架设防火墙，控制外网访问，保护服务器安全。

**输入指令:**

> 关闭防火墙:systemctl stop firewalld

>  执行开机禁用防火墙自启命令 ：systemctl disable firewalld.service

### 克隆

注意在克隆出来的虚拟机上我们要更改相依的 虚拟机名称  IP地址  ，然后通过Xshell进行连接（在更改好克隆的虚拟机后，重启在连接Xshell）。

> 1. 安装JDK
>
> 1. 进入 root 模式
> 2. 指令进入opt文件夹：cd /opt/  
> 3. ll 显示文件夹 ，指令进入 cd software
> 4. 打开XFTP,确认好路径：***\**\*/opt/software\*\**\***
> 5. 拖入 hadoop框架 和  JDK linux。
> 6. 在命令行解压文件并安装JDK
> 7. 解压安装到制定的moduel文件夹，命令输入：
>
> **tar -zxvf 文件的完整名字 -C /opt/moduel/**

* 1.进入JDK文件夹 cd文件名
* 2.配置环境变量`vim /etc/profile`
* 3.在文件名添加环境变量

> export JAVA_HOME=/usr/jdk/jdk1.8.0_241  # 你解压后的jdk名称
>
> export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
>
> export PATH=$JAVA_HOME/bin:$PATH 

* 4.更新配置文件，使其生效

> source /etc/profile

* 5.检查验证，如果能显示jdk版本信息，则安装配置成功。

> java -version

## 配置免密

> cd /root/.shh/
>
> 如果没有.shh文件
>
> 直接输入`ssh-keygen -t rsa`
>
> ls -al # 显示隐藏文件

输入 `ssh-keygen -t rsa`

* 一直敲回车

* 把密匙发给另外两台节点，在master执行命令

> ssh-copy-id master
>
> ssh-copy-id slave01
>
> ssh-copy-id slave02

- 验证master是否登录到slave1中

>  命令：ssh slave1（不需要输入密码为配置成功）

## Hadoop基本集群搭建

> 三台机动要设置网络映射的配置vi /etc/hosts

* 使用FileZilla传输压缩包
* 解压文件

> vim /etc/profile

> \#Hadoop环境变量 
>
> export HADOOP_HOME=/usr/local/src/hadoop export HADOOP_INSTALL=$HADOOP_HOME export HADOOP_MAPRED_HOME=$HADOOP_HOME export HADOOP_COMMON_HOME=$HADOOP_HOME export HADOOP_HDFS_HOME=$HADOOP_HOME export YARN_HOME=$HADOOP_HOME export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib" export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin

* 更新环境变量

  >  source /etc/profile

* 传输到slave1，slave2节点

把`/etc/profile`也传输过去

* 另外二台机子也需要更新环境变量

>  source /etc/profile

### 修改配置文件

* 进入目录/hadoop/etc/hadoop

* 修改配置文件一: vi core-site.xml

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
  <!--
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
  
      http://www.apache.org/licenses/LICENSE-2.0
  
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License. See accompanying LICENSE file.
  -->
  
  <!-- Put site-specific property overrides in this file. -->
  
  
  
  <configuration>
  	<property>
  		<name>fs.defaultFS</name>
  		<value>hdfs://mycluster</value>
  	</property>
  	<property>
  		<name>hadoop.tmp.dir</name>
  		<value>/home/hadoop/tmp</value>
  	</property>
  	<property>
  	<name>ha.zookeeper.quorum</name>
       # 修改这里
  	<value>master:2181,slave1:2181,slave2:2181</value>
  	</property>
  </configuration>
  ```

  * 2.修改配置二`hadoop-env.sh`
  * 修改文件二：vi hadoop‐env.sh （在非编辑模式使用 “：set nu”命令，没有双引号）在第25行修改java的环境变量 26行修改hadoop目录

```xml
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Set Hadoop-specific environment variables here.

# The only required environment variable is JAVA_HOME.  All others are
# optional.  When running a distributed configuration it is best to
# set JAVA_HOME in this file, so that it is correctly defined on
# remote nodes.

# The java implementation to use.
# 修改JAVA和Hadoop文件的路径
export JAVA_HOME=/home/java
export HADOOP_HOME=/home/hadoop
# The jsvc implementation to use. Jsvc is required to run secure datanodes
# that bind to privileged ports to provide authentication of data transfer
# protocol.  Jsvc is not required if SASL is configured for authentication of
# data transfer protocol using non-privileged ports.
#export JSVC_HOME=${JSVC_HOME}

export HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-"/etc/hadoop"}

# Extra Java CLASSPATH elements.  Automatically insert capacity-scheduler.
for f in $HADOOP_HOME/contrib/capacity-scheduler/*.jar; do
  if [ "$HADOOP_CLASSPATH" ]; then
    export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:$f
  else
    export HADOOP_CLASSPATH=$f
  fi
done

# The maximum amount of heap to use, in MB. Default is 1000.
#export HADOOP_HEAPSIZE=
#export HADOOP_NAMENODE_INIT_HEAPSIZE=""

# Extra Java runtime options.  Empty by default.
export HADOOP_OPTS="$HADOOP_OPTS -Djava.net.preferIPv4Stack=true"

# Command specific options appended to HADOOP_OPTS when specified
export HADOOP_NAMENODE_OPTS="-Dhadoop.security.logger=${HADOOP_SECURITY_LOGGER:-INFO,RFAS} -Dhdfs.audit.logger=${HDFS_AUDIT_LOGGER:-INFO,NullAppender} $HADOOP_NAMENODE_OPTS"
export HADOOP_DATANODE_OPTS="-Dhadoop.security.logger=ERROR,RFAS $HADOOP_DATANODE_OPTS"

export HADOOP_SECONDARYNAMENODE_OPTS="-Dhadoop.security.logger=${HADOOP_SECURITY_LOGGER:-INFO,RFAS} -Dhdfs.audit.logger=${HDFS_AUDIT_LOGGER:-INFO,NullAppender} $HADOOP_SECONDARYNAMENODE_OPTS"

export HADOOP_NFS3_OPTS="$HADOOP_NFS3_OPTS"
export HADOOP_PORTMAP_OPTS="-Xmx512m $HADOOP_PORTMAP_OPTS"

# The following applies to multiple commands (fs, dfs, fsck, distcp etc)
export HADOOP_CLIENT_OPTS="-Xmx512m $HADOOP_CLIENT_OPTS"
#HADOOP_JAVA_PLATFORM_OPTS="-XX:-UsePerfData $HADOOP_JAVA_PLATFORM_OPTS"

# On secure datanodes, user to run the datanode as after dropping privileges.
# This **MUST** be uncommented to enable secure HDFS if using privileged ports
# to provide authentication of data transfer protocol.  This **MUST NOT** be
# defined if SASL is configured for authentication of data transfer protocol
# using non-privileged ports.
export HADOOP_SECURE_DN_USER=${HADOOP_SECURE_DN_USER}

# Where log files are stored.  $HADOOP_HOME/logs by default.
#export HADOOP_LOG_DIR=${HADOOP_LOG_DIR}/$USER

# Where log files are stored in the secure data environment.
export HADOOP_SECURE_DN_LOG_DIR=${HADOOP_LOG_DIR}/${HADOOP_HDFS_USER}

###
# HDFS Mover specific parameters
###
# Specify the JVM options to be used when starting the HDFS Mover.
# These options will be appended to the options specified as HADOOP_OPTS
# and therefore may override any similar flags set in HADOOP_OPTS
#
# export HADOOP_MOVER_OPTS=""

###
# Advanced Users Only!
###

# The directory where pid files are stored. /tmp by default.
# NOTE: this should be set to a directory that can only be written to by 
#       the user that will run the hadoop daemons.  Otherwise there is the
#       potential for a symlink attack.
export HADOOP_PID_DIR=${HADOOP_PID_DIR}
export HADOOP_SECURE_DN_PID_DIR=${HADOOP_PID_DIR}

# A string representing this instance of hadoop. $USER by default.
export HADOOP_IDENT_STRING=$USER
```

* 3.修改`hdfs-site.xml`配置文件
* 修改文件三：`vi hdfs-site.xml`

**注意:**删除文件内原有的内容，添加

```xml

<configuration>
	<property>
                <name>dfs.replication</name>
        # 这里默认是3,也可以给其他的值
                <value>3</value>
        </property>
	<property>
                <name>dfs.permissions</name>
                <value>false</value>
        </property>
	<property>
                <name>dfs.permissions.enabled</name>
                <value>false</value>
        </property>
	<property>
                <name>dfs.nameservices</name>
                <value>mycluster</value>
        </property>
	<property>
                <name>dfs.ha.namenodes.mycluster</name>
 <value>nn1,nn2</value>
        </property>
        <property>            <name>dfs.namenode.rpc-address.mycluster.nn1</name>
            # 修改1
                <value>hodoop01:9000</value>
        </property>
        <property>           <name>dfs.namenode.http-address.mycluster.nn1</name>
            # 修改1
                <value>hodoop01:50070</value>
        </property>
	<property>
                <name>dfs.namenode.rpc-address.mycluster.nn2</name>
        # 修改2
                <value>hodoop02:9000</value>
        </property>
        <property>                <name>dfs.namenode.http-address.mycluster.nn2</name>
            # 修改2
                <value>hodoop02:50070</value>
        </property>
        </property>
	<property>
                <name>dfs.ha.automatic-failover.enabled</name>
                <value>true</value>
 </property>
        <property>
                <name>dfs.namenode.shared.edits.dir</name>            
				# 修改3
           <value>qjournal:hadoop01//:8485;hodoop02:8485;hodoop03:8485/mycluster</value>
        </property>
	<property>           
	<name>dfs.client.failover.proxy.provider.mycluster</name>               
	<value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value>
        </property>
        <property>
                <name>dfs.journalnode.edits.dir</name>
            # 打印路径
               <value>/home/hadoop/tmp</value>
        </property>
	<property>
                <name>dfs.ha.fencing.methods</name>
                <value>shell(/bin/true)</value>
        </property>
        <property>               <name>dfs.ha.fencing.ssh.private-key-files</name>
                <value>/root/.ssh/id_rsa</value>
  </property>
	<property>                <name>dfs.ha.fencing.ssh.connect-timeout</name>
                <value>10000</value>
        </property>
        <property>
                <name>dfs.namenode.handler.count</name>
                <value>100</value>
        </property>
		<property>
			<name>dfs.ha.fencing.methods</name>
			<value>sshfence</value>
		</property>
</configuration>
```

* 修改路径`yarn-site.xml配置文件`
  * `vim yarn-site.xml`

```xml
<?xml version="1.0"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->



<configuration>
	<property>
		<name>yarn.nodemanager.aux-services</name>
		<value>mapreduce_shuffle</value>
	</property>
	<property>
		<name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
		<value>org.apache.hadoop.mapred.ShuffleHandler</value>
	</property>
	<property>
		<name>yarn.resourcemanager.address</name>
		<value>bigdata:8032</value>
	</property>
	<property>
		<name>yarn.resourcemanager.scheduler.address</name>
		<value>bigdata:8030</value>
	</property>
	<property>
		<name>yarn.resourcemanager.resource-tracker.address</name>
		<value>bigdata:8035</value>
	</property>
	<property>
		<name>yarn.resourcemanager.admin.address</name>
		<value>bigdata:8033</value>
	</property>
	<property>
		<name>yarn.resourcemanager.webapp.address</name>
		<value>bigdata:8088</value>
	</property>
</configuration>
```

* 修改slaves

`vim slaves`

**注意:**删除文件内原有的内容，再添加主机名

> master
>
> slave1
>
> slave2

* 把hadoop文件传给slave1，slave2的机子

## zookeeper安装
* 1.传输进`home`目录
* 2.解压:`tar -zxvf zookeeper-3.4.13.tar.gz`
* 3.编辑配置文件

- 1.进入conf目录
  `cd zookeeper-3.4.13/conf`

- 2.将zoo_sample.cfg这个文件改名为zoo.cfg (必须是这个文件名)

  `mv  zoo_sample.cfg zoo.cfg`
- 3.进入zoo.cfg进行编辑
`vim zoo.cfg`
- 4.按i进入编辑模式，修改以下内容:
`
dataDir=/tmp/zookeeper/data
dataLogDir=/tmp/zookeeper/log
`

>  注意：如果想配置集群的话，请在clientPort下面添加服务器的ip。如
>
> server.1=192.168.180.132:2888:3888
> server.2=192.168.180.133:2888:3888
>
> server.3=192.168.180.134:2888:3888
> 如果电脑内存比较小，zookeeper还可以设置成伪集群。也就是全部服务器采用同一个ip，但是使用不同的端口。

* 5.在tmp目录创建目录。

> *mkdir /tmp/zookeeper*
>
> mkdir /tmp/zookeeper/data
>
> mkdir /tmp/zookeeper/log*

* 6.如果是配置集群，还需要在前面配置过的dataDir路径下新增myid文件

> cd /tmp/zookeeper/data
>
> touch myid
>
> vim myid

> 在data目录下创建文件，文件名为“myid”, 编辑该“myid”文件，并在对应的IP的机器上输入对应的编号。
> 如在192.168.180.132上，“myid”文件内容就是1。在192.168.180.133上，内容就是2。

### 配置环境变量

> export ZOOKEEPER_INSTALL=/usr/local/zookeeper-3.4.13/
> export PATH=$PATH:$ZOOKEEPER_INSTALL/bin

* 记住更新环境变量

### 启动zookeeper

> 1.进入bin目录，并启动zookeep。如果不是在bin目录下执行，启动zookeeper时会报错：
>
>  bash: ./zkServer.sh: No such file or directory

* 注意： ./zkServer.sh start前面的 . 不可忽略。

> 查看状态
>
> zkServer.sh status

## Hadoop初始化操作

先启动**journaldata**服务（每个节点上都要操作）

先启动zookeeper的bin目录启动**zookeeper**

进入**Hadoop**的**sbin**目录下（每个节点都要进入）

> hadoop-daemon.sh start journalnode（三台都要）  

* master节点格式化namenode（仅用一次)

* 先进入到hadoop目录下的**bin**目录

> hdfs namenode -format

* master节点 格式zkfc

> bin/hdfs zkfc dformatZK
> bin/hdfs zkfc -formatZK（注意一定要手打命令，不然可能会报错）  

* 启动master节点namenode

> bin/hdfs namenode

启动后切换到slave01节点，等slave02节点同步后，就用ctrl+c组合键强制停止（同步命令看下一步骤）
slave01节点同步master节点元数据信息

> bin/hdfs namenode -bootstrapStandby  

* 关闭journaldata服务，每个节点都要操作  

> sbin/hadoop-daemon.sh stop(三个节点都要操作)

* 一键启动HDFS

> sbin/start-dfs.sh

> Zookeeper、Hadoop 配置完毕后，在master节点启动Hadoop，并查看服务进程状态
> 使用jps命令查看进程  

# 安装MYSQL

* 先将安装包传输上去
* 1.先卸载mysql-libs(如果之前安装过MYSQL，要全都卸载掉)

> rpm -qa  |  grep -i -E mysql\|mariadb | xargs -n1 sudo rpm -e --nodeps

* 安装依赖

> rpm -ivh 01_mysql-community-common-5.7.16-1.el7.x86_64.rpm 

> rpm -ivh 02_mysql-community-libs-5.7.16-1.el7.x86_64.rpm 

> rpm -ivh 03_mysql-community-libs-compat-5.7.16-1.el7.x86_64.rpm

> rpm -ivh 04_mysql-community-client-5.7.16-1.el7.x86_64.rpm 

> sudo rpm -ivh 05_mysql-community-server-5.7.16-1.el7.x86_64.rpm 

**注意:如果报如下错误，这是由于yum安装了旧版本的GPG keys所造成，从rpm版本4.1后，在安装或升级软件包时会自动检查软件包的签名。**

#### 解决办法

> sudo rpm -ivh 05_mysql-community-server-5.7.16-1.el7.x86_64.rpm --force --nodeps

* 启动MYSQL

> systemctl start mysqld

* 查看状态

> service mysql status

* 自启动

> chkconfig --list mysql

* 停止

> service mysql stop

* 重启

> service mysql **restart**

* 成功启动mysql
* 获取临时登录密码

> grep 'temporary password' /var/log/mysqld.log（红线是临时密码）

* 启动MYSQL

> mysql -u root -p
>
> 回车输入临时登录密码

* 成功启动mysql
* 首先进入到MSQL里面，进行修改密码

> set global validate_password_policy=0;（修改密码强度为0，即可以不用密码就进入）

> set global validate_password_length=1;（修改密码长度为1，就是指密码最少为一位数）

> create 'root'@'% identified by `root123`; （我这里修改的密码为root123，为了和之前的hive-site.xml文件配置的密码一样）

* 如果有以下提示

> ERROR 1820 (HY000): You must reset your password using ALTER USER statement before executing this statement.

* 这是因为我们用初始密码登录，需要修改密码后才能操作

* 根据提示，我们可以使用ALTER USER命令来修改当前用户的密码

> ALTER USER root@localhost identified by '你的新密码';
>
> flush privileges;（更新配置，并立即生效）

# 安装hive

* 下载所需版本的hive
* 下载后进行解压

> tar -zxvf hive-1.1.0-cdh5.15.2.tar.gz

* 配置环境变量

  > vim /etc/profile

* 添加环境变量

> export HIVE_HOME=/home/hive
>
> export PATH=$HIVE_HOME/bin:$PATH

使得配置的环境变量立即生效：

> source /etc/profile

### 修改配置

**1. hive-env.sh**

  进入安装目录下的 `conf/` 目录，拷贝 Hive 的环境配置模板 `flume-env.sh.template`

```shell
cp hive-env.sh.template hive-env.shCopy to clipboardErrorCopied
```

  修改 `hive-env.sh`，指定 Hadoop 的安装路径：

```shell
export HADOOP_HOME=/usr/app/hadoop-2.6.0-cdh5.15.2
export HIVE_CONF_DIR=/opt/module/hive/confCopy to clipboardErrorCopied
```

**2. hive-site.xml**

  新建 `hive-site.xml` 文件，内容如下，主要是配置存放元数据的 `MySQL` 的地址、驱动、用户名和密码等信息：

  **前提是已经安装好Mysql**

```xml
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<configuration>
  <property>
    <name>javax.jdo.option.ConnectionURL</name>
    <value>jdbc:mysql://master:3306/hadoop_hive?createDatabaseIfNotExist=true</value>
  </property>

  <property>
    <name>javax.jdo.option.ConnectionDriverName</name>
    <value>com.mysql.jdbc.Driver</value>
  </property>

  <property>
    <name>javax.jdo.option.ConnectionUserName</name>
    <value>root</value>
  </property>

  <property>
    <name>javax.jdo.option.ConnectionPassword</name>
    <value>123455</value>
  </property>

</configuration>
```

### [（4）拷贝数据库驱动](http://martinhub.gitee.io/martinhub-notes/#/./notes/01-大数据相关技术栈/04-Hive/README?id=（4）拷贝数据库驱动)

* 将 MySQL 驱动包拷贝到 Hive 安装目录的 `lib` 目录下, MySQL 驱动的下载地址为：https://dev.mysql.com/downloads/connector/j/

### [（5）初始化元数据库](http://martinhub.gitee.io/martinhub-notes/#/./notes/01-大数据相关技术栈/04-Hive/README?id=（5）初始化元数据库)

- 当使用的 hive 是 1.x 版本时，可以不进行初始化操作，Hive 会在第一次启动的时候会自动进行初始化，但不会生成所有的元数据信息表，只会初始化必要的一部分，在之后的使用中用到其余表时会自动创建；

- 当使用的 hive 是 2.x 版本时，必须手动初始化元数据库。初始化命令：

  ```shell
  # schematool 命令在安装目录的 bin 目录下，由于上面已经配置过环境变量，在任意位置执行即可
  schematool -dbType mysql -initSchema
   (要是报错 显示未到命令)
  进到hive bin目录
  ./schematool -initSchema -dbType mysql
  ```

### [（6）启动](http://martinhub.gitee.io/martinhub-notes/#/./notes/01-大数据相关技术栈/04-Hive/README?id=（6）启动)

  由于已经将 Hive 的 bin 目录配置到环境变量，直接使用以下命令启动，成功进入交互式命令行后执行 `show databases` 命令，无异常则代表搭建成功。

> hive

> 在 Mysql 中也能看到 Hive 创建的库和存放元数据信息的表

# hive启动失败

hive卡在启动界面，true一直后没有信息或者报错，同时hadoop的web端无法访问。
原因：在配置hdfs高可用时，发现所有的namenode都是standby状态，需要手动启动一次namenode : hdfs haadmin -transitionToActive nn1 --forcemanual
之后再配置自动故障转移机制，就会随机启动一个namenode。
最后，hadoop的web端就可以正常访问，hive也可以正常启动了。
