#aca van los dockers tipo microsoft y mysql ,porfa acordate de poner lo de chatgpt

version: '3'
services:
  mssql:
    image: mcr.microsoft.com/mssql/server:2019-latest
    container_name: microsoft_sql_server
    environment:
      SA_PASSWORD: "contraseña"
      ACCEPT_EULA: "Y"
    ports:
      - "1433:1433"
    volumes:
      - mssql_data:/var/opt/mssql
volumes:
  mssql_data:
    driver: local

    este es el docker compose de sql server de microsoft
