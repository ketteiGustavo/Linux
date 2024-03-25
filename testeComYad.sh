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
#
# Ao entrar no script irá se deparar com o menu principal. Deverá escolher as
# opções de acordo com a Letra entre []. O programa irá reconhecer tanto letras
# maiusculas quanto letras minusculas.
# Vamos a um exemplo o usuário irá realizar o backup dos arquivos que tem as
# opções de data em seu nome, exemplo do arquivo: mv2403 que está no diretório
# /u/sist/arqm/mvAAMM. Foi feito uma variavél que irá colocar a data (ano e mes)
# que deseja na busca antes da compactação.
#
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


# Função para exibir o menu ao usuário
display_menu() {
    yad --form \
        --title="Menu de Backup" \
        --text="Selecione uma opção:" \
        --button="Backup Configurado":T \
        --button="Backup dos Arquivos":P \
        --button="Backup por Mês":M \
        --button="Ajuda":H \
        --button="Sair":S
}

# Função para realizar o backup dos arquivos
backup_arquivos() {
    rar a "$nome_bkp" sist/arq/sp01a04*
    rar a "$nome_bkp" sist/arq/sp01a77*
    rar a "$nome_bkp" sist/arqf/sp03a13*        # cfop
    rar a "$nome_bkp" sist/arqf/sp19*           # ciap
    rar a "$nome_bkp" sist/arqf/sp03a12*        # ciap
    rar a "$nome_bkp" sist/arqf/sp04a80*        # ciap
    rar a "$nome_bkp" sist/arqf/sp04a81*        # ciap
    rar a "$nome_bkp" sist/arqf/sp06a62*        #
    rar a "$nome_bkp" sist/sped/sp*             # arq sped
    rar a "$nome_bkp" sist/arqv/sp01a80*
    rar a "$nome_bkp" sist/arqv/sp04a46*
    rar a "$nome_bkp" sist/arqv/vd01a80*        # operador
    rar a "$nome_bkp" sist/arqv/v04a46*         # operador
    rar a "$nome_bkp" sist/arqv/vd04a01*        # caixas
    rar a "$nome_bkp" sist/arqa/sp01z03*        # auxiliar produtos
    rar a "$nome_bkp" sist/arqd/sp01d01*        # dd prod
    rar a "$nome_bkp" sist/arqd/sp01o03*        # dd prod
    echo "Backup dos arquivos concluído! O nome do backup usado foi '$nome_bkp'."
    echo "Caso deseje realizar mais algum backup, utilize o 'Menu' novamente!"
}

# Função para executar uma ação com base no valor passado
do_something() {
    case $1 in
        "T"|"t")
            echo "Realizando backup da configuração programada no script..."
            # Chama as funções de backups configuradas no script
            definir_nome
            backup_meses
            backup_arquivos
            display_menu
            ;;
        "P"|"p")
            echo "Realizando backup dos arquivos..."
            definir_nome
            backup_arquivos
            display_menu
            ;;
        "M"|"m")
            echo "Menu de backup referente aos arquivos que contenham MMAA e AAMM"
            # Nesse menu será realizado o backup dos arquivos que têm mês e ano no nome.
            definir_nome
            backup_meses
            display_menu
            ;;
        "H"|"h")
            clear
            display_manual
            ;;
        "I"|"i")
            clear
            display_menu
            ;;
        "L"|"l")
            clear
            listar_arquivos
            display_menu
            ;;
        "S"|"s")
            # Solicitação de confirmação para sair da rotina de backup
            yad --question \
                --title="Confirmação" \
                --text="Deseja realmente sair da rotina de backup?" \
                --button="Sim":0 \
                --button="Não":1
            confirmar_saida=$?

            # Verifica se a entrada é 'Não' (1) para exibir o menu
            if [[ $confirmar_saida -eq 1 ]]; then
                clear
                display_menu
            elif [[ $confirmar_saida -eq 0 ]]; then
                echo "Saindo..."
                exit 0
            else
                echo "Opção digitada inválida. Por favor, confirme com 'Sim' ou 'Não'."
            fi
            ;;
        *)  # Opção padrão caso nenhuma correspondência seja encontrada
            echo "Opção inválida"
            ;;
    esac
}

# Exibir menu ao usuário
display_menu

# Loop para solicitar uma opção válida do usuário
while true; do
    opcao=$(yad --entry \
        --title="Opção do Menu" \
        --text="Digite a opção do menu que deseja acessar:" \
        --entry-text="")

    do_something "$opcao"
done

# Definindo variável global
nome_bkp=""
