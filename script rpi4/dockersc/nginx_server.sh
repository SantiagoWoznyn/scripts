#!/bin/bash

# Solicitar la ruta del volumen
read -p "Introduce la ruta para montar el volumen de Nginx: " VOLUMEN_PATH

# Verificar si el directorio existe, si no, crear uno
if [ ! -d "$VOLUMEN_PATH" ]; then
    echo "El directorio no existe. Creando el directorio..."
    mkdir -p "$VOLUMEN_PATH"
fi

# Solicitar el puerto para Nginx
read -p "Introduce el puerto en el que quieres que Nginx escuche (ejemplo: 8080): " PUERTO

# Ejecutar el contenedor de Nginx con el volumen y puerto especificados
docker run -d --name nginx-container -v "$VOLUMEN_PATH:/etc/nginx" -p "$PUERTO:80" nginx

# Confirmación
echo "Nginx ha sido instalado y está ejecutándose en el contenedor 'nginx-container' en el puerto $PUERTO."
echo "El volumen de configuración se encuentra en $VOLUMEN_PATH."


