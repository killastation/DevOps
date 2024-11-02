#! /bin/bash
sudo mkdir /opt/mssql
sudo chmod 777 /opt/mssql/
sudo docker run -v /opt/mssql:/var/opt/mssql -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=Qwerty-1" -p 1433:1433 -d mcr.microsoft.com/mssql/server:2022-latest
