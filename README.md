# UniFi Controller Ubuntu Installer

Um script Bash robusto para instalar o UniFi Network Controller em servidores Ubuntu LTS (20.04, 22.04, 24.04).

**Versão do UniFi Controller Alvo:** Este script é projetado para versões do UniFi Controller que ainda dependem do **MongoDB 4.4** e da biblioteca **libssl1.1**. Versões mais recentes do UniFi (especialmente a partir da 8.x) podem empacotar seu próprio MongoDB e não exigir esta abordagem.

**Problema Resolvido:** O UniFi Controller, especialmente em versões mais recentes do Ubuntu (como 22.04 LTS e 24.04 LTS), falha devido a dependências não satisfeitas do **MongoDB 4.4** e da biblioteca **libssl1.1**, que não estão mais nos repositórios padrão.

**Solução:** Este script automatiza a instalação, incluindo a adição temporária do repositório do MongoDB 4.4 e a instalação da `libssl1.1` a partir do repositório de segurança do Ubuntu Focal (20.04), garantindo uma instalação limpa e funcional.
**Atenção:** O uso de repositórios de versões mais antigas do Ubuntu para dependências específicas pode ter implicações de segurança e estabilidade. Use com cautela e sempre verifique a documentação oficial do UniFi para a versão mais recente e compatibilidade.

---

## Pré-requisitos

* Um servidor rodando **Ubuntu Server LTS** (20.04, 22.04, 24.04).
* Acesso SSH ou Console com um usuário que tenha permissões `sudo`.
* Conexão ativa com a internet.

---

## Como Executar o Script

Siga estes passos no seu terminal para baixar e executar o script.

### 1. Baixar o Script

Faça o download do instalador diretamente do repositório no GitHub utilizando o comando git clone:

```bash
git clone https://github.com/Jonathan-Nascimento/unifi-controller-ubuntu-installer.git
```

Isso criará uma cópia local do repositório contendo o script install_unifi_controller.sh no seu servidor.

Após o download, acesse o diretório criado:

```bash
cd unifi-controller-ubuntu-installer
```

**Recomendado:** Antes de executar qualquer script com `sudo`, é uma boa prática revisar seu conteúdo para entender o que ele fará no seu sistema.

```bash
cat install_unifi_controller.sh
```

Dentro dele, você encontrará o script install_unifi_controller.sh, pronto para execução.


### 2\. Dar Permissão de Execução

Torne o script executável:

```bash
chmod +x install_unifi_controller.sh
```

### 3\. Executar a Instalação

Execute o script com privilégios de superusuário:

```bash
sudo ./install_unifi_controller.sh
```

O script cuidará de todo o processo de instalação, incluindo atualizações, instalação de dependências e a correção do MongoDB.

### 4\. Acesso ao Controller

Ao final da execução, o script informará o IP de acesso.

Abra um navegador e acesse:

```
https://[IP_DO_SEU_SERVIDOR]:8443
```

Siga o assistente de configuração inicial do UniFi Controller.
