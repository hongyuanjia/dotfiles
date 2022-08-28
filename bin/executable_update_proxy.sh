#!/bin/bash

HOSTIP=$(cat /etc/resolv.conf | grep -oP '(?<=nameserver\ ).*')
# default to modify the yum repo file
FILE="/etc/yum.repos.d/whitewaterfoundry_fedoraremix.repo"
REMOVE=0

help()
{
    echo "Usage: $0 [-u] [-f <string>] [-h]" 1>&2
    exit 2
}

while getopts ":uf:h" o; do
    case "${o}" in
        u)
            REMOVE=1
            ;;
        f)
            FILE=${OPTARG}
            ;;
        h)
            help;;
        *)
            help;;
    esac
done
shift $((OPTIND-1))

if [ ! -f "$FILE" ]; then
    echo "Input file '$FILE' does not exist."
    exit 1
else
    echo "Operating on file '$FILE'..."
fi

grep -q "proxy" $FILE
HASPROXY=$?

if [ $REMOVE -eq 0 ]; then
    if [ $HASPROXY -eq 0 ]; then
        echo "Updating proxy..."
        sed -i "s/^proxy.*/proxy=$HOSTIP:7890/" $FILE
    else
        echo "Adding proxy..."
        sed -i "s/^$/proxy=$HOSTIP:7890\n/" $FILE

        # last line
        echo "proxy=$HOSTIP:7890" >> $FILE
    fi
else
    if [ $HASPROXY -eq 0 ]; then
        echo "Removing proxy..."
        sed -i "/^proxy/d" $FILE
    else
        echo "No proxy entries found. Skip."
    fi
fi

echo "Operation completed."
exit 0
