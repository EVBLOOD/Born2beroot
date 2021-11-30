#!/bin/sh
Architecture=$(uname -a)
physicalCPU=$(cat /proc/cpuinfo | grep -c "physical id")
virtualCPU=$(cat /proc/cpuinfo | grep -c processor)
freeMem=$(free -m | awk '$1 == "Mem:" {print $2}')
usedMem=$(free -m | awk '$1 == "Mem:" {print $3}')
UsageMem=$(free -m | awk '$1 == "Mem:" {printf("(%.2f%%)\n", ($2 / $3))}')
diskusage=$(df --total -H | grep total | sed 's/G//'| sed 's/G//' | awk '$1 == "total" {print $3 "/" $2"Gb " "("$5")"}')
cpuload=$(top -bn1 | grep %Cpu | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
lastboot=$(who -b | awk '$1 == "system" {print $3 " " $4}')
checkforLVM=$(cat /etc/fstab | grep -c /dev/mapper/LVMGroup-root)
LVMuse=$(if [ $checkforLVM = '1' ]; then echo "yes"; else echo "no"; fi)
TCP=$(ss -s | grep TCP  | awk 'NR==1 {print $4 " ESTABLISHED"}' | sed 's/,//')
loguser=$(who | wc -l)
mac=$(ip link | grep "link/ether" | awk '$1 == "link/ether" {print $2}')
network=$(printf "%s" "IP $(hostname -I)($mac)")
nbsudo=$(echo "$(journalctl _COMM=sudo -q| grep -c COMMAND) cmd")
b="Mb"
wall "
#Architecture: $Architecture
#CPU physical : $physicalCPU
#vCPU : $virtualCPU
#Memory Usage: $usedMem/$freeMem$b $UsageMem
#Disk Usage: $diskusage
#CPU load: $cpuload
#Last boot: $lastboot
#LVM use: $LVMuse
#Connexions TCP : $TCP
#User log: $loguser
#Network: $network
#Sudo : $nbsudo"
