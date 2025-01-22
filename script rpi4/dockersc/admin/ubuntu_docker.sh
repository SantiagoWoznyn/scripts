#!/bin/bash

# Solicitar directorio para volúmenes
echo "Introduce el directorio donde se guardarán los volúmenes de Docker (ejemplo: /home/usuario/volumen):"
read VOLUME_PATH

# Solicitar usuario y contraseña
echo "Introduce el nombre de usuario para el contenedor:"
read USERNAME
echo "Introduce la contraseña para el usuario $USERNAME:"
read -s PASSWORD

# Crear el archivo docker-compose.yml
echo "Creando el archivo docker-compose.yml..."
cat << EOF > docker-compose.yml
version: '3.8'

services:
  ubuntu:
    image: ubuntu:latest
    container_name: ubuntu_container
    volumes:
      - $VOLUME_PATH:/mnt/data
    environment:
      - USER=$USERNAME
      - PASSWORD=$PASSWORD
    command: bash -c "echo '$PASSWORD' | passwd --stdin $USERNAME && service ssh start && bash"
    ports:
      - "22:22"
    stdin_open: true
    tty: true
EOF

# Levantar el contenedor con Docker Compose
echo "Levantando el contenedor con Docker Compose..."
docker-compose up -d

# Verificar que el contenedor está en ejecución
echo "Verificando que el contenedor esté corriendo..."
docker ps

echo "Contenedor Ubuntu instalado. Puedes acceder al contenedor mediante SSH."
