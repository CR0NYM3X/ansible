# Objetivo del proyecto
Es realizar los realoads de configuración en los servidores productivos postgresql de forma automatizada, eficiente y rápida, esto se realiza a una hora donde hay baja demanda de peticiones, por lo que se recomienda configurar el cron para que ejecute la herramienta  en la madrugada

### Ventajas: 
**1.-** Es seguro ya que la contraseña de cada servidor es encryptada con el mismo ansible, la contraseña que se utiliza para desencriptarla, se genera una nueva contraseña cada dia y borra la contraseña anterior, esto lo hace despues de las 6:30am <br>
**2.-** Ya no es necesario conectarse a cada servidor de manera manual y documentar esto en un excel <br>
**3.-** Disminuye el tiempo de ejecucion <br>
**4.-** Coloca Evidencia de cada reload en cada IP que se le realiza el reload <br>
**5.-** No realiza más de una vez el  reload en un servidor, en el caso de que alguien anexe dos veces el mismo servidor para realizarle el reload  <br>
**6.-** Disminuye  la sobrecarga de trabajo de los colaboradores del turno nocturno <br>

### Desventajas: 
**1.-** Una vez ejecutada la automaticacion, minimo una persona del turno nocturno, debe de validar los servidores que se quedaron con estatus Error para verificar, porque motivo no se pudo realizar el reload


# Ejemplos de uso:

### **1.-** Creamos la base de datos y la tabla que se va ocupar para realizar el registro :
 ```
 create database aplicativo_test;
\c aplicativo_test
 
 
 CREATE TABLE public.ansible_reload (
    id serial primary key,
    fecha timestamp without time zone DEFAULT to_char(now(), 'YYYY-MM-DD HH24:MI:SS')::timestamp ,
    TI INT,
	IP varchar(15),
	numemp int,
	pswd_vault text,
	status_reload varchar(255), 
	status_pgbouncer varchar(255), 
	msg_usuario text, 
	msg_ansible text,
	port int,
	ip_cliente varchar(15),
    playbook  varchar(255),
	user_ssh varchar(255)
);
```
![Creando_la_dba](https://raw.githubusercontent.com/CR0NYM3X/ansible/main/Proyecto-Ansible-Reload/img/Creando_la_dba.PNG)

### 2.- agregamos el script al crontab:
Abres el editor del cron con el comando : **`crontab -e`**   después colocas en una luena línea la tarea programada
```
#Tarea Programada reloads automáticos: 
0 2 * * * /tmp/test_ansible/ansible_files/generar_ansible.sh >> /tmp/test_ansible/ansible_files/logs/log$(date +%d_%m_%Y).log 2>&1
```
![crontab.PNG](https://raw.githubusercontent.com/CR0NYM3X/ansible/main/Proyecto-Ansible-Reload/img/crontab.PNG)


### 3.- Configuramos los datos de conexión para la base de datos: 
El archivo se encuentra dentro del proyecto en la ruta: ansible_files/files_conf/condb.yml <br>
![condb.PNG](https://raw.githubusercontent.com/CR0NYM3X/ansible/main/Proyecto-Ansible-Reload/img/condb.PNG)

### 4.- Realizamos nuestro primer registro :
Ejecutamos el bash **`registrar_reload.sh`** que se encuentra dentro del proyecto ansible_files, y nos preguntara los datos, sólo los ingresamos y al final nos mostrará todos los datos ingresados en la base de datos <br>
![Cregistrar_reload.PNG](https://raw.githubusercontent.com/CR0NYM3X/ansible/main/Proyecto-Ansible-Reload/img/registrar_reload.PNG)




### Ejecutar de manura manual los reload, sin esperar a que lo ejecute el cron
En caso de que por algún motivo deseas apresurar la ejecucion de los reload, puedes hacerlo de manera manual, tal como se muestra en la imagen 
![generar_ansible.PNG](https://raw.githubusercontent.com/CR0NYM3X/ansible/main/Proyecto-Ansible-Reload/img/generar_ansible.PNG)

### Asi se vera la tabla en un ejemplo real

![evidencia.png](https://raw.githubusercontent.com/CR0NYM3X/ansible/main/Proyecto-Ansible-Reload/img/evidencia2.png)


### Proyecto Ansible_files 
Pequeña descripción de cada archivo: <br>
**`files_conf`**  Es la caperta que guarda las configuraciones importantes para que la herramienta funciones  <br>
**`generar_ansible.sh`**  Es un bash el encargado de generar el inventario con los servidores con estatus pendiente y mandar llamar el playbook para que realice el reload  <br>
**`Img`**  es la carpeta donde se guardan las imagenes del ejemplo <br>
**`inventarios`** Es la carpeta donde se guardan los host con estatus pendientes, este archivo se genera cada dia y en caso de ejecutar bash generar_ansible.sh mas de 2 veces al dia, este se agrega al archivo ya existente  <br> 
**`logs`**  es donde se guardan los log del archivo generar_ansible.sh  en caso de un error o validar porque no se realizo el reaload a un servidor  <br>
**`registrar_reload.sh`** Es el bash que se usa para registrar los servidores en la base de datos, para que el bash generar_ansible.sh  en la madrugada consulte esos host con estatus pendiente y realice los reloads     <br>

![archivos_principales](https://github.com/CR0NYM3X/ansible/blob/main/Proyecto-Ansible-Reload/img/archivos_principales.PNG)

### Archivos de configuración de la herramienta:
No es necesario mover ningún archivo para el proyecto, en excepción del archivo condb.yml que se explica en paso #3 <br>

Pequeña descripción de cada archivo: <br>

**`banner.conf`** Se configura el banner que va mostrar la aplicación al ejecutarse <br>
**`condb.yml`** Datos importantes para conectarse a la base de datos  como ip, puerto etc. <br>
**`DatosPrograma.conf`**  Estan las variables donde indican la version, el autor y la hora en la que se va generar una nueva contraseña<br>
**`password-voult20_11_2023.txt`** Es donde se guarda la contraseña que encripta las contraseñas de cada servidor <br>
**`playbook.yml`** Es el playbook  es el arhcivo donde viene el codigo que se va ejecutar en cada servidor  <br>


![files_conf.PNG](https://raw.githubusercontent.com/CR0NYM3X/ansible/main/Proyecto-Ansible-Reload/img/files_conf.PNG)


### Funcionamiento de la herramienta: 

### Futuras Actualizaciones:
1.- Manejo de grupos para playbooks, ejemplos de grupos *``[ Reload_Playbook.yml , Instalaciones_Playbook.yml , agregar_pg_hba.yml, validacion_espacios.yml , instalar_parches_windows.yml ]``* <br>
2.- Indicar un tiempo de ejecucion <br>
3.- Agregar usuarios al archivo pg_hba.conf  <br>
4.- Mejor manejo y validación de los Errores   <br>
5.- Habilitar la opcion de Pg_bouncer en el playbook y indicar que si se reiniciar el pgbouncer no se hace reload en servidor <br>
7.- Validar en el momento que hace el reload que verifique si retorna la palabras "server signaled" y  en caso de que no, coloque el servidor con status: error, con mensaje : no se pudo hacer el reload  <br>
8.- Validar que si no encuentra la ruta del data coloque el servidor como error, no se encontro la ruta del binario  <br>
10.- Recopilar información para tener mas preciso un posible error en los log de postgresql 
11.- Habilitar para que puedas especificar el usuario

### Version actual:
Versión: 1.1 | Mejoras: <br>
```
 1.- Se agrego un campo en la tabla  ansible_reload, donde se va guardar la ip de la persona que realiza el registro
 2.- Se agrego la validacion de usuario en registrar_reload.sh, para que no ingresen números de empleados que no estan registrados,
 3.- Se agrego opcion para ingresar multiples ips en un TI
```
Versión: 1.2 | Mejoras: <br>
```
 1.- Te permite seleccionar que playbook quieres usar, se habilito la opción y ya funciona solo le hace falta mejoras esta en  [Beta]
```
