#!/bin/bash

# Actualizar los paquetes existentes
sudo apt update
sudo apt upgrade -y

# Instalar paquetes necesarios
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Añadir la clave GPG de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Añadir el repositorio de Docker
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Instalar Docker
sudo apt update
sudo apt install -y docker-ce

# Verificar que Docker esté funcionando
sudo systemctl status docker --no-pager

# Descargar e instalar Docker Compose
DOCKER_COMPOSE_VERSION="1.29.2"
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Aplicar permisos de ejecución
sudo chmod +x /usr/local/bin/docker-compose

# Verificar que Docker Compose esté instalado
docker-compose --version

echo "Docker y Docker Compose han sido instalados exitosamente."
