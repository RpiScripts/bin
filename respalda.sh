#!/bin/bash
# respalda.sh
# CRE: 13-03-2019
# MOD: 21/06/2019
# v2.2
# MOD: 06/12/2019
# v2.3
# Modificadas rutas a respaldos y archivo de configuración
# Añadido código para la creación de directorio local de respaldo si no existe.
# Nuevo directorio en servidor ftp con el "hostname" del equipo que manda el respaldo.

# http://wiki.gonzalezjerez.com/doku.php?id=wiki:programacion:codigo:sh:respalda

## USO
# Programa guiado de copia de seguridad del directorio desde donde se ejecuta, con respaldo en servidor ftp.
# Debe existir directorio: $HOME/respaldos

## NOTAS
# BZ2 PARA UNA MAYOR COMPRESIÓN, PERO TARDA MÁS EN CREAR EL ARCHIVO
# TGZ PARA COMPRESIÓN MÁS RÁPIDA PERO MENOR RATIO DE COMPRESIÓN

## PENDIENTE ##
#

## FUNCIONES
function sino() {
if [[ "$_continuo" = "no" ]]; then
    printf "\nCancelando operación. Saliendo del programa\n";
    exit 0;
fi
}

function f_crea_directorios_ftp() {
    local r
    local a
    r=`hostname`
    r=$r/${PWD#*/}
    while [[ "$r" != "$a" ]]; do
        a=${r%%/*}
        printf "mkdir $a\n"
        printf "cd $a\n"
        r=${r#*/}
    done
}

# Excluyo archivos ocultos, como .claves.incl
function f_comprimir() {
  if [ "$_ocultos" == "no" ]; then
    printf "\nNo se agregarán los archivos ocultos al respaldo[$_PLUS]\n"
    sleep 5
    [ "$_formato" == "2" ] && ext="bz2" && tar --exclude='*/.*' -cpvjf $_RESPALDO_AHORA.$ext .
    [ "$_formato" != "2" ] && ext="tgz" && tar --exclude='*/.*' -cpvzf $_RESPALDO_AHORA.$ext .
  else
    printf "\nSe agregarán los archivos ocultos al respaldo [$_PLUS]\n"
    sleep 5
    [ "$_formato" == "2" ] && ext="bz2" && tar -cpvjf $_RESPALDO_AHORA.$ext .
    [ "$_formato" != "2" ] && ext="tgz" && tar -cpvzf $_RESPALDO_AHORA.$ext .
  fi
}

function f_subir_ftp() {
    printf "Conectando a $FTP_SERVIDOR...\n"
    ftp -n -i $FTP_SERVIDOR <<-EOF
    user $FTP_USUARIO $FTP_CLAVE
    cd $DIR_RESPALDOS_FTP
    $(f_crea_directorios_ftp)
    put $_RESPALDO_AHORA.$ext $FECHAyHORA$_PLUS.$ext
    bye
EOF
    wait $!
}

## VARIABLES Y CONSTANTES
HORA=`date +%H%M%S`
FECHA=`date +%Y%m%d`
FECHAyHORA="$FECHA-$HORA"
# local
_RESPALDOS="$HOME/respaldos"
_RESPALDO_AHORA="$_RESPALDOS/$FECHAyHORA"
_PLUS="_FULL"
_NO="_No_Ocultos"
# ftp
DIR_RESPALDOS_FTP="respaldos"
#_RESPALDO_FTP="/$DIR_RESPALDOS_FTP/$PWD"
## -------------------------------------------------------------------------------------------
## CÓDIGO ##
clear

_CLAVES="$HOME/bin/config/.claves.incl"

. $_CLAVES

[ ! -d "$_RESPALDOS" ] && mkdir -p $_RESPALDOS && printf "Creado directorio de respaldos: $_RESPALDOS\n" || printf "Respaldos en $_RESPALDOS\n"

printf "Vas a realizar una copia de seguridad del directorio actual:\n$PWD\n[Si/no]: "
read -n 2 _continuo
sino

printf "Incluir archivos ocultos.[Si/no]: "
read -n 2 _ocultos
if [ "$_ocultos" == "no" ]; then
  _PLUS=$_NO
fi
_RESPALDO_AHORA=$_RESPALDO_AHORA$_PLUS

printf "\nElije formato de compresión:\n [1] tgz\n [2] bz2\n"
read -n 1 _formato

printf "\nCreando archivo de respaldo...\n"
f_comprimir

printf "Subir respaldo: ($_RESPALDO_AHORA.$ext)\n a servidor $FTP_SERVIDOR [Si/no]: "
read -n 2 _continuo
[[ "$_continuo" != "no" ]] && f_subir_ftp

printf "\n"
read -n 2 -p "Eliminar archivo local de repaldo [Si/no]: " _continuo

printf "\n"
if [[ "$_continuo" == "no" ]]; then
    read -p "Escribe nombre del respaldo para guardar: " _renombrar
    mv $_RESPALDO_AHORA.$ext $_RESPALDOS/$FECHA.-$_renombrar.$ext
else
    printf "Elimino archivo de respaldo local...\n"
    rm $_RESPALDO_AHORA.$ext
fi
