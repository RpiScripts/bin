#!/bin/bash
# ~/bin/temperatura.sh
# CREADO: 10/12/2019
# Controla la temperatura del procesador de una Raspberry

# v1.0

## USO ##
MIN=50
INFO="La aplicación precisa de 1 o 2 parámetros.
  El primero, determina la temperatura límite de trabajo de la CPU. Una vez superada apaga automáticamente la raspberry. Debe ser superior a $MIN.
  El segundo parámetro determina a partir de que temperatura se muestra en pantalla la temperatura del procesador.
  Se puede crear un registro de temperaturas ejecutando el programa en el cron y direccionando la salida del programa a un archivo.

Ejemplo:
  */3 * * * * /home/pi/bin/temperatura.sh 75 45 >> /home/pi/logs/temp.log 2>&1
   El progama se ejecuta cada 3 minutos.
   Todos los valores superiores a 45 se guardarán en el archivo de registro.
   Si la temperatura del cpu supera los 75º se apagará el sistema.
"

## CONTROL ARGUMENTOS ##
[[ ! "$1" =~ ^[5-9][0-9]+$ ]] && printf "$INFO" && exit 1


## VARIABLES
FECHA="$(date +'%F_%T')"
REGISTRO=`vcgencmd measure_temp`
let PUNTERO=${#REGISTRO}-6
TEMPERATURA=${REGISTRO:PUNTERO:2}

# EXCESO DE TEMPERATURA #

[[ $TEMPERATURA -gt $2 ]] && printf "$FECHA -> $REGISTRO\n"

if [[ $TEMPERATURA -gt $1 ]]; then
  archivo_alertas="/home/pi/logs/temp_alertas/$FECHA.log"
  printf "ALERTA: + INFO EN $archivo_alertas\n"
  ps aux k-pcpu | head -5 >> ${archivo_alertas}
  ps aux k-pmem | head -5 >> ${archivo_alertas}
  sudo shutdown -h
fi
