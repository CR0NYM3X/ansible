 # Inventario
 El inventario es el archivo donde especificamos la lista de servidores que vamos administrar, en este caso existen 2 tipos de extensiones para crear inventarios, cada uno usa una estructura diferente <br>

 Estas dos extensiones se pueden usar con **`ansible`** , pero cuando se usa  **`ansible-playbook`** solo se puede usar la extensión .yml
 - inventario.ini 
 - inventario.yml 

 Aquí dejo la liga de la documentacion oficial de los inventarios:  https://docs.ansible.com/ansible/latest/network/getting_started/first_inventory.html



### Inventarios .INI o  .CFG

Aqui vamos a crer un archivo .ini , aunque ya no son recomendables usarlo ya que en yml tienes mas ventajas <br>
**[NOTA]** no es recomendable usar las contraseñas en texto plano, mas adelante aprenderemos a cifrarlas 

**1.-** Creamos el archivo: **`vim inventario.ini`**

```
[tiendas]
servidor1 ansible_host=192.168.1.10
servidor2 ansible_host=192.168.1.11
servidor3 ansible_host=192.168.1.12

[tiendas:vars]
ansible_password=my_password123
ansible_ssh_user=postgres
host_key_checking=False

[bodegas]
servidor1 ansible_host=192.168.1.10
servidor2 ansible_host=192.168.1.11
servidor3 ansible_host=192.168.1.12

[bodegas:vars]
ansible_password=my_password123
ansible_ssh_user=postgres
host_key_checking=False

```

**2.-** verificamos que el inventario este correcto
Ejecutamos el comando y no tiene que dar errores, si te muestra un JSON eso quiere decir que esta bien: 
```
#Comando
ansible-inventory -i inv2.ini --list
ansible-inventory -i inv2.ini --graph

#JSON
{
    "_meta": {
        "hostvars": {
            "servidor1": {
                "ansible_host": "192.168.1.10",
                "ansible_password": "my_password123",
                "ansible_ssh_user": "postgres",
                "host_key_checking": false
            },
            "servidor2": {
                "ansible_host": "192.168.1.11",
                "ansible_password": "my_password123",
                "ansible_ssh_user": "postgres",
                "host_key_checking": false
            },
            "servidor3": {
                "ansible_host": "192.168.1.12",
                "ansible_password": "my_password123",
                "ansible_ssh_user": "postgres",
                "host_key_checking": false
            }
        }
    },
    "all": {
        "children": [
            "bodegas",
            "tiendas",
            "ungrouped"
        ]
    },
    "bodegas": {
        "hosts": [
            "servidor1",
            "servidor2",
            "servidor3"
        ]
    },
    "tiendas": {
        "hosts": [
            "servidor1",
            "servidor2",
            "servidor3"
        ]
    }
}


```

**3.-** Ejemplos para trabajar con el inventario
```
ansible -i inventario.ini tiendas -m ping
ansible -i inventario.ini tiendas -m shell -a "echo hola mundo"
```



# Hacer un inventario.yml
`[NOTA]` se recomienda encriptar todo el inventario con **ansible-voult encrypt my_inventario.ini** en este ejemplo, no lo vamos encriptar todo, solo vamos encriptar la contraseña y agregarla al inventario


**1.-** Encriptar la contraseña
Encriptamos la contraseña para colocarla en el inventario
```
ansible-vault encrypt_string 'My_contraseñaperrona' --name 'ansible_password'
```

**2.-** Creampos el inventario.yml <br>
vim  /tmp/inventario.yml
```
all:
  children:
    webservers:
      hosts:
        webserver1:
          ansible_host: 192.168.1.101
          ansible_user: webadmin
        webserver2:
          ansible_host: 192.168.1.102
          ansible_user: webadmin
      vars:
        ansible_password: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          64633639346338313134313938326666366566636364366666353065363432353030656364356464
          6338363464653835303161303032376462663862663635610a613736383730373036633365346564
          66306636633130373966353062636133376239383337383938386438363437376434386165623561
          3038656637643136330a636234383633366332363338343735376230656537356463303833393465
          33623062333139666130396339366335343131376137376366656539343562393233
    databases:
      hosts:
        dbserver1:
          ansible_host: 192.168.1.201
          ansible_user: dbadmin
        dbserver2:
          ansible_host: 192.168.1.202
          ansible_user: dbadmin
  vars: # esta variable se esta colocando en el children por lo que se colocara esta variable para todos los server
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
    variable_custom:  " sumando --> {{ 8080 + 10 }}" # esta variable se puede mandar llamar en el paybook
```
**3.-**  Verificamos que el inventario este bien 
```
# Comando:
ansible-inventory -i op.yml --graph

#Resultado
@all:
  |--@databases:
  |  |--dbserver1
  |  |--dbserver2
  |--@ungrouped:
  |--@webservers:
  |  |--webserver1
  |  |--webserver2


```


**4.-** Crear un playbook básico para el inventario:
<br> Ejecutamos el comando : **`vim /tmp/playbook.ini`** y pegamos el siguiente texto
```
- name: Realizar ping a los servidores
  hosts: "webserver1"
  vars:
        variable_en_playbook: Contenido_variable
  tasks:
    - name: hacer ping
      ping:
    - name: mostrar variables
      debug:
        msg: "este mensaje {{ variable_custom }} --- {{ variable_en_playbook }} "

```

**3.-** Ejecutamos el playbook
Pedira la contraseña del voult, la colocamos y listo
```
ansible-playbook -i inventorio.yml playbook.yml --ask-vault-password
```


# Inventarios avanzado:
puedes utilizar las plantillas Jinja2 en archivos de inventario YAML para definir configuraciones dinámicas o variables condicionales.


bibliografía : 
https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#id4

https://docs.ansible.com/ansible/2.7/user_guide/intro_inventory.html

