#!/bin/bash

# Este script automatiza a instalação do UniFi Network Controller
# em servidores Ubuntu (especialmente 22.04 LTS e 24.04 LTS),
# incluindo as correções necessárias para as dependências do MongoDB 4.4 e libssl1.1.

# --- Configurações ---
JAVA_PACKAGE="openjdk-17-jre-headless"
UNIFI_REPO_KEY_URL="https://dl.ui.com/unifi/unifi-repo.gpg"
UNIFI_REPO_SOURCE="deb [signed-by=/etc/apt/trusted.gpg.d/unifi-repo.gpg] https://www.ui.com/downloads/unifi/debian stable ubiquiti"
MONGO_REPO_KEY_URL="https://www.mongodb.org/static/pgp/server-4.4.asc"
MONGO_REPO_SOURCE="deb [ arch=amd64,arm64 signed-by=/etc/apt/keyrings/mongodb-server-4.4.gpg ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse"
# ---------------------

echo "🚀 Iniciando a instalação do UniFi Network Controller (com correção de dependências)..."

# Função para verificar o sucesso do último comando
check_success() {
    if [ $? -ne 0 ]; then
        echo "❌ ERRO: Falha na etapa $1. Verifique os logs."
        exit 1
    fi
}

# 1. Atualizar e instalar pacotes básicos
echo -e "\n--- 1. Atualizando pacotes básicos e instalando Java ($JAVA_PACKAGE) ---"
sudo apt update
check_success "apt update"
sudo apt upgrade -y
sudo apt install curl gnupg software-properties-common ca-certificates apt-transport-https wget "$JAVA_PACKAGE" -y
check_success "Instalação de pacotes essenciais"

echo -e "\nVersão do Java instalada:"
java -version

# 2. Corrigir dependência: Instalar libssl1.1
echo -e "\n--- 2. Corrigindo dependência: Instalando libssl1.1 (necessário pelo MongoDB 4.4) ---"
# Adiciona temporariamente o repositório de segurança do Ubuntu 20.04 (Focal) 
# para obter o pacote libssl1.1.
echo "deb http://security.ubuntu.com/ubuntu focal-security main" | sudo tee /etc/apt/sources.list.d/focal-security.list > /dev/null

# Atualiza a lista de pacotes para incluir o repositório 'focal'
sudo apt update

# Instala o pacote libssl1.1 a partir do novo repositório
sudo apt install libssl1.1 -y
check_success "Instalação do libssl1.1"

# Remove o repositório 'focal-security' temporário
sudo rm /etc/apt/sources.list.d/focal-security.list

# Atualiza a lista de pacotes novamente (limpando o repositório temporário)
sudo apt update

# 3. Adicionar Repositório do MongoDB 4.4
echo -e "\n--- 3. Adicionando Repositório do MongoDB 4.4 ---"
# Adicionar a chave GPG do MongoDB
curl -fsSL "$MONGO_REPO_KEY_URL" | sudo gpg --dearmor -o /etc/apt/keyrings/mongodb-server-4.4.gpg
check_success "Adição da chave GPG do MongoDB"

# Adicionar o repositório 4.4 do MongoDB
echo "$MONGO_REPO_SOURCE" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list > /dev/null

# 4. Adicionar o Repositório Oficial do UniFi
echo -e "\n--- 4. Adicionando o repositório UniFi da Ubiquiti ---"
# Adicionar a chave GPG do UniFi
sudo wget -O /etc/apt/trusted.gpg.d/unifi-repo.gpg "$UNIFI_REPO_KEY_URL"
check_success "Adição da chave GPG do UniFi"

# Adicionar a source list
echo "$UNIFI_REPO_SOURCE" | sudo tee /etc/apt/sources.list.d/100-ubnt-unifi.list > /dev/null

# 5. Instalar o UniFi Controller
echo -e "\n--- 5. Atualizando a lista de pacotes e instalando o pacote 'unifi' ---"
sudo apt update
sudo apt install unifi -y
check_success "Instalação do UniFi Controller"

# 6. Verificar o Status do Serviço
echo -e "\n--- 6. Verificando o status do serviço UniFi ---"
if sudo systemctl is-active --quiet unifi; then
    echo "✅ UniFi Controller está ativo e rodando!"
else
    echo "❌ O serviço UniFi falhou ao iniciar. Por favor, verifique os logs."
    sudo systemctl status unifi --no-pager
    exit 1
fi

# 7. Informação de Acesso
SERVER_IP=$(hostname -I | awk '{print $1}')
echo -e "\n********************************************************"
echo "🎉 INSTALAÇÃO CONCLUÍDA 🎉"
echo "O UniFi Network Controller está instalado e rodando."
echo "Acesse a interface web através do seu navegador:"
echo -e "\t 👉  https://$SERVER_IP:8443"
echo "********************************************************"
