#!/bin/bash
 
case $1 in 
"start"){  
   for i in 192.168.44.140 192.168.44.150 192.168.44.160
   do 
       echo ---------- zookeeper $i 启动 ------------ 
       ssh $i  "/home/zookeeper/bin/zkServer.sh start"
   done 
};; 
"stop"){ 
  for i in 192.168.44.140 192.168.44.150 192.168.44.160
  do 
       echo ---------- zookeeper $i 停止 ------------     
       ssh $i  "/home/zookeeper/bin/zkServer.sh  stop" 
   done 
};; 
"status"){ 
   for i in 192.168.44.140 192.168.44.150 192.168.44.160
   do 
       echo ---------- zookeeper $i 状态 ------------     
       ssh $i "/home/zookeeper/bin/zkServer.sh status" 
   done 
};; 
esac 