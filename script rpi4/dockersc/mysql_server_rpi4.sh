
#!/bin/bash

# Solicitar el directorio para almacenar los datos de MySQL
read -p "Ingrese la ruta donde desea almacenar los datos de MySQL (por ejemplo, /opt/mysql-data): " data_dir
mkdir -p "$data_dir"

# Solicitar credenciales de MySQL
read -p "Ingrese el nombre del usuario de MySQL: " mysql_user
read -sp "Ingrese la contraseña del usuario de MySQL: " mysql_password
echo
read -sp "Ingrese la contraseña de root de MySQL: " mysql_root_password
echo

# Crear el archivo docker-compose.yml
cat <<EOL > docker-compose.yml
version: '3.9'

services:
  mysql:
    image: mysql:8.0    # Compatible con ARM, ideal para Raspberry Pi
    container_name: mysql-server
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: "$mysql_root_password"
      MYSQL_USER: "$mysql_user"
      MYSQL_PASSWORD: "$mysql_password"
      MYSQL_DATABASE: "mi_base_datos"
    ports:
      - "3306:3306"
    volumes:
      - ${data_dir}:/var/lib/mysql
EOL

# Levantar el servicio con Docker Compose
sudo docker-compose up -d

# Confirmar la instalación
if [ $? -eq 0 ]; then
    echo "MySQL se ha instalado correctamente en Docker. Datos almacenados en $data_dir."
else
    echo "Hubo un problema al instalar MySQL. Verifique los logs."
fi
