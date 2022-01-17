#!/bin/bash
# /sbin/ip -o -4 addr list tun0 | awk '{print $4}' | cut -d/ -f1
# [ -d /proc/sys/net/ipv4/conf/tun0 ] && echo "$({ ip -4 -br a sh dev tun0 | awk {'print $3'} | cut -f1 -d/;} 2>/dev/null) "
TUN0IP=$((ifconfig tun0 | awk '/inet /{print $2}') 2>/dev/null)
# TUN0IP=$((/sbin/ip -o -4 addr list tun0 | awk '{print $4}' | cut -d/ -f1) 2>/dev/null);
if [[ ! -z "$TUN0IP" ]];
then 
    # echo "$({ ip -4 -br a sh dev tun0 | awk {'print $3'} | cut -f1 -d/; } 2>/dev/null) "
    echo " $TUN0IP "
else 
    echo " disconnected "
fi

