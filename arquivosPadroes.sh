#!/bin/bash

# Autor: Fabio Silva
# Melhoria de leitura de datas: Luiz Gustavo

                        #ARQUIVOS PADRÕES PARA BCKP#


echo "Para usar esse script deverá ser informado a quantidade de meses e o ano"
echo "Caso precise usar outro ano, rodar o script novamente, digitar o ano"
echo "e quando chegar na parte de compactar os arquivos sem a data digite N"
echo "para ignorar os arquivos que já foram compactados, e adicionar somente"
echo "os novos que tem a data de outro ano informado"


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
read -p "Digite os meses (MM MM MM) que deseja compactar (até 3 meses): " meses_input

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
done

# Pergunta ao usuário se deseja compactar os arquivos que estão abaixo da linha "# outros arquivos sem necessidade de data"
read -p "Deseja compactar os arquivos que não têm data atrelada? (S/N): " compactar_sem_data

# Verifica se o usuário deseja compactar os arquivos sem data
if [[ $compactar_sem_data =~ ^[Ss]$ ]]; then
    echo "Compactando agora arquivos que nao tem data atrelada"
    echo "Por favor aguarde..."
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

    echo "programas e arquivos compactados em 'baseclientes.rar'"
fi

echo "Compactação concluída com sucesso."