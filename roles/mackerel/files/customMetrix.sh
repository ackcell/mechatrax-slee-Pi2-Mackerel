#!/bin/bash
#TODO:実機の環境依存に対応
SECONDS=`date '+%s'`

NAME='mechatrax.cpu_temp'
TEMP=`cat /sys/class/thermal/thermal_zone0/temp`
VALUE=`echo "scale=3; ${TEMP} / 1000" | bc`
echo -e "${NAME}\t${VALUE}\t${SECONDS}"

NAME='mechatrax.voltage'
VOLT=`sleepi2ctl -g voltage`
VALUE=`echo "scale=3; ${VOLT} / 1000" | bc`
echo -e "${NAME}\t${VALUE}\t${SECONDS}"
