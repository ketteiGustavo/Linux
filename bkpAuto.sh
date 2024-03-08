#!/bin/bash

# Monta o HD, se não estiver montado
if ! mount | grep -q "/media/luiz/1D0902A9EA801E471"; then
    echo "Montando o HD..."
    sudo mount /dev/sdc1 /media/luiz/1D0902A9EA801E471
    if [ $? -ne 0 ]; then
        echo "Erro ao montar o HD."
        exit 1
    fi
fi


# Define as pastas do HD principal e do backup
pasta_principal1="/home/luiz/Documentos/Cursos_TI"
pasta_principal2="/home/luiz/Workspaces"
pasta_principal3="/home/luiz/eclipse-workspace"
pasta_backup="/media/luiz/1D0902A9EA801E471/CURSOS_TI"

# Define os caminhos para as pastas de destino na pasta de backup
caminho_destino_principal2="$pasta_backup/Workspaces"
caminho_destino_principal3="$pasta_backup/Workspaces/Javas_feitos"

# Define o caminho para o arquivo de log
arquivo_log="/home/luiz/Documentos/Cursos_TI/log_do_backup.txt"
# Define o caminho para copiar o arquivo de log
caminho_copia_log="/media/luiz/1D0902A9EA801E471/CURSOS_TI/log_do_backup.txt"

# Verifica se a pasta de backup existe, senão, cria-a
if [ ! -d "$pasta_backup" ]; then
    echo "A pasta de backup não existe. Criando..."
    mkdir -p "$pasta_backup"
    echo "Pasta de backup criada em $(date +'%Y-%m-%d %H:%M:%S')." >> "$arquivo_log"
fi

# Verifica se as pastas principais existem
if [ ! -d "$pasta_principal1" ] || [ ! -d "$pasta_principal2" ] || [ ! -d "$pasta_principal3" ]; then
    echo "Uma ou mais pastas principais não existem."
    exit 1
fi

# Guarda o número de arquivos antes da cópia
num_arquivos_backup=$(find "$pasta_backup" -type f | wc -l)

# Guarda o tamanho total da pasta de backup antes da cópia em megabytes
tamanho_backup_antigo_mb=$(du -hs --block-size=1M "$pasta_backup" | cut -f1)

# Guarda o tamanho total da pasta de backup antes da cópia em gigabytes
tamanho_backup_antigo_gb=$(du -hs "$pasta_backup" | cut -f1)

# Copia os arquivos e pastas das pastas principais para as pastas de destino na pasta de backup, apenas se houver diferenças
rsync -av --checksum --update "$pasta_principal1/" "$pasta_backup/" >> "$arquivo_log" 2>&1
rsync -av --checksum --update "$pasta_principal2/" "$caminho_destino_principal2/" >> "$arquivo_log" 2>&1
rsync -av --checksum --update "$pasta_principal3/" "$caminho_destino_principal3/" >> "$arquivo_log" 2>&1

# Guarda o tamanho total da pasta de backup depois da cópia em megabytes
tamanho_backup_novo_mb=$(du -hs --block-size=1M "$pasta_backup" | cut -f1)

# Guarda o tamanho total da pasta de backup depois da cópia em gigabytes
tamanho_backup_novo_gb=$(du -hs "$pasta_backup" | cut -f1)

# Calcula o número de arquivos novos copiados
num_arquivos_novos=$(( $(find "$pasta_backup" -type f | wc -l) - num_arquivos_backup ))

# Calcula o número de arquivos atualizados
num_arquivos_atualizados=$(grep -c '... .*$' "$arquivo_log")

# Exibe informações sobre a operação de backup no arquivo de log
echo "Número de arquivos novos copiados: $num_arquivos_novos" >> "$arquivo_log"
echo "Tamanho total da pasta de backup antes da cópia (em megabytes): $tamanho_backup_antigo_mb" >> "$arquivo_log"
echo "Tamanho total da pasta de backup antes da cópia (em gigabytes): $tamanho_backup_antigo_gb" >> "$arquivo_log"
echo "Tamanho total da pasta de backup depois da cópia (em megabytes): $tamanho_backup_novo_mb" >> "$arquivo_log"
echo "Tamanho total da pasta de backup depois da cópia (em gigabytes): $tamanho_backup_novo_gb" >> "$arquivo_log"
echo "Número de arquivos atualizados: $num_arquivos_atualizados" >> "$arquivo_log"

# Copia o arquivo de log para o local especificado
cp "$arquivo_log" "$caminho_copia_log"

# Saída do script
exit 0
