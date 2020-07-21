#!/usr/bin/env bash
set -x
cd $HOME/ipx
cp ./ipx.conf ./ipx.conf.gen
chmod 0644 ./ipx.conf.gen
echo "creating new configuration in ipx.conf.gen"
NEWADDRESS=`hexdump -n 1 -e '1/1 "%08X" 1 "\n"' /dev/random`
sed -i "s/IPX_ADDRESS=0x00000000/IPX_ADDRESS=0x$NEWADDRESS/g" ./ipx.conf.gen
NEWADDRESS=`hexdump -n 1 -e '1/1 "%08X" 1 "\n"' /dev/random`
sed -i "s/IPX_NET_ADDRESS=0x00000000/IPX_NET_ADDRESS=0x$NEWADDRESS/g" ./ipx.conf.gen
exit $?
