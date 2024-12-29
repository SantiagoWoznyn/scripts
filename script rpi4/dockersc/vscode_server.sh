
#!/bin/bash

# Solicitar la ubicación del volumen
echo "Ingresa la ruta donde quieres instalar el volumen para Code-Server (por ejemplo, /path/to/code-server/config):"
read VOLUMEN_PATH

# Verificar si la ruta proporcionada existe, si no, crearla
if [ ! -d "$VOLUMEN_PATH" ]; then
  echo "La ruta proporcionada no existe. Creando el directorio..."
  mkdir -p "$VOLUMEN_PATH"
  echo "Directorio creado: $VOLUMEN_PATH"
fi

# Solicitar configuración adicional opcional
echo "¿Quieres configurar un PROXY_DOMAIN? (deja en blanco para omitir)"
read PROXY_DOMAIN

echo "¿Quieres establecer un PASSWORD para el acceso? (deja en blanco para omitir)"
read PASSWORD

# Solicitar el puerto
echo "Ingresa el puerto en el que deseas que Code-Server esté disponible (por defecto 8443):"
read PUERTO

# Asignar un valor por defecto al puerto si está vacío
PUERTO=${PUERTO:-8443}

# Crear el archivo docker-compose.yml
cat <<EOL > docker-compose.yml
version: "3.8"

services:
  code-server:
    image: lscr.io/linuxserver/code-server:latest
    container_name: code-server
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - PASSWORD=${PASSWORD:-password} #optional
      - HASHED_PASSWORD= #optional
      - SUDO_PASSWORD=${PASSWORD:-password} #optional
      - SUDO_PASSWORD_HASH= #optional
      - PROXY_DOMAIN=${PROXY_DOMAIN:-} #optional
      - DEFAULT_WORKSPACE=/config/workspace #optional
    volumes:
      - $VOLUMEN_PATH:/config
    ports:
      - ${PUERTO}:8443
    restart: unless-stopped
EOL

# Confirmar creación del archivo
echo "El archivo docker-compose.yml se ha creado exitosamente en el directorio actual."

# Levantar el servicio con Docker Compose
echo "Levantando el contenedor con Docker Compose..."
sudo docker-compose up -d

# Verificar si el contenedor se levantó correctamente
if [ $? -eq 0 ]; then
  echo "El servicio Code-Server se ha iniciado correctamente."
  echo "Accede al servicio en: http://localhost:${PUERTO} (o la IP de tu servidor)."
else
  echo "Hubo un error al intentar levantar el contenedor. Revisa el archivo docker-compose.yml y los logs."
fi
