# Playbook
Es el archivo con extension playbook.yml que indica que actividad va realizar un grupo de host o un host en especifico,  yamel  utiliza el  motor de plantillas jinja de python para trabajar con el archivo utilizando condicionales, bucles, etc,etc, 

<br>
para agregar un comentario en el playbook se utiliza el carácter '#'
<br>
modulos: https://docs.ansible.com/ansible/2.8/user_guide/modules.html

# Ejemplos de configuracion Playbook

Playbook : 
```
# Los modulos tambien se pueden poner asi : ansible.builtin.copy

- name: Ejemplo de Playbook con Ansible
  hosts: 127.0.0.1 # Aqui ponemos el servidor local pero puede ser un serv remoto
  gather_facts: true #Esta opción recopila automáticamente información sobre el sistema
  vars_files:
      - mivarfile.yml
  vars:
    nombres:
      - Juan
      - María
      - Pedro
      - Ana
      - Carlos

    servidores:
      - servidor1
      - servidor2
    permisos:
      - lectura
      - escritura

  tasks:

    ####
    ####    Trabajando con  variables
    ####    bibliografía: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html

    # Tambien puedes incluir variables de archivs despues de task o mientras se ejecutan las tareas
#    - name: incuir un vault | incluir variables de un archivo
#      ansible.builtin.include_vars:
#       file: /tmp/secret2.txt

    # Sirve para crear una varibale y guardar informacion
    - name: crear variables_
      set_fact:
         numero_dia_mes: 10 #"{{ ansible_date['date'] | to_datetime('%d') | int }}"


    - name: imprimir variables del archivo
      debug:
         msg: "dia: {{ numero_dia_mes }} el nombre es: {{ nombre }} y tiene la edad: {{ edad }}  y cumple años: {{ fec_nacimiento }} -- {{ nueva_al_momento }} "
      vars:
        nueva_al_momento: 123123



    ####
    ####   Trabajando con bucles
    ####   bibliografía: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html

        #Este bucle te permite tener el nombre del key y su valor
    - name: Usar loop con with_dict
      debug:
        msg: "Clave: {{ item.key }}, Valor: {{ item.value }}"
      loop: "{{ mi_diccionario | dict2items }}"
      vars:
        mi_diccionario:
            key1: valor1
            key2: valor2
            key3: valor3


    # Este ejemplo basico hace un lop del 1 al 6  y los imprime
    - name: Loop con rango de números
      debug:
        msg: "Número: {{ my_item }}"
      loop: "{{ range(1, 6) }}"
      loop_control:
        loop_var: my_item

      # loop_control permite personalizar la variable de bucle, en este caso, se cambia de item a my_item.
    - name: Loop con control
      debug:
        msg: "Elemento: {{ my_item }}"
      with_items:
        - elemento1
        - elemento2
        - elemento3
      loop_control:
        loop_var: my_item


      # este es un bucle con varios arregos
    - name: Mostrar información de usuarios creados
      debug:
        msg: "Usuario {{ item.0 }}_{{ item.1  }} creado en el servidor {{ item.2  }}"
        # changed_when: false
      with_nested:
        - "{{ nombres }}" # si quieres meterlo directo puedes usar asi el array : - ['Juan', 'María', 'Pedro']
        - "{{ permisos }}"
        - "{{ servidores }}"


    - name: Usando el loop con el comando  echo
      command: echo " hola --> {{ item }}"
      loop: "{{ nombres }}"
      register: resultado_echo
    - name: Mostrar resultado del comando echo
      debug:
        var: resultado_echo.results | map(attribute='stdout') | list

   #- name: Register loop output as a variable
#     ansible.builtin.shell: "echo {{ item }}"
#     loop:
#       - "one"
#       - "two"
#     register: echo


    ####
    ####   Trabajando con condicionales
    ####   bibliografía: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html

    - name: ejecuta comando condicialmente
      #Si la condicion when se cumple entonces va ejecutar  modulo debug si no se cumple no va ejecutar nada
      debug:
       msg: |
         Fecha del servidor: "{{ ansible_date_time.iso8601 }}"
         Nombre del host: "{{ ansible_hostname }}"
         Dirección IP: "{{ ansible_default_ipv4.address }}"
         Distribución del sistema: "{{ ansible_facts.os_family }} {{ ansible_distribution }} {{ ansible_distribution_version }}"
      when: ansible_facts['os_family'] == "RedHat"
      register: result # guardando el resultado en una variable
      #verbosity: 2   # esta linea hace que no muestre los resultados
    - name: guardar la informacion en un archivo txt
      # se recominda usar esta opcion y no el modulo copy porque cundo son varios servidores puedes tener problemas que se sobre escribe
      shell: |
        echo -e "\n\n {{ inventory_hostname_short }} - {{ result.msg }}" >> /tmp/test_ansible/result_ansible.txt
      delegate_to: localhost


    ####
    ####   Trabajando con archivos
    ####   bibliografía:  https://docs.ansible.com/ansible/2.8/modules/list_of_files_modules.html

    - name: Check that the somefile.conf exists
      stat:
        path: /tmp/carpeta_test
      register: stat_result

    - name: mostrar el estatus de la carpeta
      debug:
        var: stat_result

    - name: Crear carpeta /tmp/carpeta_test solo si no existe
      file:
        path: /tmp/carpeta_test
        state: directory
        mode: 0600
      changed_when: false # esto se pone si quieres que al ejecutar la opcion " changed=2" no considere este parte como un cambio
      when: not stat_result.stat.exists

    - name: Crear archivo txt /tmp/tu_archivo.txt
      file:
        path: /tmp/tu_archivo.txt
        state: touch


    - name: Agregar texto al final del archivo
      lineinfile:
        path: /tmp/tu_archivo.txt
        line: "{{ text }} "
        insertafter: EOF
      #become: yes  # esta linea se coloca en caso de necesitar poner sudo
      vars:
        text: este es mi texto al final 2222222222

    - name: Copiar archivo txt del servidor local a un servidor remoto
      copy:
        src: /tmp/tu_archivo.txt
        dest: /tmp/test_ansible

    - name: Eliminar carpeta
      file:
        path: /tmp/carpeta_test
        state: absent

#    - name: Eliminar arhcivo txt
#      file:
#        path: /tmp/tu_archivo.txt
#        state: absent


#   - name: Copiar archivo del servidor remoto a servidor local
#     fetch:
#       src: /ruta/remota/tu_archivo.txt
#       dest: /ruta/local/
#       flat: yes

```

Ejecutar:<br>
`[NOTA]` el parametro **-i inventario.yml** se agrega en caso de tener un inventario ya realizado 
```
# Comando: 
ansible-playbook -i inventario.yml ping3.yml 

# Puedes usar este parametro para validar si el playbook esta bien antes de ejecutar
--syntax-check

# si son varios servidores puedes usar este parametr para que trabaje en paralelo, el dafaul son 5
-f FORKS

# En caso de querer especificar los host puede usar este parametro
-l servidor1,servidor2,servidor3,...,servidor20
-l tiendas[1:20]

# si tiene contraseñas encriptadas puedes usar esto
--ask-vault-password
```

Resultado que se imprime en consola:
```

PLAY [Ejemplo de Playbook con Ansible] *****************************************

TASK [Gathering Facts] *********************************************************
ok: [127.0.0.1]

TASK [crear variables_] ********************************************************
ok: [127.0.0.1]

TASK [imprimir variables del archivo] ******************************************
ok: [127.0.0.1] => {
    "msg": "dia: 10 el nombre es: pedro lopez y tiene la edad: 20  y cumple años: 12/12/95 -- 123123 "
}

TASK [Usar loop con with_dict] *************************************************
ok: [127.0.0.1] => (item={'key': 'key1', 'value': 'valor1'}) => {
    "msg": "Clave: key1, Valor: valor1"
}
ok: [127.0.0.1] => (item={'key': 'key2', 'value': 'valor2'}) => {
    "msg": "Clave: key2, Valor: valor2"
}
ok: [127.0.0.1] => (item={'key': 'key3', 'value': 'valor3'}) => {
    "msg": "Clave: key3, Valor: valor3"
}

TASK [Loop con rango de números] ***********************************************
ok: [127.0.0.1] => (item=1) => {
    "msg": "Número: 1"
}
ok: [127.0.0.1] => (item=2) => {
    "msg": "Número: 2"
}
ok: [127.0.0.1] => (item=3) => {
    "msg": "Número: 3"
}
ok: [127.0.0.1] => (item=4) => {
    "msg": "Número: 4"
}
ok: [127.0.0.1] => (item=5) => {
    "msg": "Número: 5"
}

TASK [Loop con control] ********************************************************
ok: [127.0.0.1] => (item=elemento1) => {
    "msg": "Elemento: elemento1"
}
ok: [127.0.0.1] => (item=elemento2) => {
    "msg": "Elemento: elemento2"
}
ok: [127.0.0.1] => (item=elemento3) => {
    "msg": "Elemento: elemento3"
}

TASK [Mostrar información de usuarios creados] *********************************
ok: [127.0.0.1] => (item=['Juan', 'lectura', 'servidor1']) => {
    "msg": "Usuario Juan_lectura creado en el servidor servidor1"
}
ok: [127.0.0.1] => (item=['Juan', 'lectura', 'servidor2']) => {
    "msg": "Usuario Juan_lectura creado en el servidor servidor2"
}
ok: [127.0.0.1] => (item=['Juan', 'escritura', 'servidor1']) => {
    "msg": "Usuario Juan_escritura creado en el servidor servidor1"
}
ok: [127.0.0.1] => (item=['Juan', 'escritura', 'servidor2']) => {
    "msg": "Usuario Juan_escritura creado en el servidor servidor2"
}
ok: [127.0.0.1] => (item=['María', 'lectura', 'servidor1']) => {
    "msg": "Usuario María_lectura creado en el servidor servidor1"
}
ok: [127.0.0.1] => (item=['María', 'lectura', 'servidor2']) => {
    "msg": "Usuario María_lectura creado en el servidor servidor2"
}
ok: [127.0.0.1] => (item=['María', 'escritura', 'servidor1']) => {
    "msg": "Usuario María_escritura creado en el servidor servidor1"
}
ok: [127.0.0.1] => (item=['María', 'escritura', 'servidor2']) => {
    "msg": "Usuario María_escritura creado en el servidor servidor2"
}
ok: [127.0.0.1] => (item=['Pedro', 'lectura', 'servidor1']) => {
    "msg": "Usuario Pedro_lectura creado en el servidor servidor1"
}
ok: [127.0.0.1] => (item=['Pedro', 'lectura', 'servidor2']) => {
    "msg": "Usuario Pedro_lectura creado en el servidor servidor2"
}
ok: [127.0.0.1] => (item=['Pedro', 'escritura', 'servidor1']) => {
    "msg": "Usuario Pedro_escritura creado en el servidor servidor1"
}
ok: [127.0.0.1] => (item=['Pedro', 'escritura', 'servidor2']) => {
    "msg": "Usuario Pedro_escritura creado en el servidor servidor2"
}
ok: [127.0.0.1] => (item=['Ana', 'lectura', 'servidor1']) => {
    "msg": "Usuario Ana_lectura creado en el servidor servidor1"
}
ok: [127.0.0.1] => (item=['Ana', 'lectura', 'servidor2']) => {
    "msg": "Usuario Ana_lectura creado en el servidor servidor2"
}
ok: [127.0.0.1] => (item=['Ana', 'escritura', 'servidor1']) => {
    "msg": "Usuario Ana_escritura creado en el servidor servidor1"
}
ok: [127.0.0.1] => (item=['Ana', 'escritura', 'servidor2']) => {
    "msg": "Usuario Ana_escritura creado en el servidor servidor2"
}
ok: [127.0.0.1] => (item=['Carlos', 'lectura', 'servidor1']) => {
    "msg": "Usuario Carlos_lectura creado en el servidor servidor1"
}
ok: [127.0.0.1] => (item=['Carlos', 'lectura', 'servidor2']) => {
    "msg": "Usuario Carlos_lectura creado en el servidor servidor2"
}
ok: [127.0.0.1] => (item=['Carlos', 'escritura', 'servidor1']) => {
    "msg": "Usuario Carlos_escritura creado en el servidor servidor1"
}
ok: [127.0.0.1] => (item=['Carlos', 'escritura', 'servidor2']) => {
    "msg": "Usuario Carlos_escritura creado en el servidor servidor2"
}

TASK [Usando el loop con el comando  echo] *************************************
changed: [127.0.0.1] => (item=Juan)
changed: [127.0.0.1] => (item=María)
changed: [127.0.0.1] => (item=Pedro)
changed: [127.0.0.1] => (item=Ana)
changed: [127.0.0.1] => (item=Carlos)

TASK [Mostrar resultado del comando echo] **************************************
ok: [127.0.0.1] => {
    "resultado_echo.results | map(attribute='stdout') | list": [
        " hola --> Juan",
        " hola --> María",
        " hola --> Pedro",
        " hola --> Ana",
        " hola --> Carlos"
    ]
}

TASK [ejecuta comando condicialmente] ******************************************
ok: [127.0.0.1] => {
    "msg": "Fecha del servidor: \"2023-11-09T20:41:50Z\"\nNombre del host: \"lvp-dba-sql03-cln\"\nDirección IP: \"192.10.1.100\"\nDistribución del sistema: \"RedHat RedHat 8.4\"\n"
}

TASK [guardar la informacion en un archivo txt] ********************************
changed: [127.0.0.1 -> localhost]

TASK [Check that the somefile.conf exists] *************************************
ok: [127.0.0.1]

TASK [mostrar el estatus de la carpeta] ****************************************
ok: [127.0.0.1] => {
    "stat_result": {
        "changed": false,
        "failed": false,
        "stat": {
            "exists": false
        }
    }
}

TASK [Crear carpeta /tmp/carpeta_test solo si no existe] ***********************
ok: [127.0.0.1]

TASK [Crear archivo txt /tmp/tu_archivo.txt] ***********************************
changed: [127.0.0.1]

TASK [Agregar texto al final del archivo] **************************************
ok: [127.0.0.1]

TASK [Copiar archivo txt del servidor local a un servidor remoto] **************
ok: [127.0.0.1]

TASK [Eliminar carpeta] ********************************************************
changed: [127.0.0.1]

PLAY RECAP *********************************************************************
127.0.0.1                  : ok=18   changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```




### Bibliografía extras:
List of Behavioral Inventory Parameters ->  https://docs.ansible.com/archive/ansible/2.4/intro_inventory.html <br>

Best Practices -> https://docs.ansible.com/archive/ansible/2.4/playbooks_best_practices.html#best-practices-for-variables-and-vaults <br>


Build Your Inventory --> https://docs.ansible.com/ansible/latest/network/getting_started/first_inventory.html <br>



/ejemplos-ansible/ --> https://github.com/pepesan/ejemplos-ansible/blob/master/26_tests/01_tests.yaml#L144 <br>


Special Variables  --> https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html <br>
 
loops --> https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html 

