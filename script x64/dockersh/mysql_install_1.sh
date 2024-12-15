#!/bin/bash

# Solicitar el directorio para los datos de MySQL
read -p "Ingrese el directorio donde desea almacenar los datos de MySQL (por ejemplo, /opt/mysql-data): " mysql_dir
sudo mkdir -p "$mysql_dir"

# Solicitar un nombre de usuario y contraseña para MySQL
read -p "Ingrese el nombre de usuario para MySQL: " mysql_user
read -sp "Ingrese la contraseña para MySQL: " mysql_password
echo

# Crear el archivo .env para las variables de entorno
cat <<EOL | sudo tee sqlserver.env
MYSQL_ROOT_PASSWORD=tu_contraseña
MYSQL_DATABASE=mi_base_datos
MYSQL_USER=$mysql_user
MYSQL_PASSWORD=$mysql_password
EOL

# Crear el archivo docker-compose.yml
cat <<EOL | sudo tee docker-compose.yml
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
      MYSQL_USER: "$mysql_user"
      MYSQL_PASSWORD: "$mysql_password"
    ports:
      - '3306:3306'
    volumes:
      - mysql-data:/var/lib/mysql
      - /c/docker/shared:/usr/shared
EOL

# Levantar los servicios con Docker Compose
sudo docker-compose up -d
