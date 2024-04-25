#!/bin/bash
#
################################################################################
# cabecalhoPadrao.sh - Criador de cabecalhos Padroes para Shell Script
#
# DATA: 24/04/2024 17:00 - Versao 1.0.1
#
# ------------------------------------------------------------------------------
# Autor: Luiz Gustavo <luiz.gustavo@avancoinfo.com.br>
#                     <luizgcesar@gmail.com.br>
# site: https://github.com/ketteiGustavo
# ------------------------------------------------------------------------------
# Versao 1: Programa para criar cabecalhos padrao com tratamento de linha de
#           comando.
# Versao 1.0.1: Colocado opcao de cores para os novos scripts.
# ------------------------------------------------------------------------------
# Objetivo: Interface de linha de comando para gerar um cabecalho padronizado em
# Shell Script
#

MENSAGEM_USO="
Programa: $(basename "$0")

--------------------------------------------------------------------------------
                              [OPCOES DISPONIVEIS]

OPCOES NA LINHA DE COMANDO:
    -h, --help      Mostra esta tela de ajuda e sai
    -V, --version   Mostra a versao do programa e sai
    -sh, --shell    Cria um novo Shell Script com um padrao
MODO DE USAR:
digite o nome do programa e a opcao desejada como acima na linha de comando.
  exemplo de uso:
  bash cabecalhoPadrao.sh --help
  'Ira mostrar essa tela de ajuda e sair.'

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
"


###############################

# Funcao para extrair e exibir a versao do programa
mostrar_versao() {
    local versao=$(grep '^# DATA:' "$0" | head -1 | cut -d '-' -f 2 | sed 's/Versao //')
    echo -n "-Programa: $(basename "$0")"
    echo
    echo "-Versao:  $versao"
}

###############################


[ -z "$1" ] && echo "Ofereca uma opcao qualquer, use -h para obter ajuda" && exit 1

###############################


GERAR_CABECALHO(){
    PRIMEIRA_LINHA="#!/bin/bash"
    local NOME_PROGRAMA="$1"
    local DESCRICAO_CURTA="$2"
    local DETALHES_VERSAO="$3"
    local OBJETIVO="$4"

    local HEADER=$(cat <<END
${PRIMEIRA_LINHA}
#
################################################################################
# ${NOME_PROGRAMA}.sh - ${DESCRICAO_CURTA}
#
# DATA: $(date +%d/%m/%Y) $(date +%H:%M) - Versao 1
#
# ------------------------------------------------------------------------------
# Autor: Luiz Gustavo <luiz.gustavo@avancoinfo.com.br>
#                     <luizgcesar@gmail.com.br>
# site: https://github.com/ketteiGustavo
# ------------------------------------------------------------------------------
# Versao 1: ${DETALHES_VERSAO}
# ------------------------------------------------------------------------------
# Objetivo: ${OBJETIVO}.
###############################


MENSAGEM_USO="
Programa: \$(basename "\$0")

--------------------------------------------------------------------------------
                              [OPCOES DISPONIVEIS]

OPCOES NA LINHA DE COMANDO:
    -h, --help      Mostra esta tela de ajuda e sai
    -V, --version   Mostra a versao do programa e sai
MODO DE USAR:

--------------------------------------------------------------------------------
"
#

# -------------------------------------------------------------------------------
# Criando opcoes visuais
# Cores
readonly RED='\e[1;91m'
readonly GREEN='\e[1;92m'
readonly YELLOW='\e[1;93m'
readonly BLUE='\e[1;94m'
readonly MAGENTA='\e[1;95m'
readonly CYAN='\e[1;96m'
readonly NO_COLOR='\e[0m'

# Funcoes mostram as mensagens no terminal com cores
# Funcao para exibir mensagens de erro em vermelho
ERRO_MSG() {
    echo -e "\${RED}[ERROR] - \$1\${NO_COLOR}"
}

# Funcao para exibir mensagens de informacao em verde
INFO_MSG() {
    echo -e "\${GREEN}[INFO] - \$1\${NO_COLOR}"
}

# Funcao para exibir mensagens de alerta em amarelo
ALERTA_MSG() {
    echo -e "\${YELLOW}[ALERTA] - \$1\${NO_COLOR}"
}

# Funcao para exibir mensagens em azul
BLUE_MSG() {
    echo -e "\${BLUE} \$1\${NO_COLOR}"
}

# Funcao para exibir mensagens em magenta
MAGENTA_MSG() {
    echo -e "\${MAGENTA} \$1\${NO_COLOR}"
}

# Funcao para exibir mensagens em ciano
CYAN_MSG() {
    echo -e "\${CYAN} \$1\${NO_COLOR}"
}


# Funcao para extrair e exibir a versao do programa
mostrar_versao() {
    local versao=\$(grep '^# DATA:' "\$0" | head -1 | cut -d '-' -f 2 | sed 's/Versao //')
    echo -n "-Programa: \$(basename "\$0")"
    echo
    echo "-Versao: \$versao"
}

###############################


# Tratamento das opcoes que serao responsaveis por controlar na linha de comando
# ------------------------------------------------------------------------------

case "\$1" in
-h | --help)
    clear
    echo "\$MENSAGEM_USO"
    exit 0
    ;;
-V | --version)
    # Extrai a versao diretamente do cabecalho do programa
    clear
    mostrar_versao
    exit 0
    ;;
*)
    if test -n "\$1"; then
        echo Opcao invalida: \$1
        exit 1
    fi
    ;;
esac

###############################
END
)
    PASTA_DESTINO="/$HOME/Workspaces/Linux_privado/Novos_Shell_Script"

    NOME_PROGRAMA="$1.sh"

    mkdir -p "$PASTA_DESTINO"

    CAMINHO_ARQUIVO="$PASTA_DESTINO/$NOME_PROGRAMA"

	#awk 'NR==1,/^###############################/{print}' <<< "$HEADER" | sed '/^###############################/d' > "$CAMINHO_ARQUIVO"

    echo "$HEADER" > "$CAMINHO_ARQUIVO"

    chmod +x "$CAMINHO_ARQUIVO"
}

# Tratamento das opcoes que serao responsaveis por controlar na linha de comando
# ------------------------------------------------------------------------------

case "$1" in
    -h | --help)
        echo "$MENSAGEM_USO"
        exit 0
        ;;
    -V | --version)
        # Extrai a versao diretamente do cabecalho do programa
        mostrar_versao
        exit 0
        ;;
    -sh | --shell)
        # Gerar cabeçalho em Shell Script
        read -p "Nome do programa: " NOME_PROGRAMA
        read -p "Descricao curta: " DESCRICAO_CURTA
        read -p "Detalhes da Versao 1: " DETALHES_VERSAO
        read -p "Objetivo desse programa: " OBJETIVO
		GERAR_CABECALHO "$NOME_PROGRAMA" "$DESCRICAO_CURTA" "$DETALHES_VERSAO" "$OBJETIVO"
		exit 0
        ;;
    *)
        if test -n "$1"; then
            echo Opcao invalida: $1
            exit 1
        fi
        ;;
esac