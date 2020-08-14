#!/bin/bash

bond_script_path=$(cd $(dirname $0); pwd)

function usage()
{
	echo "${bond_script_path}/bond.sh [OPTION]..."
	echo "-a                   add bond interface"
	echo "-d                   delete bond interface, must be with -n and -s"
	echo "-n <name>            The name of bond interface"
	echo "-m <mode>            The mode of bond interface, balance-rr, active-backup, balance-xor, broadcast, 802.3ad, balance-tlb, balance-alb"
	echo "-s <slave_list>      The slave interface list of bond, split by ',' like 'eth12,eth13'"
	echo "-h                   Print this message"
}

function create_bond()
{
	bond_name=$1
	bond_mode=$2

	if [ x"$bond_mode" == "x" ]; then
		ip link add $bond_name type bond
	else
		ip link add $bond_name type bond mode $bond_mode
	fi
	ip link set $bond_name up
}

function add_interface_to_bond()
{
	bond_name=$1
	slave_list=$2

	for inf in $(echo $slave_list | tr "," "\n"); do
		# before add interface to bond, the interface must be down
		ip link set $inf down
		ip link set $inf master $bond_name
		ip link set $inf up
	done
}

function delete_bond()
{
	bond_name=$1
	slave_list=$2

	for inf in $(echo $slave_list | tr "," "\n"); do
		ip link set $inf nomaster
	done

	ip link del $bond_name
}

if [ $# -lt 1 ]; then
	usage;
fi

name=""
mode=""
slave_list=""
add_bond=1
del_bond=0

while getopts "adn:m:s:h" arg; do
	case $arg in
		a)
			add_bond=1
			;;
		d)
			del_bond=1
			add_bond=0
			;;
		m)
			mode=$OPTARG
			;;
		n)
			name=$OPTARG
			;;
		s)
			slave_list=$OPTARG
			;;
		h)
			usage
			exit 0
			;;
		?)
			echo "Error: invalid argument $arg"
			exit 1
			;;
	esac
done

shift $(($OPTIND - 1))

if [ $add_bond -eq 1 ]; then
	create_bond $name $mode
	add_interface_to_bond $name $slave_list
fi

if [ $del_bond -eq 1 ]; then
	if [ x"$name" == "x" ]; then
		echo "-d must be indicate the name of bond."
		exit 1
	fi
	delete_bond $name $slave_list
fi

exit 0
