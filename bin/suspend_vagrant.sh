#!/bin/bash

PATH=/sbin:/usr/sbin:/bin:/usr/bin
IFS="
"
echo "suspend vm" > /tmp/suspend.log
case $1 in
    suspend)

        for vm in $( vboxmanage list runningvms )
        do
            vm_id=$( echo $vm | cut -d " " -f1 | sed s%\"%%g )
            vboxmanage controlvm $vm_id pause
        done
        ;;
esac
