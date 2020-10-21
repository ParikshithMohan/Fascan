#!/bin/bash
url=$1
RD='\033[0;31m' # Red
GR='\033[1;32m' # Green
PR='\033[1;36m' # Purple
NC='\033[0m' # No Color
if [ ! -d "$url" ];then
    mkdir $url
fi
if [ ! -f "$url/Report.txt" ];then
    touch $url/Report.txt
fi
printf "\n[+] ${PR}Initial ports:${NC}\n\n"
rustscan -r 0-10000 $url --ulimit 6000 |grep Open
printf "\n[+] ${PR}Basic NMAP scan:${NC}\n\n"
nmap -p- --min-rate 10000 $url |grep open
printf "\n[+] ${PR}Checking all 65535 ports with Rustscan${NC}\n"
rustscan -q $url --ulimit 6000  > $url/rust.txt
rustports=`cat $url/rust.txt`
printf "\n[+] ${PR}Scanning all ports with NMAP${NC}\n\n"
printf "PORTS:\n\n" >> $url/Report.txt
nmap -p $rustports -sC -sV $url >> $url/port.txt
cat $url/port.txt | grep open
cat $url/port.txt >> $url/Report.txt
printf "\n[+] ${RD}DONE${NC} > Check Report.txt in the folder: ${GR}$url${NC}\n\n"
printf "\n*************************************************************************************\n" >> $url/Report.txt
rm $url/rust.txt $url/port.txt
