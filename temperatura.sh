#!/bin/bash


# VARIABLES
FECHA="$(date +'%F_%T')"
TEMPERATURA=`vcgencmd measure_temp`
let TMP=${#TEMPERATURA}-6
TEST=${TEMPERATURA:TMP:2}

LOG="$FECHA -> $TEMPERATURA"

archivo="/home/pi/logs/temp_alertas/$FECHA.log"

# EXCESO DE TEMPERATURA
if [[ $TEST -gt $1 ]]; then
  ps aux >> ${archivo}S
  [[ $TEST -gt $2 ]] && LOG="$LOG -> ALERTA: TEMPERATURA EXTREMA -> APAGANDO SISTEMA ($archivo)" && sudo shutdown -h || LOG="$LOG -> ALERTA: $archivo"
fi

# Registro desde crontab
printf "$LOG\n"
[[ ! -z $3 ]] && printf "LONGITUD: $TMP\nTEMP: $TEST\n"

