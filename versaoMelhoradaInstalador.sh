#!/bin/bash

# Constantes
readonly DOWNLOAD_DIR="$HOME/Downloads/programas"
readonly CONFIG_FILE="/home/$USER/.config/gtk-3.0/bookmarks"

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

# Verifica a conectividade com a internet
check_internet() {
  if ! ping -c 1 8.8.8.8 -q &>/dev/null; then
    error_msg "Seu computador não tem conexão com a Internet. Verifique a rede."
    exit 1
  else
    info_msg "Conexão com a Internet funcionando normalmente."
  fi
}

# Atualiza o repositório e faz atualização do sistema
update_system() {
  sudo apt update && sudo apt dist-upgrade -y
}

# Adiciona arquitetura de 32 bits
add_archi386() {
  sudo dpkg --add-architecture i386
  sudo apt update
}

# Instala pacotes .deb
install_debs() {
  info_msg "Baixando pacotes .deb"
  mkdir -p "$DOWNLOAD_DIR"
  wget -c "$URL_GOOGLE_CHROME" -P "$DOWNLOAD_DIR"
  wget -c "$URL_4K_VIDEO_DOWNLOADER" -P "$DOWNLOAD_DIR"
  wget -c "$URL_INSYNC" -P "$DOWNLOAD_DIR"
  wget -c "$URL_SYNOLOGY_DRIVE" -P "$DOWNLOAD_DIR"

  info_msg "Instalando pacotes .deb baixados"
  sudo dpkg -i "$DOWNLOAD_DIR"/*.deb
}

# Instala pacotes do apt
install_apt_packages() {
  info_msg "Instalando pacotes apt do repositório"
  sudo apt install "${APT_PACKAGES[@]}" -y
}

# Instala pacotes Flatpak
install_flatpaks() {
  info_msg "Instalando pacotes flatpak"
  for app in "${FLATPAK_APPS[@]}"; do
    flatpak install flathub "$app" -y
  done
}

# Instala pacotes Snap
install_snaps() {
  info_msg "Instalando pacotes snap"
  sudo snap install authy
}

# Limpa o sistema
clean_system() {
  info_msg "Finalizando, atualizando e limpando o sistema"
  sudo apt update -y
  flatpak update -y
  sudo apt autoclean -y
  sudo apt autoremove -y
  nautilus -q
}

# Configurações extras
extra_config() {
  info_msg "Configurando pastas extras"
  mkdir -p /home/"$USER"/{TEMP,EDITAR,Resolve,AppImage,"Vídeos/OBS Rec"}
  if [ ! -f "$CONFIG_FILE" ]; then
    touch "$CONFIG_FILE"
  fi
  echo "file:///home/$USER/EDITAR 🔵 EDITAR" >>"$CONFIG_FILE"
  echo "file:///home/$USER/AppImage" >>"$CONFIG_FILE"
  echo "file:///home/$USER/Resolve 🔴 Resolve" >>"$CONFIG_FILE"
  echo "file:///home/$USER/TEMP 🕖 TEMP" >>"$CONFIG_FILE"
}

# Main
main() {
  check_internet
  update_system
  add_archi386
  install_debs
  install_apt_packages
  install_flatpaks
  install_snaps
  extra_config
  clean_system

  info_msg "Script finalizado, instalação concluída! :)"
}

# Define URLs e pacotes a serem instalados
readonly URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
readonly URL_4K_VIDEO_DOWNLOADER="https://dl.4kdownload.com/app/4kvideodownloader_4.20.0-1_amd64.deb?source=website"
readonly URL_INSYNC="https://d2t3ff60b2tol4.cloudfront.net/builds/insync_3.7.2.50318-impish_amd64.deb"
readonly URL_SYNOLOGY_DRIVE="https://global.download.synology.com/download/Utility/SynologyDriveClient/3.0.3-12689/Ubuntu/Installer/x86_64/synology-drive-client-12689.x86_64.deb"
readonly APT_PACKAGES=(
  snapd
  winff
  virtualbox
  ratbagd
  gparted
  timeshift
  gufw
  synaptic
  solaar
  vlc
  code
  gnome-sushi
  folder-color
  git
  wget
  ubuntu-restricted-extras
  v4l2loopback-utils
  shutter
)
readonly FLATPAK_APPS=(
  com.obsproject.Studio
  org.gimp.GIMP
  com.spotify.Client
  com.bitwarden.desktop
  org.telegram.desktop
  org.freedesktop.Piper
  org.chromium.Chromium
  org.gnome.Boxes
  org.onlyoffice.desktopeditors
  org.qbittorrent.qBittorrent
  org.flameshot.Flameshot
  org.electrum.electrum
  org.inkscape.Inkscape
  org.kde.kdenlive
  org.heroicgameslauncher.hgl
  org.upscayl.Upscayl
  org.pulseaudio.pavucontrol
  com.discordapp.Discord
  org.gabmus.hydrapaper
  com.sublimetext.three
  io.github.shiftey.Desktop
  org.filezillaproject.Filezilla
  io.github.jeffshee.Hidamari
  io.github.jorchube.monitorets
)

# Execução principal
main
