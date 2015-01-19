#!/bin/sh

LSB=$(which lsb_release)
HNAME=$(which hostname)
UNAME=$(which uname)


function get_hostname(){
	[ -x $HNAME ] && echo "$(hostname -s)" || echo "$HNAME command is not installed, get nothing"
}

hostname=$(get_hostname) || exit 1

function get_osinfo(){
	[ -x $LSB ] && echo "$hostname : Os : $(lsb_release -ds)" || echo "$LSB command is not installed, get nothing"
}

function get_kernelinfo(){
	[ -x $UNAME ] && echo "$hostname : Kernel : $(uname -r)" || echo "$UNAME command is not installed, get nothing"
	[ -x $UNAME ] && echo "$hostname : Process : $(uname -p)" || echo "$UNAME command is not installed, get nothing"
}

function get_netinfo(){
	[ -x $HNAME ] && echo "$hostname : ipaddr : $(hostname -I)" || echo "$HNAME command is not installed, get nothing"
	#[ -r /etc/resolv.conf ] && echo $(sed -e '/^$/d' /etc/resolv.conf | awk '{if (tolower($1)=="nameserver") print $2}' | sed "s/^/$hostname : dnsserver : /g")
	[ -r /etc/resolv.conf ] && local dnsip=$(sed -e '/^$/d' /etc/resolv.conf | awk '{if (tolower($1)=="nameserver") print $2}' | sed "s/^/$hostname : dnsserver : /g") && echo ${dnsip}
	#echo "${dnsip}"
}

function get_startapplist(){
	local dapps=$(ps -ef | grep -E 'nginx|java|php' | grep -v grep)
	nginxsbin=$(echo ${dapps} | sed 's/.*master process \([0-9a-z\/]\{1,\}nginx\).*/\1/')
	tomcatdir=$(echo ${dapps} | sed 's/.*Dcatalina.home=\([0-9a-z\/]\{1,\}\).*/\1/')
	nginx_version=$($nginxsbin -v 2>&1 | awk -F: '{print $2}')
	tomcat_version=$($tomcatdir/bin/version.sh | awk '/Server version/{print $4}')
	java_version=$($tomcatdir/bin/version.sh | awk '/JVM Version/{print $3}')
	[ -n $nginx_version ] && echo "$hostname : nginx_version : $nginx_version"
	[ -n $tomcat_version ] && echo "$hostname : tomcat_version : $tomcat_version"
	[ -n $java_version ] && echo "$hostname : java_version : $java_version"
}

get_startapplist

#function get_nostartapplist(){
#	ps -ef | grep -E 'nginx|java|' 
#}

function read_input() {
	os=$(get_osinfo | awk '{print $5}')
	case $os in
		Ubuntu) get_osinfo
				get_kernelinfo
				get_netinfo
		;;
		Centos) echo nono ;;
		*)
			echo "system is not knowed"
	esac


}

read_input
