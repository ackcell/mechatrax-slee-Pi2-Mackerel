#!/bin/bash
SECONDS=`date '+%s'`

NAME='raspberry.cpu_temp'
TEMP=`cat /sys/class/thermal/thermal_zone0/temp`
VALUE=`echo "scale=3; ${TEMP} / 1000" | bc`
echo -e "${NAME}\t${VALUE}\t${SECONDS}"
# wifi
which iwconfig >/dev/null
if [ $? = 0 ]; then
  NAME='raspberry.WiFi_LinkQuality'
  LQ=`iwconfig wlan0|grep "Link Quality"|sed "s/Link Quality=//"|sed "s/Signal level=//"|awk '{print $1}'|awk -F'[/]' '{print $1}'`
  echo -e "${NAME}\t${LQ}\t${SECONDS}"

  NAME='raspberry.WiFi_SignalLevel'
  SL=`iwconfig wlan0|grep "Link Quality"|sed "s/Link Quality=//"|sed "s/Signal level=//"|awk '{print $2}'`
  echo -e "${NAME}\t${SL}\t${SECONDS}"
fi
# 4GPi
which mmcli >/dev/null
if [ $? = 0 ]; then
  INDEX=`mmcli -L|grep SIM7600|awk -F'[/]' '{print $6}'|awk '{print $1}'` # modem index
# genarate custom metrics 4GPi
  OUTPUT=`mmcli -m ${INDEX} --signal-get`
# rssi,rsrq,rsrp,s/n
  NAME='4GPi.rssi'
  RSSI=`mmcli -m ${INDEX} --signal-get|grep rssi|awk -F'[:]' '{print $2}'|awk '{print $1}'`
  echo -e "${NAME}\t${RSSI}\t${SECONDS}"

  NAME='4GPi.rsrq'
  RSRQ=`mmcli -m ${INDEX} --signal-get|grep rsrq|awk -F'[:]' '{print $2}'|awk '{print $1}'`
  echo -e "${NAME}\t${RSRQ}\t${SECONDS}"

  NAME='4GPi.rsrp'
  RSRP=`mmcli -m ${INDEX} --signal-get|grep rsrp|awk -F'[:]' '{print $2}'|awk '{print $1}'`
  echo -e "${NAME}\t${RSRP}\t${SECONDS}"

  NAME='4GPi.sn'
  SN=`mmcli -m ${INDEX} --signal-get|grep "s/n"|awk -F'[:]' '{print $2}'|awk '{print $1}'`
  echo -e "${NAME}\t${SN}\t${SECONDS}"

  mmcli -m ${INDEX} --signal-setup=10>/dev/null

fi

# sleePi2
which sleepi2ctl >/dev/null
if [ $? = 0 ]; then
  # genarate custom metrics sleePi2
  # voltage
  NAME='sleepi.voltage'
  VOLT=`sleepi2ctl -g voltage`
  VALUE=`echo "scale=3; ${VOLT} / 1000" | bc`
  echo -e "${NAME}\t${VALUE}\t${SECONDS}"
fi

# tweak
NAME="mechatrax.tweak"
# WiFi_SignalLevel -30   SL
# rssi -76 RSSI
# rsrq -11 RSRQ
# rsrp -105 RSRP
# n+150 ?

ADJUST="+150"
if [ -z "$SL" ]; then
  # 空
  :
else
  NAME="mechatrax.tweak.WiFi_SignalLevel"
  VALUE=`echo "scale=3;${SL} ${ADJUST}" |bc`
  echo -e "${NAME}\t${VALUE}\t${SECONDS}"
fi

if [ -z "$RSSI" ]; then
  # 空
  :
else
  NAME="mechatrax.tweak.RSSI"
  VALUE=`echo "scale=3;${RSSI} ${ADJUST}" |bc`
  echo -e "${NAME}\t${VALUE}\t${SECONDS}"
fi

if [ -z "$RSRQ" ]; then
  # 空
  :
else
  NAME="mechatrax.tweak.RSRQ"
  VALUE=`echo "scale=3;${RSRQ} ${ADJUST}" |bc`
  echo -e "${NAME}\t${VALUE}\t${SECONDS}"
fi

if [ -z "$RSRP" ]; then
  # 空
  :
else
  NAME="mechatrax.tweak.RSRP"
  VALUE=`echo "scale=3;${RSRP} ${ADJUST}" |bc`
  echo -e "${NAME}\t${VALUE}\t${SECONDS}"
fi
