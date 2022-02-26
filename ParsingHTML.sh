#!/bin/bash

L=1

if [ "$1" == "" ]
then
    echo "Modo de usar:"
    echo "$0 [URL]"
    echo
    echo "Exemplo: $0 google.com"
else
    wget -q $1
    
    cat index.html 2>/dev/null | grep "<a" | grep "//" | cut -d "/" -f 3 | cut -d '"' -f1 | uniq > hosts.txt
    
    echo "================================================================"
    echo
    echo -e "\t\tResolvendo URLs em: $1"
    echo
    echo "================================================================"
    echo -e "\tLine\t\t\tIP\t\t\tAddress"
    echo "================================================================"
    
    for i in $( cat hosts.txt )
    do
        RESOLVEHOSTS=$( host $1 | grep "has address" )
        if [ ! "$RESOLVEHOSTS" == "" ]
        then
            echo -e "\t$L\t\t$( echo $RESOLVEHOSTS | cut -d " " -f4 )\t\t$i"
            L=$( expr $L + 1 )
        fi
    done
    
    echo "================================================================"
fi

rm index.html hosts.txt 2>/dev/null
