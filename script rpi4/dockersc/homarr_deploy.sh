#!/bin/bash

# Solicitar puerto al usuario
echo "Ingresa el puerto para Homarr (por defecto 7575):"
read -r PORT
PORT=${PORT:-7575} # Si el usuario no ingresa nada, se usa 7575 por defecto

# Solicitar path para el volumen
echo "Ingresa la ruta del volumen para Homarr (por defecto ./homarr/appdata):"
read -r VOLUME_PATH
VOLUME_PATH=${VOLUME_PATH:-./homarr/appdata} # Si no se ingresa nada, usa el path por defecto

# Generar clave de encriptación
SECRET_KEY=$(openssl rand -hex 32)

# Crear y ejecutar el contenedor
docker run -d \
  --name homarr \
  --restart unless-stopped \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$VOLUME_PATH:/appdata" \
  -e SECRET_ENCRYPTION_KEY="$SECRET_KEY" \
  -p "$PORT:7575" \
  ghcr.io/homarr-labs/homarr:latest

echo "Homarr ha sido desplegado en el puerto $PORT con el volumen en $VOLUME_PATH"
