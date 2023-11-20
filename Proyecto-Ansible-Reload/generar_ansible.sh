#!/bin/bash

#Variables
ruta_program=$(dirname $(readlink -f "$0"))/
inventario=$ruta_program/inventarios/inventario$(date +%d_%m_%Y).yml
playbook=$ruta_program/files_conf/playbook.yml
grupo=$(date +fecha_%d_%m_%Y_hora_%H_%M_%S)
pwd_vault=$ruta_program/files_conf/password-voult$(date +%d_%m_%Y).txt


db_port=$(grep db_port $ruta_program/files_conf/condb.yml | sed 's/.*: //'  | sed -e 's/\"//g' -e 's/ //g')
db_ip=$(grep db_ip $ruta_program/files_conf/condb.yml | sed 's/.*: //'  | sed -e 's/\"//g' -e 's/ //g')
db_user=$(grep db_user $ruta_program/files_conf/condb.yml | sed 's/.*: //'  | sed -e 's/\"//g' -e 's/ //g')
db_name=$(grep db_name $ruta_program/files_conf/condb.yml | sed 's/.*: //'  | sed -e 's/\"//g' -e 's/ //g')
db_password=$(grep db_password $ruta_program/files_conf/condb.yml | sed 's/.*: //'  | sed -e 's/\"//g' -e 's/ //g')

ids_pendientes=$( psql -h $db_ip -p $db_port  -d $db_name -U $db_user -t -c "select min(id) from ansible_reload where status_reload='pendiente' group by ip"   )
source $ruta_program/files_conf/DatosPrograma.conf

source $ruta_program/files_conf/banner.conf



# valida que haya host pendientes, si no hay se cierra el script
if [ -z $ids_pendientes ] 2>/dev/null;  then
	echo ""
	echo "  No se encontraron host pendientes  - $(date +fecha_%d_%m_%Y_hora_%H_%M_%S)"
	echo ""
	exit 1
fi


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

# necesitamos validar si ya existe el archivo con la fecha , si ya existe solo que realice el bucle si no existe que lo realice

if [ ! -e "$inventario" ]; then

echo "  Se genero el archivo inventario$(date +%d_%m_%Y).yml -  hora: $(date +%H:%M:%S)";

echo "
all:
  children:
    $grupo:
      hosts: " >> $inventario

else
echo "  El archivo inventario$(date +%d_%m_%Y).yml ya existe, solo se agregan host que quedaron con estatus: pendiente -  hora: $(date +%H:%M:%S)"

echo "
    $grupo:
      hosts: " >> $inventario

fi

for id in $ids_pendientes; do
  ip=$( psql -h $db_ip -p $db_port  -d $db_name -U $db_user  -t -c "select ip from ansible_reload where id=$id")
  port=$( psql -h $db_ip -p $db_port  -d $db_name -U $db_user  -t -c "select port from ansible_reload where id=$id")
  pass=$( psql -h $db_ip -p $db_port  -d $db_name -U $db_user  -t -c "select pswd_vault from ansible_reload where id=$id" | sed -e 's/\+//g' )
  

echo "
        Serv_ID_$id:
          ansible_host: $ip
          ansible_user: postgres
          ansible_port:$port
         $pass " >> $inventario

done

# Quitando los espacios que estan al final de cada linea, porque esto genera error si no se quita
sed -i 's/[[:space:]]*$//' $inventario

echo ""
echo Verificando que el inventario este bien:
echo ""
ansible-inventory -i $inventario --graph


sed -i "/hosts: fecha_/c\ \ hosts: $grupo" $playbook


echo ""
echo Ejecutando ansible
ansible-playbook -i $inventario $playbook --vault-password-file $pwd_vault --forks 10






