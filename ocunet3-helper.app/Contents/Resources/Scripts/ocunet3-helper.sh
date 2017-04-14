#!/bin/bash
#
# OCUNET3 helper program for MacOS X
# k-abe

PATH='/sbin:/usr/sbin:/usr/bin:/bin'
AUTHURL='https://webauth.nw.cii.osaka-cu.ac.jp:8443/'

# we need root privilege to run "ipconfig set"
if (( `id -u` != 0 )); then
    echo "usage: sudo $0" >&2
    exit 1
fi

function get_interfaces () {
    eths='';
    for i in `ifconfig -l`; do
	case "$i" in
	    en*) eths="$eths $i" ;;
	esac
    done
    echo $eths
}

# DHCP release and request
function dhcp_renew_hard () {
    iface=$1
    logger "DHCP renew hard on $iface"
    ipconfig set $iface DHCP
}

# just DHCP request only
function dhcp_renew_soft () {
    iface=$1
    logger "DHCP renew soft on $iface"
    echo "add State:/Network/Interface/$iface/RefreshConfiguration temporary" | scutil
}

function notify() {
    title=$1
    msg=$2
    osascript -e "display notification \"$msg\" with title \"$title\""
}

function set_state () {
    newstate=$1
    if [[ $newstate != $state ]]; then
	logger "state change: $newstate"
    fi
    state=$newstate
}

state=DISCONNECTED

period=10
while true; do
    # while connected to the auth VLAN, periodically renew DHCP lease
    for i in `get_interfaces`; do
	dom=`ipconfig getoption $i domain_name`
	# echo "$i: $dom"
	if [[ "$dom" == "ocunet3-unauthorized" ]]; then
	    dhcp_renew_soft $i
	fi
    done

    # check the connectivity to the Internet
    curl -s --connect-timeout 3 http://connectivitycheck.gstatic.com | grep webauth.nw.cii.osaka-cu.ac.jp > /dev/null
    status=(${PIPESTATUS[@]})
    # echo "status=$status"
    if (( ${status[0]} != 0 )); then
	logger "connectivitycheck failed: ${status[0]}"
	if [[ $state != DISCONNECTED ]]; then
	    set_state DISCONNECTED
	    notify DISCONNECTED
	fi
	if (( ${status[0]} != 6 )); then
	    # exit code 6 = resolve failure
	    # this check avoids requesting IP address while
	    # 'Captive Network Assistant.app' is running.
	    for i in `get_interfaces`; do
		dhcp_renew_hard $i
	    done
	fi
	period=2
    elif (( ${status[1]} == 0 )); then
        if [[ $state != AUTH ]]; then
	    set_state AUTH
	    notify AUTH 'Authentication Required'
#	    open -a 'google chrome' $AUTHURL
	    open $AUTHURL
	fi
	period=2
    else
	if [[ $state != CONNECTED ]]; then
	    set_state CONNECTED
	    dom=''
	    for i in `get_interfaces`; do
 		d=`ipconfig getoption $i domain_name`
		if [[ $d != '' ]]; then
		    dom="$dom $d"
		fi
	    done
	    if [[ $dom != '' ]]; then
		dom=${dom:1}
		notify CONNECTED "connected to Internet ($dom)"
	    else
		notify CONNECTED "connected to Internet"
	    fi
	fi
	period=30
    fi
    sleep $period
done 

# EOF
