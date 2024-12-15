#!/bin/bash

# Solicitar el directorio para Microsoft SQL Server
read -p "Ingrese el directorio donde desea almacenar los datos de Microsoft SQL Server (por ejemplo, /opt/mssql): " mssql_dir
mkdir -p "$mssql_dir"
cd "$mssql_dir" || exit 1

# Solicitar la contraseña del usuario SA
read -sp "Ingrese la contraseña para el usuario SA (mínimo 8 caracteres): " sa_password
echo
while [[ ${#sa_password} -lt 8 ]]; do
  echo "La contraseña debe tener al menos 8 caracteres. Inténtelo de nuevo."
  read -sp "Ingrese la contraseña para el usuario SA: " sa_password
  echo
done

# Solicitar el puerto para Microsoft SQL Server
read -p "Ingrese el puerto para Microsoft SQL Server (default 1433): " sql_port
sql_port=${sql_port:-1433}

# Crear el archivo docker-compose.yml
cat <<EOL > docker-compose.yml
version: '3'

services:
  mssql:
    image: mcr.microsoft.com/mssql/server:2019-latest
    container_name: microsoft_sql_server
    environment:
      SA_PASSWORD: "$sa_password"
      ACCEPT_EULA: "Y"
    ports:
      - "${sql_port}:1433"
    volumes:
      - ./mssql_data:/var/opt/mssql

volumes:
  mssql_data:
    driver: local
EOL

# Levantar el contenedor con Docker Compose
docker-compose up -d

# Confirmar que Microsoft SQL Server está funcionando
if [ $? -eq 0 ]; then
    echo "Microsoft SQL Server ha sido instalado correctamente y está corriendo en el puerto ${sql_port}."
    echo "Puedes conectarte a SQL Server en: localhost:${sql_port}"
else
    echo "Hubo un problema al levantar Microsoft SQL Server. Verifica los logs del contenedor para más detalles."
fi
