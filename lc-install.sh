
#!/bin/bash
# vim:fileencoding=utf-8:foldmethod=marker

##{{{ Initial clean
#DEPS_MX_XFCE4="blueman foliate geany liblibreoffice-java libreoffice-base-core libreoffice-base-drivers libreoffice-base libreoffice-calc libreoffice-common libreoffice-core libreoffice-draw libreoffice-gnome libreoffice-gtk3 libreoffice-help-common libreoffice-help-en-us libreoffice-impress libreoffice-java-common libreoffice-math libreoffice-report-builder-bin libreoffice-sdbc-hsqldb libreoffice-writer lo-main-helper thunderbird ure-java ure catfish conky-all conky-manager conky-toggle-mx gnome-mahjongg lbreakout2-data lbreakout2 luckybackup-data luckybackup mc-data mc mx-apps mx-conky-data mx-conky orage-data orage peg-e seahorse strawberry swell-foop timeshift vlc-bin vlc-data vlc-l10n vlc-plugin-base vlc-plugin-qt vlc-plugin-video-output vlc xfburn"
#
#DEPS_XFCE4="apt-notifier catfish desktop-defaults-mx-xfce-desktop desktop-defaults-mx-xfce-system desktop-defaults-mx-xfce exo-utils gir1.2-xfconf-0 libgarcon-gtk3-1-0 libthunarx-3-0 libxfce4ui-2-0 libxfce4ui-utils libxfconf-0-3 orage thunar-archive-plugin thunar-gtkhash thunar-modified-desktop-file thunar-shares-plugin thunar-volman thunar xfburn xfce-superkey-mx xfce4-appfinder xfce4-battery-plugin xfce4-clipman xfce4-cpufreq-plugin xfce4-cpugraph-plugin xfce4-datetime-plugin xfce4-diskperf-plugin xfce4-docklike-plugin xfce4-fsguard-plugin xfce4-genmon-plugin xfce4-mount-plugin xfce4-netload-plugin xfce4-notes-plugin xfce4-notes xfce4-notifyd xfce4-panel xfce4-places-plugin xfce4-power-manager-data xfce4-power-manager-plugins xfce4-power-manager xfce4-pulseaudio-plugin xfce4-screensaver xfce4-screenshooter xfce4-sensors-plugin xfce4-session xfce4-settings xfce4-smartbookmark-plugin xfce4-systemload-plugin xfce4-taskmanager xfce4-terminal xfce4-timer-plugin xfce4-verve-plugin xfce4-wavelan-plugin xfce4-weather-plugin xfce4-whiskermenu-plugin xfce4-xkb-plugin xfconf xfdesktop4-data xfdesktop4 xfwm4"
#
#for pak in ${DEPS_XFCE4[@]}; do
#dpkg -s $pak >/dev/null 2>&1
#if [[ $? != 1 ]]; then
#echo -e "\033[33mRemoving \033[31m$pak \033[33m..\033[0m"
#sudo apt remove --purge $pak -y >/dev/null 2>&1
#fi
#done
#for pak in ${DEPS_MX_XFCE4[@]}; do
#dpkg -s $pak >/dev/null 2>&1
#if [[ $? != 1 ]]; then
#echo -e "\033[33mRemoving \033[31m$pak \033[33m..\033[0m"
#sudo apt remove --purge $pak -y >/dev/null 2>&1
#fi
#done
#sudo apt autpremove --purge
#
##}}}
##{{{ Setup lc my-dot
#git clone https://github.com/batann/my-dot
#sudo bash my-dot/install.sh
##}}}
#!/bin/bash
# vim:fileencoding=utf-8:foldmethod=marker
#author:	fairdinkum batan
#mail:		12982@tutanota.com
------------------------------------------------------------------------------------------------

#{{{###  clear command and ansi coloring
clear
Black='\033[0;30m'
Red='\033[0;31m'
Green='\033[0;32m'
Blue='\033[0;34m'
Purple='\033[0;35m'
Cyan='\033[0;36m'
Yellow='\033[1;33m'
White='\033[1;37m'
BBlue='\e[0;104m'
BBlack='\e[0;100m'
RRed='\e[0;100m'
GGreen='\e[0;100m'
YYellow='\e[0;100m'
BBlue='\e[0;100m'
PPurple='\e[0;100m'
CCyan='\e[0;100m'
WWhite='\e[0;100m'

#}}}
#{{{ >>>   DEPS
DEPS_USER_SETTING="ufw pass git curl gnupg2 apt-transport-https ca-certificates lsb-release bash vim sudo"
for package in ${DEPS_USER_SETTING[@]};
do
	dpkg -s $package >/dev/null 2>&1
	if [[ $? == "1" ]]; then
		echo -e "\033[33mInstalling \033[31m$package\033[33m...\033[0m"
		sudo apt install $package -y
	fi
done
#}}}
#{{{ >>>   Update Upgrade and Setup Dotfiles
sudo apt update
sudo apt upgrade -y
git clone https://github.com/batann/my-dot
sudo -u batan bash my-dot/install.sh
source .bashrc
#}}}
#{{{ >>>   Change udisk2.policy !!! CAUTION
#clear
#tput cup 3 0
#echo -e "\033[33m Do you want to change \033[31mudisk2.policy \033[33m???\\033[0m"
#tput cup 3 40
#read -n1 -p " y/n" abc
#if [[ $abc == 'y' ]];
#then
#	find /usr/share/polkit-1/actions/ -type f -name "org.freedesktop.UDisks2.policy" -exec sudo sed -i 's!<allow_active>auth_admin_keep</allow_active>!<allow_active>yes</allow_active>!g' {} \;
#fi
#}}}
#{{{>>>   Add User to Visudo and Groups
echo "batan ALL=(ALL:ALL) NOPASSWD:ALL"|sudo EDITOR='tee -a' visudo
USER="batan"
# List of groups to check and add
GROUPS=('lp' 'dialout' 'cdrom' 'floppy' 'sudo' 'audio' 'dip' 'video' 'plugdev' 'users' 'netdev' 'lpadmin' 'vboxsf' 'scanner' 'sambashare')
## Check if the script is run as root
#if [[ $EUID -ne 0 ]]; then
#	echo "This script must be run as root."
#	exit 1
#fi
# Check if the user was provided
if [[ -z "$USER" ]]; then
	echo "Usage: $0 <username>"
	exit 1
fi
# Iterate through each group and check if the user is a member
for group in "${GROUPS[@]}"; do
	if groups "$USER" | grep -qw "$group"; then
		echo "User $USER is already in group $group."
	else
		echo "Adding user $USER to group $group."
		sudo usermod -aG "$group" "$USER"
	fi
done
echo -e "${B}Group membership check and update complete for$R $USER."

#}}}
#{{{>>>   Setup GPG-key
	command -v gpg >/dev/null 2>&1 || { echo >&2 "GPG is not installed. Please install GPG and try again."; exit 1; }
###   Set key details   ##########################################
full_name="fairdinkum batan"
email_address="tel.petar@gmail.com"
passphrase="Ba7an?12982"
app_password_fairdinkum="ixeh bhbn dbrq pbyc"
###   Generate GPG key   #########################################
gpg --batch --full-generate-key <<EOF
	Key-Type: RSA
	Key-Length: 4096
	Subkey-Type: RSA
	Subkey-Length: 4096
	Name-Real: $full_name
	Name-Email: $email_address
	Expire-Date: 1y
	Passphrase: $passphrase
	%commit
EOF

echo "${B}GPG key generation completed.$R Please make sure to remember your passphrase.$N"
pass init tel.petar@gmail.com
#}}}
#{{{>>>   Setup SSH-keys

key_name="id_rsa"
key_location="$HOME/.ssh/$key_name"
ssh-keygen -t rsa -b 4096 -f "$key_location" -N ""

###   Function to detect the init system   ###########
get_init_system() {
	if [ -f /run/systemd/system ]; then
		echo "systemd"
	elif command -v service >/dev/null; then
		echo "SysVinit"
	elif command -v rc-service >/dev/null; then
		echo "OpenRC"
	elif command -v initctl >/dev/null; then
		echo "Upstart"
	else
		echo "unknown"
	fi
}

###   Function to configure SSH on a remote machine   ###########
configure_ssh() {
	# SSH configuration file path
	local ssh_config="/etc/ssh/sshd_config"
	local init_system=$(get_init_system)  # Detect the init system
	sudo cp $ssh_config "$ssh_config.bak"
	# Combine all SSH configuration changes into one command
	ssh -o "StrictHostKeyChecking=no" -o "PasswordAuthentication=no" "$1" "\
		sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' $ssh_config && \
		sudo sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/' $ssh_config && \
		# Restart SSH service based on the detected init system
			$(case "$init_system" in
			systemd) echo "sudo systemctl restart ssh";;
			SysVinit) echo "sudo service ssh restart";;
			OpenRC) echo "sudo rc-service sshd restart";;
			Upstart) echo "sudo stop ssh && sudo start ssh";;
			*) echo "echo 'Unknown init system: $init_system. Cannot restart SSH.'";;
		esac)"
		}

		active_ips=()
		local_ip=$(hostname -I | awk '{print $1}')

		for i in $(seq 35 40); do
			current_ip="192.168.1.$i"
			if [ "$current_ip" != "$local_ip" ] && ping -c 1 -W 1 "$current_ip" &> /dev/null; then
				active_ips+=("$current_ip")
			fi
		done

		for ip in "${active_ips[@]}"; do
			ssh-copy-id -i "$key_location.pub" batan@"$ip"
			configure_ssh "$ip"  # Call the function to configure SSH on the remote machine
		done
		clear
#}}}
#{{{>>>   Setup Firewall

sudo dpkg -s ufw >/dev/null
if [[ $? -eq 0 ]]; then
	echo "ufw is already installed."
else
sudo apt install -y ufw
fi
for i in $(seq 35 40);
do
	sudo ufw allow from 192.168.1.$i && sudo ufw allow to 192.168.1.$i
done
sudo ufw enable
#}}}
##{{{ >>>   i3 install
DEPS_i3="i3 i3status i3lock dunst picom cava xfce4-terminal stterm suckless-tools rofi surf thunar xterm pavucontrol sox libsox-fmt-all alsa-utils i3status wmctrl xdotool xorg xinit x11-xserver-utils pulseaudio pulseaudio-utils network-manager network-manager-gnome fonts-font-awesome arandr feh lxappearance xarchiver lightdm lightdm-gtk-greeter policykit-1-gnome software-properties-gtk apt-transport-https curl wget git firefox-esr thunar-archive-plugin thunar-volman thunar-media-tags-plugin gvfs gvfs-backends xbacklight acpi acpid notification-daemon libnotify-bin volumeicon-alsa vim htop neofetch python3-pip nmcli arj lbzip2 lhasa liblz4-tool lrzip lzip lzop ncompress pbzip2 pigz plzip rar unar libgtk-4-dev libgcr-3-dev libgcr-3-dev libwebkit2gtk-4.0-dev x11-apps mesa-utils"

DESKT="i3"

if [[ "$DESKT" == "i3" ]]; then
# Silently check if any dependencies are installed and install them if not
for dep in ${DEPS_i3[@]}; do
	if ! dpkg -s $dep >/dev/null 2>&1; then
		echo "Installing \033[34m$dep...\033[0m"
		sudo apt-get install -y $dep
	fi
done
fi
#}}}
#{{{ >>>   Clone suckless Dont build surf
git clone git://git.suckless.org/dmenu
git clone git://git.suckless.org/tabbed
git clone git://git.suckless.org/st
git clone https://github.com/batann/surf
find /home/batan/ -maxdepth 5 -type d -name ".git" -exec rm -rf {} \;
sudo rm /home/batan/surf/patches/surf-bookmarks-20170722-723ff26.diff
sudo rm /home/batan/surf/patches/surf-git-20170323-webkit2-searchengines.diff
sudo rm /home/batan/surf/patches/surf-websearch-20190510-d068a38.diff


#cd /home/batan/dmenu
#sudo make
#sudo make clean install
#
#cd /home/batan/tabbed
#sudo make
#sudo make clean install
#
#cd /home/batan/st
#sudo make
#sudo make clean install
#

#}}}
#((( >>>   Install and configure minidlna and samba
# Define variables
USER="batan"
GROUP="batan"
UUID="c96173e2-aae6-43b1-bad3-2d8fb4e87e25"
MOUNT_POINT="/media/batan/100"
FSTAB_ENTRY="UUID=${UUID} ${MOUNT_POINT} ext4 defaults 0 2"
MINIDLNA_CONF="/etc/minidlna.conf"

# Ensure the script is run as root
#if [[ $EUID -ne 0 ]]; then
#    echo "This script must be run as root."
#    exit 1
#fi

# Install MiniDLNA
sudo apt update && apt install -y minidlna

# Create mount point and add fstab entry if not present
#if ! grep -q "$UUID" /etc/fstab; then
#    mkdir -p "$MOUNT_POINT"
#    echo "$FSTAB_ENTRY" >> /etc/fstab
#    mount -a
#else
#    echo "FSTAB entry already exists."
#fi

# Create media directories
#for dir in Videos Music Backgrounds; do
#    mkdir -p "$MOUNT_POINT/$dir"
#done

# Set ownership and permissions
sudo chown -R $USER:$GROUP "$MOUNT_POINT"
sudo chmod -R 755 "$MOUNT_POINT"

# Backup MiniDLNA configuration
sudo cp $MINIDLNA_CONF ${MINIDLNA_CONF}.bak

# Configure MiniDLNA
sudo cat <<EOF > $MINIDLNA_CONF
# MiniDLNA configuration file
media_dir=V,$MOUNT_POINT/Videos
media_dir=A,$MOUNT_POINT/Music
media_dir=P,$MOUNT_POINT/Backgrounds
friendly_name=My MiniDLNA Server
db_dir=/var/cache/minidlna
log_dir=/var/log
inotify=yes
EOF

# Ensure permissions for MiniDLNA
sudo chown -R minidlna:minidlna /var/cache/minidlna
sudo chmod -R 755 /var/cache/minidlna
sudo chown -R minidlna:minidlna /var/log
sudo chmod -R 755 /var/log
sudo chown -R minidlna:minidlna /media/batan/100
sudo chmod -R 755 /media/batan/100

# Restart and enable MiniDLNA
#systemctl restart minidlna
#systemctl enable minidlna
#sudo systemctl stop minidlna
#sudo rm -rf /var/cache/minidlna/files.db
#sudo systemctl start minidlna
#sudo systemctl restart minidlna
#sudo systemctl status minidlna

# Restart and enable MiniDLNA
sudo service minidlna restart
sudo service minidlna enable
sudo service minidlna stop
sudo rm -rf /var/cache/minidlna/files.db
sudo service minidlna start
sudo service minidlna restart
sudo service minidlna status


# Display status
echo "MiniDLNA installation and configuration completed."

#########################################   SAMBA   #######################
# Variables
USER="batan"
PASSWORD="Ba7an?12982"
SHARE_DIRS=("/home/batan/Videos" "/home/batan/Music" "/home/batan/Documents" "/home/batan/Pictures")

# Ensure samba service is installed
if ! command -v smbpasswd &> /dev/null; then
	echo "Samba is not installed. Installing now..."
	sudo apt-get install samba -y || sudo pacman -S samba || sudo dnf install samba -y
fi

# Create samba user and set password
echo "Creating Samba user: $USER"
sudo smbpasswd -x $USER &> /dev/null  # Remove the user if they exist already
sudo useradd -M -s /sbin/nologin $USER  # Create system user without home
echo -e "$PASSWORD\n$PASSWORD" | sudo smbpasswd -a $USER  # Set Samba password
sudo smbpasswd -e $USER  # Enable the user

# Backup smb.conf
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak

# Modify smb.conf
echo "Modifying /etc/samba/smb.conf"

for dir in "${SHARE_DIRS[@]}"; do
	sudo mkdir -p "/srv/samba/$dir"
	sudo chown $USER:users "/srv/samba/$dir"
	sudo chmod 755 "/srv/samba/$dir"

	# Add the share configuration
	sudo bash -c cat >> /etc/samba/smb.conf <<EOF

	[$dir]
	path = /srv/samba/$dir
	browseable = yes
	read only = no
	guest ok = no
	valid users = $USER
	write list = $USER
	create mask = 0775
	directory mask = 0775
	public = yes
EOF

done

# Set up read-only access for everyone else
sudo bash -c cat >> /etc/samba/smb.conf <<EOF

[Public]
path = /srv/samba
public = yes
only guest = yes
browseable = yes
writable = no
guest ok = yes
create mask = 0775
directory mask = 0775
EOF
# Restart Samba services
if [[ "$init_system" == "systemd" ]]; then
	sudo systemctl restart smbd
	sudo systemctl enable smbd
else
	sudo service smbd restart
	sudo service smbd enable
fi
echo "Samba setup complete."
#}}}
##{{{>>>   Install LAMP stack
DEPS_LAMP="apache2 apache2-utils curl mariadb-server mariadb-client php libapache2-mod-php php-mysql php-common php-cli php-common php-opcache php-xml php-yaml php-readline php-fpm php-gd php-mbstring php-curl php-zip"

# Variables
DB_NAME="nextcloud"
DB_USER="batan"
DB_PASSWORD="Ba7an?12982"
NEXTCLOUD_URL="https://download.nextcloud.com/server/releases/latest.zip"
NEXTCLOUD_DIR="/var/www/nextcloud"
ADMIN_USER="batan"
ADMIN_PASSWORD="Ba7an?12982"
DOMAIN="localhost"

# Update and Install Dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install apache2 mariadb-server libapache2-mod-php8.2 -y
sudo apt install php8.2 php8.2-gd php8.2-mysql php8.2-curl php8.2-xml php8.2-mbstring php8.2-zip php8.2-intl php8.2-bcmath php8.2-gmp php-imagick unzip wget -y

# Enable Apache Modules
sudo a2enmod rewrite headers env dir mime
sudo service apache2 restart
#sudo systemctl restart apache2

# Configure MariaDB
#sudo systemctl start mariadb
sudo service mariadb start
sudo mysql_secure_installation <<EOF

Y
$DB_PASSWORD
$DB_PASSWORD
Y
Y
Y
Y
EOF

# Create Nextcloud Database and User
sudo mysql -uroot -p$DB_PASSWORD <<EOF
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF

 Download and Install Nextcloud
cd /tmp
wget $NEXTCLOUD_URL -O nextcloud.zip
unzip nextcloud.zip
sudo mv nextcloud $NEXTCLOUD_DIR
sudo chown -R www-data:www-data $NEXTCLOUD_DIR
sudo chmod -R 755 $NEXTCLOUD_DIR

# Apache Configuration for Nextcloud
sudo bash -c "cat >/etc/apache2/sites-available/nextcloud.conf" <<EOF
<VirtualHost *:80>
    ServerAdmin admin@$DOMAIN
    DocumentRoot $NEXTCLOUD_DIR
    ServerName $DOMAIN

    <Directory $NEXTCLOUD_DIR>
        Options +FollowSymlinks
        AllowOverride All

        <IfModule mod_dav.c>
            Dav off
        </IfModule>

        SetEnv HOME $NEXTCLOUD_DIR
        SetEnv HTTP_HOME $NEXTCLOUD_DIR
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

sudo a2ensite nextcloud.conf
#sudo systemctl reload apache2
sudo service apache2 reload
# Set Permissions
sudo chown -R www-data:www-data $NEXTCLOUD_DIR

# Install Nextcloud via Command Line
sudo -u www-data php $NEXTCLOUD_DIR/occ maintenance:install \
    --database "mysql" --database-name "$DB_NAME" \
    --database-user "$DB_USER" --database-pass "$DB_PASSWORD" \
    --admin-user "$ADMIN_USER" --admin-pass "$ADMIN_PASSWORD" \
    --data-dir "$NEXTCLOUD_DIR/data"

# Set local IP to trusted domain
LOCAL_IP=$(hostname -I | awk '{print $1}')
sudo -u www-data php $NEXTCLOUD_DIR/occ config:system:set trusted_domains 1 --value=$LOCAL_IP

# Restart Apache
#sudo systemctl restart apache2

echo "Nextcloud installation complete. Access it via http://$LOCAL_IP"

sudo service apache2 restart
#}}}
#{{{ >>>   LC-hosts file setup
HOS1="/etc/hosts"
HOS2="/etc/hosts.2"
HOS3="/etc/hosts.3"
SIGN_FILE="/home/batan/.lc-sign"

clear

# Ensure .lc-sign exists before reading
if [[ ! -f "$SIGN_FILE" ]]; then
    touch "$SIGN_FILE"
fi
BLOCKING=$(grep "lc-sign-1" "$SIGN_FILE")

check_hosts() {
    # Check if hosts.2 exists
    if [[ ! -f "$HOS2" ]]; then
        echo -e "\033[32mGetting the hosts file...\033[0m"
        git clone https://github.com/batann/host.git /tmp/host_repo > /dev/null 2>&1
        if [[ $? -ne 0 ]]; then
            echo -e "\033[31mFailed to fetch hosts file from repository.\033[0m"
            exit 1
        fi
        cat "$HOS1" >> /tmp/host_repo/hosts
        sudo mv /tmp/host_repo/hosts "$HOS2"
        rm -rf /tmp/host_repo
        echo -e "\033[32mHosts file setup complete.\033[0m"
    fi
}

block_hosts() {
    if [[ "$BLOCKING" == "lc-sign-1" ]]; then
        echo -e "\033[31mYou are already blocking with the hosts file...\033[0m"
    else
        sudo cp "$HOS1" "$HOS3"
        sudo cp "$HOS2" "$HOS1"
        sudo mv "$HOS3" "$HOS2"
        echo "lc-sign-1" >> "$SIGN_FILE"
        echo -e "\033[32mBlocking enabled.\033[0m"
    fi
}

unblock_hosts() {
    if [[ "$BLOCKING" != "lc-sign-1" ]]; then
        echo -e "\033[31mYou are not blocking with the hosts file...\033[0m"
    else
        sudo cp "$HOS1" "$HOS3"
        sudo cp "$HOS2" "$HOS1"
        sudo mv "$HOS3" "$HOS2"
        sed -i '/lc-sign-1/d' "$SIGN_FILE"
        echo -e "\033[32mBlocking disabled.\033[0m"
    fi
}

# Main Script
clear
check_hosts
echo -e "\033[32mDo you want to block with the hosts file? (y/n)\033[0m"
read -p ">> " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    block_hosts
else
    unblock_hosts
fi

clear
echo -e "\033[32mScript executed successfully.\033[0m"
if [[ "$BLOCKING" == "lc-sign-1" ]]; then
    echo -e "\033[31mYou are blocking with the hosts file.\033[0m"
else
    echo -e "\033[31mYou are not blocking with the hosts file.\033[0m"
fi
#}}}
#{{{ >>>   NEOVIM CODIUM VIM-PLUG and PLUGINS
NEOVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"

#{{{###   Update system and install prerequisites
echo "Updating system and installing prerequisites..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget git python3 python3-pip \
  build-essential libfuse2 nodejs npm \
  taskwarrior ripgrep software-properties-common fzf
#}}}
#{{{###   Install the latest Neovim
echo "Installing the latest Neovim..."
wget "$NEOVIM_URL" -O /tmp/nvim.appimage
chmod u+x /tmp/nvim.appimage
sudo mv /tmp/nvim.appimage /usr/local/bin/nvim
sudo chown -R batan:batan /usr/local/bin/nvim
#}}}
#{{{###   Install Node.js (required for Neovim autocompletion plugins)
echo "Installing Node.js and npm packages for Neovim autocompletion..."
sudo npm install -g neovim
#}}}
#{{{###   Install and configure Python support for Neovim
echo "Configuring Python for Neovim..."
sudo apt-get install python3-pynvim -y
#}}}
#{{{###   Clone Codeium.vim plugin into the correct directory for Neovim
echo "Cloning Codeium.vim plugin..."
git clone https://github.com/Exafunction/codeium.vim /home/batan/.config/nvim/pack/Exafunction/start/codeium.vim
#}}}
#{{{###   Open Neovim config (init.vim) to add Codeium settings
echo "Setting up Codeium configuration in Neovim..."

cat <<EOF >/home/batan/.config/nvim/init.vim

" Enable Codeium plugin
let g:codeium_disable_bindings = 0

" Map <Tab> and <Shift-Tab> to accept/previous suggestions
inoremap <silent><expr> <Tab> codeium#Accept()
inoremap <silent><expr> <S-Tab> codeium#Previous()

" Enable Codeium when entering Insert mode
autocmd InsertEnter * call codeium#Enable()

" Optional: Check Codeium status with a custom function
function! CheckCodeiumStatus()
    let status = luaeval("vim.api.nvim_call_function('codeium#GetStatusString', {})")
    echo "Codeium Status: " . status
endfunction

" Map <Leader>cs to check Codeium status
nnoremap <Leader>cs :call CheckCodeiumStatus()<CR>

" TABLE-MODE
let g:table_mode_corner='|'
let g:table_mode_corner_corner='+'
let g:table_mode_header_fillchar='='

function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
          \ <SID>isAtStartOfLine('\|\|') ?
          \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
          \ <SID>isAtStartOfLine('__') ?
          \ '<c-o>:silent! TableModeDisable<cr>' : '__'



" Common settings for Neovim

syntax on
filetype plugin indent on
set laststatus=2
set so=7
set foldcolumn=1
"#set encoding=utf8
set ffs=unix,dos
set cmdheight=1
set hlsearch
set lazyredraw
set magic
set showmatch
set mat=2
set foldcolumn=1
set smarttab
set shiftwidth=4
set tabstop=4
set lbr
set tw=500
set ai "Auto indent
set si "Smart indent
set nobackup
set nowb
set nocp
set autowrite
set hidden
set mouse=a
set noswapfile
set nu
set relativenumber
set t_Co=256
set cursorcolumn
set cursorline
set ruler
set scrolloff=10

" netrw filemanager settings

let g:netrw_menu = 1
let g:netrw_preview = 1
let g:netrw_winsize = 20
let g:netrw_banner = 0
let g:netrw_lifestyle = 1
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4

" Leader and other mappings

let mapleader = ","
nnoremap <Leader>te :terminal<CR>
nnoremap <Leader>tc :terminal<CR>sudo -u batan bash $HOME/check/vim.cmd.sh <CR>
nnoremap <Leader>xc :w !xclip -selection clipboard<CR>	"copy page to clipboard
nnoremap <leader>dd :Lexplore %:p:h<CR>		"open netrw in 20% of the screen to teh left
nnoremap <Leader>da :Lexplore<CR>
nnoremap <leader>vv :split $MYVIMRC<CR>		"edit vimrc
nnoremap <leader>sv :source $MYVIMRC<CR>	"source vimrc
nnoremap <leader>ra :<C-U>RangerChooser<CR>
nmap <F8> :TagbarToggle<CR>				"tagbar toggle

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun
if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

"###################		TEMPLATES		################################
autocmd! BufNewFile *.sh 0r /home/batan/.config/nvim/templates/sklt.sh |call setpos('.', [0, 29, 1, 0])
autocmd! BufNewFile *popup.html 0r /home/batan/.config/nvim/templates/popup.html
autocmd! BufNewFile *popup.css 0r /home/batan/.config/nvim/templates/popup.css
autocmd! BufNewFile *popup.js 0r /home/batan/.config/nvim/templates/popup.js
autocmd! BufNewFile *.html 0r /home/batan/.config/nvim/templates/sklt.html
autocmd! BufNewFile *.txt 0r /home/batan/.config/nvim/templates/sklt.txt
if has ('autocmd') " Remain compatible with earlier versions
 augroup vimrc     " Source vim configuration upon save
    autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
    autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
  augroup END
endif " has autocmd

"##########################   TASK WIKI   ###############################
" default task report type
let g:task_report_name     = 'next'
" custom reports have to be listed explicitly to make them available
let g:task_report_command  = []
" whether the field under the cursor is highlighted
let g:task_highlight_field = 1
" can not make change to task data when set to 1
let g:task_readonly        = 0
" vim built-in term for task undo in gvim
let g:task_gui_term        = 1
" allows user to override task configurations. Seperated by space. Defaults to ''
let g:task_rc_override     = 'rc.defaultwidth=999'
" default fields to ask when adding a new task
let g:task_default_prompt  = ['due', 'description']
" whether the info window is splited vertically
let g:task_info_vsplit     = 0
" info window size
let g:task_info_size       = 15
" info window position
let g:task_info_position   = 'belowright'
" directory to store log files defaults to taskwarrior data.location
let g:task_log_directory   = '/home/batan/.task'
" max number of historical entries
let g:task_log_max         = '20'
" forward arrow shown on statusline
let g:task_left_arrow      = ' <<'
" backward arrow ...
let g:task_left_arrow      = '>> '

"###   STARTUP PAGE   ##############################################################

fun! Start()
    if argc() || line2byte('$') != -1 || v:progname !~? '^[-gmnq]\=vim\=x\=\%[\.exe]$' || &insertmode
        return
    endif

    " Force clear buffer
    enew
    call setline(1, []) " Clear content explicitly

    " Set buffer options
    setlocal bufhidden=wipe buftype=nofile nobuflisted nocursorcolumn nocursorline nolist nonumber noswapfile norelativenumber

    " Append task output
    let lines = split(system('task'), '\n')
    for line in lines
        call append('$', '            ' . line)
    endfor

    " Make buffer unmodifiable
    setlocal nomodifiable nomodified

    " Key mappings for convenience
    nnoremap <buffer><silent> e :enew<CR>
    nnoremap <buffer><silent> i :enew <bar> startinsert<CR>
    nnoremap <buffer><silent> o :enew <bar> startinsert<CR>
endfun

augroup StartPage
    autocmd!
    autocmd VimEnter * call Start()
augroup END




EOF
#}}}
#{{{###   INSTALL some plugins from my old neovim lc-configs
# cloneing templates for neovim
git clone https://github.com/batann/templates.git /home/batan/.config/nvim/templates
# Install Orig TW
git clone https://github.com/farseer90718/vim-taskwarrior /home/batan/.config/nvim/pack/plugins/start/vim-taskwarrior
# Install table-mode
git clone https://github.com/dhruvasagar/vim-table-mode.git /home/batan/.config/nvim/pack/plugins/start/vim-table-mode
# Install vimwiki
git clone https://github.com/vimwiki/vimwiki.git  /home/batan/.config/nvim/pack/plugins/start/vimwiki
# Install task.wiki
git clone https://github.com/tools-life/taskwiki.git --branch dev /home/batan/.config/nvim/pack/plugins/start/taskwiki

# remove any .git directories
find /home/batan/.config/nvim/ -maxdepth 10 -type d -name ".git" -exec rm -rf {} \;
#}}}
#{{{###   Install vim-plug (optional, in case you want to add more plugins)
echo "Installing vim-plug (optional for plugin management)..."
curl -fLo /home/batan/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Neovim and Codeium setup complete!"
echo "Use :call CheckCodeiumStatus() or press <Leader>cs to check Codeium status in Neovim."
#}}}


#{{{ >>>   html enabled yad dialog build
# Exit immediately if a command exits with a non-zero status
set -e

# Define variables
REPO_URL="https://github.com/v1cont/yad.git"
INSTALL_DIR="$HOME/yad-build"

# Update system and install dependencies
echo "Updating system and installing dependencies..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y git build-essential intltool \
  libgtk-3-dev libwebkit2gtk-4.0-dev \
  libgdk-pixbuf2.0-dev libnotify-dev \
  libjson-glib-dev libxml2-utils

# Clone the YAD repository
echo "Cloning the YAD repository..."
if [ -d "$INSTALL_DIR" ]; then
  echo "Directory $INSTALL_DIR already exists, removing it."
  rm -rf "$INSTALL_DIR"
fi

git clone "$REPO_URL" "$INSTALL_DIR"

# Navigate to the repository
cd "$INSTALL_DIR"

# Configure and enable HTML browser support
echo "Configuring YAD with HTML browser support..."
autoreconf -ivf && intltoolize
./configure --enable-html

# Compile and install YAD
echo "Compiling and installing YAD..."
make
sudo make install

# Verify installation
echo "Verifying YAD installation..."
if yad --version; then
  echo "YAD installed successfully!"
else
  echo "There was an issue with the YAD installation."
  exit 1
fi

#}}}
#{{{ >>>   Install and Config Windsurf
curl -fsSL "https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/windsurf.gpg" | sudo gpg --dearmor -o /usr/share/keyrings/windsurf-stable-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/windsurf-stable-archive-keyring.gpg arch=amd64] https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/apt stable main" | sudo tee /etc/apt/sources.list.d/windsurf.list > /dev/null
sudo apt-get update
sudo apt-get upgrade windsurf
#}}}




