#!/bin/bash

# Solicitar la entrada del usuario para el path de instalación
read -p "Ingrese el path de instalación para el contenedor Docker: " path

# Solicitar la entrada del usuario para el nombre del contenedor
read -p "Ingrese un nombre para el contenedor Docker: " nombre

# Contenedor Docker
docker run -d \
  --name $nombre \
  -v $path:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=root \
  mysql:latest
