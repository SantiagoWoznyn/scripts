#!/bin/bash

# Instalar ZeroTier
curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/main/doc/contact%40zerotier.com.gpg' | gpg --import && \
if z=$(curl -s 'https://install.zerotier.com/' | gpg); then echo "$z" | sudo bash; fi

# Actualizar los paquetes existentes
sudo apt update
sudo apt upgrade -y

# Instalar paquetes necesarios
sudo apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common

# Añadir la clave GPG de Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

# Añadir el repositorio de Docker
echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

# Actualizar los repositorios de paquetes
sudo apt update

# Instalar Docker
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

# Preguntar al usuario en qué puerto desea instalar Portainer
read -p "Por favor, ingrese el puerto en el que desea instalar Portainer (por ejemplo, 9000): " PORTAINER_PORT

# Descargar e instalar Portainer usando Docker en el puerto elegido por el usuario
sudo docker run -d -p ${PORTAINER_PORT}:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce

echo "ZeroTier, Docker, Docker Compose y Portainer han sido instalados exitosamente. Portainer está disponible en el puerto $PORTAINER_PORT."
