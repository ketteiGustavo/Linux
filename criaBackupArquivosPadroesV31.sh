#!/bin/bash
#
# criaBackupArquivosPadroes.sh - Cria backup de principais arquivos do cliente
#
# DATA: 18/03/2024 07:15 - Versão 1
# ------------------------------------------------------------------------------
# UPDATE E MODIFICAÇÕES
# DATA: 25/03/2024 09:00 - Updates para versão 3.0.2
# ------------------------------------------------------------------------------
# Autor:    Luiz Gustavo <luiz.gustavo@avancoinfo.com.br>
# Co-Autor: Fabio Silva
#
# Versão 1: Compactava todos arquivos somente com uma opção de mês e ano
# Versão 2: Opção de selecionar mais de um mês para criar o backup
# Versão 3: Melhoria de menu e opções para backup, podendo realizar backup's
#           de mais meses e até outros anos caso necessário, além de escolher
#           criar os backups de forma separada, podendo compactar somente os
#           arquivos que tem MMAA e AAMM no nome, os arquivos sem data ou ambos
# Versão 3.0.2 : Adicionado confirmações ao programa, para exitar que seja ini-
#                ciado o backup sem confirmar o que foi escolhido
# Versão 3.1.0 : Adicionando opções melhores para o manual com o comando --help
#                e opção para ver a versão atual com o --version
#
#
#
# ------------------------------------------------------------------------------
# Este programa recebe um nome para o arquivo que será criado como backup de
# acordo com o informado pelo usuário, e irá compactar os arquivos mais comuns
# que são necessários para realizar testes e validações internas. Favor comuni-
# car ao clienter a necessidade de trazer os arquivos para que seja enviado o
# e-mail solicitando o acesso aos arquivos do servidor do cliente.
# ------------------------------------------------------------------------------
# Caso necessite de algum arquivo que não se encontra na lista dos que estão dis-
# poníveis nesse script, por favor nos acione que iremos adicionar par que possa
# facilitar cada vez mais a sua utilização.
#
#
#
#
#
#
#
#


# Limpa o terminal putty, para iniciar o menu no topo
clear

MENSAGEM_USO="
Uso: $(basename "$0") [OPÇÕES]

OPÇÕES:
  -h, --help      Mostra esta tela de ajuda e sai
  -V, --version   Mostra a versão do programa e sai

  Usando o programa de backup:
    Ao entrar no script irá se deparar com o menu principal. Deverá escolher as
    opções de acordo com a Letra entre []. O programa irá reconhecer tanto letras
    maiusculas quanto letras minusculas.
    Vamos a um exemplo o usuário irá realizar o backup dos arquivos que tem as
    opções de data em seu nome, exemplo do arquivo: mv2403 que está no diretório
    /u/sist/arqm/mvAAMM. Foi feito uma variavél que irá colocar a data (ano e mes)
    que deseja na busca antes da compactação.
"

# Tratamento das opções de linha de comando
if test "$1" = "-h"
then
    echo "$MENSAGEM_USO"
    exit 0
elif test "$1" = "-V"
then
    grep '^# Versão ' "$0" | tail -1 | cut -d : -f 1 | tr -d \#
    exit 0
fi


# Tratamento das opções de linha de comando
case "$1" in
    -h | --help)
        echo "$MENSAGEM_USO"
        sleep 100
        exit 0
    ;;
    -V | --version)
        echo -n $(basename "$0")
        # Extrai a versão diretamente dos cabeçalhos do programa
        grep '^# Versão ' "$0" | tail -1 | cut -d : -f 1 | tr -d \#
        exit 0
    ;;
    *)
        if test -n "$1"
        then
            echo Opção inválida: $1
            exit 1
        fi
    ;;
esac


# Funcao para exibir o menu
DISPLAY_MENU() {
    echo "________________________________________________________"
    echo "| Manual de utilizacao:                                 |"
    echo "| Opcoes disponiveis:                                   |"
    echo "|    [I]nicio    : Menu inicial                         |"
    echo "|    [T]otal     : backup total do script               |"
    echo "|    [P]arcial   : backup dos arquivos                  |"
    echo "|    [M]eses     : backup dos arquivos de mes e ano     |"
    echo "|    [H]elp      : acessar o menu de ajuda              |"
    echo "|    [L]istar    : listar arquivos                      |"
    echo "|    [S]air      : Sair do script                       |"
    echo "|_______________________________________________________|"
}

# Funcao para exibir o manual
DISPLAY_MANUAL() {
    echo "Manual de utilização:"
    echo "Opções disponíveis:"
    echo "  [I]nicio    : Voltar ao menu principal"
    echo "  [T]otal     : Realizar backup total (faz o backup de todos os \
arquivos de acordo com a programação do script)"
    echo "  [P]arcial   : Realizar backup dos arquivos (faz o backup dos \
arquivos previamente configurados)"
    echo "  [M]eses     : Realizar backup dos arquivos de meses (faz o backup \
dos arquivos com datas específicas)"
    echo "  [H]elp      : Exibir o menu de ajuda (mostra este menu novamente)"
    echo "  [L]istar    : Listar a lista completa dos arquivos que são \
compactados na execução desse script."
    echo "  [S]air      : Sair do script (encerra a execução do script)"
    echo ""
    echo "Exemplos de uso:"
    echo "--------------------------------------------------------------------------"
    echo "  Para realizar um backup total, acesse a opção do menu com a letra \
'T' e informe um nome que deseja utilizar para identificar o backup! Após \
isso será iniciado a validação das datas para os arquivos que contém datas \
no nome, podendo assim escolher determinados meses de um ano."
    echo "--------------------------------------------------------------------------"
    echo "  Para realizar um backup parcial, acesse a opção do menu com a letra \
'P' e informe um nome que deseja utilizar para identificar o backup!"
    echo "--------------------------------------------------------------------------"
    echo "  Para realizar um backup de arquivos de um mês específico, acesse a \
opção do menu com a letra 'M', informe um nome que deseja utilizar para \
identificar o backup e prossiga com a validação das datas dos arquivos. Será \
perguntando quantos meses deseja utilizar, informe até 3 meses por backup, \
respeitando o padrão com dois digitos. Ex.: 'Quantos meses deseja compactar \
(ate 3 meses)?'. 3 'Digite o(s) mes(es) (MM MM MM) que deseja compactar... \
01 02 03.'. Após informe o ano que deseja usar. 'Ex.: Digite o ano que deseja \
usar (apenas 2 digitos):' 19 Dessa forma será realizado o backup dos arquivos \
que tenham as combinações de 0119 0219 0319 ou 1901 1902 1903 no nome. Caso \
seja informado qualquer padrão inválido durante a utilização do backup, \
será retornado uma mensagem de aviso na tela para o usuário"
    echo "--------------------------------------------------------------------------"
    echo "  Para listar os arquivos que serão compactados, acesse a opção do \
menu com a letra 'L'. Caso necessite de algum outro arquivo que não se \
encontra nesse programa, por favor execute a compactação manual e nos \
informe posteriormente para adicionar na próxima versão"
    echo "  Para exibir o menu de ajuda, acesse a pção do menu com a letra 'H'"
    echo "  Para sair do script, aperte a letra 'S'. Será necessário confirmar \
que deseja sair novamente."
    echo ""
    echo ""
}

# Funcao para definir o nome do arquivo de backup
DEFINIR_NOME(){
    while true; do
        # Pergunta ao usuario o nome que deseja usar no arquivo de backup
        read -p "Digite o nome para o arquivo de 'Backup'  " NOME_BKP

        # Confirma ao usuario o nome digitado
        read -p "Deseja usar o nome '$NOME_BKP' para esse backup? (S/N)  " confirma_nome

        case $confirma_nome in
            "s"|"S")
                echo "Sera usado o seguinte nome para o backup: '$NOME_BKP'"
                return 0 # encerra o loop do nome
                ;;
            "n"|"N")
                ;;
            *)  # Opção padrão caso nenhuma correspondência seja encontrada
            echo "Entrada invalida. Por favor, confirme com 'S' ou 'N'."
            ;;
        esac
    done
}

# Funcao para listar os nomes e caminhos dos arquivos que serao realizados os backups
listar_arquivos(){
    echo "diretorios"
    echo "/u/arq/*"
    echo "/u/arq/sp01*03"
    echo "/u/arq/sp01a22*"
    echo "/u/arq/sp01a25*"
    echo "/u/arq/sp02a25*"
    echo "/u/arq/so02a11*"
    echo "/u/arq/sp01a18*"
    echo "/u/arq/sp06a42*"
    echo "/u/arq/sp04a93*"
    echo "/u/arq/sp01v04*"
    echo "/u/arq/sp01a43*"
    echo "/u/arq/sp03a32*"
    echo "/u/arq/sp01a02*"
    echo "/u/arq/sp01a08*"
    echo "/u/arq/sp01a34*"
    echo "/u/arq/sp02a79*"
    echo "/u/arq/sp04a21*"
    echo "/u/sist/arq/sp01a00*"
    echo "/u/sist/arq/sp01a01*"
    echo "/u/sist/arq/sp03080*"
    echo "/u/sist/arq/sp01a07*"
    echo "/u/sist/arq/sp01a16*"
    echo "/u/sist/arq/sp01a04*"
    echo "/u/sist/arq/sp01a77*"
    echo "/u/sist/arqf/sp03a13*"
    echo "/u/sist/arqf/sp19*"
    echo "/u/sist/arqf/sp03a12*"
    echo "/u/sist/arqf/sp04a80*"
    echo "/u/sist/arqf/sp04a81*"
    echo "/u/sist/arqf/sp06a62*"
    echo "/u/sist/sped/sp*"
    echo "/u/sist/arqv/sp01a80*"
    echo "/u/sist/arqv/sp04a46*"
    echo "/u/sist/arqv/vd01a80*"
    echo "/u/sist/arqv/v04a46*"
    echo "/u/sist/arqv/vs04a01*"
    echo "/u/sist/arqa/sp01z03*"
    echo "/u/sist/arqd/sp01d01*"
    echo "/u/sist/arqd/sp01o03*"
    echo "  "
    echo "Arquivos com datas"
    echo "/u/sist/arqf/*MMAA*"
    echo "/u/sist/arqf/*AAMM*"
    echo "/u/sist/arqm/mvAAMM*"
    echo "/u/sist/arqf/gnrenAAMM*"
    echo "/u/sist/arqi/es*AAMM*"
    echo "/u/sist/arqi/in*AAMM*"
    echo "/u/sist/sped/obsAAMM*"
    echo "/u/sist/sped/ajitensAAMM*"
    echo "/u/sist/sped/apu*AAMM*"
    echo "/u/sist/arqv/*AAMM*"

}



# Funcao para executar backup dos Meses
BACKUP_MESES(){
# Pergunta ao usuario quantas datas deseja usar (limitado a 3)
    while true; do
        read -p "Quantos meses deseja compactar (ate 3 meses)? " quantidade_meses

        # Verifica se a quantidade fornecida e um numero inteiro entre 1 e 3
        if [[ $quantidade_meses =~ ^[1-3]$ ]]; then
        break
        else
        echo "Quantidade invalida. Por favor, insira um numero entre 1 e 3."
        fi
    done

    # Pergunta ao usuario quais meses deseja usar, separados por espaço e confirma o que foi digitado
    while true; do

        read -p "Digite o(s) mes(es) (MM MM MM) que deseja compactar (ate '$quantidade_meses' mes(es)): " meses_input

        # Validador de meses
        meses_invalidos=0
        for mes in $meses_input; do
            if [[ $mes -lt 1 || $mes -gt 12 ]]; then
                meses_invalidos=1
                break
            fi
        done

        if [[ $meses_invalidos -eq 1 ]]; then
            echo "Por favor, insira apenas valores de mes entre 1 e 12."
        else
            # Conta o numero de meses informados acima
            num_meses=$(echo "$meses_input" | wc -w)


            # Verificar a quantidade digitada para nao permitir digitar meses a mais.
            if [[ $num_meses -gt $quantidade_meses ]]; then
                echo "Foi informado apenas '$quantidade_meses' mes(es). Por favor respeite a quantidade informada."
            else
                read -p "Deseja realmente usar o(s) mes(es) '$meses_input' informado(s) (S/N)?  " confirma_meses

                case $confirma_meses in
                    "S"|"s")
                        echo "Sera realizado o backup com o(s) mes(es) informado(s) '$meses_input' "
                        break
                        ;;
                    "N"|"n")
                        clear
                        echo "Digite novamente o(s) mes(es). "
                        ;;
                    *)  # Opção padrão caso nenhuma correspondência seja encontrada
                        echo "Entrada invalida. Por favor, confirme com 'S' ou 'N'."
                        ;;
                esac
            fi
        fi
    done

    # Pergunta ao usuario qual ano deseja usar (limitado a 2 dígitos)
    while true; do
    read -p "Digite o ano que deseja usar (apenas 2 digitos): " ano
    # Verifica se o ano fornecido tem exatamente 2 digitos
        if [[ $ano =~ ^[0-9]{2}$ ]]; then
        break
        else
        echo "Ano invalido. Por favor, insira apenas 2 digitos para o ano."
        fi
    done

    # Divide a entrada em um array de meses
    read -ra meses <<< "$meses_input"

    # Solicitacao de confirmacao para iniciar o backup dos arquivos gerais
    read -p "Confirma o backup dos arquivos do(s) mes(es) '$meses_input' do ano '20$ano'? (S/N)" confirma_backups

    # Verifica se a entrada foi 'S' ou 's' para iniciar o backup, do contrario volta ao menu principal
    if [[ $confirma_backups =~ ^[Ss]$ ]]; then
    echo "Iniciando Backup..."

        # Loop para compactar os arquivos correspondentes a cada data fornecida
        for mes in "${meses[@]}"; do
            echo "Sera compactado os arquivos que contenham o(s) mes(es) '$meses_input' e o ano '$ano'."
            # Constrói o padrão para a data no formato MMAA
            padrao_mmaa="$mes$ano"
            rar a "$NOME_BKP" "sist/arqf/*${padrao_mmaa}*"          # fiscal  --- livros fiscais (fsLLMMAA, leLLMMAA, mpLLMMAA, alLLMMAA)
            # Constrói o padrão para a data no formato AAMM
            padrao_aamm="$ano$mes"
            rar a "$NOME_BKP" "sist/arqf/*${padrao_aamm}*"     
            rar a "$NOME_BKP" "sist/arqm/mv${padrao_aamm}*"         # movimento
            rar a "$NOME_BKP" "sist/arqf/gnren${padrao_aamm}*"      # gnre
            rar a "$NOME_BKP" "sist/arqi/es*${padrao_aamm}*"        # inventario
            rar a "$NOME_BKP" "sist/arqi/in*${padrao_aamm}*"        # inventario
            rar a "$NOME_BKP" "sist/sped/obs${padrao_aamm}*"        # observacao
            rar a "$NOME_BKP" "sist/sped/ajitens${padrao_aamm}*"    # ajuste
            rar a "$NOME_BKP" "sist/sped/apu*${padrao_aamm}*"       # apuracao
            rar a "$NOME_BKP" "sist/arqv/*${padrao_aamm}*"          # vendas cf
            echo "Backup do(s) arquivo(s) do(s) mes(es) '$meses_input' do ano '20$ano' concluido! O nome do backup usado foi '$NOME_BKP' "
            echo "Caso deseje realizar mais algum backup utilize o 'Menu' novamente!"
        done

    elif [[ $confirma_backups =~ ^[Nn]$ ]]; then
        clear
        echo "Retornando ao menu..."
        
    else
        echo "Entrada invalida. Por favor, confirme com 'S' ou 'N'."
    fi
    
}

# Funcao para executar backup Arquivos
BACKUP_ARQUIVOS(){
    # Solicitacao de confirmacao para iniciar o backup dos arquivos gerais
    read -p "Confirma o backup dos arquivos descritos na lista de arquivos? (S/N)" confirma_backup2

    # Verifica se a entrada foi 'S' ou 's' para iniciar o backup, do contrario volta ao menu principal

    if [[ $confirma_backup2 =~ ^[Ss]$ ]]; then
    echo "Iniciando Backup..."

    rar a "$NOME_BKP" arqh/*                    # cad usuario
    rar a "$NOME_BKP" arq/sp01*03*              # produtos
    rar a "$NOME_BKP" arq/sp01a22*              # cod barras
    rar a "$NOME_BKP" arq/sp01a25*
    rar a "$NOME_BKP" arq/sp02a25*
    rar a "$NOME_BKP" arq/sp02a11*
    rar a "$NOME_BKP" arq/sp01a18*
    rar a "$NOME_BKP" arq/sp06a42*
    rar a "$NOME_BKP" arq/sp04a93*
    rar a "$NOME_BKP" arq/sp01v04*
    rar a "$NOME_BKP" arq/sp01a43*              # cidades
    rar a "$NOME_BKP" arq/sp03a32*              # plano contas
    rar a "$NOME_BKP" arq/sp01a02*              # setor e grupo
    rar a "$NOME_BKP" arq/sp01a08*              # plano contas gerencial
    rar a "$NOME_BKP" arq/sp01a34*              # cad transportadora
    rar a "$NOME_BKP" arq/sp02a79*              # vinc cliente
    rar a "$NOME_BKP" arq/sp04a21*              # vinc cidade
    rar a "$NOME_BKP" sist/arq/sp01a00*         # parametro
    rar a "$NOME_BKP" sist/arq/sp01a01*         # filial
    rar a "$NOME_BKP" sist/arq/sp03a80*         # filial
    rar a "$NOME_BKP" sist/arq/sp01a07*         # contas pagar
    rar a "$NOME_BKP" sist/arq/sp01a16*         # contas receber
    rar a "$NOME_BKP" sist/arq/sp01a04*
    rar a "$NOME_BKP" sist/arq/sp01a77*
    rar a "$NOME_BKP" sist/arqf/sp03a13*        # cfop
    rar a "$NOME_BKP" sist/arqf/sp19*           # ciap
    rar a "$NOME_BKP" sist/arqf/sp03a12*        # ciap
    rar a "$NOME_BKP" sist/arqf/sp04a80*        # ciap
    rar a "$NOME_BKP" sist/arqf/sp04a81*        # ciap
    rar a "$NOME_BKP" sist/arqf/sp06a62*        #
    rar a "$NOME_BKP" sist/sped/sp*             # arq sped
    rar a "$NOME_BKP" sist/arqv/sp01a80*
    rar a "$NOME_BKP" sist/arqv/sp04a46*
    rar a "$NOME_BKP" sist/arqv/vd01a80*        # operador
    rar a "$NOME_BKP" sist/arqv/v04a46*         # operador
    rar a "$NOME_BKP" sist/arqv/vd04a01*        # caixas
    rar a "$NOME_BKP" sist/arqa/sp01z03*        # auxiliar produtos
    rar a "$NOME_BKP" sist/arqd/sp01d01*        # dd prod
    rar a "$NOME_BKP" sist/arqd/sp01o03*        # dd prod
    echo "Backup dos arquivos concluido! O nome do backup usado foi '$NOME_BKP'. "
    echo "Caso deseje realizar mais algum backup utilize o 'Menu' novamente!"
    elif [[ $confirma_backup2 =~ ^[Nn]$ ]]; then
        clear
        echo "Retornando ao menu..."
        menu
    else
        echo "Entrada invalida. Por favor, confirme com 'S' ou 'N'."
    fi
}

# Funcao que executa uma acao com base no valor passado
do_something() {
    case $1 in
        "A"|"a")
            echo "Menu de adicionar novo arquivo a rotina de backup"
            # Chama a função de Adicionar um novo arquivo
            ADICIONAR_NOVO_ARQUIVO
            ;;
        "T"|"t")
            echo "Realizando backup da configuracao programada no script..."
            # Chama as funções de backups configuradas no script
            DEFINIR_NOME
            BACKUP_MESES
            BACKUP_ARQUIVOS
            DISPLAY_MENU
            ;;
        "P"|"p")
            echo "Realizando backup dos arquivos..."
            
            DEFINIR_NOME
            BACKUP_ARQUIVOS
            DISPLAY_MENU
            ;;
        "M"|"m")
            echo "Menu de backup referente aos arquivos que contenham MMAA e AAMM"
            # nesse menu sera realizado o backup dos arquivos que tem mes e ano no nome.
            DEFINIR_NOME
            BACKUP_MESES
            DISPLAY_MENU
            ;;
        "H"|"h")
            clear
            DISPLAY_MANUAL
            DISPLAY_MENU
            ;;
        "I"|"i")
            clear
            DISPLAY_MENU
            ;;
        "L"|"l")
            clear
            listar_arquivos
            DISPLAY_MENU
            ;;
        "S"|"s")
            # Solicitacao de confirmacao para sair da rotina de backup
            read -p "Deseja realmente sair da rotina de backup? (S/N): " confirmar_saida

            # Verifica se a entrada e 'N' ou 'n' para exibir o menu
            if [[ $confirmar_saida =~ ^[Nn]$ ]]; then
                clear
                DISPLAY_MENU
            elif [[ $confirmar_saida =~ ^[Ss]$ ]]; then
            echo "Saindo..."
            exit 0
            else
                echo "Opcao digitada invalida. Por favor, confirme com 'S' ou 'N'."
            fi
            ;;
        *)  # Opção padrão caso nenhuma correspondência seja encontrada
            echo "Opcao invalida"
            ;;
    esac
}

# Funcao para adicionar um novo arquivo ao backup
ADICIONAR_NOVO_ARQUIVO() {    
    read -p "Por favor, insira o diretório do arquivo: " diretorio
    read -p "Por favor, insira o nome do arquivo:" nome

    # Verifica se o arquivo existe
    if [ ! -f "$diretorio/$nome" ]; then
        echo "O arquivo não existe no diretório informado."
        return 1
    fi

    # Verifica se o nome do arquivo contém MMAA ou AAMM
    if [[ $nome =~ [0-9]{4} ]]; then
        # Adiciona o arquivo à função BACKUP_MESES
        BACKUP_MESES "$diretorio/$nome"
    else
        # Adiciona o arquivo à função BACKUP_ARQUIVOS
        BACKUP_ARQUIVOS "$diretorio/$nome"
    fi

    # Adiciona o arquivo à função listar_arquivos
    listar_arquivos "$diretorio/$nome"
}


# Exibir menu ao usuario
DISPLAY_MENU

# Loop para solicitar uma opção valida do usuario
while true; do
    read -p "Digite a opcao do menu que deseja acessar: " opcao
    do_something "$opcao"
done

# Definindo variavel global
NOME_BKP=""
