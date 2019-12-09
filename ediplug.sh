#!/bin/bash
# ~/bin/ediplug
# Creado 01 Dic. 2018
# v1.3

# v1.4
#Modificado 06 Dic. 2019
# Modificada ruta a archivo de configuración con ruta absoluta porque no funcionaba si se llamaba desde fuera de /home/pi/bin

# v1.5
# Modificado 07 Dic. 2019
# Nuevo archivo de configuración y rutas
# Impresión en pantalla con fecha y hora "$TEXTO"

## PENDIENTE
# Si enciendo manualmente el enchufe ya no coincide el registro del estado en el log con el estado real, pero el comando ediplug.sh si muestra correctamente el estado del enchufe, por lo que se puede corregir el registro si se desea ejecutando el programa de vez en cuando.


## PARÁMETROS ##
# $1 = ON/OFF


## VARIABLES Y CONSTANTES ##
TEXTO=$(date '+%d/%m/%Y %H:%M:%S')" -> Estado EDIMAX:";

## Variables definidas en:
CONFIG_="$HOME/bin/config"
_CONFIG="pi.conf"
RA_CONFIG="$CONFIG_/$_CONFIG"
#INCLUDE
#EDIPLUG_ESTADO
#EDIPLUG_IP
#EDIPLUG_USUARIO
#EDIPLUG_CLAVE


## INCLUDES ##
# Evita incluir dos veces el script de configuración.
# Sin embargo la primera vez que se ejecuta desde kodi.sh tiene que cargarlo
# La segunda vez, cuando lanza la orden 'ediplug OFF' no lo carga.
if [[ -z $INCLUDE ]]; then
  printf "$INCLUDE";
  [[ -f $RA_CONFIG ]] && . $RA_CONFIG
  printf "Configuración: $RA_CONFIG\n";
else
  printf "Include: $INCLUDE\n"
fi



## CÓDIGO ##
## -------------------------------------------------------------------------------------------------------------------
if [ $1 ]; then
  OPCION="-s $1";
  printf "$TEXTO $1\n";
  echo $1 > $EDIPLUG_ESTADO;
elif [ $accion ]; then
  OPCION="-s $accion";
  printf "$TEXTO accion=$accion\n";
  echo $accion > $EDIPLUG_ESTADO;
else
  OPCION="-g";
fi

GO=`python ~/python/ediplug-py/src/ediplug/smartplug.py -H $EDIPLUG_IP -l $EDIPLUG_USUARIO -p $EDIPLUG_CLAVE $OPCION`

# $GO solo tiene valor cuando se hace una consulta del estado '-g'
[[ ! -z $GO ]] && printf "$TEXTO $GO\n" && echo $GO > $EDIPLUG_ESTADO
