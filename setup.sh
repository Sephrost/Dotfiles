user=$USER
userpath="/home/${user}"

if [ "$EUID" -ne 0 ]
	then echo "Please run as root"
	exit
fi

apt update 
apt install sudo -y 
adduser $user sudo 

# Setup editors
apt install vim -y
wget https://github.com/neovim/neovim/releases/download/v0.8.3/nvim-linux64.deb
dpkg -i nvim-linux64,deb
sudo update-alternatives --set editor /usr/bin/vim.basic
sh -c 'curl -fLo "${userpath}/.local/share"/nvim/site/autoload/plug.vim --create-dirs \
	       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

apt install awesome  # Setup wm
echo "exec awesome" > $userpath/.xinitrc

# Setup display manager
apt install lightdm  
systemctl enable lighdm 

# Setup kitty
# Settings file in ~/.config/kitty/kitty.conf
apt install kitty -y

# Setup tmux
apt install tmux
cp tmux/.tmux.conf $userpath

# Setup file manager
apt install thunar -y

# Setup browser
apt install firefox-esr

# Setup pdf viewer
apt install okular -y

# Setup font
sudo apt install unzip -y
FONT_DIR="/tmp/sourcecodepro"
mkdir $FONT_DIR
wget https://github.com/adobe-fonts/source-code-pro/releases/download/2.042R-u%2F1.062R-i%2F1.026R-vf/OTF-source-code-pro-2.042R-u_1.062R-i.zip -O $FONT_DIR/font.zip
unzip -o -j -d $FONT_DIR $FONT_DIR/font.zip
mkdir -p /usr/local/share/fonts/sourcecodepro
cp $FONT_DIR/*.otf /usr/local/sharefonts/sourcecodepro/
fc-cache -f


# Setup lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
install lazygit /usr/local/bin
rm lazygit.tar.gz
rm lazygit

# Setup rofi 
apt install rofi

# Setup grub
cp -R ./etc/ /etc/
cp -R ./boot/ /boot/
sudo grub-mkconfig -o /boot/grub/grub.cfg
