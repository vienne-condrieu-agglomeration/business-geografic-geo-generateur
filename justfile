# Recettes
@default:
  just --list

init-infra:
  @./init-infra.sh

geo-deployment:
  ansible-playbook -i hosts.ini run.yml --limit geo --tags deployment

geo-setup:
  ansible-playbook -i hosts.ini run.yml --user igeo --private-key ~/.ssh/igeo --limit geo --tags setup

geo-postgresql:
  ansible-playbook -i hosts.ini run.yml --user igeo --private-key ~/.ssh/igeo --limit geo --tags postgresql

# Ansible Vault Encrypt
encrypt:
  @if (grep --quiet "^vault_password_file" ansible.cfg); then ansible-vault encrypt ./vars/vault.yml; else ansible-vault encrypt --vault-password-file bw-vault.sh ./vars/vault.yml; fi

# Ansible Vault Decrypt
decrypt:
  @if (grep --quiet "^vault_password_file" ansible.cfg); then ansible-vault decrypt ./vars/vault.yml; else ansible-vault decrypt --vault-password-file bw-vault.sh ./vars/vault.yml; fi

yamllint:
  yamllint -s .

ansible-lint: yamllint
  #!/usr/bin/env bash
  ansible-lint .
  ansible-playbook run.yml --syntax-check
