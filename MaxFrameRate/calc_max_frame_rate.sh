#!/bin/bash

nic_type=$1
pkt_len=$2

let M=1000*1000
let G=1000*1000*1000

nic_type_last_char=${nic_type:0-1}
nic_type_prefix_speed=${nic_type:0:-1}

nic_speed=$nic_type_prefix_speed
if [ x"$nic_type_last_char" == x"M" ]; then
	let nic_speed*=M
elif [ x"$nic_type_last_char" == x"G" ]; then
	let nic_speed*=G
fi

# Inter-Packet Gap
frame_gap=12
preamble=7
# Start frame Delimiter
sfd=1

let BPS=nic_speed/8
let all_need=frame_gap+preamble+sfd+pkt_len

speed=$(echo "scale=2;$BPS/$all_need" | bc)
speed=$(echo "scale=2; $speed/1000000" | bc)

echo "max frame rate=${speed}Mpps"
