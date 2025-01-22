#!/bin/bash

# Solicitar el directorio para Gitea
read -p "Ingrese el directorio donde desea almacenar los datos de Gitea (por ejemplo, /opt/gitea): " gitea_dir
mkdir -p "$gitea_dir"
cd "$gitea_dir" || exit 1

# Solicitar los puertos
read -p "Ingrese el puerto para la interfaz web de Gitea (default 3000): " web_port
web_port=${web_port:-3000}
read -p "Ingrese el puerto para SSH de Gitea (default 222): " ssh_port
ssh_port=${ssh_port:-222}

# Crear el archivo docker-compose.yml
cat <<EOL > docker-compose.yml
version: "3"

networks:
  gitea:
    external: false

services:
  server:
    image: gitea/gitea:1.22.6
    container_name: gitea
    environment:
      - USER_UID=1000
      - USER_GID=1000
    restart: always
    networks:
      - gitea
    volumes:
      - ./gitea:/data
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    ports:
      - "${web_port}:3000"
      - "${ssh_port}:22"
EOL

# Levantar el contenedor con Docker Compose
docker-compose up -d

# Confirmar que Gitea está funcionando
if [ $? -eq 0 ]; then
    echo "Gitea ha sido instalado correctamente y está corriendo en el puerto ${web_port}."
    echo "Puedes acceder a Gitea en: http://localhost:${web_port}"
else
    echo "Hubo un problema al levantar Gitea. Verifica los logs del contenedor para más detalles."
fi
