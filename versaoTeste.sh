#!/bin/bash

# Autor: Fabio Silva
# Melhoria de leitura de datas: Luiz Gustavo

                        #ARQUIVOS PADRÕES PARA BCKP#

# Pergunta ao usuário quantas datas deseja usar (limitado a 3)
read -p "Quantos meses deseja compactar (até 3 meses)? " quantidade_meses

# Verifica se a quantidade fornecida é um número inteiro entre 1 e 3
if ! [[ $quantidade_meses =~ ^[1-3]$ ]]; then
    echo "Quantidade inválida. Por favor, insira um número entre 1 e 3."
    exit 1
fi

# Pergunta ao usuário qual ano deseja usar
read -p "Digite o ano que deseja usar: " ano

# Pergunta ao usuário quais meses deseja usar, separados por espaço
read -p "Digite os meses (MM MM MM) que deseja compactar (até 3 meses): " meses_input

# Divide a entrada em um array de meses
read -ra meses <<< "$meses_input"

# Verifica se o número de meses fornecidos é válido
if (( ${#meses[@]} < 1 || ${#meses[@]} > 3 )); then
    echo "Quantidade de meses fornecidos inválida. Forneça entre 1 e 3 meses."
    exit 1
fi

# Loop para compactar os arquivos correspondentes a cada data fornecida
for mes in "${meses[@]}"; do
    # Constrói o padrão para a data no formato AAMM
    padrao_aamm="$ano$mes"
    
    rar a baseclientes "sist/arqi/es*${padrao_aamm}*"          # inventario
    rar a baseclientes "sist/arqi/in*${padrao_aamm}*"          # inventario
   
done

echo "programas e arquivos compactados em 'baseclientes.rar'"

echo "Compactação concluída com sucesso."