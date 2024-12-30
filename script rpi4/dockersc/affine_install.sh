#!/bin/bash

# Solicitar información al usuario
echo "Configuración del servicio Affine"
echo "=================================="

# Solicitar puerto
echo "Ingresa el puerto para Affine (por defecto 3010):"
read PORT
PORT=${PORT:-3010}

# Solicitar rutas para volúmenes
echo "Ingresa la ubicación del volumen para almacenamiento (por ejemplo, /path/to/storage):"
read UPLOAD_LOCATION

echo "Ingresa la ubicación del volumen para configuración (por ejemplo, /path/to/config):"
read CONFIG_LOCATION

echo "Ingresa la ubicación del volumen para datos de PostgreSQL (por ejemplo, /path/to/db):"
read DB_DATA_LOCATION

# Solicitar credenciales de base de datos
echo "Ingresa el nombre de usuario para la base de datos (por defecto affine_user):"
read DB_USERNAME
DB_USERNAME=${DB_USERNAME:-affine_user}

echo "Ingresa la contraseña para la base de datos (por defecto affine_pass):"
read DB_PASSWORD
DB_PASSWORD=${DB_PASSWORD:-affine_pass}

echo "Ingresa el nombre de la base de datos (por defecto affine):"
read DB_DATABASE
DB_DATABASE=${DB_DATABASE:-affine}

# Generar el archivo docker-compose.yml
cat <<EOL > docker-compose.yml
name: affine
services:
  affine:
    image: ghcr.io/toeverything/affine-graphql:\${AFFINE_REVISION:-stable}
    container_name: affine_server
    ports:
      - '${PORT}:3010'
    depends_on:
      redis:
        condition: service_healthy
      postgres:
        condition: service_healthy
      affine_migration:
        condition: service_completed_successfully
    volumes:
      - ${UPLOAD_LOCATION}:/root/.affine/storage
      - ${CONFIG_LOCATION}:/root/.affine/config
    environment:
      - REDIS_SERVER_HOST=redis
      - DATABASE_URL=postgresql://${DB_USERNAME}:${DB_PASSWORD}@postgres:5432/${DB_DATABASE}
    restart: unless-stopped

  affine_migration:
    image: ghcr.io/toeverything/affine-graphql:\${AFFINE_REVISION:-stable}
    container_name: affine_migration_job
    volumes:
      - ${UPLOAD_LOCATION}:/root/.affine/storage
      - ${CONFIG_LOCATION}:/root/.affine/config
    command: ['sh', '-c', 'node ./scripts/self-host-predeploy.js']
    environment:
      - REDIS_SERVER_HOST=redis
      - DATABASE_URL=postgresql://${DB_USERNAME}:${DB_PASSWORD}@postgres:5432/${DB_DATABASE}
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy

  redis:
    image: redis
    container_name: redis
    healthcheck:
      test: ['CMD', 'redis-cli', '--raw', 'incr', 'ping']
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped

  postgres:
    image: postgres:16
    container_name: postgres
    volumes:
      - ${DB_DATA_LOCATION}:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: ${DB_USERNAME}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: ${DB_DATABASE}
      POSTGRES_INITDB_ARGS: '--data-checksums'
      POSTGRES_HOST_AUTH_METHOD: trust
    healthcheck:
      test:
        ['CMD', 'pg_isready', '-U', "${DB_USERNAME}", '-d', "${DB_DATABASE}"]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped
EOL

# Confirmación
echo "El archivo docker-compose.yml se ha creado con éxito."
echo "=================================="
echo "Archivo generado:"
cat docker-compose.yml

# Levantar el servicio automáticamente
echo "¿Deseas levantar el servicio ahora? (s/n):"
read START_SERVICE

if [ "$START_SERVICE" == "s" ]; then
  docker-compose up -d
  if [ $? -eq 0 ]; then
    echo "El servicio Affine se ha levantado correctamente en el puerto ${PORT}."
  else
    echo "Hubo un error al levantar el servicio. Revisa la configuración."
  fi
else
  echo "El contenedor no se ha levantado. Ejecuta 'docker-compose up -d' manualmente si lo deseas."
fi
