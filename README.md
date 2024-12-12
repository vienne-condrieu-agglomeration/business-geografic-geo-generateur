<h1 align="center">
  <br>
  <a href="https://geo-ressources.vienne-condrieu-agglomeration.fr/"><img src="https://github.com/user-attachments/assets/bda83939-e2e2-4f17-853e-bda6538975e3" alt="Vienne Condrieu Agglomération" width="300px"></a>

  <a href="https://www.business-geografic.com/fr/"><img src="https://github.com/user-attachments/assets/32734be9-eeae-4856-8b52-c2d54aba862e" alt="Business Geographic" width="200px"></a>
  <a href="https://www.business-geografic.com/fr/ressources/documentation.html#geo-technologies-business-geografic-geo-generateur"><img src="https://github.com/user-attachments/assets/74108236-3788-429a-b1e1-9868f2657b13" alt="GEO Generateur" width="200px"></a>

  Infrastructure As Code
  <br>
  <a href="https://www.ansible.com/" target="_blank"><img src="https://img.shields.io/badge/ansible-000000?style=for-the-badge&logo=ansible&logoColor=white" /></a>
  <br>
</h1>

<p align="center">
  <a href="#pourquoi-ce-dépôt-">Pourquoi ce dépôt ?</a> •
  <a href="#pré-requis">Pré-requis</a> •
  <a href="#pré-requis-technique">Pré-requis techniques</a> •
  <a href="#variables-ansible">Variables Ansible</a> •
  <a href="#instructions-de-déploiement">Instructions de déploiement</a> •
  <a href="#coffre-fort-ansible">Coffre-fort Ansible</a> •
  <a href="#crédits">Crédits</a> •
  <a href="#license">License</a>
</p>

# Pourquoi ce dépôt ?

Ce dépôt contient l'ensemble du code Ansible pour déployer et configurer la plateforme GEO sur un conteneur LXC sous Proxmox.

 # Pré-requis

 - Python 3,
 - Ansible,
 - [`just`](https://github.com/casey/just) :
    - Installation : `curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | sudo bash -s -- --to /usr/local/bin`


 # Pré-requis techniques

Business Geografic assure une compatibilité de GEO uniquement sur les versions de Linux suivantes :
- `Ubuntu 18.04 LTS` - `Ubuntu 20.04 LTS` - `Ubuntu 22.04 LTS`
- `Debian 9` - `Debian 10` - `Debian 11`
- `RHEL` - `CentOS 7` - `CentOS 8`

La version initial de ce script a été écrit pour le déploiement et l'installation d'un conteneur LXC tournant sous `Debian 11`.

Pour l'installation d'un serveur `GEO`, il est nécessaire d'avoir les prérequis techniques suivants pour la machine qui va accueillir le `GEO Générateur :

| Processeurs             | configuration «small» : 4 coeurs configuration «medium» : 8 coeurs configuration «large» : Cluster de serveurs « medium », nous consulter.                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
|-------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Mémoire vive RAM        | configuration «small» : 10 Go de RAM (12 Go sous Windows Server) configuration «medium» : 12 Go de RAM (14 Go sous Windows Server) configuration «large» : Cluster de serveurs « medium », nous consulter                                                                                                                                                                                                                                                                                                                                                                                                    |
| Disque dur performance  | Disque rapide (10K RPM conseillé)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| Disque dur Volumétrie   | Système d’exploitation : voir prérequis du système + Volume des données + 5 Go pour l’installation GEO (applicatif + logs) + volume pour les caches de tuile + volume des données raster fichier si nécessaire.                                                                                                                                                                                                                                                                                                                                                                                              |
| Carte réseau            | 1Gb/s                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| Système d’exploitation  | Linux (Versions 64 bits exclusivement) : - Ubuntu 18.04 LTS-20.04 LTS / Debian 9-10 / RHEL-CentOS 7 - Ubuntu 22.04 LTS / Debian 11 / RHEL 8 Ci-dessous la liste des versions Linux exigeant l’installeur spécifique « Linux avec GDAL LTS » : - Ubuntu 18.04 LTS - Debian 9-10-11 - RHEL-CentOS 7 Pour les versions Linux ci-dessous, veuillez utiliser l’installeur standard : - Ubuntu 20.04 LTS - Ubuntu 22.04 LTS - RHEL 8 Windows Server (Versions 64 bits exclusivement) : - 2012 R2 et supérieures jusqu’à Windows Server 2022 inclus. (L’option Server Core – sans IHM -- n’est pas prise en charge) |
| Serveur Web             | Apache 2.4 / nginx Remarque : dans le cadre du règlement général sur la protection des données (RGPD), l’utilisation d’un certificat SSL est désormais obligatoire pour toute utilisation de GEO comprenant des données personnelles de citoyens européens (Cadastre, GEOxalis...)                                                                                                                                                                                                                                                                                                                           |
| Environnement           | Java - OpenJDK 8 x64 (distribution « Temurin »). - Java > 8 non supporté pour le moment. - PostgreSQL (x64) v9.6 à 13 et PostgreSQL 15. - PostGIS 2.5 / 3 - Python 3                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| Navigateurs compatibles | FF : ESR+ - Chrome : Version courante - EDGE : Version courante - Safari : Version courante - Opéra : Version courante                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
|                         |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |



# Variables Ansible

Les variables `secrètes` sont répertoriées ci-dessous dans le fichier `vars/vault.yml` :
```yaml
# vars/vault.yml
---
secret:
  ssh:
    port: "22"

  user:
    me:
      name: myuser
      password: "my_password"
      uid: 1000
      gid: 1000
      group: myuser
      groups: sudo
      create_home: true
      home: /home/myuser
      system: false
      comment: "Administrateur SIG"
      ssh:
        pubkey: "My SSH Pubkey"
    geo:
      name: geo
      password: "my_password"
      uid: 1001
      gid: 1001
      group: geo
      groups: sudo
      create_home: true
      home: /home/geo
      system: false
      comment: Utilisateur GEO
      ssh:
        pubkey: "My SSH Pubkey"
    pve:
      ssh:
        user: root
        pam: root@pam
        password: "my_password"
    lxc:
      ssh:
        user: root
        password: "my_password"
    
  proxmox:
    pve:
      api:
        node: pve
        host: 192.168.100.100
        user: "root@pam"
        password: "#my_password"
        token_id: "ansible"
        token_secret: "my_token"

  github:
    api:
      user: my_github_user
      token: "my_github_token"
      token_name: "ansible-api-access"
      auth: yes
```

Elles sont surchargées dans les fichiers de variables de rôle `roles/deployment/defaults/main.yml` et `roles/setup/defaults/main.yml` :

```yaml
# roles/deployment/defaults/main.yml
---
ssh:
  port: "{{ secret.ssh.port }}"

user:
  me:
    name: "{{ secret.user.me.name }}"
    password: "{{ secret.user.me.password }}"
    uid: "{{ secret.user.me.uid }}"
    gid: "{{ secret.user.me.gid }}"
    group: "{{ secret.user.me.group }}"
    groups: "{{ secret.user.me.groups }}"
    create_home: true
    home: "{{ secret.user.me.home }}"
    system: false
    comment: "{{ secret.user.me.comment }}"
    ssh:
      pubkey: "{{ secret.user.me.ssh.pubkey }}"
  pve:
    ssh:
      user: "{{ secret.user.pve.ssh.user }}"
      pam: "{{ secret.user.pve.ssh.pam }}"
      password: "{{ secret.user.pve.ssh.password }}"
  lxc:
    ssh:
      user: "{{ secret.user.lxc.ssh.user }}"
      password: "{{ secret.user.lxc.ssh.user }}"
  
proxmox:
  pve:
    api:
      node: "{{ secret.proxmox.pve.api.node }}"
      host: "{{ secret.proxmox.pve.api.host }}"
      user: "{{ secret.proxmox.pve.api.user }}"
      password: "{{ secret.proxmox.pve.api.password }}"
      token_id: "{{ secret.proxmox.pve.api.token_id }}"
      token_secret: "{{ secret.proxmox.pve.api.token_secret }}"
  lxc:
    name: geo
    vmid: 199
    cores: 4
    cpus: "1"
    cpuunits: "1000"
    disk: "local-zfs:32"       # pve-storage-name:size-of-volume(GO)
    nesting: 1
    keyctl: 0
    fuse: 0
    memory: 8192
    nameserver: 192.168.0.253
    ip: 192.168.10.99
    gw: 192.168.10.1
    unprivileged: false       # true | false
    onboot: true
    startup: "order=99"
    ostemplate: "iso:vztmpl/debian-11-standard_11.7-1_amd64.tar.zst"
    password: "{{ secret.user.lxc.ssh.password }}"
    pubkey: "{{ secret.user.me.ssh.pubkey }}"
    storage: "local-zfs"
    storage_template: "iso"
    swap: "512"
    tags:
      - myctlxc
      - prod
    timezone: "{{ timezone }}"
    description: |
      <div align="center">
      <a href="https://geo-ressources.vienne-condrieu-agglomeration.fr/"><img src="https://github.com/user-attachments/assets/bda83939-e2e2-4f17-853e-bda6538975e3" alt="Vienne Condrieu Agglomération" width="100px"></a>

      # GEO Plateforme

      <a href="https://www.business-geografic.com/fr/"><img src="https://github.com/user-attachments/assets/32734be9-eeae-4856-8b52-c2d54aba862e" alt="Business Geographic" width="80px"></a>
      <a href="https://www.business-geografic.com/fr/ressources/documentation.html#geo-technologies-business-geografic-geo-generateur"><img src="https://github.com/user-attachments/assets/74108236-3788-429a-b1e1-9868f2657b13" alt="GEO Generateur" width="80px"></a>
      </div>
```

```yaml
# roles/setup/defaults/main.yml
---
#LOCALE
locale:
  short: "fr_FR"
  long: "fr_FR.UTF-8"
    
# MOTD
figurine:  
  install_login_script: true
  font: "3d.flf"
  arch: amd64

# PACKAGES
default_packages:
  - apt-transport-https
  - bash-completion
  - ca-certificates
  - curl
  - duf
  - git
  - gpg
  - htop
  - inxi
  - lm-sensors
  - lsb-release
  - openssh-client
  - openssh-server
  - python3
  - python3-psutil
  - progress
  - sudo
  - tree
  - vim
  - wget

bash_aliases:
  - { alias: "ls", command: "ls --color=auto" }
  - { alias: "ll", command: "ls -hl --color=auto" }
  - { alias: "la", command: "ls -hal --color=auto" }
  - { alias: "c", command: "clear" }
  - { alias: "grep", command: "grep --color=auto" }
  - { alias: "mkdir", command: "mkdir -pv" }
  - { alias: "dcp", command: "docker compose up -d"}
  - { alias: "dcd", command: "docker compose down"}
  - { alias: "dtail", command: "docker logs -tf --tail='50' "} 
  - { alias: "z", command: "zellij" }
  - { alias: "vi", command: "vim" }
  - { alias: "geo", command: "/opt/geo/bin/geo.sh" }
```

# Instructions de déploiement

- `just init-infra` :
    - Installation de la libraire [`just`](https://github.com/casey/just),
    - Installation des rôles Ansible requis (requirements.yml),
    - Installation des collections Ansible requises (requirements.yml),
    - Installation d'un hook github pour éviter de partager sur le dépôt un fichier de coffre-fort non crypté [(en savoir +)](https://github.com/allfab/infrastructure/tree/main?tab=readme-ov-file#ma-gestion-des-secrets).

- `just geo-deployment` :
    - Exécute la commande `ansible-playbook -i hosts.ini run.yml --limit geo --tags deployment`
    - Ce playbook déploit un conteneur LXC sur un noeud Proxmox Virtual Environment :
        - `roles/deployment` : Déploiement du conteneur LXC avec l'ensemble des options spécifiées dans le fichier `defaults/main.yml`,
        
- `just geo-setup` : 
  - Exécute la commande `ansible-playbook -i hosts.ini run.yml --user myuser --private-key ~/.ssh/mysshpubkey --limit geo --tags setup` avec `user` pour l'utilisateur initial (`user` dans l'exemple à modifier suivant votre nom d'utilisateur) :
  - Ce playbook exécute les roles suivant :
    - `roles/setup` : Installe et configure les différents logiciels et outils nécessaire sur le conteneur LXC pour son administration,
    - `roles/postgresql` : Installe et configure PostgreSQL nécessaire au stockage des données du backoffice `GEO`,
    - `roles/geo` : Installe et configure la plateforme `GEO`.


# Coffre-fort Ansible

## Raccourcis

- `just encrypt` - Chiffre le coffre-fort Ansible :
  - Exécute la commande `ansible-vault encrypt --vault-password-file bw-vault.sh ./vars/vault.yml;`
- `just decrypt` - Décrypte le coffre-fort Ansible :
  - Exécute la commande `ansible-vault decrypt --vault-password-file bw-vault.sh ./vars/vault.yml;`

## PRÉREQUIS : `ansible-vault` - Chiffrement des fichiers vault.yml

### Qu'est-ce qu'Ansible Vault ?

Ansible `Vault` (coffre-fort en français) est une fonctionnalité d'Ansible qui nous permet de conserver des données sensibles telles que des mots de passe, des clés SSH, de certificats SSL, des jetons d'API et tout ce que vous ne voulez pas que le public découvre en parcourant votre dépôt Github, plutôt que de les stocker sous un format brut dans des playbooks ou des rôles.

Il est courant de stocker de telles configurations dans un contrôleur de version tel que git. Nous avons donc besoin d'un moyen de stocker ces données secrètes en toute sécurité.

Le `Vault` est la réponse à notre besoin, puisqu'il permet de chiffrer n'importe quoi à l'intérieur de nos fichiers YAML. Ces données de Vault peuvent ensuite être distribuées ou placées dans le contrôle de code source tel que `git`.

### Ma gestion des secrets

Dans ce projet, j'ai combiné l'utilisation de plusieurs outils pour ma gestion des secrets :
- [`Ansible Vault`](https://docs.ansible.com/ansible/latest/cli/ansible-vault.html),
- [`Bitwarden command-line interface (CLI)`](https://bitwarden.com/help/cli/), qui est l'outil en ligne de commande de [`Bitwarden`](https://bitwarden.com/) qui s'intègre très bien avec l'implémentation alternative de l'API du serveur Bitwarden - [`Vaultwarden`](https://github.com/dani-garcia/vaultwarden) - parfaite pour un déploiement auto-hébergé,
- les `hooks GIT` (notamment avec les hooks de `pre-commit`) afin de ne pas commiter mes fichiers `vault.yml` en clair sur ce dépôt,
- le script `git-vault-check.sh` qui va me permettre de vérifier si le fichier `vault.yml` est crypté ou non.
- les fonctions contenues dans le fichier `justfile` qui vont me permettre de crypter et/ou de décryper les fichiers `vault.yml` présents dans le projet.

# Crédits

Script Ansible écrit grâce à la documentation de Business Geographic.

# Licence

À définir