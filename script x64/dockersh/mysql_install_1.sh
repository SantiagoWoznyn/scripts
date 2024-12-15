#!/bin/bash

# Solicitar el directorio para el volumen SQL Server
read -p "Ingrese el directorio donde desea almacenar los datos del servidor SQL (por ejemplo, /opt/sql-server-data): " sql_dir
mkdir -p "$sql_dir"

# Solicitar un nombre de usuario y contraseña para el servidor SQL
read -p "Ingrese el nombre de usuario para el servidor SQL: " sql_user
read -sp "Ingrese la contraseña para el servidor SQL: " sql_password
echo

# Crear el archivo docker-compose.yml
cat <<EOL > docker-compose.yml
version: '3.9'

networks:
  app-network-public:
    driver: bridge

volumes:
  sql-server-data:
    driver: local
  sqldata:
  sqllog:
  sqlbackup:

services:
  db:
    image: mcr.microsoft.com/mssql/server:2019-CU3-ubuntu-18.04
    container_name: db-sqlserver
    networks:
      - app-network-public
    restart: always
    environment:
      SA_PASSWORD: "$sql_password"
      ACCEPT_EULA: "Y"
    env_file:
      - sqlserver.env
      - sapassword.env
    ports:
      - '1433:1433'
    volumes:
      - sql-server-data:/var/opt/mssql/
      - sqldata:/var/opt/sqlserver/data
      - sqllog:/var/opt/sqlserver/log
      - sqlbackup:/var/opt/sqlserver/backup
      - /c/docker/shared:/usr/shared
EOL

# Levantar los servicios con Docker Compose
docker-compose up -d
