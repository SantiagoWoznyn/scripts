#!/bin/bash

# Preguntar al usuario por las rutas para los volúmenes
read -p "Introduce la ruta donde se encuentra el código de la API (./api): " api_path
read -p "Introduce la ruta donde se encuentra el contenido de html5up-stellar (./html5up-stellar): " html_path
read -p "Introduce la ruta donde se encuentra el archivo de configuración de Nginx (./nginx/default.conf): " nginx_conf_path

# Crear un archivo docker-compose.yml con las rutas proporcionadas
cat > docker-compose.yml <<EOL
version: "3.8"
services:
  node:
    build:
      context: ./api
      target: dev
    volumes:
      - ${api_path}/index.js:/src/index.js
  nginx:
    restart: always
    image: nginx:1-alpine
    ports:
      - 8089:80
    volumes:
      - ${html_path}:/var/www/html
      - ${nginx_conf_path}:/etc/nginx/conf.d/default.conf
    depends_on:
      - node
EOL

echo "docker-compose.yml ha sido generado con las rutas proporcionadas."

# Levantar los contenedores de Docker
echo "Levantando los contenedores de Docker..."
sudo docker-compose up -d

echo "Los contenedores han sido levantados."
