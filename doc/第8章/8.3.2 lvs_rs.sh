#!/bin/bash
vip=192.168.220.130
case $1 in
start)
    echo "Start LVS"
    ifconfig eth0:0 $vip broadcast $vip netmask 255.255.255.255 up
    route add -host $vip dev eth0:0
    echo "1" > /proc/sys/net/ipv4/conf/lo/arp_ignore
    echo "2" > /proc/sys/net/ipv4/conf/lo/arp_announce
    echo "1" > /proc/sys/net/ipv4/conf/all/arp_ignore
    echo "2" > /proc/sys/net/ipv4/conf/all/arp_announce
    sysctl -p > /dev/null 2>&1
;;
stop)
    echo "Stop LVS"
    route del -host $vip dev eth0:0
    /sbin/ifconfig eth0:0 down
    echo "0" > /proc/sys/net/ipv4/conf/lo/arp_ignore
    echo "0" > /proc/sys/net/ipv4/conf/lo/arp_announce
    echo "0" > /proc/sys/net/ipv4/conf/all/arp_ignore
    echo "0" > /proc/sys/net/ipv4/conf/all/arp_announce
    sysctl -p > /dev/null 2>&1
;;
*)
echo "Usage:$0 {start|stop}"
exit 1
esac
