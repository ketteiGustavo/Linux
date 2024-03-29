#!/bin/bash
#
# criaBackupArquivosPadroes.sh - Cria backup de principais arquivos do cliente
#
# DATA: 18/03/2024 07:15
# Autor:    Luiz Gustavo <luiz.gustavo@avancoinfo.com.br>
# Co-Autor: Fabio Silva
# Melhoria de Menu e opcoes: Luiz Gustavo
# Versao: 3.0.2
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

# Funcao para exibir o menu
display_menu() {
    echo "________________________________________________________"
    echo "| Manual de utilizacao:                                 |"
    echo "| Opcoes disponiveis:                                   |"
    echo "|    [I]nicio    : Menu inicial                         |"
    echo "|    [T]otal     : backup total do script               |"
    echo "|    [P]arcial   : backup dos arquivos                  |"
    echo "|    [M]eses     : backup dos arquivos de mes e ano     |"
    echo "|    [H]elp      : acessar o menu de ajuda              |"
    echo "|    [L]istar    : listar arquivos                      |"
    echo "|    [E]xit      : Sair do script                       |"
    echo "|_______________________________________________________|"
}

# Funcao para exibir o manual
display_manual() {
    echo "Manual de utilizacao:"
    echo "Opcoes disponiveis:"
    echo "  [I]nicio    : Voltar ao meneu principal"
    echo "  [T]otal     : Realizar backup total (faz o backup de todos os arquivos de acordo com a programacao do script)"
    echo "  [P]arcial   : Realizar backup dos arquivos (faz o backup dos arquivos previamente configurados)"
    echo "  [M]eses     : Realizar backup dos arquivos de meses (faz o backup dos arquivos com datas especificas)"
    echo "  [A]juda     : Exibir o menu de ajuda (mostra este menu novamente)"
    echo "  [L]istar    : Listar a lista completa dos arquivos que são compactados na execucao desse script."
    echo "  [S]air      : Sair do script (encerra a execucao do script)"
}

# Funcao para definir o nome do arquivo de backup
definir_nome(){
    while true; do
        # Pergunta ao usuario o nome que deseja usar no arquivo de backup
        read -p "Digite o nome para o arquivo de 'Backup'  " nome_bkp

        # Confirma ao usuario o nome digitado
        read -p "Deseja usar o nome '$nome_bkp' para esse backup? (S/N)  " confirma_nome

        case $confirma_nome in
            "s"|"S")
                echo "Sera usado o seguinte nome para o backup: '$nome_bkp'"
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
backup_meses(){
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
            rar a "$nome_bkp" "sist/arqf/*${padrao_mmaa}*"          # fiscal  --- livros fiscais (fsLLMMAA, leLLMMAA, mpLLMMAA, alLLMMAA)
            # Constrói o padrão para a data no formato AAMM
            padrao_aamm="$ano$mes"
            rar a "$nome_bkp" "sist/arqf/*${padrao_aamm}*"     
            rar a "$nome_bkp" "sist/arqm/mv${padrao_aamm}*"         # movimento
            rar a "$nome_bkp" "sist/arqf/gnren${padrao_aamm}*"      # gnre
            rar a "$nome_bkp" "sist/arqi/es*${padrao_aamm}*"        # inventario
            rar a "$nome_bkp" "sist/arqi/in*${padrao_aamm}*"        # inventario
            rar a "$nome_bkp" "sist/sped/obs${padrao_aamm}*"        # observacao
            rar a "$nome_bkp" "sist/sped/ajitens${padrao_aamm}*"    # ajuste
            rar a "$nome_bkp" "sist/sped/apu*${padrao_aamm}*"       # apuracao
            rar a "$nome_bkp" "sist/arqv/*${padrao_aamm}*"          # vendas cf
            echo "Backup do(s) arquivo(s) do(s) mes(es) '$meses_input' do ano '20$ano' concluido! O nome do backup usado foi '$nome_bkp' "
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
backup_arquivos(){
    # Solicitacao de confirmacao para iniciar o backup dos arquivos gerais
    read -p "Confirma o backup dos arquivos descritos na lista de arquivos? (S/N)" confirma_backup2

    # Verifica se a entrada foi 'S' ou 's' para iniciar o backup, do contrario volta ao menu principal

    if [[ $confirma_backup2 =~ ^[Ss]$ ]]; then
    echo "Iniciando Backup..."

    rar a "$nome_bkp" arqh/*                    # cad usuario
    rar a "$nome_bkp" arq/sp01*03*              # produtos
    rar a "$nome_bkp" arq/sp01a22*              # cod barras
    rar a "$nome_bkp" arq/sp01a25*
    rar a "$nome_bkp" arq/sp02a25*
    rar a "$nome_bkp" arq/sp02a11*
    rar a "$nome_bkp" arq/sp01a18*
    rar a "$nome_bkp" arq/sp06a42*
    rar a "$nome_bkp" arq/sp04a93*
    rar a "$nome_bkp" arq/sp01v04*
    rar a "$nome_bkp" arq/sp01a43*              # cidades
    rar a "$nome_bkp" arq/sp03a32*              # plano contas
    rar a "$nome_bkp" arq/sp01a02*              # setor e grupo
    rar a "$nome_bkp" arq/sp01a08*              # plano contas gerencial
    rar a "$nome_bkp" arq/sp01a34*              # cad transportadora
    rar a "$nome_bkp" arq/sp02a79*              # vinc cliente
    rar a "$nome_bkp" arq/sp04a21*              # vinc cidade
    rar a "$nome_bkp" sist/arq/sp01a00*         # parametro
    rar a "$nome_bkp" sist/arq/sp01a01*         # filial
    rar a "$nome_bkp" sist/arq/sp03a80*         # filial
    rar a "$nome_bkp" sist/arq/sp01a07*         # contas pagar
    rar a "$nome_bkp" sist/arq/sp01a16*         # contas receber
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
    echo "Backup dos arquivos concluido! O nome do backup usado foi '$nome_bkp'. "
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
        "T"|"t")
            echo "Realizando backup da configuracao programada no script..."
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
            display_menu
            ;;
        "S"|"s")
            # Solicitacao de confirmacao para sair da rotina de backup
            read -p "Deseja realmente sair da rotina de backup? (S/N): " confirmar_saida

            # Verifica se a entrada e 'N' ou 'n' para exibir o menu
            if [[ $confirmar_saida =~ ^[Nn]$ ]]; then
                clear
                display_menu
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

# Exibir menu ao usuario
display_menu

# Loop para solicitar uma opção valida do usuario
while true; do
    read -p "Digite a opcao do menu que deseja acessar: " opcao
    do_something "$opcao"
done

# Definindo variavel global
nome_bkp=""
