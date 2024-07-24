#!/bin/bash
# Instalação do Docker
set -e

apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update -y
apt-get install -y docker-ce
systemctl start docker
systemctl enable docker

# Instalação do Curl
apt install -y curl

# Instalação do Docker Compose 
curl -L "https://github.com/docker/compose/releases/download/v2.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Dando permissão de execução ao Docker Compose
chmod +x /usr/local/bin/docker-compose

# Criação da pasta para as aplicações
mkdir -p /opt/aplicacoes

# Criar o arquivo docker-compose.yml
cat <<EOF > /opt/aplicacoes/docker-compose.yml
version: '3.8'

services:
  db:
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "3306:3306"
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: GAud4mZby8F3SD6P
      MYSQL_DATABASE: wordpress
      MYSQL_USER: simeia-macedo
      MYSQL_PASSWORD: GAud4mZby8F3SD6P

  wordpress:
    image: wordpress:latest
    depends_on:
      - db
    volumes:
      - wordpress_data:/var/www/html
    ports:
      - "8080:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: simeia-macedo
      WORDPRESS_DB_PASSWORD: GAud4mZby8F3SD6P
      WORDPRESS_DB_NAME: wordpress

volumes:
  db_data:
  wordpress_data:
EOF

# Criando arquivo init.sql
cat <<EOF > /opt/aplicacoes/init.sql

GRANT ALL PRIVILEGES ON WORDPRESS TO 'simeia'@'%';
FLUSH PRIVILEGES;
EOF

# Iniciar os containers com o Docker Compose
cd /opt/aplicacoes
docker-compose up -d
