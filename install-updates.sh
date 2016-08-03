#!/bin/bash
set -e

CONTESTANT_USERNAME=contestant

# Install IDEs and editor that can be found in the repositories
apt-get -y install geany-plugins ruby
# Install other software needed for contest management
apt-get -y install python-gtk2 python-webkit python-requests
# Install software that is not found in Ubuntu repositories
cd /tmp
#Update C++ build command
wget https://pcms.university.innopolis.ru/files/C++.sublime-package
mv C++.sublime-package /opt/sublime_text/Packages
# Netbeans
wget http://download.netbeans.org/netbeans/8.1/final/bundles/netbeans-8.1-linux.sh
chmod a+x netbeans-8.1-linux.sh
#./netbeans-8.1-linux.sh --record netbeans.xml
wget http://pcms.university.innopolis.ru/files/netbeans.xml
./netbeans-8.1-linux.sh --silent --state netbeans.xml
#Enable/disable AltGr
wget https://pcms.university.innopolis.ru/files/icon.png
mkdir /usr/local/share/altgr/
cp icon.png /usr/local/share/altgr/
#Python3.4 Documentation
wget https://www.python.org/ftp/python/doc/current/python-3.4.3-docs-html.tar.bz2
tar xvf python-3.4.3-docs-html.tar.bz2 -C /opt/
cat << EOF > python3-doc.desktop
[Desktop Entry]
Type=Application
Name=Python 3.4.3 Documentation
Comment=Python 3.4.3 Documentation
Icon=firefox
Exec=firefox /opt/python-3.4.3-docs-html/index.html
Terminal=false
Categories=Documentation;Python3;
EOF
# Create desktop icons
for i in netbeans-8.1
do
	cp /usr/share/applications/$i.desktop /home/$CONTESTANT_USERNAME/Desktop
done
cat << EOF > disable_altgr.desktop
[Desktop Entry]
Type=Application
Name=Disable Menu\non Alt Gr
Comment=Disable AltGr
Exec=/opt/disable_altgr.sh
Icon=/usr/local/share/altgr/icon.png
Terminal=true
Categories=AltGr; 
EOF
cat << EOF > enable_altgr.desktop
[Desktop Entry]
Type=Application
Name=Enable Menu\non Alt Gr
Comment=Enable AltGr
Exec=/opt/enable_altgr.sh
Icon=/usr/local/share/altgr/icon.png
Terminal=true
Categories=AltGr; 
EOF
for i in disable_altgr enable_altgr python3-doc
do
	cp $i.desktop /home/$CONTESTANT_USERNAME/Desktop
done
chmod a+x /home/$CONTESTANT_USERNAME/Desktop/*.desktop
