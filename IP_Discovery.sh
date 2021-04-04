#!/usr/bin/env bash
#
#-------------------------------------------------------
#
# autor: Luciano Brito
# author: Luciano Brito
#
#-------------------------------------------------------
#
# Creation
#
# Data: 03/04/2021 as 22:00
# Date: 04/03/2021 at 10:00 pm
#
#-------------------------------------------------------
#
# Contacts
#
# e-mail: lucianobrito.dev@gmail.com
# github: github.com/lucianobritodev
#
#-------------------------------------------------------
#
# Version
#
# version: 1.0.0
#
#-------------------------------------------------------
#
# To run the script run one of the following commands:
#
# ./IP_Discovery.sh
#
# or
#
# bash IP_Discovery.sh
#-------------------------------------------------------

#PID=$$
controll=true
answer='n'

function Question () {
    clear
    echo -e "\e[1mIP Discovery\e[m\n\nDo you want to scan your network right now?"
    read -rp "[Y/N]: " answer
    answer=$(echo "${answer}" | tr '[:upper:]' '[:lower:]')
    if [ "$answer" != 'y' ]; then
        answer='n'
    fi
}


function Scanning () {
    clear
    echo -e "\e[1mScanning ... \e[m"
    nmap -sn 10.0.0.*/24 \
    192.168.0.*/24 \
    192.168.1.*/24 \
    192.168.15.*/24 \
    192.168.25.*/24 \
    192.168.88.*/24 \
    192.168.100.*/24 |\
    awk '{print $5, $6}' |\
    sed 's/http.*//;s/latency.*//;s/address.*//;/^$/d;s/[()]//g;s/ $//;s/.* //' > /tmp/discovery.$$
    
    echo -e "IP's found:\n\nIP           :   Host\n" > /tmp/ip_discovery.txt
    
    while read -r ip_discovery; do
        if [ "${ip_discovery}" == '' ]; then
            continue
        else
            if [ "$(nmap -sL "${ip_discovery}" | grep "${ip_discovery}" | awk '{print $5}')" == "${ip_discovery}" ]; then
                echo "${ip_discovery} :   undefined!" >> /tmp/ip_discovery.txt
                continue
            fi
            echo "${ip_discovery} :   $(nmap -sL "${ip_discovery}" | grep "${ip_discovery}" | awk '{print $5}')" >> /tmp/ip_discovery.txt
        fi
    done < /tmp/discovery.$$
    
    echo -e "\n\nPress the 'Q' key to exit!\n" >> /tmp/ip_discovery.txt
    
    rm -Rf /tmp/discovery.$$
    
    clear
    less < /tmp/ip_discovery.txt

}

while [ "$controll" = true ] ; do
    Question
    if [ "$answer" == 'y'  ]; then
        Scanning
    else
        controll=false
        clear
        exit 0
    fi
done

exit 1
