#!/bin/bash

# Função para exibir o menu
display_menu() {
    echo "Manual de utilizacao:"
    echo "Opcoes disponíveis:"
    echo "  T: Realizar backup total"
    echo "  P: Realizar backup dos programas"
    echo "  M: Realizar backup dos arquivos de meses"
    echo "  A: Acessar o menu de ajuda"
    echo "  U: Baixar script atualizado"
    echo "  E: Sair do script"
}

# Função para exibir o manual
display_manual() {
    echo "Manual de utilizacao:"
    echo "Opcoes disponiveis:"
    echo "  T: Realizar backup total"
    echo "  P: Realizar backup dos programas"
    echo "  M: Realizar backup dos arquivos de meses"
    echo "  A: Acessar o menu de ajuda"
    echo "  E: Sair do script"
}

# Fucao para baixar a versao mais recente do script
atualizar_script(){
    echo "Abrindo o link para o download do script mais recente..."
    xdg-open https://docs.google.com/spreadsheets/d/1O2weFd7Qs4XkF7GRszc7HV1KBjhRLaTZjk7Dve4nn2s/edit?pli=1#gid=0
}

# Funcao para executar backup dos Meses
backup_meses(){
# Pergunta ao usuário quantas datas deseja usar (limitado a 3)
                while true; do
                    read -p "Quantos meses deseja compactar (até 3 meses)? " quantidade_meses

                    # Verifica se a quantidade fornecida é um número inteiro entre 1 e 3
                    if [[ $quantidade_meses =~ ^[1-3]$ ]]; then
                    break
                    else
                        echo "Quantidade inválida. Por favor, insira um número entre 1 e 3."
                    fi
                done

                # Pergunta ao usuário qual ano deseja usar (limitado a 2 dígitos)
                while true; do
                    read -p "Digite o ano que deseja usar (apenas 2 dígitos): " ano

                    # Verifica se o ano fornecido tem exatamente 2 dígitos
                    if [[ $ano =~ ^[0-9]{2}$ ]]; then
                    break
                    else
                        echo "Ano inválido. Por favor, insira apenas 2 dígitos para o ano."
                    fi
                done

            # Pergunta ao usuário quais meses deseja usar, separados por espaço
            read -p "Digite o(s) mes(es) (MM MM MM) que deseja compactar (até 3 meses): " meses_input

            # Divide a entrada em um array de meses
            read -ra meses <<< "$meses_input"

            # Loop para compactar os arquivos correspondentes a cada data fornecida
            for mes in "${meses[@]}"; do
            # Constrói o padrão para a data no formato MMAA
            padrao_mmaa="$mes$ano"
            rar a baseclientes "sist/arqf/*${padrao_mmaa}*"     # fiscal  --- livros fiscais (fsLLMMAA, leLLMMAA, mpLLMMAA, alLLMMAA)
            # Constrói o padrão para a data no formato AAMM
            padrao_aamm="$ano$mes"
                rar a baseclientes "sist/arqf/*${padrao_aamm}*"     
                rar a baseclientes "sist/arqm/mv${padrao_aamm}*"      # movimento
                rar a baseclientes "sist/arqf/gnren${padrao_aamm}*"   # gnre
                rar a baseclientes "sist/arqi/es*${padrao_aamm}*"          # inventario
                rar a baseclientes "sist/arqi/in*${padrao_aamm}*"          # inventario
                rar a baseclientes "sist/sped/obs${padrao_aamm}*"      # observacao
                rar a baseclientes "sist/sped/ajitens${padrao_aamm}*"    # ajuste
                rar a baseclientes "sist/sped/apu*${padrao_aamm}*"       # apuracao
                rar a baseclientes "sist/arqv/*${padrao_aamm}*"          # vendas cf
                echo "Backup dos arquivos MMAA concluído."
    done
}

# Funcao para executar backup Programas
backup_programas(){
rar a baseclientes arqh/*             # cad usuario
                rar a baseclientes arq/sp01*03*        # produtos
                rar a baseclientes arq/sp01a22*        # cod barras            
                rar a baseclientes arq/sp01a25*
                rar a baseclientes arq/sp02a25*
                rar a baseclientes arq/sp02a11*
                rar a baseclientes arq/sp01a18*
                rar a baseclientes arq/sp06a42*
                rar a baseclientes arq/sp04a93*
                rar a baseclientes arq/sp01v04*
                rar a baseclientes arq/sp01a43*        # cidades
                rar a baseclientes arq/sp03a32*                # plano contas 
                rar a baseclientes arq/sp01a02*        # setor e grupo
                rar a baseclientes arq/sp01a08*                # plano contas gerencial
                rar a baseclientes arq/sp01a34*                # cad transportadora
                rar a baseclientes arq/sp02a79*                # vinc cliente
                rar a baseclientes arq/sp04a21*                # vinc cidade
                rar a baseclientes sist/arq/sp01a00*         # parametro
                rar a baseclientes sist/arq/sp01a01*         # filial
                rar a baseclientes sist/arq/sp03a80*         # filial
                rar a baseclientes sist/arq/sp01a07*         # contas pagar
                rar a baseclientes sist/arq/sp01a16*        # contas receber
                rar a baseclientes sist/arq/sp01a04*
                rar a baseclientes sist/arq/sp01a77*
                rar a baseclientes sist/arqf/sp03a13*       # cfop
                rar a baseclientes sist/arqf/sp19*             # ciap
                rar a baseclientes sist/arqf/sp03a12*     # ciap
                rar a baseclientes sist/arqf/sp04a80*     # ciap
                rar a baseclientes sist/arqf/sp04a81*     # ciap
                rar a baseclientes sist/arqf/sp06a62*       #
                rar a baseclientes sist/sped/sp*             # arq sped
                rar a baseclientes sist/arqv/sp01a80*
                rar a baseclientes sist/arqv/sp04a46*
                rar a baseclientes sist/arqv/vd01a80*        # operador
                rar a baseclientes sist/arqv/v04a46*         # operador
                rar a baseclientes sist/arqv/vd04a01*        # caixas
                rar a baseclientes sist/arqa/sp01z03*        # auxiliar produtos
                rar a baseclientes sist/arqd/sp01d01*        # dd prod
                rar a baseclientes sist/arqd/sp01o03*        # dd prod
                echo "Backup dos programas concluído."
}

# Função que executa uma ação com base no valor passado
do_something() {
    case $1 in
        "T"|"t")
            echo "Realizando backup total..."
            # Chama as funções de backup dos programas e dos arquivos de meses
            backup_meses
            backup_programas
            ;;
        "P"|"p")
            echo "Realizando backup dos programas..."
            # Adicione aqui o comando para realizar o backup dos programas
            backup_programas
            ;;
        "M"|"m")
            echo "Menu de backup referente aos arq MMAA e AAMM"
            # nesse menu sera realizado o backup dos arquivos que tem mes e ano no nome.
            backup_meses
            ;;
        "A"|"a")
            display_manual
            ;;
        "U"|"u")
            atualizar_script
            ;;
        "E"|"e")
            echo "Saindo do script."
            exit 0
            ;;
        *)  # Opção padrão caso nenhuma correspondência seja encontrada
            echo "Opcao invalida"
            ;;
    esac
}

# Exibir menu ao usuário
display_menu

# Loop para solicitar uma opção válida do usuário
while true; do
    read -p "Digite a opção do menu que deseja acessar: " opcao
    do_something "$opcao"
done