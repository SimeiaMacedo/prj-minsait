# Projeto minsait - Terraform Azure VM com Docker, Docker compose, Wordpress e MYSQL.

Este projeto utiliza Terraform para provisionar um máquina virtual na Azure, configurada para instalação de docker, docker compose e implantação de containers WordPress e MYSQL na máquina virtual.

## Pré-requisitos

- Conta na Azure.
- Azure CLI instalado e configurado.
- Terraform instalado.
- Editor de código (Usado o VS Code, mas fica ao seu critério).

## Estrutura
- main.tf :
  Script do Terraform, contendo os recursos para a VM, com direcionamentos para baixar Docker, Docker compose e containers WordPress e MYSQL;
- config.h :
  Configurações para a intalação do Docker, Docker compose e criações de containers WordPress e MYSQL;
- terraform.tfstate:
  Armazenamento o estado da infrainstrutura gerenciada;

## Explicação

1- Uso

- Clonar o repositório do Github;
- Antes de ir para o próximo passo, faça o login do Azure CLI no terminal com o comando az login, em seguida:
- Abra o main.tf no terminal e escreva os comandos:
- terraform init;
- terraform plan;
- terraform apply;
- Confirme na sua conta Azure se foi criada a VM;
- Abra o terminal com seu admin_user + IP público criado na Vm + senha, para certificar que a VM está criada e com suas devidas instalações.

2- Contribuição

Aumento da eficiência de recursos, simplificações e desenvolvimento ágil e continuo.
