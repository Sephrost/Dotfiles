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
apt install lightdm -y 
systemctl enable lighdm 

# Setup bashrc
cp ./.bashrc $userpath/

#Setup dotfiles
cp -R ./.config/ $userpath/.config/

# Setup kitty
# Settings file in ~/.config/kitty/kitty.conf
apt install kitty -y

# Setup tmux
apt install tmux -y
cp tmux/.tmux.conf $userpath

# Setup file manager
apt install thunar -y

# Setup browser
apt install firefox-esr -y

# Setup pdf viewer
apt install okular -y

# Setup font
cp -R ./usr /usr/
fc-cache -f


# Setup lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
install lazygit /usr/local/bin
rm lazygit.tar.gz
rm lazygit

# Setup rofi 
apt install rofi -y

# Setup grub
cp -R ./etc/ /etc/
cp -R ./boot/ /boot/
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Setup icons
# Donk know about this
gtk-update-icon-cache -f -t $userpath/.icons/Catppuccin-Macchiato/

# Setup picom
git clone https://github.com/FT-Labs/picom
apt install libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-dpms0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl-dev libegl-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev meson -y
# additional packages to add: libxcb-util-dev
meson setup --buildtype=release build ./picom/
ninja -C build
ninja -C build install

# Setup TLP
apt install tlp -y

# Setup audio control
apt install pulseaudio -y
# systemctl --user enable pulseaudio

# Setup brightness control
apt install brightnessctl -y

# Set GTK theme
cp -R ./.themes/ $userpath/

# Setup Network Manager
apt install network-manager -y
