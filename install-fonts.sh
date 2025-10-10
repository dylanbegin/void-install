#!/bin/sh

# Installation script to install all latest nerdfont packages.
# https://www.nerdfonts.com/

# get dependencies
echo "Installing dependencies..."
doas xbps-install wget unzip curl

# Vars
FONT_VER=`curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest |  grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'`

echo "Install script for nerd-fonts version $FONT_VER"

# Download all font files
echo "Downloading all zip files..."
mkdir /tmp/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/0xProto.zip -O /tmp/fonts/0xProto.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/3270.zip -O /tmp/fonts/3270.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/AdwaitaMono.zip -O /tmp/fonts/AdwaitaMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/Agave.zip -O /tmp/fonts/Agave.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/AnonymousPro.zip -O /tmp/fonts/AnonymousPro.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/Arimo.zip -O /tmp/fonts/Arimo.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/AtkinsonHyperlegibleMono.zip -O /tmp/fonts/AtkinsonHyperlegibleMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/AurulentSansMono.zip -O /tmp/fonts/AurulentSansMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/BigBlueTerminal.zip -O /tmp/fonts/BigBlueTerminal.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/BitstreamVeraSansMono.zip -O /tmp/fonts/BitstreamVeraSansMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/IBMPlexMono.zip -O /tmp/fonts/IBMPlexMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/CascadiaCode.zip -O /tmp/fonts/CascadiaCode.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/CodeNewRoman.zip -O /tmp/fonts/CodeNewRoman.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/ComicShannsMono.zip -O /tmp/fonts/ComicShannsMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/CommitMono.zip -O /tmp/fonts/CommitMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/Cousine.zip -O /tmp/fonts/Cousine.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/D2Coding.zip -O /tmp/fonts/D2Coding.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/DaddyTimeMono.zip -O /tmp/fonts/DaddyTimeMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/DepartureMono.zip -O /tmp/fonts/DepartureMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/DejaVuSansMono.zip -O /tmp/fonts/DejaVuSansMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/DroidSansMono.zip -O /tmp/fonts/DroidSansMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/EnvyCodeR.zip -O /tmp/fonts/EnvyCodeR.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/FantasqueSansMono.zip -O /tmp/fonts/FantasqueSansMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/FiraCode.zip -O /tmp/fonts/FiraCode.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/FiraMono.zip -O /tmp/fonts/FiraMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/GeistMono.zip -O /tmp/fonts/GeistMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/Go-Mono.zip -O /tmp/fonts/Go-Mono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/Gohu.zip -O /tmp/fonts/Gohu.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/Hack.zip -O /tmp/fonts/Hack.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/Hasklig.zip -O /tmp/fonts/Hasklig.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/HeavyData.zip -O /tmp/fonts/HeavyData.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/Hermit.zip -O /tmp/fonts/Hermit.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/iA-Writer.zip -O /tmp/fonts/iA-Writer.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/Inconsolata.zip -O /tmp/fonts/Inconsolata.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/InconsolataGo.zip -O /tmp/fonts/InconsolataGo.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/InconsolataLGC.zip -O /tmp/fonts/InconsolataLGC.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/IntelOneMono.zip -O /tmp/fonts/IntelOneMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/Iosevka.zip -O /tmp/fonts/Iosevka.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/IosevkaTerm.zip -O /tmp/fonts/IosevkaTerm.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/IosevkaTermSlab.zip -O /tmp/fonts/IosevkaTermSlab.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/JetBrainsMono.zip -O /tmp/fonts/JetBrainsMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/Lekton.zip -O /tmp/fonts/Lekton.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/LiberationMono.zip -O /tmp/fonts/LiberationMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/Lilex.zip -O /tmp/fonts/Lilex.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/MartianMono.zip -O /tmp/fonts/MartianMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/Meslo.zip -O /tmp/fonts/Meslo.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/Monaspace.zip -O /tmp/fonts/Monaspace.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/Monofur.zip -O /tmp/fonts/Monofur.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/Monoid.zip -O /tmp/fonts/Monoid.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/Mononoki.zip -O /tmp/fonts/Mononoki.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/MPlus.zip -O /tmp/fonts/MPlus.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/Noto.zip -O /tmp/fonts/Noto.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/OpenDyslexic.zip -O /tmp/fonts/OpenDyslexic.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/Overpass.zip -O /tmp/fonts/Overpass.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/ProFont.zip -O /tmp/fonts/ProFont.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/ProggyClean.zip -O /tmp/fonts/ProggyClean.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/Recursive.zip -O /tmp/fonts/Recursive.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/RobotoMono.zip -O /tmp/fonts/RobotoMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/ShareTechMono.zip -O /tmp/fonts/ShareTechMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/SourceCodePro.zip -O /tmp/fonts/SourceCodePro.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/SpaceMono.zip -O /tmp/fonts/SpaceMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/NerdFontsSymbolsOnly.zip -O /tmp/fonts/NerdFontsSymbolsOnly.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/Terminus.zip -O /tmp/fonts/Terminus.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/Tinos.zip -O /tmp/fonts/Tinos.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/Ubuntu.zip -O /tmp/fonts/Ubuntu.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/UbuntuMono.zip -O /tmp/fonts/UbuntuMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/UbuntuSans.zip -O /tmp/fonts/UbuntuSans.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/VictorMono.zip -O /tmp/fonts/VictorMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VER}/ZedMono.zip -O /tmp/fonts/ZedMono.zip

# clean up old fonts
rm -rf ${HOME}/.local/share/fonts/*

# extract zip files to fonts folder
echo "Extracting all zip files to fonts folder..."
mkdir -p ${HOME}/.local/share/fonts
for x in /tmp/fonts/*.zip; do
  unzip -o "$x" -d ${HOME}/.local/share/fonts/
done

# reconfigure fonts
echo "reconfiguring fonts..."
doas xbps-reconfigure -f fontconfig

# removing zip files
echo "Cleaning up downloads..."
rm -rf /tmp/fonts
