#!/bin/bash

LGREEN='\033[1;32m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# usage: sudo scan.sh IP
# sudo required for -sU UDP scans
# this will create nmap output files in the directory from where this script was invoked 

# create an alias `scan` to invoke this script 

# check if nmap output file already exists 

ext=".txt"
timestamp="_$(date "+%Y%m%d-%H.%M.%S")";
IP=$1
fast="fast_$IP$timestamp$ext"
fastsvc="fast_svc_$IP$timestamp$ext"
slow="slow_$IP$timestamp$ext"
slowsvc="slow_svc_$IP$timestamp$ext"
udptop1000="udp_top_1000_$IP$timestamp$ext"
udptop1000svc="udp_top_1000_svc_$IP$timestamp$ext"
udpall="udp_all_ports_$IP$timestamp$ext"
udpallsvc="udp_all_ports_svc_$IP$timestamp$ext"



# TCP Scans

if [ -z "$IP" ]
then
    echo "Provide an IP address to scan..."
    echo "usage: sudo scan.sh IP"
    echo "sudo required for -sU UDP scans"
    exit
else
    printf "%s\n\n${WHITE}     =-=-=-=-=-=-=-=-=-=- TCP Scan -=-=-=-=-=-=-=-=-=-=${NC}\n\n"
    printf "%s\n${LGREEN}Initiating Fast Nmap All TCP Ports Scan... ${NC}\n\n"
    printf "${WHITE}nmap -Pn -p 0-65535 --min-rate 2000 -v -oN $fast $IP${NC}%s\n\n"

    nmap -Pn -p 0-65535 --min-rate 3000 -v -oN $fast $IP && 
        fastports=$(cat $fast | grep '^[0-9]' | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//);
        # fastports=$(cat $fast | grep '^[0-9]' | cut -d '/' -f 1 | tr '\n' ' ' | sed s/,$//);

    printf "%s\n${LGREEN}Fast Scan => Open Ports: $fastports ${NC}"
    printf "%s\n\n${LGREEN}Fast Scan => Initiating Service Detection & Scripts Scan... ${NC}\n\n"

    printf "${WHITE}nmap -Pn -A -p $fastports -v -oN $fastsvc $IP${NC}%s\n\n"

    nmap -Pn -A -p $fastports -v -oN $fastsvc $IP

    printf "%s\n${LGREEN}Initiating Slow Nmap All TCP Ports Scan... ${NC}\n\n"
    printf "${WHITE}nmap -Pn -p 0-65535 -v -oN $slow $IP${NC}%s\n\n"

    nmap -Pn -p- -v -oN $slow $IP && 
        slowports=$(cat $slow | grep '^[0-9]' | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//);

    printf "%s\n${LGREEN}Fast Scan => Open Ports: $fastports ${NC}"
    printf "%s\n${LGREEN}Slow Scan => Open Ports: $slowports ${NC}"

    if [[ "$fastports" != "$slowports" ]]
    then
        printf "%s\n\n${LGREEN}Slow Scan => Initiating Service Detection & Scripts Scan... ${NC}\n\n"
        printf "${WHITE}nmap -Pn -A -p $slowports -v -oN $slowsvc $IP${NC}%s\n\n"
        nmap -Pn -A -p $slowports -v -oN $slowsvc $IP

    elif [[ "$fastports" == "$slowports" ]]
    then
        # printf "%s\n${LGREEN}Fast Scan => Open Ports: $fastports ${NC}"
        # printf "%s\n${LGREEN}Slow Scan => Open Ports: $slowports ${NC}"
        printf "%s\n\n${LGREEN}No new ports found in Slow Nmap Scan... ${NC}\n"
    fi

    # UDP Scans 

    printf "%s\n\n${WHITE}     =-=-=-=-=-=-=-=-=-=- UDP Scan -=-=-=-=-=-=-=-=-=-=${NC}\n\n"

    printf "%s\n${LGREEN}Initiating Nmap UDP Top 1000 Ports Scan... ${NC}\n\n"
    printf "${WHITE}sudo nmap -Pn -sU -vv --open --reason --top-ports 1000 -oN $udptop1000 $IP${NC}%s\n\n"
    sudo nmap -Pn -sU -vv --open --reason --top-ports 1000 -oN $udptop1000 $IP && 
        udp1000openports=$(cat $udptop1000 | grep '^[0-9]' | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//);


    if [ -z "$udp1000openports" ]
    then
        printf "%s\n${LGREEN}UDP Top 1000 Ports Scan => No Open UDP Ports Found...${NC}\n"
    else
        printf "%s\n${LGREEN}UDP Top 1000 Ports Scan => Open Ports: $udp1000openports ${NC}\n\n"
        printf "%s${LGREEN}Initiating Service Detection and Scripts Scan on Open UDP Ports...${NC}\n\n"
        printf "%s${WHITE}sudo nmap -Pn -sU -A -p $udp1000openports -oN $udptop1000svc $IP\n\n"
        sudo nmap -Pn -sU -A -p $udp1000openports -v -oN $udptop1000svc $IP

    fi    

    printf "%s\n${LGREEN}Initiating Fast Nmap All UDP Ports Scan...${NC}%s\n\n"

    printf "${WHITE}sudo nmap -Pn -sU -p 0-65535 --min-rate 2000 -vv --open --reason -oN $udpall $IP${NC}%s\n\n"
    sudo nmap -Pn -sU -p 0-65535 --min-rate 2000 -vv --open --reason -oN $udpall $IP && 
        udpallopenports=$(cat $udpall | grep '^[0-9]' | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//);

    if [ -z "$udpallopenports" ]
    then
        printf "%s\n${LGREEN}UDP All Ports Scan => No Open UDP Ports Found...${NC}\n"
    else
        printf "%s\n${LGREEN}UDP All Ports Scan => Open Ports: $udpallopenports ${NC}\n\n"
        printf "%s\n${LGREEN}Initiating Service Detection and Scripts Scan on Open UDP Ports... ${NC}\n\n"
        printf "%s\n${WHITE}sudo nmap -Pn -sU -A -p $udpallopenports -v -oN $udpallsvc $IP\n\n"
        sudo nmap -Pn -sU -A -p $udpallopenports -v -oN $udpallsvc $IP
    fi
fi
