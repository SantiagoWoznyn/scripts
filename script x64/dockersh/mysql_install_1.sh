#!/bin/bash

# Pedir la ruta de instalación
read -p "Ingrese el path de instalación para el contenedor Docker: " DOCKER_PATH

# Pedir el nombre del contenedor
read -p "Ingrese un nombre para el contenedor Docker: " CONTAINER_NAME

# Pedir la contraseña del usuario 'sa'
read -sp "Ingrese la contraseña para el usuario 'sa': " SA_PASSWORD
echo

# Crear el contenedor Docker de SQL Server
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=$SA_PASSWORD" -p 1433:1433 --name $CONTAINER_NAME --hostname $CONTAINER_NAME -d mcr.microsoft.com/mssql/server:2022-latest
