#!/bin/bash

# Solicitar la entrada del usuario para el path de instalación
read -p "Ingrese el path de instalación para el contenedor Docker: " path

# Solicitar la entrada del usuario para el nombre del contenedor
read -p "Ingrese un nombre para el contenedor Docker: " nombre

# Solicitar la entrada del usuario para la contraseña de SA de MSSQL
read -p "Ingrese una contraseña para SA de MSSQL: " MSSQL_SA_PASSWORD

# Solicitar la entrada del usuario para el puerto
read -p "Ingrese el número de puerto para el contenedor Docker: " puerto

# Docker run para iniciar un contenedor de Microsoft SQL Server
docker run -e "ACCEPT_EULA=Y" \
           -e "MSSQL_SA_PASSWORD=$MSSQL_SA_PASSWORD" \
           -e "MSSQL_PID=Evaluation" \
           -p $puerto:1433 \
           --name $nombre \
           --hostname $nombre \
           -d mcr.microsoft.com/mssql/server:2022-preview-ubuntu-22.04
