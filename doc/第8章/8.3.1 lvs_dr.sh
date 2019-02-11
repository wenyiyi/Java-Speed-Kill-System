#! /bin/bash
echo 1 > /proc/sys/net/ipv4/ip_forward
ipv=/sbin/ipvsadm
vip=192.168.220.130
rs1=192.168.220.135
rs2=192.168.220.139
case $1 in
start)
    echo "Start LVS"
    ifconfig eth0:0 $vip broadcast $vip netmask 255.255.255.255 up #添加虚拟网卡
    route add -host $vip dev eth0:0          #添加到虚拟主机的路由
    $ipv -A -t $vip:80 -s lc                 #添加虚拟服务器，-s：调度算法
    $ipv -a -t $vip:80 -r $rs1:80 -g -w 1    #添加真实服务器，-g：DR，-w：权重
    $ipv -a -t $vip:80 -r $rs2:80 -g -w 1
;;
stop)
    echo "Stop LVS"
    route del -host $vip dev eth0:0  #删除虚拟网卡
    ifconfig eth0:0 down             #删除路由
    $ipv -C                          #删除虚拟主机
;;
*)
echo "Usage:$0 {start|stop}"
exit 1
esac
