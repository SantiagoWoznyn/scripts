#!/bin/bash

# Solicitar el path del volumen al usuario
read -p "Introduce el path del volumen para SQL Server: " volume_path

# Verificar si el directorio existe, si no, crearlo
if [ ! -d "$volume_path" ]; then
    echo "El directorio no existe. Creándolo..."
    mkdir -p "$volume_path"/{data,log,secrets}
else
    echo "El directorio ya existe."
    # Asegúrate de que las subcarpetas necesarias existan
    mkdir -p "$volume_path"/{data,log,secrets}
fi

# Establecer permisos adecuados para el usuario mssql (UID 10001)
echo "Configurando permisos para el directorio..."
sudo chown -R 10001:10001 "$volume_path"
sudo chmod -R 700 "$volume_path"

# Solicitar la contraseña del usuario SA
echo -n "Introduce la contraseña para el usuario SA de SQL Server: "
stty -echo  # Desactivar impresión de texto
read sa_password
stty echo   # Reactivar impresión de texto
echo  # Salto de línea para limpiar la pantalla

# Verificar si la contraseña cumple los requisitos
if [ ${#sa_password} -lt 8 ] || ! echo "$sa_password" | grep -q '[A-Z]' || ! echo "$sa_password" | grep -q '[a-z]' || ! echo "$sa_password" | grep -q '[0-9]'; then
    echo "Error: La contraseña debe tener al menos 8 caracteres, incluir mayúsculas, minúsculas y números."
    exit 1
fi

# Crear el archivo docker-compose.yml
compose_file="docker-compose.yml"
cat <<EOF > $compose_file
version: '3.8'

services:
  sqlserver:
    image: mcr.microsoft.com/mssql/server:2022-latest
    user: "10001"
    environment:
      ACCEPT_EULA: 'Y'
      MSSQL_SA_PASSWORD: '$sa_password'
    ports:
      - "1433:1433"
    volumes:
      - "$volume_path/data:/var/opt/mssql/data"
      - "$volume_path/log:/var/opt/mssql/log"
      - "$volume_path/secrets:/var/opt/mssql/secrets"
    restart: always
EOF

# Confirmación de creación
echo "El archivo docker-compose.yml ha sido creado exitosamente:"
cat $compose_file

# Preguntar si se desea iniciar el contenedor
read -p "¿Deseas iniciar el contenedor ahora? (s/n): " iniciar
if [ "$iniciar" = "s" ] || [ "$iniciar" = "S" ]; then
    echo "Iniciando contenedor con Docker Compose..."
    docker-compose up -d
    echo "Contenedor iniciado."
else
    echo "Puedes iniciar el contenedor más tarde con: docker-compose up -d"
fi

