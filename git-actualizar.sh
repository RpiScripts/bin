#!/bin/bash
# /home/pi/bin/git-actualizar.sh
# release v1.0

## FUNCION ##
# Pasando como parámetro el texto para el commit actualiza el repositorio actual
# Tambien paso como parámetro la rama donde actualizar el código
# Ahora envía usuario y clave

## PENDIENTE ##
# Añadir commit y rama (branch) por defecto.

## EJEMPLO ##
# Estoy teniendo problemas al subir los archivos.
# git-update.sh "v1.2" "version2"

## INCLUDES ##
# Evita incluir dos veces los scripts de configuración.
if [[ -z $CONFIGURACION ]]; then
  printf "$CONFIGURACION";
  archivo_configuracion="$HOME/bin/pi.conf";
  [[ -f $archivo_configuracion ]] && . $archivo_configuracion
  printf "Include: $archivo_configuracion\n";
fi

CLAVES=True
if [[ -z $CLAVES ]]; then
  printf "$CLAVES";
  configuracion_oculta="$HOME/bin/.claves.incl";
  [[ -f $configuracion_oculta ]] && . $configuracion_oculta
  printf "Include: $configuracion_oculta\n";
fi

cd $GIT_REPO_LOCAL;

# No sube los archivos ocultos de configuración:
for f in $(ls);
do
  git add $f;
  printf "$f\n";
done;
# git add --all
# git add .
git commit -m "$1"
# git rm bin.config
#git push -u https://$GIT_USUARIO:$GIT_CLAVE@github.com/$GIT_REPO/bin "$2"
#git push -u https://github.com/RpiScripts/bin "$2"
git push -u https://github.com/RpiScripts/bin "$2"
