# Para que sirve Ansibe :   
Es una herramienta de automatización de código abierto que se utiliza principalmente para simplificar y automatizar tareas de administración, configuración y orquestación en sistemas informáticos, en simples palabras puedes conectarte remotamente a varios servidores y administrarlos automaticamente

- con ansible existen muchos modulos ya programados para que los utilices, sin necesidad de que crees toda una shell, puedes consultar modulos en las paginas:<br><br>

-> Modulos de ansible: https://docs.ansible.com/ansible/2.9/modules/list_of_all_modules.html<br>
-> Modulos de la comunidad:  https://galaxy.ansible.com 


### Rutas de los archivo ansible
Puedes ejecutar el siguiente comando **`ansible --version`** y veras las rutas donde estan los archvios de configuración
```
/etc/ansible
/etc/ansible/ansible.cfg
/etc/ansible/hosts
/etc/ansible/roles/

/usr/share/ansible/Collections/ansible_collections/community/libvirt/plugins/modules/

/usr/bin/ansible
```

### Extensiones de archivo para inventarios:
Existen 2, los archivos con extensión .INI y los .YML y tiene sintaxis diferentes, por lo que tienes que tener cuidado como extructuras tu inventario, aquí dejo el link donde puedes ver la estrucutra y ejemplos <br>

https://docs.ansible.com/ansible/latest/network/getting_started/first_inventory.html


### Heramientas de ansible que tienen diferente propósito 
```
ansible            | Con esta herramienta indicas el inventario de hosts y solo puedes especificar un accion para todos los servidores  
ansible-playbook   | Con esta herramienta indicas el inventario de hosts y puedes especificar que accion quieres que realice cada servidor
ansible-vault      | Creas un vault para tus contraseñas cifradas 
ansible-config     | Verificas las configuraciones del ansible
ansible-inventory  | Puedes verificar si el inventorio es correcto y no tiene detalles de sintaxis 

ansible-connection  
ansible-doc           
ansible-pull
ansible-console     
ansible-galaxy
```         

### Ejemplos básicos de usos de las herramientas:
```
ansible -i /tmp/inventory 10.28.172.4 -m ping -t /tmp/log_ansible.txt -f 10 
ansible-playbook -i inventorio_host.yml playbook.yml --ask-vault-password -f 10
```   


### Variables especiales que pueden servir
https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html

Ejemplos:
```
# Esta variable te dice el nombre del host que se esta ejecutando
inventory_hostname_short

# Esta variable te dice la version de ansible
ansible_version

# esta variable te dice la el tipo de servidor por ejemplo Debian, Redhat, Ubuntu etc, etc,
ansible_facts.os_family
```

### variables de entorno para la configuracion  de ansible
https://docs.ansible.com/ansible/latest/reference_appendices/config.html

Con este comando puedes ver todas las variables de configuracion, se recomienda hacer un respaldo de la info antes de modicar
```
# Buscas variables que te pueden servir
ansible-config dump  | grep -i pass

# Con esto validas solo las variables que han sido modificadas 
ansible-config dump --only-changed
```

Ejemplos de configuración:<br>
```
export ANSIBLE_HOST_KEY_CHECKING=False
export DEFAULT_EXECUTABLE=/bin/bash
```




