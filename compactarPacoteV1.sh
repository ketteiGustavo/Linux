#!/bin/bash
#
# compactarPacotes.sh - Cria um pacote com os programas que foram compilados
# 
# DATA: 08/04/2024 21:33 - Versao 1
# ---------------------------------------------------------------------------
# Autor: Luiz Gustavo <luiz.gustavo@avancoinfo.com.br>
# ---------------------------------------------------------------------------
# Versao 1: Compacta programas informados pelo usuario de acordo com o ID card informado
#
#
# ---------------------------------------------------------------------------
# Este programa ira compactar os programas respeitando a versao do cobol

# variaveis
ID_CARD=""

DIR40="/u/envio/exec40"
DIR41="/u/envio/exec"

DIRETORIO_SALVO40="/u/envio/compacta/novocobol/"
DIRETORIO_SALVO41="/u/envio/compacta/liberadas/"

# Limpa o terminal putty, para iniciar o menu no topo
clear

MENSAGEM_USO="
Uso: $(basename "$0") [OPCOES]

OPCOES:
  -h, --help      Mostra esta tela de ajuda e sai
  -V, --version   Mostra a versao do programa e sai

  Usando o programa de backup:
    Ao entrar no programa ira se deparar com o menu principal.Devera escolher as
    opcoes de acordo com o numero 1 - fazer backup ou 2 - sair.
    O programa aceita varios '.gnt', portanto adicione de acordo com a sua neces
    sidade. 
"

# Tratamento das opcoes de linha de comando
if test "$1" = "-h"
then
    echo "$MENSAGEM_USO"
    exit 0
elif test "$1" = "-V"
then
    grep '^# Versao ' "$0" | tail -1 | cut -d : -f 1 | tr -d \#
    exit 0
fi


# Tratamento das opcoes de linha de comando
case "$1" in
    -h | --help)
        echo "$MENSAGEM_USO"
        sleep 100
        exit 0
    ;;
    -V | --version)
        echo -n $(basename "$0")
        # Extrai a versao diretamente dos cabecalhos do programa
        grep '^# Versao ' "$0" | tail -1 | cut -d : -f 1 | tr -d \#
        exit 0
    ;;
    *)
        if test -n "$1"
        then
            echo Opcao invalida: $1
            exit 1
        fi
    ;;
esac

# Cores
readonly RED='\e[1;91m'
readonly GREEN='\e[1;92m'
readonly NO_COLOR='\e[0m'

# Função para exibir mensagens de erro em vermelho
error_msg() {
  echo -e "${RED}[ERROR] - $1${NO_COLOR}"
}

# Função para exibir mensagens de informação em verde
info_msg() {
  echo -e "${GREEN}[INFO] - $1${NO_COLOR}"
}

# Funcao para definir o nome do .rar usando o ID do card
DEFINIR_ID(){
    while true; do
        #definindo prefixo
        prefixo="ID"
        # Pergunta ao usuario qual o ID do card
        read -p "Informe o numero do card: " ID_CARD

        # Confirma o numero do card
        read -p "Confirma o card '$prefixo$ID_CARD' informado? (S/N): " confirma_id

        case $confirma_id in
            "S"|"s")
                info_msg "CARD '$prefixo$ID_CARD' confirmado para criar o pacote"
                ID_CARD="$prefixo$ID_CARD"
                return 0
                ;;
            "N"|"n")
                ;;
            *)
            error_msg "Entrada invalida. Por favor, confirme com 'S' ou 'N'."
                ;;
        esac
    done
}

# Funcao para ler os nomes dos programas
INFORMAR_GNT(){
    programas=()  # Inicializa o array programas
    while true; do
        read -p "Digite o nome do programa, ou ENTER para continuar: " entrada
        if [ -z "$entrada" ]; then
            # Verifica se há programas informados
            if [ ${#programas[@]} -eq 0 ]; then
                echo "Nenhum programa foi informado."
                continue
            fi
            # Exibe os programas informados pelo usuário
            echo "Programas informados para backup:"
            for programa in "${programas[@]}"; do
                echo "$programa"
            done
            # Pergunta ao usuário se deseja informar mais programas
            read -p "Deseja informar mais algum programa? (S/N): " continuar
            case $continuar in
                [Ss]*)
                    continue ;;
                [Nn]*)
                    # Inicia o processo de backup
                    BACKUP_GNT
                    break ;;
                *)
                    echo "Entrada invalida. Por favor, responda com 'S' ou 'N'." ;;
            esac
        else
            programas+=("$entrada")  # Adiciona o nome do programa ao array programas
        fi
    done
}

# Funcao para realizar backup de acordo com os programas informados
BACKUP_GNT() {
    # Verifica se o ID_CARD está definido
    if [ -z "$ID_CARD" ]; then
        error_msg "ID do cartao nao foi definido. Por favor, defina o ID do cartao antes de fazer o backup."
        return 1
    fi

    # Verifica se o array de programas está vazio
    if [ ${#programas[@]} -eq 0 ]; then
        echo "Nenhum programa foi informado para backup."
        return 1
    fi

    # Define sufixo1 e sufixo2
    sufixo1="cobol40"
    sufixo2="cobol41"

    # Loop para fazer backup de cada programa
    for programa in "${programas[@]}"; do
        # Verifica se o programa existe no diretório DIR40
        if [ -e "$DIR40/$programa.gnt" ]; then
            rar a "$DIRETORIO_SALVO40$ID_CARD$sufixo1.rar" "$DIR40/$programa.gnt"
            chmod +x "$DIRETORIO_SALVO40$ID_CARD$sufixo1.rar"
            info_msg "Backup concluido. Pacote '$ID_CARD$sufixo1.rar' criado em '$DIRETORIO_SALVO40$ID_CARD$sufixo1.rar'."
        else
            error_msg "Programa '$programa' nao encontrado no diretorio DIR40. Ignorado."
        fi

        # Verifica se o programa existe no diretório DIR41
        if [ -e "$DIR41/$programa.gnt" ]; then
            rar a "$DIRETORIO_SALVO41$ID_CARD$sufixo2.rar" "$DIR41/$programa.gnt"
            chmod +x "$DIRETORIO_SALVO41$ID_CARD$sufixo2.rar"
            info_msg "Backup concluido. Pacote '$ID_CARD$sufixo2.rar' criado em '$DIRETORIO_SALVO41$ID_CARD$sufixo2.rar'."
        else
            error_msg "Programa '$programa' nao encontrado no diretorio DIR41. Ignorado."
        fi
    done
}

# Funcao para chamar menu
MENU(){
    echo "Menu de compactacao"
    echo "Selecione uma opcao: "
    options=("Compactar programa(s)" "Sair")

    select opt in "${options[@]}"; do
        case $opt in
            "Compactar programa(s)")
                DEFINIR_ID
                INFORMAR_GNT
                ;;
            "Sair")
                info_msg "Saindo..."
                break
                exit
                ;;
            *) error_msg "Opcao invalida"
                ;;
        esac
    done
}


# Chama menu de interacao
MENU