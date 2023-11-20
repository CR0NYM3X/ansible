#!/bin/bash

#echo ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗     █████╗ ███╗   ██╗███████╗██╗██████╗ ██╗     ███████╗
#echo ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝    ██╔══██╗████╗  ██║██╔════╝██║██╔══██╗██║     ██╔════╝
#echo ███████╗██║     ██████╔╝██║██████╔╝   ██║       ███████║██╔██╗ ██║███████╗██║██████╔╝██║     █████╗  
#echo ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║       ██╔══██║██║╚██╗██║╚════██║██║██╔══██╗██║     ██╔══╝  
#echo ███████║╚██████╗██║  ██║██║██║        ██║       ██║  ██║██║ ╚████║███████║██║██████╔╝███████╗███████╗
#echo ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝       ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝╚═════╝ ╚══════╝╚══════╝
                       
ruta_program=$(dirname $(readlink -f "$0"))/

#   https://askubuntu.com/questions/282715/how-can-i-make-ascii-banners-from-the-command-line
source $ruta_program/files_conf/DatosPrograma.conf # Importando datos 

source $ruta_program/files_conf/banner.conf  

#Variables
status_reload="pendiente"
# Expresión regular para validar una dirección IP
ip_pattern="^([0-9]{1,3}\.){3}[0-9]{1,3}$"
son_numeros="^[0-9]+$"
pwd_vault=$ruta_program/files_conf/password-voult$(date +%d_%m_%Y).txt
hora_valida_cambiar_password=00:05 #06:29

# Importando los datos de conexion para la base de datos 
db_port=$(grep db_port $ruta_program/files_conf/condb.yml | sed 's/.*: //'  | sed -e 's/\"//g' -e 's/ //g')
db_ip=$(grep db_ip $ruta_program/files_conf/condb.yml | sed 's/.*: //'  | sed -e 's/\"//g' -e 's/ //g')
db_user=$(grep db_user $ruta_program/files_conf/condb.yml | sed 's/.*: //'  | sed -e 's/\"//g' -e 's/ //g')
db_name=$(grep db_name $ruta_program/files_conf/condb.yml | sed 's/.*: //'  | sed -e 's/\"//g' -e 's/ //g')
db_password=$(grep db_password $ruta_program/files_conf/condb.yml | sed 's/.*: //'  | sed -e 's/\"//g' -e 's/ //g')

# Esta linea valida que el archivo password-voult no sea de dias pasados y esto mejora la seguridad y cambia la contraseña todos los dias
if [[ `date +%H:%M` > $hora_valida_cambiar_password ]]; then

    if [ ! -e "$pwd_vault" ];then
	rm $ruta_program/files_conf/password-voult* # Eliminando las contraseñas antiguas
        echo ""
        echo "¡Ya son las 6:30 AM o más tarde!"
        echo "Por seguridad se genero una nueva contraseña para el vault, ya que la que estaba era de días pasados"
        echo ""
        echo $(openssl rand -base64 150) > $pwd_vault
    fi

fi

# Solicitar información al usuario
while [[ ! $ti =~ $son_numeros ]];
do
    read -p "Ingrese el TI: " ti
done

while [[ ! $no_emp =~ $son_numeros ]];
do
    read -p "Ingrese tu Numero de empleado: " no_emp
done


while [[ ! $ip =~ $ip_pattern ]];
do
    read -p "Ingrese la IP: " ip
done


while [[ ! $port =~ $son_numeros ]];
do
    read -e -i "22" -p "Ingrese el puerto: " port
done


while [[ -z $pswd_vault ]];
do
    read -p "Ingrese la contraseña ssh del servidor: " pswd_vault
done

while [ "$status_pgbouncer" != "s" ] && [ "$status_pgbouncer" != "S" ] && [ "$status_pgbouncer" != "n" ] && [ "$status_pgbouncer" != "N" ];
do
    read -e -i "n" -p "Necesitas reiniciar el pg_bouncer si o no [s/n]: " status_pgbouncer
done

if [ "$status_pgbouncer" = "s" ] || [ "$status_pgbouncer" = "S" ]; then
status_pgbouncer="pendiente"
else
status_pgbouncer="no"	
fi

read -p "Quieres ingresar algun mensaje [Puedes dejarlo vacio si quieres]: " msg_usuario



pswd_vault2=$(ansible-vault encrypt_string $pswd_vault --name 'ansible_password' --vault-password-file $pwd_vault | grep -v "Encryption success" )

# Eliminando espacios 
ti=$(echo $ti |  tr -d '[[:space:]]')
ip=$(echo $ip |  tr -d '[[:space:]]')
no_emp=$(echo $no_emp |  tr -d '[[:space:]]')
port=$(echo $port |  tr -d '[[:space:]]')
pswd_vault=$(echo $pswd_vault |  tr -d '[[:space:]]' )
status_pgbouncer=$(echo $status_pgbouncer |  tr -d '[[:space:]]')
#msg_usuario=$(echo $msg_usuario |  tr -d '[[:space:]]')



# Conectar a la base de datos e insertar datos
psql -h $db_ip -p $db_port -d $db_name -U $db_user  <<EOF
INSERT INTO ansible_reload ( ti , ip , numemp , pswd_vault , status_reload , status_pgbouncer , msg_usuario, port )
VALUES ( '$ti', '$ip', '$no_emp', '$pswd_vault2', 'pendiente', '$status_pgbouncer', '$msg_usuario', $port);
EOF



# Verificar el resultado
if [ $? -eq 0 ]; then
  echo "Datos insertados correctamente."
  echo ""
  echo ""
  psql -h $db_ip -p $db_port  -d $db_name -U $db_user -c "select  ti , ip , numemp  , status_reload , status_pgbouncer , msg_usuario, port from ansible_reload where ip='$ip' and ti='$ti'"
else
  echo "Error al insertar datos en la base de datos."
fi


