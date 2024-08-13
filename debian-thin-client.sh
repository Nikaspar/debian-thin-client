#!/bin/bash

echo "Openbox thin client installer"
read -p "Do you want to install X, Openbox, GDM3, FreeRDP? (y/n) " answer
if [ "$answer" = "y" ]; then
    echo "Installing X, Openbox, GDM3, FreeRDP..."
    apt -y install xorg xinit xterm openbox obconf gdm3 neovim freerdp2-x11
    systemctl set-default graphical.target
fi
echo "=========="
echo "Creating autostart script..."
echo ""
read -p "Enter a local username: " localuser
echo ""
if ! id -u "$localuser" > /dev/null 2>&1; then
    echo "User $localuser does not exist. Create? (y/n)"
    read answer
    if [ "$answer" = "y" ]; then
        useradd -m -U $localuser
        passwd $localuser
        echo "User $localuser created."
    else
        exit 1
    fi
fi
echo ""
read -p "Enter a remote host: " remotehost
echo ""
read -p "Enter a remote username: " remoteuser
echo ""
read -p "Enter a remote password: " remotepass

obconfig="/home/$localuser/.config/openbox"

mkdir -p $obconfig

echo "#!/bin/bash" > $obconfig/autostart.sh
echo "xfreerdp -toggle-fullscreen /sound:format:1 /microphone:format:1 /cert:tofu /f /video /v:$remotehost /u:$remoteuser /p:$remotepass || openbox --exit" >> $obconfig/autostart.sh

chown $localuser:$localuser /home/$localuser/.config
chown -R $localuser:$localuser $obconfig
chmod -R +x $obconfig

echo "=========="
echo "Autostart script created."
echo "Use \"openbox\" --exit to logout."
