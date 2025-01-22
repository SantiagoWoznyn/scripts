#!/bin/bash

# Script para instalar y configurar el servidor RustDesk

# Colores para mensajes
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Docker no está instalado. Por favor, instala Docker antes de continuar.${RESET}"
    exit 1
fi

# Solicitar la dirección IP del servidor
echo "Por favor, ingresa la dirección IP del servidor:"
read -rp "IP: " SERVER_IP

# Crear el directorio de configuración
CONFIG_DIR="$(pwd)/docker/rustdesk"
mkdir -p "$CONFIG_DIR"

# Ejecutar el contenedor hbbs
echo -e "${GREEN}Iniciando el contenedor hbbs...${RESET}"
docker run --name hbbs \
  --restart unless-stopped \
  -p 21115:21115 \
  -p 21116:21116 \
  -p 21116:21116/udp \
  -p 21118:21118 \
  -v "$CONFIG_DIR:/root" \
  -td rustdesk/rustdesk-server hbbs -r "$SERVER_IP:21117"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}hbbs se configuró correctamente.${RESET}"
else
    echo -e "${RED}Hubo un error al configurar hbbs.${RESET}"
    exit 1
fi

# Ejecutar el contenedor hbbr
echo -e "${GREEN}Iniciando el contenedor hbbr...${RESET}"
docker run --name hbbr \
  --restart unless-stopped \
  -p 21117:21117 \
  -p 21119:21119 \
  -v "$CONFIG_DIR:/root" \
  -td rustdesk/rustdesk-server hbbr

if [ $? -eq 0 ]; then
    echo -e "${GREEN}hbbr se configuró correctamente.${RESET}"
else
    echo -e "${RED}Hubo un error al configurar hbbr.${RESET}"
    exit 1
fi

# Mensaje final
echo -e "${GREEN}Instalación y configuración de RustDesk Server completadas.${RESET}"
echo "Puedes verificar los contenedores con el comando: docker ps"
