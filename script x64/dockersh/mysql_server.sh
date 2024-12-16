#!/bin/bash

# Solicitar el directorio para almacenar los datos del contenedor
read -p "Ingrese la ruta donde desea almacenar los datos del contenedor (por ejemplo, /opt/mis_datos): " data_dir
mkdir -p "$data_dir"

# Crear archivos .env para las variables de entorno necesarias
cat <<EOL > sqlserver.env
MYSQL_ROOT_PASSWORD=tu_contraseña
MYSQL_DATABASE=mi_base_datos
MYSQL_USER=usuario_mysql
MYSQL_PASSWORD=contraseña_mysql
EOL

# Crear el archivo docker-compose.yml
cat <<EOL > docker-compose.yml
version: '3.9'

networks:
  app-network-public:
    driver: bridge

volumes:
  mysql-data:
    driver: local

services:
  mysql:
    image: mysql:latest
    container_name: mysql-server
    networks:
      - app-network-public
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: "tu_contraseña"
      MYSQL_DATABASE: "mi_base_datos"
      MYSQL_USER: "usuario_mysql"
      MYSQL_PASSWORD: "contraseña_mysql"
    ports:
      - '3306:3306'
    volumes:
      - ${data_dir}:/var/lib/mysql
EOL

# Levantar los servicios con Docker Compose
docker-compose up -d
