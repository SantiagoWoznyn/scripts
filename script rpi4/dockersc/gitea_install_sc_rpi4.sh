#!/bin/bash

# Solicitar el directorio para Gitea
read -p "Ingrese el directorio donde desea almacenar los datos de Gitea (por ejemplo, /opt/gitea): " gitea_dir
export GITEA_DIR=$gitea_dir

# Solicitar el directorio para MySQL
read -p "Ingrese el directorio donde desea almacenar los datos de MySQL (por ejemplo, /opt/mysql): " mysql_dir
export MYSQL_DIR=$mysql_dir

# Crear los directorios si no existen
mkdir -p "$GITEA_DIR"
mkdir -p "$MYSQL_DIR"

# Crear el archivo docker-compose.yml con los volúmenes configurados
cat <<EOL > docker-compose.yml
version: "3"

networks:
  gitea:
    external: false

services:
  server:
    image: docker.io/gitea/gitea:1.22.6
    container_name: gitea
    environment:
      - USER_UID=1000
      - USER_GID=1000
      - GITEA__database__DB_TYPE=mysql
      - GITEA__database__HOST=db:3306
      - GITEA__database__NAME=gitea
      - GITEA__database__USER=gitea
      - GITEA__database__PASSWD=gitea
    restart: always
    networks:
      - gitea
    volumes:
      - ${GITEA_DIR}:/data
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    ports:
      - "3000:3000"
      - "222:22"
    depends_on:
      - db

  db:
    image: docker.io/library/mysql:8
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=gitea
      - MYSQL_USER=gitea
      - MYSQL_PASSWORD=gitea
      - MYSQL_DATABASE=gitea
    networks:
      - gitea
    volumes:
      - ${MYSQL_DIR}:/var/lib/mysql
EOL

# Levantar el contenedor con Docker Compose
docker-compose up -d

# Confirmar que los contenedores están corriendo
if [ $? -eq 0 ]; then
    echo "Gitea y MySQL han sido instalados correctamente y están corriendo."
else
    echo "Hubo un problema al levantar los contenedores. Verifica los logs de Docker para más detalles."
fi
