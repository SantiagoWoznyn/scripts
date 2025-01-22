#!/bin/bash

# --- Instalar ZeroTier ---
curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/main/doc/contact%40zerotier.com.gpg' | gpg --import && \
if z=$(curl -s 'https://install.zerotier.com/' | gpg); then echo "$z" | sudo bash; fi

# --- Actualizar el sistema ---
sudo apt update && sudo apt upgrade -y

# --- Instalar paquetes necesarios ---
sudo apt install -y apt-transport-https ca-certificates curl gnupg software-properties-common

# --- Añadir la clave GPG de Docker ---
curl -fsSL https://download.docker.com/linux/raspbian/gpg | sudo apt-key add -

# --- Añadir el repositorio de Docker para arm64 ---
echo "deb [arch=arm64] https://download.docker.com/linux/raspbian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

# --- Actualizar los repositorios ---
sudo apt update

# --- Instalar Docker ---
sudo apt install -y docker-ce docker-ce-cli containerd.io

# --- Habilitar y arrancar Docker ---
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker --no-pager

# --- Instalar Docker Compose ---
DOCKER_COMPOSE_VERSION="1.29.2"
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose

# --- Aplicar permisos de ejecución ---
sudo chmod +x /usr/local/bin/docker-compose

# --- Verificar que Docker Compose esté instalado ---
docker-compose --version

# --- Mostrar mensaje de éxito ---
echo "ZeroTier, Docker, Docker Compose han sido instalados exitosamente."
