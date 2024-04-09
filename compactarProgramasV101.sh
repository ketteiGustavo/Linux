#!/bin/bash
#
# compactarProgramasV101.sh - Cria um pacote com os programas que foram compilados
#
# DATA: 08/04/2024 21:33 - Versao 1.0.1
# ---------------------------------------------------------------------------
# Autor: Luiz Gustavo <luiz.gustavo@avancoinfo.com.br>
# ---------------------------------------------------------------------------
# Versao 1: Compacta programas informados pelo usuario de acordo com o ID card
# informado
# Versao 1.0.1: Altera a forma de leitura dos programas, puxando pelo Card
#
# ---------------------------------------------------------------------------
# Este programa ira compactar os programas respeitando a versao do cobol

# variaveis
ID_CARD=""

DIR40="/u/envio/exec40"
DIR41="/u/envio/exec"

DIRETORIO_SALVO40="/u/envio/compacta/novocobol/"
DIRETORIO_SALVO41="/u/envio/compacta/liberadas/"
prefixo="ID"

# Limpa o terminal putty, para iniciar o menu no topo
clear

MENSAGEM_USO="
Uso: $(basename "$0") [OPCOES]

OPCOES:
  -h, --help      Mostra esta tela de ajuda e sai
  -V, --version   Mostra a versao do programa e sai

  Usando o programa de backup:
    Ao entrar no programa ira se deparar com o menu principal.Devera escolher as
    opcoes de acordo com o numero 1 - fazer compactacao ou 2 - sair.
    A rotina ira ler de acordo com o Card informado os programas que foram com-
    pilados.
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
        # Pergunta ao usuario qual o ID do card
        read -p "Informe o numero do card: " ID_CARD

        # Confirma o numero do card
        read -p "Confirma o card '$prefixo$ID_CARD' informado? (S/N): " confirma_id

        case $confirma_id in
            "S"|"s")
                info_msg "CARD '$prefixo$ID_CARD' confirmado para criar o pacote"
                ID_CARD=$ID_CARD
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


# Função para ler os programas do Card informado
LER_GNT(){
    # Define o nome do arquivo temporário
    ARQTMP="/tmp/$ID_CARD.txt"

    # Executa o comando para obter os programas do cartão e salva no arquivo temporário
    curl -s -X 'GET' "https://avanoinformticaltda.kanbanize.com/api/v2/cards/$ID_CARD" \
    -H 'accept: application/json' -H 'apikey: StoAGNyzFPNw0Pc8Lok4rquCMNDxHPekF6F3fb5U' \
    | grep -oP '\w+\.cbl' | sed 's/\.cbl$//' > "$ARQTMP"
    
    # Verifica se o arquivo temporário foi criado e se está vazio
    if [ ! -s "$ARQTMP" ]; then
        echo "Nenhum programa foi encontrado."
        return
    fi

    # Lê os programas do arquivo temporário
    programas=($(< "$ARQTMP"))

    # Exibe os programas na tela para confirmação
    echo "Programas encontrados para compactacao:"
    for programa in "${programas[@]}"; do
        echo "$programa"
    done

    # Pergunta ao usuário se deseja continuar
    read -p "Deseja prosseguir com a compactacao do(s) programa(s) listado(s) acima? (S/N): " continuar
    case $continuar in
        [Ss]*)
            # Inicia o processo de backup
            BACKUP_GNT ;;
        [Nn]*)
            echo "Operacao cancelada." ;;
        *)
            echo "Entrada invalida. Por favor, responda com 'S' ou 'N'." ;;
    esac

    # Remove o arquivo temporário
    rm -f "$ARQTMP"
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
            rar a -ep "$DIRETORIO_SALVO40$prefixo$ID_CARD$sufixo1.rar" "$DIR40/$programa.gnt"
            chmod +x "$DIRETORIO_SALVO40$ID_CARD$sufixo1.rar"
            info_msg "Compactacao concluida. Pacote '$prefixo$ID_CARD$sufixo1.rar' criado em '$DIRETORIO_SALVO40$ID_CARD$sufixo1.rar'."
        else
            error_msg "Programa '$programa' nao encontrado no diretorio DIR40. Ignorado."
        fi

        # Verifica se o programa existe no diretório DIR41
        if [ -e "$DIR41/$programa.gnt" ]; then
            rar a -ep "$DIRETORIO_SALVO41$prefixo$ID_CARD$sufixo2.rar" "$DIR41/$programa.gnt"
            chmod +x "$DIRETORIO_SALVO41$ID_CARD$sufixo2.rar"
            info_msg "Compactacao concluida. Pacote '$prefixo$ID_CARD$sufixo2.rar' criado em '$DIRETORIO_SALVO41$ID_CARD$sufixo2.rar'."
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
                LER_GNT
                break
                exit
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