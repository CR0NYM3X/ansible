# Para que sirve Ansibe :   
Es una herramienta de automatización de código abierto que se utiliza principalmente para simplificar y automatizar tareas de administración, configuración y orquestación en sistemas informáticos, en simples palabras puedes conectarte remotamente a varios servidores y administrarlos automaticamente

- con ansible existen muchos modulos ya programados para que los utilices, sin necesidad de que crees toda una shell, puedes consultar modulos en las paginas:<br><br>

-> Modulos de ansible: https://docs.ansible.com/ansible/2.9/modules/list_of_all_modules.html<br>
-> Modulos de la comunidad:  https://galaxy.ansible.com <br><br>

Documentación Oficial: https://docs.ansible.com/ansible/latest/index.html



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





# Helps de las herramientas:
- [my_user_test@my_server_hostname]$ ansible -h
```

usage: ansible [-h] [--version] [-v] [-b] [--become-method BECOME_METHOD] [--become-user BECOME_USER] [-K | --become-password-file BECOME_PASSWORD_FILE] [-i INVENTORY]
               [--list-hosts] [-l SUBSET] [-P POLL_INTERVAL] [-B SECONDS] [-o] [-t TREE] [--private-key PRIVATE_KEY_FILE] [-u REMOTE_USER] [-c CONNECTION] [-T TIMEOUT]
               [--ssh-common-args SSH_COMMON_ARGS] [--sftp-extra-args SFTP_EXTRA_ARGS] [--scp-extra-args SCP_EXTRA_ARGS] [--ssh-extra-args SSH_EXTRA_ARGS]
               [-k | --connection-password-file CONNECTION_PASSWORD_FILE] [-C] [--syntax-check] [-D] [-e EXTRA_VARS] [--vault-id VAULT_IDS]
               [--ask-vault-password | --vault-password-file VAULT_PASSWORD_FILES] [-f FORKS] [-M MODULE_PATH] [--playbook-dir BASEDIR] [--task-timeout TASK_TIMEOUT]
               [-a MODULE_ARGS] [-m MODULE_NAME]
               pattern
ansible: error: the following arguments are required: pattern

usage: ansible [-h] [--version] [-v] [-b] [--become-method BECOME_METHOD] [--become-user BECOME_USER] [-K | --become-password-file BECOME_PASSWORD_FILE] [-i INVENTORY]
               [--list-hosts] [-l SUBSET] [-P POLL_INTERVAL] [-B SECONDS] [-o] [-t TREE] [--private-key PRIVATE_KEY_FILE] [-u REMOTE_USER] [-c CONNECTION] [-T TIMEOUT]
               [--ssh-common-args SSH_COMMON_ARGS] [--sftp-extra-args SFTP_EXTRA_ARGS] [--scp-extra-args SCP_EXTRA_ARGS] [--ssh-extra-args SSH_EXTRA_ARGS]
               [-k | --connection-password-file CONNECTION_PASSWORD_FILE] [-C] [--syntax-check] [-D] [-e EXTRA_VARS] [--vault-id VAULT_IDS]
               [--ask-vault-password | --vault-password-file VAULT_PASSWORD_FILES] [-f FORKS] [-M MODULE_PATH] [--playbook-dir BASEDIR] [--task-timeout TASK_TIMEOUT]
               [-a MODULE_ARGS] [-m MODULE_NAME]
               pattern

Define and run a single task 'playbook' against a set of hosts

positional arguments:
  pattern               host pattern

optional arguments:
  --ask-vault-password, --ask-vault-pass
                        ask for vault password
  --become-password-file BECOME_PASSWORD_FILE, --become-pass-file BECOME_PASSWORD_FILE
                        Become password file
  --connection-password-file CONNECTION_PASSWORD_FILE, --conn-pass-file CONNECTION_PASSWORD_FILE
                        Connection password file
  --list-hosts          outputs a list of matching hosts; does not execute anything else
  --playbook-dir BASEDIR
                        Since this tool does not use playbooks, use this as a substitute playbook directory. This sets the relative path for many features including roles/
                        group_vars/ etc.
  --syntax-check        perform a syntax check on the playbook, but do not execute it
  --task-timeout TASK_TIMEOUT
                        set task timeout limit in seconds, must be positive integer.
  --vault-id VAULT_IDS  the vault identity to use
  --vault-password-file VAULT_PASSWORD_FILES, --vault-pass-file VAULT_PASSWORD_FILES
                        vault password file
  --version             show program's version number, config file location, configured module search path, module location, executable location and exit
  -B SECONDS, --background SECONDS
                        run asynchronously, failing after X seconds (default=N/A)
  -C, --check           don't make any changes; instead, try to predict some of the changes that may occur
  -D, --diff            when changing (small) files and templates, show the differences in those files; works great with --check
  -K, --ask-become-pass
                        ask for privilege escalation password
  -M MODULE_PATH, --module-path MODULE_PATH
                        prepend colon-separated path(s) to module library (default=~/.ansible/plugins/modules:/usr/share/ansible/plugins/modules)
  -P POLL_INTERVAL, --poll POLL_INTERVAL
                        set the poll interval if using -B (default=15)
  -a MODULE_ARGS, --args MODULE_ARGS
                        The action's options in space separated k=v format: -a 'opt1=val1 opt2=val2'
  -e EXTRA_VARS, --extra-vars EXTRA_VARS
                        set additional variables as key=value or YAML/JSON, if filename prepend with @
  -f FORKS, --forks FORKS
                        specify number of parallel processes to use (default=5)
  -h, --help            show this help message and exit
  -i INVENTORY, --inventory INVENTORY, --inventory-file INVENTORY
                        specify inventory host path or comma separated host list. --inventory-file is deprecated
  -k, --ask-pass        ask for connection password
  -l SUBSET, --limit SUBSET
                        further limit selected hosts to an additional pattern
  -m MODULE_NAME, --module-name MODULE_NAME
                        Name of the action to execute (default=command)
  -o, --one-line        condense output
  -t TREE, --tree TREE  log output to this directory
  -v, --verbose         Causes Ansible to print more debug messages. Adding multiple -v will increase the verbosity, the builtin plugins currently evaluate up to -vvvvvv. A
                        reasonable level to start is -vvv, connection debugging might require -vvvv.

Privilege Escalation Options:
  control how and which user you become as on target hosts

  --become-method BECOME_METHOD
                        privilege escalation method to use (default=sudo), use `ansible-doc -t become -l` to list valid choices.
  --become-user BECOME_USER
                        run operations as this user (default=root)
  -b, --become          run operations with become (does not imply password prompting)

Connection Options:
  control as whom and how to connect to hosts

  --private-key PRIVATE_KEY_FILE, --key-file PRIVATE_KEY_FILE
                        use this file to authenticate the connection
  --scp-extra-args SCP_EXTRA_ARGS
                        specify extra arguments to pass to scp only (e.g. -l)
  --sftp-extra-args SFTP_EXTRA_ARGS
                        specify extra arguments to pass to sftp only (e.g. -f, -l)
  --ssh-common-args SSH_COMMON_ARGS
                        specify common arguments to pass to sftp/scp/ssh (e.g. ProxyCommand)
  --ssh-extra-args SSH_EXTRA_ARGS
                        specify extra arguments to pass to ssh only (e.g. -R)
  -T TIMEOUT, --timeout TIMEOUT
                        override the connection timeout in seconds (default=10)
  -c CONNECTION, --connection CONNECTION
                        connection type to use (default=smart)
  -u REMOTE_USER, --user REMOTE_USER
                        connect as this user (default=None)

Some actions do not make sense in Ad-Hoc (include, meta, etc)

```


- [my_user_test@my_server_hostname]$ ansible-playbook -h
```
usage: ansible-playbook [-h] [--version] [-v] [--private-key PRIVATE_KEY_FILE] [-u REMOTE_USER] [-c CONNECTION] [-T TIMEOUT] [--ssh-common-args SSH_COMMON_ARGS]
                        [--sftp-extra-args SFTP_EXTRA_ARGS] [--scp-extra-args SCP_EXTRA_ARGS] [--ssh-extra-args SSH_EXTRA_ARGS]
                        [-k | --connection-password-file CONNECTION_PASSWORD_FILE] [--force-handlers] [--flush-cache] [-b] [--become-method BECOME_METHOD]
                        [--become-user BECOME_USER] [-K | --become-password-file BECOME_PASSWORD_FILE] [-t TAGS] [--skip-tags SKIP_TAGS] [-C] [--syntax-check] [-D] [-i INVENTORY]
                        [--list-hosts] [-l SUBSET] [-e EXTRA_VARS] [--vault-id VAULT_IDS] [--ask-vault-password | --vault-password-file VAULT_PASSWORD_FILES] [-f FORKS]
                        [-M MODULE_PATH] [--list-tasks] [--list-tags] [--step] [--start-at-task START_AT_TASK]
                        playbook [playbook ...]

Runs Ansible playbooks, executing the defined tasks on the targeted hosts.

positional arguments:
  playbook              Playbook(s)

optional arguments:
  --ask-vault-password, --ask-vault-pass
                        ask for vault password
  --become-password-file BECOME_PASSWORD_FILE, --become-pass-file BECOME_PASSWORD_FILE
                        Become password file
  --connection-password-file CONNECTION_PASSWORD_FILE, --conn-pass-file CONNECTION_PASSWORD_FILE
                        Connection password file
  --flush-cache         clear the fact cache for every host in inventory
  --force-handlers      run handlers even if a task fails
  --list-hosts          outputs a list of matching hosts; does not execute anything else
  --list-tags           list all available tags
  --list-tasks          list all tasks that would be executed
  --skip-tags SKIP_TAGS
                        only run plays and tasks whose tags do not match these values
  --start-at-task START_AT_TASK
                        start the playbook at the task matching this name
  --step                one-step-at-a-time: confirm each task before running
  --syntax-check        perform a syntax check on the playbook, but do not execute it
  --vault-id VAULT_IDS  the vault identity to use
  --vault-password-file VAULT_PASSWORD_FILES, --vault-pass-file VAULT_PASSWORD_FILES
                        vault password file
  --version             show program's version number, config file location, configured module search path, module location, executable location and exit
  -C, --check           don't make any changes; instead, try to predict some of the changes that may occur
  -D, --diff            when changing (small) files and templates, show the differences in those files; works great with --check
  -K, --ask-become-pass
                        ask for privilege escalation password
  -M MODULE_PATH, --module-path MODULE_PATH
                        prepend colon-separated path(s) to module library (default=~/.ansible/plugins/modules:/usr/share/ansible/plugins/modules)
  -e EXTRA_VARS, --extra-vars EXTRA_VARS
                        set additional variables as key=value or YAML/JSON, if filename prepend with @
  -f FORKS, --forks FORKS
                        specify number of parallel processes to use (default=5)
  -h, --help            show this help message and exit
  -i INVENTORY, --inventory INVENTORY, --inventory-file INVENTORY
                        specify inventory host path or comma separated host list. --inventory-file is deprecated
  -k, --ask-pass        ask for connection password
  -l SUBSET, --limit SUBSET
                        further limit selected hosts to an additional pattern
  -t TAGS, --tags TAGS  only run plays and tasks tagged with these values
  -v, --verbose         Causes Ansible to print more debug messages. Adding multiple -v will increase the verbosity, the builtin plugins currently evaluate up to -vvvvvv. A
                        reasonable level to start is -vvv, connection debugging might require -vvvv.

Connection Options:
  control as whom and how to connect to hosts

  --private-key PRIVATE_KEY_FILE, --key-file PRIVATE_KEY_FILE
                        use this file to authenticate the connection
  --scp-extra-args SCP_EXTRA_ARGS
                        specify extra arguments to pass to scp only (e.g. -l)
  --sftp-extra-args SFTP_EXTRA_ARGS
                        specify extra arguments to pass to sftp only (e.g. -f, -l)
  --ssh-common-args SSH_COMMON_ARGS
                        specify common arguments to pass to sftp/scp/ssh (e.g. ProxyCommand)
  --ssh-extra-args SSH_EXTRA_ARGS
                        specify extra arguments to pass to ssh only (e.g. -R)
  -T TIMEOUT, --timeout TIMEOUT
                        override the connection timeout in seconds (default=10)
  -c CONNECTION, --connection CONNECTION
                        connection type to use (default=smart)
  -u REMOTE_USER, --user REMOTE_USER
                        connect as this user (default=None)

Privilege Escalation Options:
  control how and which user you become as on target hosts

  --become-method BECOME_METHOD
                        privilege escalation method to use (default=sudo), use `ansible-doc -t become -l` to list valid choices.
  --become-user BECOME_USER
                        run operations as this user (default=root)
  -b, --become          run operations with become (does not imply password prompting)

```




- [my_user_test@my_server_hostname]$  ansible-dump -h


```

usage: ansible-inventory [-h] [--version] [-v] [-i INVENTORY] [--vault-id VAULT_IDS] [--ask-vault-password | --vault-password-file VAULT_PASSWORD_FILES] [--playbook-dir BASEDIR]
                         [-e EXTRA_VARS] [--list] [--host HOST] [--graph] [-y] [--toml] [--vars] [--export] [--output OUTPUT_FILE]
                         [host|group]

positional arguments:
  host|group

optional arguments:
  --ask-vault-password, --ask-vault-pass
                        ask for vault password
  --export              When doing an --list, represent in a way that is optimized for export,not as an accurate representation of how Ansible has processed it
  --output OUTPUT_FILE  When doing --list, send the inventory to a file instead of to the screen
  --playbook-dir BASEDIR
                        Since this tool does not use playbooks, use this as a substitute playbook directory. This sets the relative path for many features including roles/
                        group_vars/ etc.
  --toml                Use TOML format instead of default JSON, ignored for --graph
  --vars                Add vars to graph display, ignored unless used with --graph
  --vault-id VAULT_IDS  the vault identity to use
  --vault-password-file VAULT_PASSWORD_FILES, --vault-pass-file VAULT_PASSWORD_FILES
                        vault password file
  --version             show program's version number, config file location, configured module search path, module location, executable location and exit
  -e EXTRA_VARS, --extra-vars EXTRA_VARS
                        set additional variables as key=value or YAML/JSON, if filename prepend with @
  -h, --help            show this help message and exit
  -i INVENTORY, --inventory INVENTORY, --inventory-file INVENTORY
                        specify inventory host path or comma separated host list. --inventory-file is deprecated
  -v, --verbose         Causes Ansible to print more debug messages. Adding multiple -v will increase the verbosity, the builtin plugins currently evaluate up to -vvvvvv. A
                        reasonable level to start is -vvv, connection debugging might require -vvvv.
  -y, --yaml            Use YAML format instead of default JSON, ignored for --graph

Actions:
  One of following must be used on invocation, ONLY ONE!

  --graph               create inventory graph, if supplying pattern it must be a valid group name
  --host HOST           Output specific host info, works as inventory script
  --list                Output all hosts info, works as inventory script

Show Ansible inventory information, by default it uses the inventory script JSON format

```

- [my_user_test@my_server_hostname]$  ansible-config -h

```
usage: ansible-config [-h] [--version] [-v] {list,dump,view,init} ...

View ansible configuration.

positional arguments:
  {list,dump,view,init}
    list                Print all config options
    dump                Dump configuration
    view                View configuration file
    init                Create initial configuration

optional arguments:
  --version             show program's version number, config file location, configured module search path, module location, executable location and exit
  -h, --help            show this help message and exit
  -v, --verbose         Causes Ansible to print more debug messages. Adding multiple -v will increase the verbosity, the builtin plugins currently evaluate up to -vvvvvv. A
                        reasonable level to start is -vvv, connection debugging might require -vvvv.
```








- [my_user_test@my_server_hostname]$   ansible-vault -h

```
usage: ansible-vault [-h] [--version] [-v] {create,decrypt,edit,view,encrypt,encrypt_string,rekey} ...

encryption/decryption utility for Ansible data files

positional arguments:
  {create,decrypt,edit,view,encrypt,encrypt_string,rekey}
    create              Create new vault encrypted file
    decrypt             Decrypt vault encrypted file
    edit                Edit vault encrypted file
    view                View vault encrypted file
    encrypt             Encrypt YAML file
    encrypt_string      Encrypt a string
    rekey               Re-key a vault encrypted file

optional arguments:
  --version             show program's version number, config file location, configured module search path, module location, executable location and exit
  -h, --help            show this help message and exit
  -v, --verbose         Causes Ansible to print more debug messages. Adding multiple -v will increase the verbosity, the builtin plugins currently evaluate up to -vvvvvv. A
                        reasonable level to start is -vvv, connection debugging might require -vvvv.

See 'ansible-vault <command> --help' for more information on a specific command.
```
