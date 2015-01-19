#!/bin/sh
 
if [ $# -ne 2 ]
then
	echo "$0 -[i|n] [ip|num]"
	exit 1
fi
 
function num2ip()
{
	num=$1
	a=$((num>>24))
	b=$((num>>16&0xff))
	c=$((num>>8&0xff))
	d=$((num&0xff))
 
#	echo "$d.$c.$b.$a"
	echo "$a.$b.$c.$d"
}
 
function ip2num()
{

   IP_ADDR=$1
   [[ $IP_ADDR =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] || { echo "ip format error."; exit 1; }
   IP_LIST=${IP_ADDR//./ };

   read -a IP_ARRAY <<<${IP_LIST};

   IPADDR=`echo $(( ${IP_ARRAY[0]}<<24 | ${IP_ARRAY[1]}<<16 | ${IP_ARRAY[2]}<<8 | ${IP_ARRAY[3]} ));`
   printf "$IPADDR "


}
 
if [ "$1" = "-i" ]
then
	ip2num $2
elif [ "$1" = "-n" ]
then
	num2ip $2
else
	echo "$0 -[i|n] [ip|num]"
	exit 1
fi
