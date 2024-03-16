#!/bin/bash

# Autores: Fabio Silva
#          Luiz Gustavo
# Melhoria de Menu e opcoes: Luiz Gustavo
# Versao: 3.0.2

                        #ARQUIVOS PADROES PARA BCKP#


# Definindo variavel global
nome_bkp=""

# Funcao para exibir o menu
display_menu() {
    echo "Manual de utilizacao:"
    echo "Opcoes disponiveis:"
    echo "  [I]nicio    : Menu inicial"
    echo "  [T]otal     : backup total do script"
    echo "  [P]arcial   : backup dos arquivos"
    echo "  [M]eses     : backup dos arquivos de mes e ano"
    echo "  [A]juda     : acessar o menu de ajuda"
    echo "  [L]istar    : listar arquivos"
    echo "  [E]xit      : Sair do script"
}

# Funcao para exibir o manual
display_manual() {
    echo "Manual de utilizacao:"
    echo "Opcoes disponiveis:"
    echo "  [I]nicio    : Voltar ao meneu principal"
    echo "  [T]otal     : Realizar backup total (faz o backup de todos os arquivos de acordo com a programacao do script)"
    echo "  [P]arcial : Realizar backup dos arquivos (faz o backup dos arquivos previamente configurados)"
    echo "  [M]eses     : Realizar backup dos arquivos de meses (faz o backup dos arquivos com datas especificas)"
    echo "  [A]juda     : Exibir o menu de ajuda (mostra este menu novamente)"
    echo "  [L]istar    : Listar a lista completa dos arquivos que são compactados na execucao desse script."
    echo "  [E]xit      : Sair do script (encerra a execucao do script)"
}

# Funcao para definir o nome do arquivo de backup
definir_nome(){
    # Pergunta ao usuario o nome que deseja usar no arquivo de backup
    read -p "Digite o nome para o arquivo de 'Backup'  " nome_bkp
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
backup_meses(){
# Pergunta ao usuario quantas datas deseja usar (limitado a 3)
    while true; do
        read -p "Quantos meses deseja compactar (até 3 meses)? " quantidade_meses

        # Verifica se a quantidade fornecida e um numero inteiro entre 1 e 3
        if [[ $quantidade_meses =~ ^[1-3]$ ]]; then
        break
        else
        echo "Quantidade invalida. Por favor, insira um numero entre 1 e 3."
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

    # Pergunta ao usuário quais meses deseja usar, separados por espaço
    read -p "Digite o(s) mes(es) (MM MM MM) que deseja compactar (ate 3 meses): " meses_input

    # Divide a entrada em um array de meses
    read -ra meses <<< "$meses_input"

    # Loop para compactar os arquivos correspondentes a cada data fornecida
    for mes in "${meses[@]}"; do

        # Constrói o padrão para a data no formato MMAA
        padrao_mmaa="$mes$ano"
        rar a "$nome_bkp" "sist/arqf/*${padrao_mmaa}*"     # fiscal  --- livros fiscais (fsLLMMAA, leLLMMAA, mpLLMMAA, alLLMMAA)
        # Constrói o padrão para a data no formato AAMM
        padrao_aamm="$ano$mes"
        rar a "$nome_bkp" "sist/arqf/*${padrao_aamm}*"     
        rar a "$nome_bkp" "sist/arqm/mv${padrao_aamm}*"      # movimento
        rar a "$nome_bkp" "sist/arqf/gnren${padrao_aamm}*"   # gnre
        rar a "$nome_bkp" "sist/arqi/es*${padrao_aamm}*"          # inventario
        rar a "$nome_bkp" "sist/arqi/in*${padrao_aamm}*"          # inventario
        rar a "$nome_bkp" "sist/sped/obs${padrao_aamm}*"      # observacao
        rar a "$nome_bkp" "sist/sped/ajitens${padrao_aamm}*"    # ajuste
        rar a "$nome_bkp" "sist/sped/apu*${padrao_aamm}*"       # apuracao
        rar a "$nome_bkp" "sist/arqv/*${padrao_aamm}*"          # vendas cf
        echo "Backup dos arquivos MMAA concluido."
    done
}

# Funcao para executar backup Arquivos
backup_programas(){
    rar a "$nome_bkp" arqh/*             # cad usuario
    rar a "$nome_bkp" arq/sp01*03*        # produtos
    rar a "$nome_bkp" arq/sp01a22*        # cod barras            
    rar a "$nome_bkp" arq/sp01a25*
    rar a "$nome_bkp" arq/sp02a25*
    rar a "$nome_bkp" arq/sp02a11*
    rar a "$nome_bkp" arq/sp01a18*
    rar a "$nome_bkp" arq/sp06a42*
    rar a "$nome_bkp" arq/sp04a93*
    rar a "$nome_bkp" arq/sp01v04*
    rar a "$nome_bkp" arq/sp01a43*        # cidades
    rar a "$nome_bkp" arq/sp03a32*                # plano contas 
    rar a "$nome_bkp" arq/sp01a02*        # setor e grupo
    rar a "$nome_bkp" arq/sp01a08*                # plano contas gerencial
    rar a "$nome_bkp" arq/sp01a34*                # cad transportadora
    rar a "$nome_bkp" arq/sp02a79*                # vinc cliente
    rar a "$nome_bkp" arq/sp04a21*                # vinc cidade
    rar a "$nome_bkp" sist/arq/sp01a00*         # parametro
    rar a "$nome_bkp" sist/arq/sp01a01*         # filial
    rar a "$nome_bkp" sist/arq/sp03a80*         # filial
    rar a "$nome_bkp" sist/arq/sp01a07*         # contas pagar
    rar a "$nome_bkp" sist/arq/sp01a16*        # contas receber
    rar a "$nome_bkp" sist/arq/sp01a04*
    rar a "$nome_bkp" sist/arq/sp01a77*
    rar a "$nome_bkp" sist/arqf/sp03a13*       # cfop
    rar a "$nome_bkp" sist/arqf/sp19*             # ciap
    rar a "$nome_bkp" sist/arqf/sp03a12*     # ciap
    rar a "$nome_bkp" sist/arqf/sp04a80*     # ciap
    rar a "$nome_bkp" sist/arqf/sp04a81*     # ciap
    rar a "$nome_bkp" sist/arqf/sp06a62*       #
    rar a "$nome_bkp" sist/sped/sp*             # arq sped
    rar a "$nome_bkp" sist/arqv/sp01a80*
    rar a "$nome_bkp" sist/arqv/sp04a46*
    rar a "$nome_bkp" sist/arqv/vd01a80*        # operador
    rar a "$nome_bkp" sist/arqv/v04a46*         # operador
    rar a "$nome_bkp" sist/arqv/vd04a01*        # caixas
    rar a "$nome_bkp" sist/arqa/sp01z03*        # auxiliar produtos
    rar a "$nome_bkp" sist/arqd/sp01d01*        # dd prod
    rar a "$nome_bkp" sist/arqd/sp01o03*        # dd prod
    echo "Backup dos programas concluido."
}

# Funcao que executa uma acao com base no valor passado
do_something() {
    case $1 in
        "T"|"t")
            echo "Realizando backup da configuracao programada no script..."
            # Chama as funções de backup dos programas e dos arquivos de meses
            definir_nome
            backup_meses
            backup_programas
            display_menu
            ;;
        "P"|"p")
            echo "Realizando backup dos programas..."
            # Adicione aqui o comando para realizar o backup dos programas
            definir_nome
            backup_programas
            display_menu
            ;;
        "M"|"m")
            echo "Menu de backup referente aos arq MMAA e AAMM"
            # nesse menu sera realizado o backup dos arquivos que tem mes e ano no nome.
            definir_nome
            backup_meses
            display_menu
            ;;
        "A"|"a")
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

# Exibir menu ao usuario
display_menu

# Loop para solicitar uma opção valida do usuario
while true; do
    read -p "Digite a opcao do menu que deseja acessar: " opcao
    do_something "$opcao"
done