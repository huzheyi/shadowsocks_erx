#!/bin/bash
set -e

echo "start installation"

#copy files
cp -f ./etc/init.d/shadowsocks /etc/init.d/
cp -rf ./config/shadowsocks /config
chmod +x /etc/init.d/shadowsocks
chmod +x /config/shadowsocks/bin/*
echo "copy file ok"

#change dnsmasq config
dnscfg=/etc/dnsmasq.conf
[ 0 == `grep "^log-facility" $dnscfg|wc -l` ] && echo log-facility=/var/log/dnsmasq.log >> $dnscfg
[ 0 == `grep "^cache-size" $dnscfg|wc -l` ] && echo cache-size=1000 >> $dnscfg
[ 0 == `grep "^no-resolv" $dnscfg|wc -l` ] && echo no-resolv >> $dnscfg
[ 0 == `grep "^server" $dnscfg|wc -l` ] && echo server=$public_dns >> $dnscfg
echo "change dnsmasq config ok"

#add auto start
sed -i "s/^exit 0//" /etc/rc.local
[ 0 == `grep shadowsocks /etc/rc.local|wc -l` ] && echo /etc/init.d/shadowsocks start >> /etc/rc.local
echo exit 0 >> /etc/rc.local
echo "add auto start ok"

#start service
[ `/etc/init.d/shadowsocks status|grep "is running"|wc -l` -gt 0 ] && /etc/init.d/shadowsocks stop
/etc/init.d/shadowsocks start
