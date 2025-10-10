#!/bin/sh

# Installation script to install all latest icon packages.

# Vars
COLLOID_ICON_VER=`curl -s https://api.github.com/repos/vinceliuice/Colloid-icon-theme/releases/latest |  grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'`
DRACULA_ICON_VER=`curl -s https://api.github.com/repos/dracula/gtk/releases/latest |  grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'`
NORDZY_ICON_VER=`curl -s https://api.github.com/repos/alvatip/Nordzy-icon/releases/latest |  grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'`
PAPIRUS_ICON_VER=`curl -s https://api.github.com/repos/PapirusDevelopmentTeam/papirus-icon-theme/releases/latest |  grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'`

#echo "Install script getting all icon packs..."

# Creating icons dir
echo "Make icons directory..."
mkdir -p ${HOME}/icons
mkdir -p ${HOME}/.local/share/icons

###########
# Colloid #
###########

# Download Colloid Icon pack
echo "Downloading Colloid Icons pack ${COLLOID_ICON_VER}..."
wget https://github.com/vinceliuice/Colloid-icon-theme/archive/refs/tags/${COLLOID_ICON_VER}.zip -O ${HOME}/icons/${COLLOID_ICON_VER}.zip

# Extract Colloid zip
echo "Extracting Colloid zip..."
unzip -o ${HOME}/icons/${COLLOID_ICON_VER}.zip -d ${HOME}/icons/

# Run Colloid installer
echo "Running Colloid installer..."
cd ${HOME}/icons/Colloid-icon-theme-${COLLOID_ICON_VER}
exec ${HOME}/icons/Colloid-icon-theme-${COLLOID_ICON_VER}/install.sh
cd ${HOME}/

###########
# Dracula #
###########

# Download Dracula zip
echo "Downloading Dracula Icons pack ${DRACULA_ICON_VER}..."
wget https://github.com/dracula/gtk/files/5214870/Dracula.zip -O ${HOME}/icons/Dracula.zip

# Extract Dracula zip
echo "Extracting Dracula zip..."
unzip -o ${HOME}/icons/Dracula.zip -d ${HOME}/.local/share/icons/

#########
# Win11 #
#########

# Download Win11 Icon repo
echo "Downloading Win11 Icon repo..."
cd ${HOME}/icons
git clone https://github.com/yeyushengfan258/Win11-icon-theme.git

# Install Win11 Icon repo
# Run Win11 installer
echo "Running Win11 installer..."
exec ${HOME}/icons/Win11-icon-theme/install.sh
cd ${HOME}/

##########
# Nordzy #
##########

# Download Nordzy Icon tar
echo "Downloading Nordzy Icon tar..."
wget https://github.com/alvatip/Nordzy-icon/releases/download/${NORDZY_ICON_VER}/Nordzy.tar.gz -O ${HOME}/icons/Nordzy.tar.gz
wget https://github.com/alvatip/Nordzy-icon/releases/download/${NORDZY_ICON_VER}/Nordzy-dark.tar.gz -O ${HOME}/icons/Nordzy-dark.tar.gz

# Extract Nordzy tar
echo "Extracting Nordzy tar file..."
tar xzv -f ${HOME}/icons/Nordzy.tar.gz -C ${HOME}/.local/share/icons/
tar xzv -f ${HOME}/icons/Nordzy-dark.tar.gz -C ${HOME}/.local/share/icons/

###########
# Papirus #
###########

# Download Papirus Icon pack
echo "Downloading Papirus Icons pack ${PAPIRUS_ICON_VER}..."
wget https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/archive/refs/tags/${PAPIRUS_ICON_VER}.zip -O ${HOME}/icons/${PAPIRUS_ICON_VER}.zip

# Extract Papirus zip
echo "Extracting Papirus zip..."
unzip -o ${HOME}/icons/${PAPIRUS_ICON_VER}.zip -d ${HOME}/icons/

# Run Papirus installer
echo "Running Papirus installer..."
cd ${HOME}/icons/papirus-icon-theme-${PAPIRUS_ICON_VER}
exec ${HOME}/icons/papirus-icon-theme-${PAPIRUS_ICON_VER}/install.sh
cd ${HOME}/
