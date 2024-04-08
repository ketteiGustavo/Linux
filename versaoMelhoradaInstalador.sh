#!/bin/bash

# Constantes
readonly DOWNLOAD_DIR="/home/$USER/Downloads/programas"
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

# Verifica a acessibilidade das URLs
check_urls() {
  local urls=("$URL_GOOGLE_CHROME" "$URL_VSCODE" "$URL_ZOOM")
  for url in "${urls[@]}"; do
    if ! curl --output /dev/null --silent --head --fail "$url"; then
      error_msg "A URL $url não está acessível. Verifique a conexão com a Internet e tente novamente."
      exit 1
    fi
  done
}


# Atualiza o repositório e faz atualização do sistema
update_system() {
  sudo apt update && sudo apt dist-upgrade -y
  if [ $? -ne 0 ]; then
    error_msg "Falha ao atualizar o sistema. Verifique sua conexão com a Internet e tente novamente."
    exit 1
  fi
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
  for url in "$URL_GOOGLE_CHROME" "$URL_ZOOM" "$URL_VSCODE"; do
    wget -c "$url" -P "$DOWNLOAD_DIR" || {
      error_msg "Falha ao baixar $url. Verifique a conexão com a Internet e tente novamente."
      exit 1
    }
  done
  info_msg "Instalando pacotes .deb baixados"
  sudo dpkg -i "$DOWNLOAD_DIR"/*.deb || {
    error_msg "Falha ao instalar pacotes .deb. Verifique os pacotes baixados e tente novamente."
    exit 1
  }
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
}

# Configurações extras
extra_config() {
  info_msg "Configurando pastas extras"
  mkdir -p /home/"$USER"/{TEMP,EDITAR,Resolve,AppImage,"Videos/OBS_Rec"}
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
  check_urls
  update_system
  add_archi386
  install_debs
  install_apt_packages
  install_flatpaks
  install_snaps
  extra_config
  extras_terminal
  clean_system
  configure_aliases
  configure_second_monitor

  info_msg "Script finalizado, instalação concluída! :)"
}



# Define URLs e pacotes a serem instalados
URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
# URL_4K_VIDEO_DOWNLOADER="https://dl.4kdownload.com/app/4kvideodownloader_4.20.0-1_amd64.deb?source=website"
# URL_INSYNC="https://cdn.insynchq.com/builds/linux/insync_3.8.7.50516-noble_amd64.deb"
# URL_SYNOLOGY_DRIVE="https://global.download.synology.com/download/Utility/SynologyDriveClient/3.0.3-12689/Ubuntu/Installer/x86_64/synology-drive-client-12689.x86_64.deb"
URL_VSCODE="'https://go.microsoft.com/fwlink/?LinkID=760868' -O vscode.deb"
URL_ZOOM="https://zoom.us/client/5.17.11.3835/zoom_amd64.deb"



readonly APT_PACKAGES=(
  snapd
  curl
  flatpak
  winff
  virtualbox
  ratbagd
  gparted
  timeshift
  gufw
  synaptic
  solaar
  vlc
  gnome-sushi
  folder-color
  git
  wget
  ubuntu-restricted-extras
  v4l2loopback-utils
  shutter
  make
  default-libmysqlclient-dev
  libssl-dev
  build-essential
  python3.11-full
  python3.11-dev
  dkms
  perl
  openjdk-17-jdk
  maven
  vim
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
  com.heroicgameslauncher.hgl
  org.upscayl.Upscayl
  org.pulseaudio.pavucontrol
  com.discordapp.Discord
  org.gabmus.hydrapaper
  com.sublimetext.three
  io.github.shiftey.Desktop
  org.filezillaproject.Filezilla
  io.github.jorchube.monitorets
  org.localsend.localsend_app
  com.bitwarden.desktop
  org.gnome.Todo
  com.github.bcedu.valasimplehttpserver
  org.prismlauncher.PrismLauncher
  com.github.hluk.copyq
  net.christianbeier.Gromit-MPX
)

extras_terminal(){
  mkdir -p ~/.fonts
  git clone https://github.com/pdf/ubuntu-mono-powerline-ttf.git ~/.fonts/ubuntu-mono-powerline-ttf
  fc-cache -vf

  sudo apt-get install dconf-cli
  git clone https://github.com/dracula/gnome-terminal
  cd gnome-terminal
  ./install.sh
  
}

# Função para configurar aliases
configure_aliases() {
  # Adicione aqui seus aliases desejados
  echo "alias ccc='clear'" >> /home/$USER/.bashrc
  echo "alias ddd='shutdown now'" >> /home/$USER/.bashrc
  echo "alias att='sudo apt update -y && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoclean -y && sudo apt autoremove -y && alert'" >> /home/$USER/.bashrc
}


# Função para configurar a resolução do segundo monitor
configure_second_monitor() {
  # Adiciona os comandos ao final do arquivo .profile para persistir as configurações
  echo "" >> /home/$USER/.profile
  echo "# Configuração da resolução do segundo monitor" >> /home/$USER/.profile
  echo "xrandr --newmode \"1920x1080_60.00\"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync" >> /home/$USER/.profile
  echo "xrandr --addmode VGA-1 1920x1080_60.00" >> /home/$USER/.profile
  echo "xrandr --output VGA-1 --mode 1920x1080_60.00" >> /home/$USER/.profile
}
# Função para o menu principal
main_menu() {
  clear
  echo "Selecione uma opção:"
  options=("Atualizar sistema" "Adicionar arquitetura de 32 bits" "Instalar pacotes .deb" "Instalar pacotes do apt" "Instalar pacotes Flatpak" "Instalar pacotes Snap" "Configurações extras" "Limpar o sistema" "Sair")
  select opt in "${options[@]}"; do
    case $opt in
      "Atualizar sistema")
        echo "Atualizando Sistema"
        update_system
        ;;
      "Adicionar arquitetura de 32 bits")
        echo "Adicionando arquitetura de 32bits"
        add_archi386
        ;;
      "Instalar pacotes .deb")
        echo "Instalando programas '.debs'"
        install_debs
        ;;
      "Instalar pacotes do apt")
        echo "Instalando programas via 'Apt'"
        install_apt_packages
        ;;
      "Instalar pacotes Flatpak")
        echo "Instalando programas via 'Flatpak'"
        install_flatpaks
        ;;
      "Instalar pacotes Snap")
        echo "Instalando programas via 'Snap'"
        install_snaps
        ;;
      "Configurações extras")
        echo "Realizando configurações extras"
        configure_aliases
        configure_second_monitor
        ;;
      "Limpar o sistema")
        echo "Limpando o sistema..."
        clean_system
        ;;
      "Sair")
        echo "Saindo, até..."
        break
        ;;
      *) echo "Opção inválida";;
    esac
  done
}


main_menu